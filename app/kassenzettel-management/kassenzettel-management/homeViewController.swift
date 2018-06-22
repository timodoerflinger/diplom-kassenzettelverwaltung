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
    
    var takenPhoto:UIImage?
    var editedPhoto:UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var budgetFromSettingsLabel: UILabel!
    @IBOutlet weak var budgetAvailableLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var realm: Realm!
    
    var lastEntryErfassdatum = ""
    var lastEntryEndbetrag:Double = 0.0
    
    var arrayDatum:[String] = [""]
    var arrayBetrag:[Double] = [0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Get the default Realm
        let realm = try! Realm()
        
        //gibt den Pfad der Realm-Datei an, die im Realm-Browser geöffnet werden kann
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //Gibt den zusammengerechneten Wert aller Kassenzettel aus
        // Query using a predicate string
        //let KR = realm.objects(kassenzettel.self).sum(ofProperty: kassenzettelEndbetrag) // retrieves all Dogs from the default Realm
        //https://stackoverflow.com/questions/31319711/realm-query-sum-of-property
        let addedValues: Double = realm.objects(kassenzettel.self).sum(ofProperty: "kassenzettelEndbetrag")
        //print(addedValues)
        
        //Beschreibt die zwei Labels mit dem gesetzten monatlichen Budget und dem noch übrigen monatlichen Budget
        budgetFromSettingsLabel.text = "Monatliches Budget: 1000.00 SFR"
        budgetAvailableLabel.text = "Noch verfügbares Budget: "
        
        //Wichtige Angaben für das TableView
        tableView.delegate = self //Set the delegate
        tableView.dataSource = self //Set the datasource
        
        //Funktioniert nicht, gibt nul-Reference zurück, kann nicht gelöst werden, daher die manuelle Alternative
        //let listeRealm: Results<kassenzettel> = realm.objects(kassenzettel.self)()
        
        //ascending: https://stackoverflow.com/questions/34283405/how-to-sort-using-realm
        let lastEntry: kassenzettel = realm.objects(kassenzettel.self).sorted(byKeyPath: "kassenzettelID", ascending: false).first!
        let lastEntryKassenzettelID = lastEntry.kassenzettelID
        print("lastEntryID: ",lastEntryKassenzettelID)
        let lastEntryKassenzettelErfassdatum = lastEntry.kassenzettelErfassdatum
        let lastEntryKassenzettelEndbetrag = lastEntry.kassenzettelEndbetrag
        
        let secondLastEntryID  = lastEntryKassenzettelID - 1
        let secondLastEntry: kassenzettel = realm.objects(kassenzettel.self).filter("kassenzettelID == %@", secondLastEntryID).first! //"== %@" -> https://stackoverflow.com/questions/42772523/swift-filtering-records-using-realm
        //let secondLastEntryID  = secondLastEntry.kassenzettelID
        print("secondLastEntryID: ",secondLastEntryID)
        let secondLastEntrykassenzettelErfassdatum = secondLastEntry.kassenzettelErfassdatum
        let secondLastEntrykassenzettelEndbetrag = secondLastEntry.kassenzettelEndbetrag
        
        let thirdLastEntryID  = lastEntryKassenzettelID - 2
        let thirdLastEntry: kassenzettel = realm.objects(kassenzettel.self).filter("kassenzettelID == %@", thirdLastEntryID).first!
        //let thirdLastEntryID  = thirdLastEntry.kassenzettelID
        print("thirdLastEntryID: ",thirdLastEntryID)
        let thirdLastEntrykassenzettelErfassdatum = thirdLastEntry.kassenzettelErfassdatum
        let thirdLastEntrykassenzettelEndbetrag = thirdLastEntry.kassenzettelEndbetrag
        
        //Erstellt zwei Arrays aus den ausgelesenen Werten (siehe direkt obendran), die TableView setzt dann die Werte aus dem Array in seine Zellen
        arrayDatum = [lastEntryKassenzettelErfassdatum,secondLastEntrykassenzettelErfassdatum, thirdLastEntrykassenzettelErfassdatum]
        arrayBetrag = [lastEntryKassenzettelEndbetrag, secondLastEntrykassenzettelEndbetrag, thirdLastEntrykassenzettelEndbetrag]
        
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
        
        let row = indexPath.row
        cell.textLabel?.text = arrayDatum[row]
        //cell.detailTextLabel!.text = arrayBetrag[row]
        return cell
    }
    // MARK:  UITableViewDelegate Methods
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
   
    
   
    //Menu-Taskbar
    //https://makeapppie.com/2016/07/11/programmatic-navigation-view-controllers-in-swift-3-0/
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
