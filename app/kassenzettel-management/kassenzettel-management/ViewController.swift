//
//  ViewController.swift
//  tesseractTest
//
//  Created by Timo on 29.03.18.
//  Copyright © 2018 Timo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var textView: UITextView!
    
    //var imageArray = [UIImage?]()
    var imageArrayGlobal:[UIImage?] = []
    
    
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
        
        //der folgende eingerueckte Block ist dafuer da, dass das ausgewaehlte Bild im UIImageView im anderen storyboard angezeigt wird
        let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoVC") as! photoViewController
        
        photoVC.takenPhoto = image
        
        DispatchQueue.main.async {
            self.present(photoVC, animated: true, completion: nil)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //Following Part is for the Button "bild auswaehlen":
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
           
            /*
            let image1 = UIImage(named:"pano_19_16_mid.jpg")
            let image2 = UIImage(named:"pano_19_20_mid.jpg")
            let image3 = UIImage(named:"pano_19_22_mid.jpg")
            let image4 = UIImage(named:"pano_19_25_mid.jpg")
            let imageArray:[UIImage?] = [image1,image2,image3,image4]
            */
            
            let imageArray:[UIImage?] = arrayParam
            
            let stitchedImage:UIImage = OpenCVWrapper.process(with: imageArray as! [UIImage]) as UIImage
            
            DispatchQueue.main.async {
                NSLog("stichedImage %@", stitchedImage)
                let imageView:UIImageView = UIImageView.init(image: stitchedImage)
                self.imageView = imageView
                self.scrollView.addSubview(self.imageView!)
                self.scrollView.backgroundColor = UIColor.black
                self.scrollView.contentSize = self.imageView!.bounds.size
                self.scrollView.maximumZoomScale = 4.0
                self.scrollView.minimumZoomScale = 0.5
                self.scrollView.delegate = self as? UIScrollViewDelegate
                self.scrollView.contentOffset = CGPoint(x: -(self.scrollView.bounds.size.width - self.imageView!.bounds.size.width)/2.0, y: -(self.scrollView.bounds.size.height - self.imageView!.bounds.size.height)/2.0)
                NSLog("scrollview \(self.scrollView.contentSize)")
                //self.spinner.stopAnimating()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

