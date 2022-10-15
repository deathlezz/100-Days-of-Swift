//
//  ViewController.swift
//  Project25-Selfie-Share
//
//  Created by deathlezz on 13/10/2022.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Selfie Share"
        
        // Challenge 3
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let peers = UIBarButtonItem(title: "Peers", style: .plain, target: self, action: #selector(showPeers))
        
        // Challenge 2
        let picture = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let message = UIBarButtonItem(title: "Text", style: .plain, target: self, action: #selector(showSendMessage))

        navigationItem.leftBarButtonItems = [add, peers]
        navigationItem.rightBarButtonItems = [picture, message]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated:  true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        sendImage(image)
    }

    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // Challenge 2
    @objc func showSendMessage() {
        let ac = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Send", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.sendMessage(text)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func sendMessage(_ text: String) {
        let data = Data(text.utf8)
        sendData(data)
    }
    
    func sendImage(_ image: UIImage) {
        if let imageData = image.pngData() {
            sendData(imageData)
        }
    }
    
    func sendData(_ data: Data) {
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    // Challenge 3
    @objc func showPeers() {
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            let ac = UIAlertController(title: "Connected Peers", message: nil, preferredStyle: .actionSheet)
            
            for peer in mcSession.connectedPeers {
                ac.addAction(UIAlertAction(title: "\(peer.displayName)", style: .default))
            }
            ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItems?[1]
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
            
        } else {
            let ac = UIAlertController(title: "No peers connected", message: nil, preferredStyle: .alert)
            ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItems?[1]
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            // Challenge 1
            let ac = UIAlertController(title: "\(peerID) has disconnected", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .connected:
            print("Connected: \(peerID.displayName)")
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
                
            } else {
                // Challenge 2
                let text = String(decoding: data, as: UTF8.self)
                let ac = UIAlertController(title: "New message", message: text, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(ac, animated: true)
            }
        }
    }
}

