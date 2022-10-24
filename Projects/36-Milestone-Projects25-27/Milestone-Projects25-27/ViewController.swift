//
//  ViewController.swift
//  Milestone-Projects25-27
//
//  Created by deathlezz on 22/10/2022.
//

enum Position {
    case top
    case bottom
}

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var currentImage: UIImage!
    
    var topCaption: String?
    var bottomCaption: String?
    
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
        
        let vc = UIActivityViewController(activityItems: [image, "meme"], applicationActivities: [])
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
        topCaption = nil
        bottomCaption = nil
        imageView.image = currentImage
    }
    
    @objc func topTextTapped() {
        guard imageView.image != nil else { return }
        
        let ac = UIAlertController(title: "Enter top text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            // leave field empty to reset
            guard let text = ac.textFields?[0].text else { return }
            self?.topCaption = text
            self?.submit()
        })
        present(ac, animated: true)
    }
    
    @objc func bottomTextTapped() {
        guard imageView.image != nil else { return }
        
        let ac = UIAlertController(title: "Enter bottom text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            // leave field empty to reset
            guard let text = ac.textFields?[0].text else { return }
            self?.bottomCaption = text
            self?.submit()
        })
        present(ac, animated: true)
    }
    
    func submit() {
        let renderer = UIGraphicsImageRenderer(size: currentImage.size)
        
        let image = renderer.image { ctx in
            currentImage.draw(at: CGPoint(x: 0, y: 0))
            
            if let topCaption = topCaption {
                addText(text: topCaption, position: .top)
            }
            
            if let bottomCaption = bottomCaption {
                addText(text: bottomCaption, position: .bottom)
            }
        }
        
        imageView.image = image
    }
    
    func addText(text: String, position: Position) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.cgColor,
            .strokeColor: UIColor.black.cgColor,
            .strokeWidth: -3,
            .font: UIFont(name: "Helvetica Bold", size: 90)!,
            .paragraphStyle: paragraphStyle
        ]
        
        let textHeight = calculateTextHeight(text: text, attributes: attrs)
        let startY = currentImage.size.height - CGFloat(textHeight + 32)
        
        if position == .top {
            let attributedString = NSAttributedString(string: text, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: currentImage.size.width - 64, height: currentImage.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
        } else if position == .bottom {
            let attributedString = NSAttributedString(string: text, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: startY, width: currentImage.size.width - 64, height: CGFloat(textHeight)), options: .usesLineFragmentOrigin, context: nil)
        }
    }
    
    func calculateTextHeight(text: String, attributes: [NSAttributedString.Key : Any]) -> Int {
        let nsText = NSString(string: text)
        let size = CGSize(width: CGFloat(currentImage.size.width), height: .greatestFiniteMagnitude)
        let textRect = nsText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return Int(ceil(textRect.size.height))
    }

}

