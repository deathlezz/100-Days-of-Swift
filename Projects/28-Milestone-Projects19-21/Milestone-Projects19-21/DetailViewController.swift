//
//  DetailViewController.swift
//  Milestone-Projects19-21
//
//  Created by deathlezz on 01/10/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var indexPathRow: Int!
    var text = ""
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        let save = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveNote))
        
        navigationItem.rightBarButtonItems = [save, share]
        
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        toolbarItems = [delete]
        UIToolbar.appearance().tintColor = .systemOrange
        navigationController?.isToolbarHidden = false
        
        let notifiactionCenter = NotificationCenter.default
        notifiactionCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notifiactionCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if !text.isEmpty {
            textView.text = text
        }
    }
    
    @objc func saveNote() {
        if !textView.text.isEmpty && indexPathRow == nil {
            notes.insert(textView.text, at: 0)
        } else if !textView.text.isEmpty && indexPathRow != nil {
            notes[indexPathRow] = textView.text
        }
        
        filteredNotes = notes
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func deleteNote() {
        guard indexPathRow != nil else { return }
        
        let ac = UIAlertController(title: "Delete", message: "Are you sure, you want to delete this note?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            notes.remove(at: self!.indexPathRow)
            filteredNotes = notes
            self?.navigationController?.popToRootViewController(animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func shareNote() {
        guard indexPathRow != nil else { return }
        
        let vc = UIActivityViewController(activityItems: [filteredNotes[indexPathRow]], applicationActivities: [])
        present(vc, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
