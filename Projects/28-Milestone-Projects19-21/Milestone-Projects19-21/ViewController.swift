//
//  ViewController.swift
//  Milestone-Projects19-21
//
//  Created by deathlezz on 01/10/2022.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        
        performSelector(inBackground: #selector(load), with: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredNotes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.indexPathRow = indexPath.row
            vc.text = filteredNotes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addNote() {
        guard navigationItem.leftBarButtonItem?.title == "Filter" else { return }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            notes.insert("", at: 0)
            filteredNotes = notes
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            vc.indexPathRow = 0
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        if notes.contains("") {
            notes.remove(at: 0)
            filteredNotes = notes
            tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ac = UIAlertController(title: "Delete", message: "Are you sure, you want to delete this note?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
                let index = notes.firstIndex(of: filteredNotes[indexPath.row])
                filteredNotes.remove(at: indexPath.row)
                notes.remove(at: index!)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                self?.performSelector(inBackground: #selector(self?.save), with: nil)
                
                if notes.isEmpty {
                    self?.submit("")
                }
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    @objc func filterTapped() {
        if notes.isEmpty { return }
        
        let ac = UIAlertController(title: "Filter", message: "Enter text to filter notes", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let word = ac?.textFields?[0].text else { return }
            self?.submit(word)
            self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func submit(_ word: String) {
        if word.isEmpty {
            filteredNotes = notes
            navigationItem.leftBarButtonItem?.title = "Filter"
            return
        }
        filteredNotes.removeAll()
        
        for note in notes {
            if note.lowercased().contains(word.lowercased()) {
                filteredNotes.append(note)
            }
        }
        navigationItem.leftBarButtonItem?.title = "Filter: \(word)"
    }
    
    @objc func save() {
        let defaults = UserDefaults.standard
        defaults.set(notes, forKey: "Notes")
    }
    
    @objc func load() {
        let defaults = UserDefaults.standard
        notes = defaults.object(forKey: "Notes") as? [String] ?? [String]()
        filteredNotes = notes
    }
}
