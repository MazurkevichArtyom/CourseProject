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
    
    @IBOutlet weak var secretMessage: UITextField!
    let picker = UIImagePickerController()
    
    var selectedImage = UIImage()
    var imageInfo = String()

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
        
        if (secretMessage.text != "" && imageView.image != nil){
            let img = imageView.image
            ISSteganographer.hideData(secretMessage.text, withImage: img) { (img, error) in
                if ((error) != nil){
                    print("error")
                }
                else{
                    let temp = img as! UIImage
                    UIImageWriteToSavedPhotosAlbum(UIImage(data: UIImagePNGRepresentation(temp)!)!, nil, nil, nil)
                }
            }
            imageView.image = nil
            secretMessage.text = ""
        }
        else{
            let alertC = UIAlertController(title: "Invalid data", message: "Please upload photo and input secret message", preferredStyle: .ActionSheet)
            
            let okC = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
            })
            alertC.addAction(okC)
            presentViewController(alertC, animated: true, completion: nil)
        }
        //print(documentsDirectory)
    }
    
    @IBAction func decipherMessage(sender: AnyObject) {
        
        if (imageView.image != nil && isPNGImage()){
        
            ISSteganographer.dataFromImage(imageView.image) { (data, error) in
                if ((error) != nil){
                    print("error")
                }
                else{
                    let hiddenData = NSString(data: data, encoding: 8)
                    let decMsg = hiddenData as! String
                    let alertMsg = UIAlertController(title: "Secret message", message: decMsg, preferredStyle: .Alert)
                    
                    let okMsg = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                        self.imageView.image = nil
                    })
                    alertMsg.addAction(okMsg)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(alertMsg, animated: true, completion: nil)
                    })
                }
            }
        }
        else{
            let alertDec = UIAlertController(title: "Upload photo", message: "Please upload photo by format PNG", preferredStyle: .ActionSheet)
            
            let okDec = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                self.imageView.image = nil
            })
            alertDec.addAction(okDec)
            presentViewController(alertDec, animated: true, completion: nil)
        }
        
    }
    @IBAction func openLibrary(sender: AnyObject) {
        
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        picker.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage]
        let someInfo = info[UIImagePickerControllerReferenceURL]
        if let url = someInfo as? NSURL{
             imageInfo = url.absoluteString
            print(imageInfo)
        }
        imageView.contentMode = .ScaleAspectFit
        imageView.image = chosenImage as? UIImage
        self.selectedImage = imageView.image!
        //print(chosenImage?.size)
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

    private func isPNGImage() -> Bool{
        
        return self.imageInfo.containsString("&ext=PNG")
    }

}

