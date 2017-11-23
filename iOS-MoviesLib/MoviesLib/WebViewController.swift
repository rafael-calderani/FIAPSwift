//
//  WebViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 11/09/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading.startAnimating()
        webView.delegate = self
        
        let webURL = URL(string: url)!
        let request = URLRequest(url: webURL)
        webView.loadRequest(request)    
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func runJS(_ sender: Any) {
        webView.stringByEvaluatingJavaScript(from: "alert('Rodando JavaScript na WebView.');")
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var result = true
        
        let absoluteURLString = request.url!.absoluteString
        
        if absoluteURLString.range(of: "facebook") != nil {
            let alert = UIAlertController(title: "URL Blocked", message: "This app does not like Facebook.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
            result = false
        }
        
        return result
    }
}
