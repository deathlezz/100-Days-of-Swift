//
//  ViewController.swift
//  Milestone-Projects25-27
//
//  Created by deathlezz on 22/10/2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Meme Generator"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let topText = UIBarButtonItem(title: "Set Top Text", style: .plain, target: self, action: #selector(topTextTapped))
        let bottomText = UIBarButtonItem(title: "Set Bottom Text", style: .plain, target: self, action: #selector(bottomTextTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [topText, spacer, bottomText]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image else { return }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func addTapped() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        imageView.image = currentImage
    }
    
    @objc func topTextTapped() {
        guard imageView.image != nil else { return }
        
        let ac = UIAlertController(title: "Enter top text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let text = ac.textFields?[0].text else { return }
            self?.submit(text)
        })
        present(ac, animated: true)
    }
    
    @objc func bottomTextTapped() {
        guard imageView.image != nil else { return }
        
        let ac = UIAlertController(title: "Enter bottom text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let text = ac.textFields?[0].text else { return }
            self?.submit(text)
        })
        present(ac, animated: true)
    }
    
    func submit(_ text: String) {
        
    }

}

