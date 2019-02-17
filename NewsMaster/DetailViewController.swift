//
//  DetailViewController.swift
//  NewsMaster
//
//  Created by Vincent Yu on 2/16/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

    // MARK: Properties
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var FailedLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    let indicator = UIActivityIndicatorView()
    var sourceText: String? = nil
    var url: URL? = nil
    var color: UIColor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize
        webView.alpha = 1
        FailedLabel.isHidden = true
        webView.navigationDelegate = self
        
        // Load web page
        guard let url = self.url, let text = sourceText else { return }
        sourceLabel.text = text
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.alpha = 0
        FailedLabel.isHidden = false
        indicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.color = self.color
        indicator.startAnimating()
        indicator.center = CGPoint(x: webView.center.x + stackView.frame.origin.x,
                                   y: webView.center.y + stackView.frame.origin.y)
        
        view.addSubview(indicator)
        indicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.isHidden = true
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
