//
//  DetailViewController.swift
//  16-Milestone-Projects10-12
//
//  Created by deathlezz on 17/08/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var pictures: [Picture]!
    var selectedImage: Picture!
    var selectedImageNumber: Int?
    var totalPictures: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPhoto))
        
        title = "\(selectedImage!.name) | \(selectedImageNumber!) of \(totalPictures!)"
        navigationItem.largeTitleDisplayMode = .never
        
        let path = Utilities.getDocumentDirectory().appendingPathComponent(selectedImage!.image)
        imageView.image = UIImage(contentsOfFile: path.path)
    }
    
    @objc func editPhoto() {
        let ac = UIAlertController(title: "Enter new name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac, weak self] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            self?.selectedImage.name = newName
            
//            self?.performSelector(inBackground: #selector(Utilities.savePicture), with: nil)
            
//            Utilities.savePicture(self!.pictures)
            
            DispatchQueue.global().async { [weak self] in
                Utilities.savePicture(self!.pictures)
                
                DispatchQueue.main.async {
                    self?.title = "\(self!.selectedImage!.name) | \(self!.selectedImageNumber!) of \(self!.totalPictures!)"
                }
            }
//            self?.title = "\(self!.selectedImage!.name) | \(self!.selectedImageNumber!) of \(self!.totalPictures!)"
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

}
