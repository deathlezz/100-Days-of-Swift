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
        let ac = UIAlertController(title: "Enter new name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac, weak self] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            self?.selectedImage.name = newName
            self?.title = "\(self!.selectedImage!.name) | \(self!.selectedImageNumber!) of \(self!.totalPictures!)"
        })
        
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
