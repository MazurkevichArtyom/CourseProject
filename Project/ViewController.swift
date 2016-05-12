//
//  ViewController.swift
//  Project
//
//  Created by Artyom Mazurkevich on 27/04/16.
//  Copyright © 2016 Artyom Mazurkevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    var selectedImage = UIImage()

    @IBAction func openCamera(sender: AnyObject) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil{
            picker.allowsEditing = false
            picker.sourceType = .Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker, animated: true, completion: nil)
        }
        else{
            self.noCamera()
        }
    }
    @IBAction func cipherMessage(sender: AnyObject) {
        
    }
    
    @IBAction func decipherMessage(sender: AnyObject) {
    }
    @IBAction func openLibrary(sender: AnyObject) {
        
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        picker.delegate = self
        
        //let p = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.PicturesDirectory,NSSearchPathDomainMask.UserDomainMask, true)
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0].stringByAppendingString("/secrert.png")
       // let dd = p[0].stringByAppendingString("/a.png")
        
        let dt = "senya"
        let img = UIImage(named: "ORIGINAL_IMAGE")
        ISSteganographer.hideData(dt, withImage: img) { (img, error) in
            if ((error) != nil){
                print("error")
            }
            else{
                let temp = img as! UIImage
                UIImagePNGRepresentation(temp)?.writeToFile(documentsDirectory as! String, atomically: true)
            }
        }
        print(documentsDirectory)
        // Do any additional setup after loading the view, typically from a nib.
        
        let img1 = UIImage(named: "secrert")
        ISSteganographer.dataFromImage(img1) { (data, error) in
            if ((error) != nil){
                print("error")
            }
            else{
                let hiddenData = NSString(data: data, encoding: 8)
                print(hiddenData)
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage]
        imageView.contentMode = .ScaleAspectFit
        imageView.image = chosenImage as? UIImage
        self.selectedImage = imageView.image!
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

