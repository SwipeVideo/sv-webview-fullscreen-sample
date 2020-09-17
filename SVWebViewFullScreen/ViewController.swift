//
//  ViewController.swift
//  SVWebViewFullScreen
//
//  Created by nakazono on 2020/09/17.
//  Copyright © 2020 nakazono. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {
        
    @IBOutlet weak var playerView: UIView!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        if webView == nil {
            let webConfig: WKWebViewConfiguration = WKWebViewConfiguration()
            let userController: WKUserContentController = WKUserContentController()
            userController.add(self, name: "requestFullscreen")
            userController.add(self, name: "exitFullscreen")
            webConfig.userContentController = userController
            webView = WKWebView(frame: playerView.frame, configuration: webConfig)
            view.addSubview(webView)
            
            setupHTML()
        }
    }
    
    private func setupHTML() {
        let htmlString = """
<html>
<header>
<meta name="viewport" content="width=320" />
</header>
<body>
<script src="https://swipevideo.site/libs/embedcdn.js"></script>
<div class="sv-embed" data-cid="1097462e5f"></div>
<script>
  var element = document.getElementsByClassName('sv-embed')[0];
  element.addEventListener('requestFullscreen', function(event) {
    window.webkit.messageHandlers.requestFullscreen.postMessage('');
  });
  element.addEventListener('exitFullscreen', function(event) {
    window.webkit.messageHandlers.exitFullscreen.postMessage('');
  });
</script>
</body>
</html>
"""
        
        webView.loadHTMLString(htmlString,baseURL: nil)
    }
    
    // MARK: - WKScriptMessageHandler

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "requestFullscreen" {
            webView.frame = view.frame
        } else if message.name == "exitFullscreen" {
            webView.frame = playerView.frame
            setupHTML()
        }
    }
}
