//
//  SlideView.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 10/4/19.
//  Copyright © 2019 iOS Team. All rights reserved.

import UIKit
import WebKit

class SlideView: UIView {
    
    private var db = DB()
    private var labelName = UILabel()
    private var webView = WKWebView()
    private var slide = Slide()
    
    init(_ slide: Slide, frameSlide: CGRect) {
        
//        let frame = CGRect(x: 20, y: 50, width: frameSlide.width - 40, height: frameSlide.height - 100)
        let frame = CGRect(x: frameSlide.origin.x, y: frameSlide.origin.y, width: frameSlide.width, height: frameSlide.height)
        
        super.init(frame: frame)
        
        self.slide = slide
        prepareSlide(&self.slide)
        
        // need to make with guard
        let name = self.slide.name
        var html = self.slide.html ?? ""
        let baseUrl = self.slide.baseUrl ?? URL(string: "")
        
        if slide.id == 51 {
            html = ""
        }
        
        print("super.init(frame: frame) =", frame)
        
        var w = frame.width
        var h = frame.height
        if w < h {
            w = frame.height
            h = frame.width
        }
        
        self.webView.frame = CGRect(x: 0, y: 0, width: w, height: h)
         
        self.webView.loadHTMLString(html, baseURL: baseUrl)
        print("self.webView.frame =", self.webView.frame)
        
        self.labelName = createLabel(name)
        
//        print("делаем прозрачным webView")
//        webView.isUserInteractionEnabled = true
        
        self.addSubview(self.webView)
    }
    
    deinit {
        self.labelName.removeFromSuperview()
        self.webView.removeFromSuperview()
        self.slide = Slide()
        
        print("deinit slideview")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SlideView {
    
    private func prepareSlide(_ slide: inout Slide) {
        
        let id = slide.id
        
        // TODO: - need to make with guard or if and use class for cell of the tableView
        let nameTopic = (slide.nameTopic != nil) ? (slide.nameTopic! + ": ") : ""
        let name = slide.name
        let search = (slide.search != nil) ? (" - " + slide.search!) : ""
        
        let info = db.getInfoAboutDocForSlide(id)
        
        FM.checkDocSlide(info)
        
        let html = db.getHTML(id)
        
        let getUrlForSlide = FM.getUrlForSlide(id)
        print("getUrlForSlide = ", getUrlForSlide)
        
        FM.printListItemsFromDir(getUrlForSlide.path)
        
        let nameSlide = nameTopic + name + search
        
        slide = Slide(id: id, name: nameSlide, nameTopic: nameTopic, search: search, html: html, baseUrl: getUrlForSlide)
    }
}

// MARK: - create item for view
extension SlideView {
    
    private func createLabel(_ name: String) -> UILabel {
        
        let labelName = UILabel(frame: CGRect(x: 0, y: 0, width: 728, height: 80))
        labelName.font = .boldSystemFont(ofSize: 25)
        labelName.numberOfLines = 0
        labelName.textColor = .green
        labelName.backgroundColor = .lightGray
        labelName.textAlignment = .natural
        labelName.text = name
        labelName.sizeToFit()
        print("self.labelName.frame =", self.labelName.frame)
        
        return labelName
    }
}


/* code for output hmvl file in webview, before save it file in folder
 let getUrlHTMLFile = FM.getUrlHTMLFile(id: id, nameFile: name)
 FM.saveHTMLFile(html: html, url: getUrlHTMLFile)
 let request = URLRequest(url: getUrlHTMLFile)
 webView.load(request)
 webView.loadFileURL(getUrlHTMLFile, allowingReadAccessTo: getUrlHTMLFile) */
