//
//  ViewController.swift
//  DigimeSkeleton
//
//  Created on 19/09/2017.
//  Copyright © 2017 digi.me Ltd. All rights reserved.
//

import UIKit
import DigiMeFramework
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var FirstButton: UIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet var progressView: UIView!
    @IBOutlet weak var progressStart: UIButton!
    
    var loggerController = LogViewController()
    var DecryptVC = DecryptVCViewController()
    var contractID: String!
    var startDate = Date()
    
    @IBAction func Click(_ sender: Any) {
       // self.performSegue(withIdentifier: VCtoVC2, sender: <#T##Any?#>)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.title = "digi.me Consent Access"
    
        progressView.isHidden = false
        progressLabel.isHidden = false
        progressStart.isHidden = false
        
        initialize()
    }
    
    func initialize() {
        addChildViewController(loggerController)
        self.loggerController.view.frame = view.frame
        self.view.addSubview(loggerController.view)
        self.loggerController.didMove(toParentViewController: self)
        DigiMeFramework.sharedInstance().delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(runTapped))
        
        self.loggerController.log(toView: "Please press 'Start' to begin requesting data. Also make sure that digi.me app is installed and onboarded.")
        self.navigationController?.isToolbarHidden = false
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(title: "➖", style: .plain, target: self, action: #selector(zoomOut))) // replace add with your function
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        //added bar button item
        items.append( UIBarButtonItem(title: "Decrypt", style: .plain, target: self, action: #selector(butt)))
        items.append( UIBarButtonItem(title: "➕", style: .plain, target: self, action: #selector(zoomIn))) // replace add with your function
        self.toolbarItems = items
        
        
        
        
        
    }
    
    //added function
    @objc func butt(){
        self.loggerController.EnterButtonAction()
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "VCtoVC2", sender: self)
            
        }
    }
    @objc func zoomIn () {
        self.loggerController.increaseFontSize()
    }
    @objc func zoomOut () {
        self.loggerController.decreaseFontSize()
    }
    
    
    
    @objc private func runTapped() {
        self.startDate = Date()
        self.loggerController.reset()
        self.contractID = staticConstants.kContractId
        self.requestConsentAccessData(p12FileName: staticConstants.kP12KeyStoreFileName, p12Password: staticConstants.kP12KeyStorePassword)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func requestConsentAccessData(p12FileName: String, p12Password: String) {
        let keyHex = SecurityUtilities.getPrivateKeyHex(p12FileName: p12FileName, p12Password: p12Password)
        DigiMeFramework.sharedInstance().digimeFrameworkInitiateDataRequest(withAppID: staticConstants.kAppId,
                                                                         contractID: self.contractID,
                                                                         rsaPrivateKeyHex:keyHex!)
    }
}

extension ViewController: DigiMeFrameworkDelegate {
    
    func digimeFrameworkLog(withMessage message: String) {
        self.loggerController.log(toView: message)
        
    }
    
    
    func digimeFrameworkReceiveData(withFileNames fileNames: [String]?, filesWithContent: [AnyHashable : Any]?, error: Error?) {
        
        if(error != nil) {
            self.loggerController.log(toView: String(describing: error))
        } else {
            
            self.loggerController.log(toView: String(format: "JFS files: %@", fileNames!))
            self.loggerController.log(toView: String(format: "JFS files content: %@", filesWithContent!))
            
                     if let filesWithContent = filesWithContent {
                do {
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: filesWithContent, options: [.prettyPrinted])
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent("Lucky.txt")
                        do {
                            try jsonData.write(to: fileURL, options: [])
                            print(fileURL)
                        }
                        catch {/* error handling here */}
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
           // creation of csv file
            
             var csvText = "ID,CREATED_DATE,TYPE,AMOUNT,TYPE,CATEGORY,CATEGORYTYPE\n"
             // end csv creation
            
             if let file1 = Bundle.main.url(forResource: "Lucky", withExtension: "txt") {
             let data = try! Data(contentsOf: file1)
             let json = try! JSONSerialization.jsonObject(with: data, options: [])
             let jsonDict = json as? NSDictionary
             
            // let fileNames = ["18_3_17_3_201_D201608_1.json","18_3_17_3_201_D201609_1.json","18_3_17_3_201_D201610_1.json"]
             
                for each in fileNames! {
             let likes = jsonDict![each] as? NSArray
             // let likes1 = jsonDict!["18_1_4_1_1_D201610_1.json"] as? NSArray
             // "18_1_4_1_1_D201610_1.json"
             // let numberOfLikes1 = likes1?.count
             //  print(numberOfLikes1)
             let numberOfLikes = likes?.count
             
             
             for index in 0..<numberOfLikes! {
             if let user = likes![index] as? [String:AnyObject]{
             
             let displayName = user["createddate"]
             let amount = user["amount"]
             let basetype = user["basetype"]
             let id = user["id"]
             let type = user["type"]
             let category = user["category"]
             let categorytype = user["categorytype"]
             var timeStamp = TimeInterval(displayName as! Double)/1000.0
             let day = NSDate(timeIntervalSince1970: timeStamp)
             let formatter = DateFormatter()
             formatter.dateFormat = "dd/MM/yyyy"
             
             let date = formatter.string(from: day as Date)
             // Appending data to the csv file
             let newLine = "\(id!),\(date),\(basetype!),\(amount!),\(type!),\(category!),\(categorytype!),\n"
             csvText.append(newLine)
             print("new line",newLine)
             }
             }
             }
             // writing data to csv file
         
                
                let filename = getDocumentsDirectory().appendingPathComponent("Tasks.csv")
                
                do {
                    try csvText.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                     print("write to csv file successful")
                } catch {
                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                }
              
             }
             else {
             print("no file")
             } 
 
    }
    
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("path",paths[0])
        return paths[0]
    }
    
    
    func digimeFrameworkDidChange(_ state: DigiMeFrameworkOperationState) {
        let elapsed = Date().timeIntervalSince(self.startDate)
        self.loggerController.log(toView: String(format: "state: %@ elapsed in %f seconds", String.getDigiMeSDKStateString(state).uppercased(), elapsed))
    }
    
    func digimeFrameworkJsonFilesDownloadProgress(_ progress: Float) {
        self.loggerController.log(toView: String(format: "progress: %.2f%%", progress * 100))
    }
    
    }


