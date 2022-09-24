//
//  TableViewController.swift
//  Extension
//
//  Created by deathlezz on 24/09/2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScript))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScripts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = Array(userScripts.keys)[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Open", style: .default) { [weak self] _ in

        })
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let alert = UIAlertController(title: "Enter new name", message: nil, preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak alert] _ in
                guard let newName = alert?.textFields?[0].text else { return }
                let oldKey = Array(userScripts.keys)[indexPath.row]
                let oldValue = userScripts[oldKey]
                
                userScripts.removeValue(forKey: oldKey)
                userScripts[newName] = oldValue
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(alert, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func addScript() {
        let ac = UIAlertController(title: "Add script", message: "Enter script name", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            let alert = UIAlertController(title: "Add script", message: "Enter script itself", preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
                guard let script = alert.textFields?[0].text else { return }
                userScripts[name] = script
                self?.tableView.reloadData()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(alert, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

}
