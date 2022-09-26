//
//  TableViewController.swift
//  Extension
//
//  Created by deathlezz on 24/09/2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    var pageURL = ""
    
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
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ScriptView") as? ActionViewController {
                vc.scriptText = Array(userScripts.values)[indexPath.row]
                self?.navigationController?.pushViewController(vc, animated: true)
                vc.done()
                
                DispatchQueue.global().async {
                    self?.saveHistory(indexPath: indexPath)
                }
            }
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

                self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
                
                DispatchQueue.global().async {
                    self?.saveScripts()
                }
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
                
                self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
                
                DispatchQueue.global().async {
                    self?.saveScripts()
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(alert, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if Array(userScripts.values)[indexPath.row] != "alert(document.title);" && Array(userScripts.values)[indexPath.row] != "alert(document.URL);" {
                userScripts.removeValue(forKey: Array(userScripts.keys)[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                DispatchQueue.global().async { [weak self] in
                    self?.saveScripts()
                }
            } else {
                let ac = UIAlertController(title: "Access denied", message: "You can't delete this script.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    func saveScripts() {
        let defaults = UserDefaults.standard
        defaults.set(userScripts, forKey: "UserScripts")
    }
    
    func saveHistory(indexPath: IndexPath) {
        let value = Array(userScripts.values)[indexPath.row]
        
        if scriptsHistory[pageURL] != nil {
            if !scriptsHistory[pageURL]!.contains(value) {
                scriptsHistory[pageURL]!.append(value)
            }
        } else {
            scriptsHistory[pageURL] = [value]
        }
        
        let defaults = UserDefaults.standard
        defaults.set(scriptsHistory, forKey: "ScriptsHistory")
    }
}
