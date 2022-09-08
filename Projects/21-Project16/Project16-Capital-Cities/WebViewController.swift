//
//  WebViewController.swift
//  Project16-Capital-Cities
//
//  Created by deathlezz on 08/09/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    var website: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.largeTitleDisplayMode = .never
        
        guard website != nil else {
            print("Website not set")
            navigationController?.popViewController(animated: true)
            return
        }
        
        if let url = URL(string: website) {
            webView.load(URLRequest(url: url))
        }
    }
}
