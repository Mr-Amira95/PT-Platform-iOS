//
//  WebViewViewController.swift
//  PT_Platform
//
//  Created by User on 14/06/2023.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController,  WKNavigationDelegate {
    
    var url: String?
    let webview = WKWebView()

    @IBOutlet weak var pdfView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            openWebView(url)
        }
    }
    
    func openWebView(_ url: String) {
        let webview = WKWebView(frame: UIScreen.main.bounds)
        pdfView.addSubview(webview)
        webview.navigationDelegate = self
        webview.load(URLRequest(url: URL(string: url)!))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
              if url.absoluteString.contains("success") {
                  let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                  let controller = storyboard.instantiateViewController(withIdentifier: "PurchaseSuccesfulVC")
                  controller.modalPresentationStyle = .fullScreen
                  self.present(controller, animated: true, completion: nil)
              } else if url.absoluteString.contains("error") {
                  dismiss(animated: true)
              }
          }
          decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString {
            if url.contains("success") {
                let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PurchaseSuccesfulVC")
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            } else if url.contains("error") {
                dismiss(animated: true)
            }
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
