//
//  photoViewController.swift
//  swiftocrtest
//
//  Created by Timo on 26.03.18.
//  Copyright © 2018 Timo. All rights reserved.
//

import UIKit
import AVFoundation
import Realm
import RealmSwift

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    //Wenn ein ? dahinter steht, dann bedeutet das wohl dass es optional ist
    var takenPhoto:UIImage?
    var editedPhoto:UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    //die Verbindung zum TextView im storyboard
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var budgetFromSettingsLabel: UILabel!
    @IBOutlet weak var budgetAvailableLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    

    var realm: Realm!
    
    var lastEntryErfassdatum = ""
    var lastEntryEndbetrag:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   
        
        // Get the default Realm
        let realm = try! Realm()
        
        
        
        //let listeRealm: Results<kassenzettel> = realm.objects(kassenzettel.self)()
        
        //gibt den Pfad der Realm-Datei an, die im Realm-Browser geöffnet werden kann
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //gibt den zusammengerechneten Wert aller Kassenzettel aus
        // Query using a predicate string
        //let KR = realm.objects(kassenzettel.self).sum(ofProperty: kassenzettelEndbetrag) // retrieves all Dogs from the default Realm
        //https://stackoverflow.com/questions/31319711/realm-query-sum-of-property
        let addedValues: Double = realm.objects(kassenzettel.self).sum(ofProperty: "kassenzettelEndbetrag")
        
        print(addedValues)
        
        
        var lastEntry: kassenzettel = realm.objects(kassenzettel.self).sorted(byKeyPath: "kassenzettelErfassdatum").first!
        lastEntryErfassdatum = lastEntry.kassenzettelErfassdatum
        lastEntryEndbetrag  = lastEntry.kassenzettelEndbetrag
        

      
        
        
        budgetFromSettingsLabel.text = "Monatliches Budget: 1000.00 SFR"
        budgetAvailableLabel.text = "Noch verfügbares Budget: "
        
        //kassenzettelListe.append(kassenzettel())
    
        //print("kassenzettelListe.startIndex: ",kassenzettelListe.startIndex)
        
        
        tableView.delegate = self //Set the delegate
        tableView.dataSource = self //Set the datasource
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    //http://www.codingexplorer.com/getting-started-uitableview-swift/
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //let row = indexPath.row
        //cell.textLabel?.text = swiftBlogs[row]
        
        //let item = lists[row]
        //cell.textLabel!.text = item.kassenzettelErfassdatum
        
        
        cell.textLabel!.text = lastEntryErfassdatum
        //cell.detailTextLabel!.text =
        
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //let row = indexPath.row
        //print(swiftBlogs[row])
    }
    
   
    
   
    @IBAction func photoSceneButton(_ sender: UIButton) {
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
    
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
