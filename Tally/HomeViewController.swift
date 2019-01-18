import UIKit

class HomeViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var mainWebview: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // We don't want to refresh every time the view appears
    var hasLoadedOnce = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        if(hasLoadedOnce == false) {
            // Hide the loading web view to prevent a flash of loading content
            activityIndicator.startAnimating()
            mainWebview.isHidden = true;
            
            // Attempt to load GA Tally
            let urlString:String = "http://app.genderavenger.com"
            let urlObject:URL = URL(string: urlString)!
            let urlRequest:URLRequest = URLRequest(url: urlObject)
            mainWebview.delegate = self
            mainWebview.loadRequest(urlRequest)
            hasLoadedOnce = true;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        performSegue(withIdentifier: "loadErrorSegue", sender: self)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        // We used injected JS to rewrite any external URLs
        if(request.url!.absoluteString.hasPrefix("newtab:")) {
            let originalString: String = (request.url?.absoluteString)!
            let urlString: String = originalString.substring(from: originalString.characters.index(originalString.startIndex, offsetBy: 7))
            let url: URL = URL(string: urlString)!;
            UIApplication.shared.openURL(url);
            return false
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) { }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Show the webview and stop the animation
        mainWebview.isHidden = false;
        activityIndicator.stopAnimating()
        
        // This is a hack to allow us to detect when a link would open a new tab
        let JSInjection: String = "javascript: var allLinks = document.getElementsByTagName('a'); if (allLinks) {var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target'); if (target && target == '_blank') {link.setAttribute('target','_self');link.href = 'newtab:'+link.href;}}}";
        webView.stringByEvaluatingJavaScript(from: JSInjection);
    }
}

