//
//  ViewController.swift
//  Project1-Storm-Viewer
//
//  Created by deathlezz on 11/06/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var viewCount = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendApp))
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
            }
        }
        pictures.sort()
        
        let defaults = UserDefaults.standard
        viewCount = defaults.object(forKey: "ViewCount") as? [String: Int] ?? [String: Int]()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Views: \(viewCount[pictures[indexPath.row], default: 0])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImageNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            viewCount[pictures[indexPath.row], default: 0] += 1
            save()
            navigationController?.pushViewController(vc, animated: true)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    @objc func recommendApp() {
        let shareURL = "https://yourAppURL.com"
        
        let vc = UIActivityViewController(activityItems: [shareURL], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(viewCount, forKey: "ViewCount")
    }

}

