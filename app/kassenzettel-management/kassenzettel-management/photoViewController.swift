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
    
    
    func getFinalValue(recognizedTextAsString: String) -> String {
       
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
