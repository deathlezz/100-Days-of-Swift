//
//  DetailViewController.swift
//  Milestone-Projects13-15
//
//  Created by deathlezz on 04/09/2022.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var country: Country!
    
    let sectionTitles = ["Flag", "General", "Currencies", "Languages"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = country.name
        navigationItem.largeTitleDisplayMode = .never

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionTitles[section] {
        case "Flag":
            return 1
        case "General":
            return 5
        case "Currencies":
            return country.currencies?.count ?? 1
        case "Languages":
            return country.languages.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionTitles[indexPath.section] {
        case "Flag":

            if let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath) as? FlagCell {
                cell.flagView.image = UIImage(named: "flag_hd_\(country.alpha2Code)")
                cell.flagView.layer.borderWidth = 0.5
                cell.flagView.layer.borderColor = UIColor.darkGray.cgColor
                return cell
            }
            
        case "General":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Name: \(country.name)"
            case 1:
                cell.textLabel?.text = "Capital: \(country.capital ?? "N/A")"
            case 2:
                cell.textLabel?.text = "Region: \(country.subregion)"
            case 3:
                cell.textLabel?.text = "Population: \(country.population)"
            case 4:
                cell.textLabel?.text = "Area: \(country.area ?? 0) km²"
            default:
                return cell
            }
            return cell
            
        case "Currencies":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = country.currencies?[indexPath.row].code ?? "N/A"
            return cell
            
        case "Languages":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = country.languages[indexPath.row].name
            return cell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
}
