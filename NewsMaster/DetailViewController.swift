//
//  DetailViewController.swift
//  NewsMaster
//
//  Created by Vincent Yu on 2/16/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit
import WebKit

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
}

class DetailViewController: UIViewController, WKNavigationDelegate {

    // MARK: Properties
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var FailedLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var barUIVIew: UIView!
    
    let indicator = UIActivityIndicatorView()
    var sourceText: String? = nil
    var urlString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize
        webView.alpha = 1
        FailedLabel.isHidden = true
        webView.navigationDelegate = self
        
        // Add observer
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        
        // Load web page
        guard let url = URL(string: self.urlString ?? ""), let text = sourceText else { return }
        sourceLabel.text = text
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        // TODO
        if let data = notification.userInfo as? [String : String] {
            for (key, value) in data {
                switch(key) {
                case "source":
                    sourceLabel.text = value
                    break
                case "url":
                    guard let url = URL(string: value) else { return }
                    webView.load(URLRequest(url: url))
                    break
                default:
                    fatalError("Error: Unsolved Notification InfoData")
                }
            }
        }
        else {
            webView.alpha = 0
            FailedLabel.isHidden = false
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.alpha = 0
        FailedLabel.isHidden = false
        indicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.color = barUIVIew.backgroundColor
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
