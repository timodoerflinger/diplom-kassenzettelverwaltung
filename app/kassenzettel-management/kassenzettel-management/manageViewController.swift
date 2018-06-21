//
//  manageViewController.swift
//  kassenzettel-management
//
//  Created by Timo on 21.06.18.
//  Copyright © 2018 Timo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Realm
import RealmSwift
import TesseractOCR

class manageViewController: UIViewController, G8TesseractDelegate{
    
    @IBOutlet weak var imageViewManaged: UIImageView!
    
    @IBOutlet weak var kategorieSwitcher: UIPickerView!
    
    @IBAction func iCloudSpeicherung(_ sender: UISwitch) {
    }
    
   
    var theImagePassed = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        // Get the default Realm
        //let realm = try! Realm()
        
        //gibt den zusammengerechneten Wert aller Kassenzettel aus
        // Query using a predicate string
        //https://stackoverflow.com/questions/31319711/realm-query-sum-of-property
        
        //let addedValues: Double = realm.objects(kassenzettel.self).sum(ofProperty: "kassenzettelEndbetrag")
        
        
        
        //let addedValues: Double = realm.objects(kassenzettel.self).sum(ofProperty: "kassenzettelEndbetrag")
        
        
        imageViewManaged.image = theImagePassed
        
    }
    
    func BildVerarbeitungMitOpenCV(bild: UIImage) -> UIImage{
        
        //Funktioniert: !!!!!
        //editedPhoto = OpenCVWrapper.makeGray(from: takenPhoto)
        
        //Funktioniert auch !!!!!
        //editedPhoto = OpenCVWrapper.processImageThresholding(takenPhoto)
        
        //https://iosdevcenters.blogspot.com/2016/04/save-and-get-image-from-document.html
        //Zum lokalen speichern der bearbeiteten Bilder
        /*let fileManager = FileManager.default
         let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("tresholdingTest11.jpg")
         //let image = UIImage(named: "tresholdingTest.jpg")
         print(paths)
         let imageData = UIImageJPEGRepresentation(editedPhoto!, 0.5)
         fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
         */
        
        //imageView.image = editedPhoto
        //imageView.transform = imageView.transform.rotated(by: CGFloat(M_PI_2))
        
        return bild;
        
    }
    
    func BildAusleseneMitTesseract(bild: UIImage) -> String{
        
        let tesseract:G8Tesseract = G8Tesseract(language:"deu")
        
        //tesseract.engineMode = .tesseractCubeCombined
        
        //tesseract.language = "eng+ita"
        tesseract.delegate = self
        
        //Eines der beiden unteren muss aktiviert werden, das erste ruft ein lokal abgelegtes Bild auf, das zweite ruft ein Bild aus dem iPhone direkt auf
        //tesseract.image = UIImage(named: "b_1_q_0_p_0_2")?.g8_blackAndWhite()
        
        //tesseract.image = takenPhoto
        tesseract.image = imageViewManaged.image
        
        tesseract.pageSegmentationMode = G8PageSegmentationMode(rawValue: 4)!
        //tesseract.dictionaryWithValues(forKeys: <#T##[String]#>)
        
        var texttmp = ""
        tesseract.recognize()
        //textView.text = tesseract.recognizedText
        texttmp = tesseract.recognizedText
        
        //Funktioniert noch nicht einwandfrei, muss noch ueberarbeitet werden
        //getFinalValue(recognizedTextAsString: tesseract.recognizedText)
        
        return texttmp
    }
    
    func DatabaseVerarbeitung(ID: Int, Bildname: String, AusgelesenerText: String, Betrag: Double){
        
        // Use them like regular Swift objects
        let newBon = kassenzettel()
        newBon.kassenzettelID = ID
        newBon.kassenzettelBildname = Bildname
        newBon.kassenzettelErfassdatum = timestamp()
        newBon.kassenzettelAusgelesenerText = AusgelesenerText
        newBon.kassenzettelEndbetrag = Betrag
        
        do {
            let realm = try Realm()
            // Persist your data easily
            try! realm.write {
                realm.add(newBon)
            }
        } catch let error as NSError {
            // handle error
            print("Realm-Error 2:", error)
        }
        
    }
    
    
    
    //diese Function erstellt einen Timestamp, da es Timestamp in Realm nicht gibt
    func timestamp() -> String{
        //erstellt den timestamp
        //source: https://stackoverflow.com/questions/38248941/how-to-get-time-hour-minute-second-in-swift-3-using-nsdate/38248942#38248942
        let calendar = Calendar.current
        let time=calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
        //print("date: ","\(time.year!)-\(time.month!)-\(time.day!)-\(time.hour!)-\(time.minute!)-\(time.second!)")
        let timestamp = "\(time.year!)-\(time.month!)-\(time.day!)-\(time.hour!)-\(time.minute!)-\(time.second!)"
        //print("date ",timestamp )
        return timestamp;
    }
    
    
    
    func getFinalValue(recognizedTextAsString: String) -> Double {
     
        let finalValue:Double = 0.0
        let recognizedTextFromTesseract = recognizedTextAsString
        //split the recognized text at the end of every row
        let array = recognizedTextFromTesseract.components(separatedBy: "\n")
        var finalValues = ["summe", "total", "bar", "gesamt", "visa", "TDTHL"]
        var index = 0
        var index2 = 0
        while index < 40 {
        print("array " + array[index])
         
            while index2 < 10 {
             
                 index2+=1
            }
            index+=1
        }
        return finalValue;
    }
    
    
    @IBAction func bildVerarbeitungButton(_ sender: UIButton) {
    
        //let bildNachOpenCV: UIImage = BildVerarbeitungMitOpenCV(bild: imageViewManaged.image!)
        
        //let textNachTesseract: String = BildAusleseneMitTesseract(bild: bildNachOpenCV)
        
        //let gezahlterBetragAusText: Double = getFinalValue(recognizedTextAsString: textNachTesseract)
        
        //Database-Connection
        let realm = try! Realm()
        
        //auto-increment: die ID des letzten Eintrags auslesen
        let lastEntry: kassenzettel = realm.objects(kassenzettel.self).sorted(byKeyPath: "kassenzettelID").first!
        let lastEntryID = lastEntry.kassenzettelID
        
        print("lastEntryID", lastEntryID)
        
        //DatabaseVerarbeitung(ID: lastEntryID+1, Bildname: "platzhalter", AusgelesenerText: textNachTesseract, Betrag: gezahlterBetragAusText)
        
        //Nachdem die daten in der Datenbank sind, spring die Benutzeroberfläche automatisch auf das homeScene
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "homeScene") else {
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
