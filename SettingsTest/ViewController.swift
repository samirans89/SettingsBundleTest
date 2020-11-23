//
//  ViewController.swift
//  SettingsTest


import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        registerSettingsBundle()
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        defaultsChanged()
    }
    
    private func loadDefaults() {
        let userDefaults = UserDefaults.standard

        let pathStr = Bundle.main.bundlePath
        let settingsBundlePath = (pathStr as NSString).appendingPathComponent("Settings.bundle")
        let finalPath = (settingsBundlePath as NSString).appendingPathComponent("Root.plist")
        let settingsDict = NSDictionary(contentsOfFile: finalPath)
        guard let prefSpecifierArray = settingsDict?.object(forKey: "PreferenceSpecifiers") as? [[String: Any]] else {
            return
        }

        var defaults = [String: Any]()

        for prefItem in prefSpecifierArray {
            guard let key = prefItem["Key"] as? String else {
                continue
            }
            defaults[key] = prefItem["DefaultValue"]
        }
        userDefaults.register(defaults: defaults)
    }
    
    func registerSettingsBundle(){
        loadDefaults();
    }
    
    @objc func defaultsChanged(){
    
        var theme = false
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            //print("\(key) = \(value) \n")
        
            if(key.elementsEqual("theme")) {
                print("\(key) = \(value) \n")
                if let b = value as? String {
                    if(b.elementsEqual("red")) {
                        theme = true
                    }
                } else {
                    print("Error") // Was not a string
                }
            }
            
        }
        
     
        if theme {
            self.view.backgroundColor = UIColor.red
        }
        else {
            self.view.backgroundColor = UIColor.green
        }
    }
    
    deinit { //Not needed for iOS9 and above. ARC deals with the observer in higher versions.
        NotificationCenter.default.removeObserver(self)
    }
}


