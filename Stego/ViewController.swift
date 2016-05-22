//
//  ViewController.swift
//  Stego
//
//  Created by Artyom Mazurkevich on 21/05/16.
//  Copyright © 2016 Artyom Mazurkevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SetSizeAttachment {
    
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    @IBOutlet weak var secretMessage: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    let picker = UIImagePickerController()
    
    var attchmentSize : Float = 1.0
    var selectedImage = UIImage()
    var imageInfo = String()
    
    @IBAction func openPhotoLibrary(sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)

    }
    
    func setSA(size: Float){
        attchmentSize = size
        self.navigationItem.title = String.init(format: "%.1f",attchmentSize*100) + " %"

    }
    
    @IBAction func viewImageInfo(sender: AnyObject) {
        
        if (imageView.image != nil && !isPNGImage()){
            
            let utf8str = secretMessage.text?.dataUsingEncoding(NSUTF8StringEncoding)
            
            let base64e = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            
            let size = "Size of image: " + NSStringFromCGSize(imageView.image!.size)
            let indexSize = CGFloat.init(attchmentSize)
            let s = Int((imageView.image!.size.width * imageView.image!.size.height * indexSize) / 8)
            let secretMsgBytes = "\n" + "\(s)" + " cipher bytes can be stored in image"
            
            let useBytes = "\n \(base64e.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)+14*Int(!(secretMessage.text?.isEmpty)!)) bytes are used in your secret message"
            
            let alertDec = UIAlertController(title: "Information", message: size + secretMsgBytes + useBytes, preferredStyle: .Alert)
            
            let okDec = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                
            })
            alertDec.addAction(okDec)
            presentViewController(alertDec, animated: true, completion: nil)
        }
        else{
            let alertC = UIAlertController(title: "Invalid data", message: "Please upload JPG photo if you want to see some info", preferredStyle: .Alert)
            
            let okC = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
            })
            alertC.addAction(okC)
            presentViewController(alertC, animated: true, completion: nil)
        }

    }
    
    @IBAction func decipherMessage(sender: AnyObject) {
        infoButton.enabled = false
        self.settingsButton.enabled = false
        
        if (imageView.image != nil && isPNGImage()){
            
            loadingView.hidden = false
            loadingView.alpha = 0.7
            loadingAnimation.startAnimating()
            
            ISSteganographer.dataFromImage(imageView.image) { (data, error) in
                if ((error) != nil || data == nil){
                    print("error")
                }
                else{
                    let hiddenData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    let decMsg = hiddenData as! String
                    let alertMsg = UIAlertController(title: "Secret message", message: decMsg, preferredStyle: .Alert)
                    
                    //print(decMsg.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                    
                    let okMsg = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                        self.imageView.image = nil
                        self.imageInfo = ""
                    })
                    alertMsg.addAction(okMsg)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadingAnimation.stopAnimating()
                        self.loadingView.hidden = true
                        self.presentViewController(alertMsg, animated: true, completion: nil)
                        self.settingsButton.enabled = true
                        self.infoButton.enabled = true
                    })
                }
            }
        }
        else{
            let alertDec = UIAlertController(title: "Upload photo", message: "Please upload photo by format PNG", preferredStyle: .ActionSheet)
            
            let okDec = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                self.imageView.image = nil
                self.settingsButton.enabled = true
                self.infoButton.enabled = true
                
            })
            alertDec.addAction(okDec)
            presentViewController(alertDec, animated: true, completion: nil)
        }
        

    }
    
    @IBAction func cipherMessage(sender: AnyObject) {
        
        
        
        if (secretMessage.text != "" && imageView.image != nil && !isPNGImage() && !dataIsLarge()){
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
            imageInfo = ""
            secretMessage.text = ""
        }
        else if(imageView.image != nil && dataIsLarge()){
            let alertC = UIAlertController(title: "Inaccessible size", message: "The size of secret message is more than size of your container", preferredStyle: .ActionSheet)
            
            let okC = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
            })
            alertC.addAction(okC)
            presentViewController(alertC, animated: true, completion: nil)
        }
        else{
            let alertC = UIAlertController(title: "Invalid data", message: "Please upload JPG photo and input secret message", preferredStyle: .ActionSheet)
            
            let okC = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                self.imageView.image = nil
            })
            alertC.addAction(okC)
            presentViewController(alertC, animated: true, completion: nil)
        }

    }
    
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage]
        let someInfo = info[UIImagePickerControllerReferenceURL]
        
        if let url = someInfo as? NSURL{
            imageInfo = url.absoluteString
        }
        imageView.contentMode = .ScaleAspectFit
        imageView.image = chosenImage as? UIImage
        self.selectedImage = imageView.image!
        //print(someInfo)
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "goToSettings"){
            if let nextVC = segue.destinationViewController as? SettingsViewController{
                nextVC.delegate = self
                nextVC.attSize = self.attchmentSize
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = String.init(format: "%.1f",attchmentSize*100) + " %"
        
        picker.delegate = self
        
        mainView.backgroundColor = UIColor(patternImage: UIImage(named: "pixels")!)
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func isPNGImage() -> Bool{
        
        return self.imageInfo.containsString("&ext=PNG")
    }
    
    private func dataIsLarge() -> Bool{
        let utf8str = secretMessage.text?.dataUsingEncoding(NSUTF8StringEncoding)
        let indexSize = CGFloat.init(attchmentSize)
        let base64e = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        return Int((imageView.image!.size.width * imageView.image!.size.height * indexSize) / 8) < base64e.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)+14*Int(!(secretMessage.text?.isEmpty)!)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

