//
//  DetailViewController.swift
//  Project7-Whitehouse-Petitions
//
//  Created by deathlezz on 11/07/2022.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let detailItem = detailItem else { return }
        
        let html = """
            <html>
                <head>
                    <meta name= "viewport" content= "width=device-width, initial-scale= 1">
                    <style> body { font-size: 150%; } </style>
                </head>
                <body>
                    <h2>\(detailItem.title)</h2>
                    \(detailItem.body)
                </body>
            </html>
            """
        
        webView.loadHTMLString(html, baseURL: nil)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
