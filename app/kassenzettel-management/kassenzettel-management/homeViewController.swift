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
    var countEntrys: Int = 0
    
    
    var lastEntryErfassdatum = ""
    var lastEntryEndbetrag:Double = 0.0
    
    var arrayDatum:[String] = [""]
    var arrayBetrag:[String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the default Realm
        let realm = try! Realm()
        
        //gibt den Pfad der Realm-Datei an, die im Realm-Browser geöffnet werden kann
        //https://stackoverflow.com/questions/28465706/how-to-find-my-realm-file/28465803#28465803
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //Ist für das gesetzte Budget aus dem settingsViewController
        let defaults = UserDefaults.standard
        let myBudget = defaults.double(forKey: "MyBudget")
        
        let labelOne:String = "Monatliches Budget: "
        
        //Beschreibt die zwei Labels mit dem gesetzten monatlichen Budget und dem noch übrigen monatlichen Budget
        let tmpTextOne:String = String(format:"%.2f", myBudget)
        let appendStringOne = "\(labelOne) \(tmpTextOne)"
        
        budgetFromSettingsLabel.text = appendStringOne
        
        //Gibt den zusammengerechneten Wert aller Kassenzettel aus
        //https://stackoverflow.com/questions/31319711/realm-query-sum-of-property
        let addedValues: Double = realm.objects(kassenzettel.self).sum(ofProperty: "kassenzettelEndbetrag")
        //print(addedValues)
        
        var myBudgetTmp:Double = myBudget
        myBudgetTmp = myBudgetTmp - addedValues
        
        let labelTwo:String = "Monatliches Budget: "
        
        //Beschreibt die zwei Labels mit dem gesetzten monatlichen Budget und dem noch übrigen monatlichen Budget
        let tmpTextTwo:String = String(format:"%.2f", myBudgetTmp)
        let appendStringTwo = "\(labelTwo) \(tmpTextTwo)"
        
        budgetAvailableLabel.text = appendStringTwo
        
    
        //Wichtige Angaben für das TableView
        tableView.delegate = self //Set the delegate
        tableView.dataSource = self //Set the datasource
        
        //Funktioniert nicht, gibt nul-Reference zurück, kann nicht gelöst werden, daher die manuelle Alternative
        //let listeRealm: Results<kassenzettel> = realm.objects(kassenzettel.self)()
        
        countEntrys = realm.objects(kassenzettel.self).count
        
        //Die manuelle Alternative, da nicht alle Objekte von Realm in eine Liste geladen werden können, das gibt sonst ein "Fatal Error" zurück, siehe Dokumentation
        print("countEntrys:", countEntrys)
        if(countEntrys == 0){}
        else if(countEntrys == 1){
            print("Count = 1")
        //ascending: https://stackoverflow.com/questions/34283405/how-to-sort-using-realm
        let lastEntry: kassenzettel = realm.objects(kassenzettel.self).sorted(byKeyPath: "kassenzettelID", ascending: false).first!
        let lastEntryKassenzettelID = lastEntry.kassenzettelID
        print("lastEntryID: ",lastEntryKassenzettelID)
        let lastEntryKassenzettelErfassdatum = lastEntry.kassenzettelErfassdatum
        let lastEntryKassenzettelEndbetrag = lastEntry.kassenzettelEndbetrag
            
            //https://stackoverflow.com/questions/25339936/swift-double-to-string/25340084
            let lastEntryKassenzettelEndbetragString:String = String(format:"%.2f", lastEntryKassenzettelEndbetrag)
            arrayDatum = [lastEntryKassenzettelErfassdatum]
            arrayBetrag = [lastEntryKassenzettelEndbetragString]
        }
        else if(countEntrys == 2){
            print("Count = 2")
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
            
            //https://stackoverflow.com/questions/25339936/swift-double-to-string/25340084
            //round to decimal places: https://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
            let lastEntryKassenzettelEndbetragString:String = String(format:"%.2f", lastEntryKassenzettelEndbetrag)
            let secondLastEntrykassenzettelEndbetragString:String = String(format:"%.2f", secondLastEntrykassenzettelEndbetrag)
            
            
            
            arrayDatum = [lastEntryKassenzettelErfassdatum,secondLastEntrykassenzettelErfassdatum]
            arrayBetrag = [lastEntryKassenzettelEndbetragString, secondLastEntrykassenzettelEndbetragString]
        }
        else if(countEntrys >= 3){
            print("Count = 3")
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
            
            //https://stackoverflow.com/questions/25339936/swift-double-to-string/25340084
            let lastEntryKassenzettelEndbetragString:String = String(format:"%f", lastEntryKassenzettelEndbetrag)
            let secondLastEntrykassenzettelEndbetragString:String = String(format:"%f", secondLastEntrykassenzettelEndbetrag)
            let thirdLastEntrykassenzettelEndbetragString:String = String(format:"%f", thirdLastEntrykassenzettelEndbetrag)
            
            arrayDatum = [lastEntryKassenzettelErfassdatum,secondLastEntrykassenzettelErfassdatum, thirdLastEntrykassenzettelErfassdatum]
            arrayBetrag = [lastEntryKassenzettelEndbetragString, secondLastEntrykassenzettelEndbetragString, thirdLastEntrykassenzettelEndbetragString]
        }
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
        return countEntrys
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = arrayBetrag[row]
        //change table view cell-style to subtitle: https://stackoverflow.com/questions/27221003/uitableviewcell-not-showing-detailtextlabel-text-swift
        cell.detailTextLabel!.text = arrayDatum[row]
        
        return cell
    }
    // MARK:  UITableViewDelegate Methods
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
   
    //Diese Function erstellt einen Timestamp, da es Timestamp in Realm nicht gibt
    func timestamp() -> String{
        //erstellt den timestamp
        //source: https://stackoverflow.com/questions/38248941/how-to-get-time-hour-minute-second-in-swift-3-using-nsdate/38248942#38248942
        let calendar = Calendar.current
        let time=calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
        //print("date: ","\(time.year!)-\(time.month!)-\(time.day!)-\(time.hour!)-\(time.minute!)-\(time.second!)")
        let timestamp = "\(time.year!)-\(time.month!)-\(time.day!)-\(time.hour!)-\(time.minute!)-\(time.second!)"
        //print("date ",timestamp )
        return timestamp
    }
    
    //https://stackoverflow.com/questions/33605816/first-and-last-day-of-the-current-month-in-swift
    func lastDate(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
    }

    //Menu-Taskbar
    //https://makeapppie.com/2016/07/11/programmatic-navigation-view-controllers-in-swift-3-0/
    @IBAction func photoSceneButton(_ sender: UIButton) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
