//
//  DetailViewController.swift
//  16-Milestone-Projects10-12
//
//  Created by deathlezz on 17/08/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: Picture!
    var selectedImageNumber: Int?
    var totalPictures: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPhoto))
        
        title = "\(selectedImage!.name) | \(selectedImageNumber!) of \(totalPictures!)"
        navigationItem.largeTitleDisplayMode = .never
        
        let path = ViewController().getDocumentDirectory().appendingPathComponent(selectedImage!.image)
        imageView.image = UIImage(contentsOfFile: path.path)
    }
    
    @objc func editPhoto() {
        let ac = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Change name", style: .default) { [weak self] _ in
            let alert = UIAlertController(title: "Enter new name", message: nil, preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak alert, weak self] _ in
                guard let newName = alert?.textFields?[0].text else { return }
                self?.selectedImage.name = newName
                self?.title = "\(self!.selectedImage!.name) | \(self!.selectedImageNumber!) of \(self!.totalPictures!)"
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(alert, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
