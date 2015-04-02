//
//  ViewController.swift
//  Tally
//
//  Created by Daniel Schultz on 3/22/15.
//  Copyright (c) 2015 Gender Avenger. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var mainWebview: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        
        // Hide the loading web view to prevent a flash of loading content
        activityIndicator.startAnimating()
        mainWebview.hidden = true;
        
        // Attempt to load GA Tally
        var urlString:NSString = "http://even-steven-yoni-test.herokuapp.com"
        var urlObject:NSURL = NSURL(string: urlString)!
        var urlRequest:NSURLRequest = NSURLRequest(URL: urlObject)
        mainWebview.delegate = self
        mainWebview.loadRequest(urlRequest)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        performSegueWithIdentifier("loadErrorSegue", sender: self)
    }
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        // We used injected JS to rewrite any external URLs
        if(request.URL.absoluteString!.hasPrefix("newtab:")) {
            var urlString: NSString = (request.URL.absoluteString! as NSString).substringFromIndex(7);
            var url: NSURL = NSURL(string: urlString)!;
            UIApplication.sharedApplication().openURL(url);
            return false
        }
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        // Show the webview and stop the animation
        mainWebview.hidden = false;
        activityIndicator.stopAnimating()
        
        // This is a hack to allow us to detect when a link would open a new tab
        var JSInjection: NSString = "javascript: var allLinks = document.getElementsByTagName('a'); if (allLinks) {var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target'); if (target && target == '_blank') {link.setAttribute('target','_self');link.href = 'newtab:'+link.href;}}}";
        webView.stringByEvaluatingJavaScriptFromString(JSInjection);
    }
}

