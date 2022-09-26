//
//  ActionViewController.swift
//  Extension
//
//  Created by deathlezz on 20/09/2022.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var scriptText = ""
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHistory()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let scriptsButton = UIBarButtonItem(title: "Scripts", style: .plain, target: self, action: #selector(showAlert))
        
        let tableViewScripts = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(tableViewScripts))
        
        navigationItem.leftBarButtonItems = [scriptsButton, tableViewScripts]
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.description as String) { [weak self] (dict, error) in
                    // do stuff
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    self?.loadScripts()
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        print(scriptsHistory)
    }

    @IBAction func done() {
        if scriptText.isEmpty {
            scriptText = script.text
        }
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": scriptText as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.description as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
        DispatchQueue.global().async { [weak self] in
            self?.saveHistory()
        }
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    // challenge 1
    @objc func showAlert() {
        let ac = UIAlertController(title: "Scripts", message: nil, preferredStyle: .actionSheet)
        
        for (key, value) in userScripts.sorted(by: >) {
            ac.addAction(UIAlertAction(title: key, style: .default) { [weak self] _ in
                self?.script.text = value
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // challenge 2
    func saveHistory() {
        if let url = URL(string: pageURL) {
            if let host = url.host {
                
                if scriptsHistory[host] != nil {
                    if !scriptsHistory[host]!.contains(scriptText) && !scriptText.isEmpty {
                        scriptsHistory[host]!.append(scriptText)
                    }
                } else {
                    if !scriptText.isEmpty {
                        scriptsHistory[host] = [scriptText]
                    }
                }
                
                let defaults = UserDefaults.standard
                defaults.set(scriptsHistory, forKey: "ScriptsHistory")
            }
        }
    }
    
    func loadHistory() {
        let defaults = UserDefaults.standard
        scriptsHistory = defaults.object(forKey: "ScriptsHistory") as? [String: [String]] ?? [String: [String]]()
    }
    
    // challenge 3
    func loadScripts() {
        let defaults = UserDefaults.standard
        let savedScripts = defaults.object(forKey: "UserScripts") as? [String: String] ?? [String: String]()
        
        if savedScripts.isEmpty {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "TableView") as? TableViewController {
                vc.saveScripts()
            }
        } else {
            userScripts = savedScripts
        }
    }
    
    @objc func tableViewScripts() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TableView") as? TableViewController {
            if let url = URL(string: pageURL) {
                if let host = url.host {
                    vc.pageURL = host
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
