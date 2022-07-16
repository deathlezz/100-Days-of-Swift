//
//  TableViewController.swift
//  Project4-Easy-Browser
//
//  Created by deathlezz on 29/06/2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    var websites = ["apple.com", "razer.com", "google.com", "samsung.com"]
    var blockedWebsites = ["google.com"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Websites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {

            if blockedWebsites.contains(websites[indexPath.row]) {
                let ac = UIAlertController(title: "Page blocked", message: "Website \(websites[indexPath.row]) has been blocked", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            } else {
                vc.websiteToLoad = websites[indexPath.row]
                vc.websites = websites
                vc.blockedWebsites = blockedWebsites
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
