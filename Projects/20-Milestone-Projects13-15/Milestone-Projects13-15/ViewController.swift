//
//  ViewController.swift
//  Milestone-Projects13-15
//
//  Created by deathlezz on 02/09/2022.
//

import UIKit
import Foundation

class ViewController: UITableViewController {
    
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Countries"
        
        loadData()
        
    }
    
    @objc func loadData() {
        if let url = URL(string: "https://restcountries.com/v2/all") {
            if let data = try? Data(contentsOf: url) {
                // we are OK to parse
                parse(json: data)
                print(countries.count)
                return
            }
        }
        print("Failed to load data.")
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCountries = try? decoder.decode([Country].self, from: json) {
            countries = jsonCountries
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flagCell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        
//        if let url = URL(string: countries[indexPath.row].flag) {
//             if let data = try? Data(contentsOf: url) {
//                 cell.imageView!.image = UIImage(data: data)
//             }
//        }
        
        return cell
    }

}

