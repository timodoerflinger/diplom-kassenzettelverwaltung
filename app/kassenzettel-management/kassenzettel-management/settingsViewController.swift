//
//  preferences-scene.swift
//  kassenzettel-management
//
//  Created by Timo on 20.06.18.
//  Copyright © 2018 Timo. All rights reserved.
//

import Foundation

class settingsViewController: UIViewController {
    
    var pBudget = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Menu-Taskbar
    //https://makeapppie.com/2016/07/11/programmatic-navigation-view-controllers-in-swift-3-0/
    @IBAction func cameraSceneButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "cameraScene") else {
            print("View controller Six not found")
            return
        }
        present(vc, animated: true, completion: nil)
    }
    @IBAction func homeSceneButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "homeScene") else {
            print("View controller Six not found")
            return
        }
        present(vc, animated: true, completion: nil)
    }
    @IBAction func preferencesSceneButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "preferencesScene") else {
            print("View controller Six not found")
            return
        }
        present(vc, animated: true, completion: nil)
    }
}

class personalBudget{

    //https://syntaxdb.com/ref/swift/getters-setters
    /*private var Budget: Double = 0.0
    init(Budget: Double) {
        self.Budget = 10000.00
    }
    var BudgetGS: Double {
        get {
            return Budget
        }
        set(newBudget) {
            self.Budget = newBudget
        }
    }*/
    
    //https://stackoverflow.com/questions/44442941/data-encapsulation-and-security-in-swift
    /*private var _Budget: Double!
    
    var budget: Double {
        get {
            if _Budget == nil {
                //fetch _weight from somewhere
            }
            return _Budget!
        }
        set {
            _Budget = newValue
        }
    }*/
    
}




