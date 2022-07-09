//
//  ViewController.swift
//  08-Milestone-Projects4-6
//
//  Created by deathlezz on 09/07/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Shopping list"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeItems))
        navigationItem.rightBarButtonItems = [add, share]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submit = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let enteredItem = ac?.textFields?[0].text else { return }
            self?.submit(enteredItem)
        }
        
        ac.addAction(submit)
        present(ac, animated: true)
    }
    
    func submit(_ item: String) {
        if !item.isEmpty {
            shoppingList.insert(item, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            return
            
        } else {
            let ac = UIAlertController(title: "Empty field", message: "Try to add some text inside", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func removeItems() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func shareTapped() {
        let list = shoppingList.joined(separator: "\n")
        
        if !list.isEmpty {
            let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
            
        } else {
            let ac = UIAlertController(title: "Empty list", message: "Try to add some items first", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
}

