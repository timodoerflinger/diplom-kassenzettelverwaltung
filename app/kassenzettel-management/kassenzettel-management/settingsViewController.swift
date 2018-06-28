//
//  preferences-scene.swift
//  kassenzettel-management
//
//  Created by Timo on 20.06.18.
//  Copyright © 2018 Timo. All rights reserved.
//

import Foundation
import CloudKit

class settingsViewController: UIViewController{

    
    var pBudget:Double = 0.0
    
    @IBOutlet weak var textFieldBudget: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func budgetSetzenButton(_ sender: UIButton) {
        
        //https://stackoverflow.com/questions/24115141/converting-string-to-int-with-swift
        let pBudget:Double? = Double(textFieldBudget.text!)
        
        let defaults = UserDefaults.standard
        defaults.set(pBudget, forKey: "MyBudget")
    }
    
    //Menu-Taskbar
    //https://makeapppie.com/2016/07/11/programmatic-navigation-view-controllers-in-swift-3-0/
    @IBAction func cameraSceneButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "cameraScene") else {
            print("View controller cameraScene not found")
            return
        }
        present(vc, animated: true, completion: nil)
    }
    @IBAction func homeSceneButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "homeScene") else {
            print("View controller homeScene not found")
            return
        }
        present(vc, animated: true, completion: nil)
    }
    @IBAction func preferencesSceneButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "preferencesScene") else {
            print("View controller preferencesScene not found")
            return
        }
        present(vc, animated: true, completion: nil)
    }
}


