//
//  DetailViewController.swift
//  Milestone-Projects13-15
//
//  Created by deathlezz on 04/09/2022.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var country: Country!
    let formatter = NumberFormatter()
    let sectionTitles = ["Flag", "General", "Currencies", "Languages"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = country.name
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
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
            return 6
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
            formatter.numberStyle = .decimal
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Name: \(country.name)"
            case 1:
                cell.textLabel?.text = "Capital: \(country.capital ?? "N/A")"
            case 2:
                cell.textLabel?.text = "Region: \(country.region)"
            case 3:
                cell.textLabel?.text = "Subregion: \(country.subregion)"
            case 4:
                cell.textLabel?.text = "Population: \(formatter.string(for: country.population) ?? "N/A")"
            case 5:
                cell.textLabel?.text = "Area: \(formatter.string(for: country.area) ?? "N/A") km²"
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
    
    @objc func shareTapped() {
        guard let image = UIImage(named: "flag_hd_\(country.alpha2Code)")?.jpegData(compressionQuality: 0.8) else {
            print("Image not found.")
            return
        }
        
        var text = """
        GENERAL
            Name: \(country.name)
            Capital: \(country.capital ?? "N/A")
            Region: \(country.region)
            Subregion: \(country.subregion)
            Population: \(formatter.string(for: country.population) ?? "N/A")
            Area: \(formatter.string(for: country.area) ?? "N/A") km²
        CURRENCIES
        """
        
        if country.currencies == nil {
            text.append("\n    N/A")
        } else {
            for currency in country.currencies! {
                text.append(contentsOf: "\n    \(currency.code)")
            }
        }
        
        text.append("\nLANGUAGES")
        
        for language in country.languages {
            text.append(contentsOf: "\n    \(language.name)")
        }
        
        let vc = UIActivityViewController(activityItems: [image, text], applicationActivities: [])
        present(vc, animated: true)
    }
    
}
