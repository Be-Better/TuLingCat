

import UIKit

class WebViewController: UIViewController {
    
    let webView: UIWebView = {
        let webView = UIWebView(frame:CGRectZero)
        return webView
    }()
    var preButton: UIButton!
    var nextButton: UIButton!
    var closeButton: UIButton!
    let url: String!
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        let request = NSURLRequest(URL: NSURL(string: self.url)!)
        self.webView.loadRequest(request)
    }

}
