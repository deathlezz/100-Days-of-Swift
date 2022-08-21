//
//  ViewController.swift
//  16-Milestone-Projects10-12
//
//  Created by deathlezz on 17/08/2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 100
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        
        DispatchQueue.global().async { [weak self] in
            self?.pictures = Utilities.loadPicture()
        }
        
    }
    
    @objc func addPicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let ac = UIAlertController(title: "Source", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.showPicker(fromCamera: true)
            })
            
            ac.addAction(UIAlertAction(title: "Photos", style: .default) { [weak self] _ in
                self?.showPicker(fromCamera: false)
            })
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
            
        } else {
            showPicker(fromCamera: false)
        }
    }
    
    func showPicker(fromCamera: Bool) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if fromCamera {
            picker.sourceType = .camera
        }
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        DispatchQueue.global().async { [weak self] in
            let imageName = UUID().uuidString
            let imagePath = Utilities.getDocumentDirectory().appendingPathComponent(imageName)
            
            if let jpegData = image.jpegData(compressionQuality: 1) {
                try? jpegData.write(to: imagePath)
            }
            
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
                
                let ac = UIAlertController(title: "Enter caption", message: nil, preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac, weak self] _ in
                    guard let caption = ac?.textFields?[0].text else { return }
                    let picture = Picture(name: caption, image: imageName)
                    let indexPath = IndexPath(row: 0, section: 0)
                    self?.pictures.insert(picture, at: 0)
                    
                    DispatchQueue.global().async { [weak self] in
                        Utilities.savePicture(self!.pictures)
                        
                        DispatchQueue.main.async {
                            self?.tableView.insertRows(at: [indexPath], with: .automatic)
                        }
                    }
                
                })
                
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self?.present(ac, animated: true)
            }
        }
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue PictureCell")
        }
        
        let path = Utilities.getDocumentDirectory().appendingPathComponent(pictures[indexPath.row].image)
        
        cell.pictureLabel.text = pictures[indexPath.row].name
        cell.pictureView.image = UIImage(contentsOfFile: path.path)
        cell.pictureView.layer.cornerRadius = 5
        cell.pictureView.layer.borderColor = UIColor.black.cgColor
        cell.pictureView.layer.borderWidth = 0.1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.pictures = pictures
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImageNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pictures.remove(at: indexPath.row)
            
            DispatchQueue.global().async { [weak self] in
                Utilities.savePicture(self!.pictures)
                
                DispatchQueue.main.async {
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        
        }
    }

}

