//
//  ViewController.swift
//  tesseractTest
//
//  Created by Timo on 29.03.18.
//  Copyright © 2018 Timo. All rights reserved.
//

import UIKit
import TesseractOCR
import AVFoundation
import RealmSwift
import Realm

class cameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    //für die Stitching-Methode, in dieses Array werden die Bilder zum stitchen geladen
    var imageArrayGlobal:[UIImage?] = []
    //Following Part is for the Button "bild auswaehlen":
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view,
    
        
    }
    
    //source: https://www.youtube.com/watch?v=4CbcMZOSmEk
    @IBAction func takePhoto(_ sender: Any) {
        let imagePickerControllerOne = UIImagePickerController()
        imagePickerControllerOne.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerControllerOne.sourceType = .camera
            self.present(imagePickerControllerOne, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerControllerOne.sourceType = .photoLibrary
            self.present(imagePickerControllerOne, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //Wie das Bild an die weiterverarbeitungs-Funktionen übergeben?
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //Übergibt das Bild dem nächsten manageViewController, wo es eine Kategorie zugewiesen bekommt, die Option ob es in die iCloud gesichert werden soll und dann wird alles verarbeitet
    @IBAction func geladenesPhotoVerarbeiten(_ sender: UIButton) {
        //übergibt das Bild aus dem lokalen ImageView dem ImageView vom manageViewController
        //https://code.tutsplus.com/tutorials/ios-sdk-passing-data-between-controllers-in-swift--cms-27151
        let myVC = storyboard?.instantiateViewController(withIdentifier: "manageScene") as! manageViewController
        myVC.theImagePassed = imageView.image!
        navigationController?.pushViewController(myVC, animated: true)
        
        //switcht auf das andere Storyboard "manageScene"
        //https://makeapppie.com/2016/07/11/programmatic-navigation-view-controllers-in-swift-3-0/
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "manageScene") else {
            print("View controller Six not found")
            return
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func imageTakePhotoForStitching(_ sender: UIButton) {
        let imagePickerControllerTwo = UIImagePickerController()
        imagePickerControllerTwo.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerControllerTwo.sourceType = .camera
            self.present(imagePickerControllerTwo, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerControllerTwo.sourceType = .photoLibrary
            self.present(imagePickerControllerTwo, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerTwo(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
 
    
    //function is for button "bild hinzufuegen"
    @IBAction func imageAddToStitching(_ sender: UIButton) {
        imageArrayGlobal.append(imageView.image)
    }
    
    //funkction ist for button "stitching..."
    @IBAction func imageStitching(_ sender: UIButton) {
        stitch(arrayParam: imageArrayGlobal)
    }
    
    //function get called by button imageStitching/stitching...
    //source: https://github.com/foundry/OpenCVSwiftStitch/blob/master/SwiftStitch/SwViewController.swift
    func stitch(arrayParam:[UIImage?]) {
        DispatchQueue.global().async {
            let imageArray:[UIImage?] = arrayParam
            let stitchedImage:UIImage = OpenCVWrapper.process(with: imageArray as! [UIImage]) as UIImage
            //Statt das Bild in das ScrollView zu packen, einfach wieder zurück ins ImageView
            let imageView:UIImageView = UIImageView.init(image: stitchedImage)
        }
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
    @IBAction func settingsSceneButton(_ sender: UIButton) {
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

