//
//  photoViewController.swift
//  swiftocrtest
//
//  Created by Timo on 26.03.18.
//  Copyright © 2018 Timo. All rights reserved.
//

import UIKit
import TesseractOCR
import AVFoundation
import Realm
import RealmSwift

class photoViewController: UIViewController, UITextViewDelegate, G8TesseractDelegate {

    //Wenn ein ? dahinter steht, dann bedeutet das wohl dass es optional ist
    var takenPhoto:UIImage?
    var editedPhoto:UIImage?
    

    
    @IBOutlet weak var imageView: UIImageView!
    
    //die Verbindung zum TextView im storyboard
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //setzt das ausgewaehlte Bild in die Variable takenPhoto
        imageView.image = takenPhoto
        
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
        textView.text = ""
        
    }
    
    @IBAction func buttonRecognize(_ sender: Any) {
        
        let tesseract:G8Tesseract = G8Tesseract(language:"deu")
        
        //tesseract.engineMode = .tesseractCubeCombined
        
        //tesseract.language = "eng+ita"
        tesseract.delegate = self
        
        //Eines der beiden unteren muss aktiviert werden, das erste ruft ein lokal abgelegtes Bild auf, das zweite ruft ein Bild aus dem iPhone direkt auf
        //tesseract.image = UIImage(named: "b_1_q_0_p_0_2")?.g8_blackAndWhite()
        
        //tesseract.image = takenPhoto
        tesseract.image = imageView.image
        
        tesseract.pageSegmentationMode = G8PageSegmentationMode(rawValue: 4)!
        //tesseract.dictionaryWithValues(forKeys: <#T##[String]#>)
        
        
        tesseract.recognize()
        textView.text = tesseract.recognizedText
        
        //Funktioniert noch nicht einwandfrei, muss noch ueberarbeitet werden
        //getFinalValue(recognizedTextAsString: tesseract.recognizedText)
        
    }
    
    
    /*func getFinalValue(recognizedTextAsString: String) -> String {
       
        var finalValue = ""
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
    }*/
    
    
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
    
    func realm(){
        //https://realm.io/docs/swift/latest#models
 
        
        // kassenzettel model
        class kassenzettel: Object {
            @objc dynamic var kassenzettelID = ""
            @objc dynamic var kassenzettelBildname = ""
            //dem nächsten Attribut würde ich gerne die Function timestamp() übergeben, funktioniert aber nicht
            @objc dynamic var kassenzettelErfassdatum = Date()
            @objc dynamic var kassenzettelAusgelesenerText = ""
            @objc dynamic var kassenzettelEndbetrag = 0.0
            //folgende zwei Attribute sind optional
            @objc dynamic var kassenzettelAusgelesenesDatum : Data? = nil
            @objc dynamic var kassenzettelLinkZuiCloud: String? = nil
            //One-to-many Relationship
            @objc dynamic var endbetragBegriff: endbetragBegriff?
            @objc dynamic var kategorie: kategorie?
            @objc dynamic var haendler: haendler?
            //PrimaryKey überschreiben
            override static func primaryKey() -> String? {
                return "kassenzettelID"
            }
            //auto-increment:
            //https://academy.realm.io/posts/realm-primary-keys-tutorial/
            //https://stackoverflow.com/questions/39579025/auto-increment-id-in-realm-swift-3-0
        }
        
        // haendler model
        class haendler: Object {
            @objc dynamic var haendlerID = 0
            @objc dynamic var haendlerName = ""
            //PrimaryKey überschreiben
            override static func primaryKey() -> String? {
                return "haendlerID"
            }
        }
        
        // kategorie model
        class kategorie: Object {
            @objc dynamic var kategorieID = 0
            @objc dynamic var kategorieName = 0
            //PrimaryKey überschreiben
            override static func primaryKey() -> String? {
                return "kategorieID"
            }
        }
        
        // endbetragBegriff model
        class endbetragBegriff: Object {
            @objc dynamic var endbetragBegriffID = 0
            @objc dynamic var endbetragBegriff = ""
            //PrimaryKey überschreiben
            override static func primaryKey() -> String? {
                return "endbetragBegriffID"
            }
        }   
        
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
