//
//  manageViewController.swift
//  kassenzettel-management
//
//  Created by Timo on 22.06.18.
//  Copyright © 2018 Timo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Realm
import RealmSwift
import TesseractOCR

class manageViewController: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageViewManaged: UIImageView!
    
    @IBOutlet weak var kategorieSwitcher: UIPickerView!
    
    //http://artoftheapp.com/ios/uiswitch-tutorial-swift/
    @IBOutlet weak var iCloudSwitch: UISwitch!
    @IBAction func iCloudSwitchToggled(_ sender: UISwitch) {
        toggleiCloudSpeicherung()
    }
    
    //var theImagePassed:UIImage? = nil
    var theImagePassed: UIImage? = UIImage()
    
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //http://artoftheapp.com/ios/uiswitch-tutorial-swift/
        toggleiCloudSpeicherung()
        iCloudSwitch.addTarget(self, action: #selector(iCloudSwitchToggled(_:)), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //imageViewManaged.image = theImagePassed
    }

    //Diese Funktion besteht aus dem Vorprojekt, eine aufgerufene Funktionen von OpenCV funktionieren, aber nicht wie gewünscht, daher gibt diese Methode direkt das übergebene Bild wieder zurück
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
        
        //imageView.transform = imageView.transform.rotated(by: CGFloat(M_PI_2))
        
        return bild
        
    }
    
    //Diese Funktion erhält das bearbeitete Bild und liest den Text mit dem Framework TesseractOCRiOS aus und gibt diesen zurück
    func BildAusleseneMitTesseract(bild: UIImage) -> String{
        
        let tesseract:G8Tesseract = G8Tesseract(language:"deu")
        //tesseract.engineMode = .tesseractCubeCombined
        tesseract.delegate = self
        tesseract.image = imageViewManaged.image
        tesseract.pageSegmentationMode = G8PageSegmentationMode(rawValue: 4)!
        tesseract.recognize()
        var ausgelesenerText:String = ""
        ausgelesenerText = tesseract.recognizedText
        
        return ausgelesenerText
    }
    
    //Diese Funktion liest den Endbetrag aus dem ausgelesenen Text (mit Tesseract) aus und gibt diesen zurück
    //Da diese Methode aus dem Vorprojekt besteht und nicht richtig funktioniert, gibt sie manuell einen Testbetrag zurück
    func getFinalValue(recognizedTextAsString: String) -> Double {
        
        let finalValue:Double = 50.0
        /*let recognizedTextFromTesseract = recognizedTextAsString
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
        }*/
        return finalValue
    }
    
    //Diese Funktion liest die letzte ID (die grösste und damit den aktuellesten Eintrag aus und erhöht diese um eins
    func getkassenzettelIDforAutoIncrement() -> Int {
        
        let lastDBKassenzettelEntry: kassenzettel = realm.objects(kassenzettel.self).sorted(byKeyPath: "kassenzettelID", ascending: false).first!
        let lastEntryKassenzettelID = lastDBKassenzettelEntry.kassenzettelID
        
        return lastEntryKassenzettelID
    }
    
    //Diese Funktion erstellt ein neues Objekt als DB-Eintrag und pusht es in die DB
    func DatabaseVerarbeitung(ID: Int, Bildname: String, AusgelesenerText: String, Betrag: Double){
        
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
    
    //http://artoftheapp.com/ios/uiswitch-tutorial-swift/
    func toggleiCloudSpeicherung() {
        if iCloudSwitch.isOn {
            print("Switch is on")
        } else {
            print("Switch is off")
        }
    }
    
    
    //Button verarbeitet das gewählte/erstellte Bild mit OpenCV und liest den Text mit Tesseract aus und pusht die Daten in die DB
    @IBAction func bildVerarbeitungButton(_ sender: UIButton) {
        
        let bildEditWithOpenCV: UIImage = BildVerarbeitungMitOpenCV(bild: imageViewManaged.image!)
        
        let textNachTesseract: String = BildAusleseneMitTesseract(bild: bildEditWithOpenCV)
        
        let gezahlterBetragAusText: Double = getFinalValue(recognizedTextAsString: textNachTesseract)
        
        //DatabaseVerarbeitung(ID: getkassenzettelIDforAutoIncrement, Bildname: "platzhalter", AusgelesenerText: textNachTesseract, Betrag: gezahlterBetragAusText)
        
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
