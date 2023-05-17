//
//  PersonalizedPdfVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 01/12/2022.
//

import UIKit
import PDFKit
import WebKit


class PersonalizedPdfVC: UIViewController, WKNavigationDelegate {
    
    var pdfData = ""
    let webview = WKWebView()

    @IBOutlet weak var pdfView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openPdf()
    }
    
    func openPdf() {
        let webview = WKWebView(frame: UIScreen.main.bounds)
        pdfView.addSubview(webview)
        webview.navigationDelegate = self
        webview.load(URLRequest(url: URL(string: pdfData)!))
        
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
