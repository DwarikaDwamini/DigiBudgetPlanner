//
//  LogViewController.swift
//  DigiMeSkeleton
//
//  Created on 20/09/2017.
//  Copyright © 2017 digi.me Ltd. All rights reserved.
//

import Foundation
import UIKit

private let kMALoggingViewDefaultFontSize: CGFloat = 10
private let kMALoggingViewMinFontSize: CGFloat = 2
private let kMALoggingViewMaxFontSize: CGFloat = 28
private let kMALoggingViewDefaultFont = "Courier-Bold"




class LogViewController: UIViewController  {
    var textView: UITextView?
    var currentFontSize: CGFloat = 0.0
    
    
    
  
   
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentFontSize = kMALoggingViewDefaultFontSize
        generateTextView()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Shrink Font", style: .plain, target: self, action: #selector(self.decreaseFontSize))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Grow Font", style: .plain, target: self, action: #selector(self.increaseFontSize))
    }
    
    // MARK: - Navigation button actions
    @objc func increaseFontSize() {
        if currentFontSize >= kMALoggingViewMaxFontSize {
            return
        }
        currentFontSize += 1
        textView?.font = UIFont(name: kMALoggingViewDefaultFont, size: currentFontSize)
    }
    
    @objc func decreaseFontSize() {
        if currentFontSize <= kMALoggingViewMinFontSize {
            return
        }
        currentFontSize -= 1
        textView?.font = UIFont(name: kMALoggingViewDefaultFont, size: currentFontSize)
    }
    
    //changed code
    
    @objc func EnterButtonAction(){
        
       
        }
      /*     do {
                if let file = Bundle.main.url(forResource: "https://api.digi.me/v1/permission-access/query/sKyzixtmN9NIAdXCXtJ5oSG6wtf67WgA/18_1_4_3_1_D201610_1.json", withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [String: Any] {
                        // json is a dictionary
                        print(object)
                    } else if let object = json as? [Any] {
                        // json is an array
                        print(object)
                    } else {
                        print("JSON is invalid")
                    }
                } else {
                    print("no file")
                }
            } catch {
                print(error.localizedDescription)
            } */
        
/*   var names = [String]()
        do
        {
            if let data = Data,
                let json = try JSONSerialization.jsonObject(with: Data, options: JSONSerialization) as? [String:Any],
            let blogs = json["blogs"] as? [[String:any]]{
                for blog in blogs{
                    if let name = ["baseid"] as? String {
                        names.append(name)
                    }
                }
            }
        }    catch {
            print("Error deserializing JSON:\(error)")
        }
        print(names)
        
     */
        
    
    
    // MARK: - Text view
    func reset() {
        if textView != nil {
            textView?.removeFromSuperview()
        }
        generateTextView()
    }
    
    func generateTextView() {
    
        textView = UITextView(frame: view.frame)
        textView?.backgroundColor = UIColor.cyan
       // textView?.autoresizingMask = [UIViewAutoresizing(rawValue: 100), UIViewAutoresizing(rawValue: 100)]
        textView?.isEditable = false
        textView?.font = UIFont(name: kMALoggingViewDefaultFont, size: currentFontSize)
        textView?.textColor = UIColor.black
        view.addSubview(textView!)
       // textView?.isHidden = true
    }
    
    func scrollToBottom() {
        textView?.scrollRangeToVisible(NSRange(location: (textView?.text.characters.count ?? 0), length: 0))
        textView?.isScrollEnabled = false
        textView?.isScrollEnabled = true
    }
    
 
    
    
    // MARK: - Logging
    func log(toView logText: String) {

        if logText == "" {
            return
        }
        let now = Date()
        let formatter = DateFormatter()
        
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dateString: String = formatter.string(from: now)

        DispatchQueue.main.async(execute: {() -> Void in
            let prevText = (self.textView?.text)!
            self.textView?.text = (prevText + ("\n\(dateString) " + "\(logText) "))

            self.scrollToBottom()
        })

        print("\(logText)")
    }
    //changed code
    
   
    
    
    
    
    
    
    
    
    
}
