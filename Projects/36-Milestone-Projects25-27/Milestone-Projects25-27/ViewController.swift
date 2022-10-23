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
    
    var topTextImage: UIImage!
    var bottomTextImage: UIImage!
    var fullTextImage: UIImage!
    
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
        
        let vc = UIActivityViewController(activityItems: [image, "MEME"], applicationActivities: [])
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
            // leave field empty to reset
            guard let text = ac.textFields?[0].text else { return }
            self?.submit(text, "top")
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
            self?.submit(text, "bottom")
        })
        present(ac, animated: true)
    }
    
    func submit(_ text: String, _ place: String) {
        let renderer = UIGraphicsImageRenderer(size: currentImage.size)
        
        let image = renderer.image { ctx in
            // awesome drawing code
            
            currentImage.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white.cgColor,
                .strokeColor: UIColor.black.cgColor,
                .strokeWidth: -3,
                .font: UIFont(name: "Helvetica Bold", size: 90)!,
                .paragraphStyle: paragraphStyle
            ]
            
            if place == "top" {
                let attributedString = NSAttributedString(string: text, attributes: attrs)
                attributedString.draw(with: CGRect(x: 32, y: 32, width: currentImage.size.width - 64, height: currentImage.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
            } else if place == "bottom" {
                let attributedString = NSAttributedString(string: text, attributes: attrs)
                attributedString.draw(with: CGRect(x: 32, y: currentImage.size.height - 128, width: currentImage.size.width - 64, height: currentImage.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        if place == "top" && text.isEmpty {
            topTextImage = nil
        } else if place == "bottom" && text.isEmpty {
            bottomTextImage = nil
        } else if place == "top" {
            topTextImage = image
        } else if place == "bottom" {
            bottomTextImage = image
        }
        
        if topTextImage == nil {
            imageView.image = bottomTextImage
        } else if bottomTextImage == nil {
            imageView.image = topTextImage
        } else {
            imageView.image = image
        }
    }

}

