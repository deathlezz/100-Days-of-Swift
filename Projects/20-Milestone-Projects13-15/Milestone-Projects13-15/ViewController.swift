//
//  ViewController.swift
//  Milestone-Projects13-15
//
//  Created by deathlezz on 02/09/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()
    var filteredCountries = [Country]()
    var currencies = [Currency]()
    var language: Language!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 70
        
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
    }
    
    @objc func filterTapped() {
        let ac = UIAlertController(title: "Filter", message: "Enter a word to filter, leave field empty to reset.", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak ac, weak self] _ in
            guard let word = ac?.textFields?[0].text else { return }
            self?.submit(word)
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func submit(_ word: String) {
        // reset filter
        if word.isEmpty {
            filteredCountries = countries
            navigationItem.rightBarButtonItem?.title = "Filter"
            return
        }
        filteredCountries.removeAll()
        
        for country in countries {
            if country.name.lowercased().contains(word.lowercased()) {
                filteredCountries.append(country)
            }
        }
        navigationItem.rightBarButtonItem?.title = "Filter: \(word)"
    }
    
    @objc func loadData() {
        if let url = URL(string: "https://restcountries.com/v2/all") {
            if let data = try? Data(contentsOf: url) {
                // we are OK to parse
                parse(json: data)
                return
            }
        }
        print("Failed to load data.")
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCountries = try? decoder.decode([Country].self, from: json) {
            countries = jsonCountries
            filteredCountries = countries
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "flagCell", for: indexPath) as? CountryCell else {
            fatalError("Unable to dequeue flagCell.")
        }
        
        cell.countryLabel.text = filteredCountries[indexPath.row].name
        cell.flagView.image = UIImage(named: "flag_sd_\(filteredCountries[indexPath.row].alpha2Code)")
        cell.flagView.layer.borderColor = UIColor.darkGray.cgColor
        cell.flagView.layer.borderWidth = 0.5
        cell.flagView.layer.cornerRadius = 3
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.country = filteredCountries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

