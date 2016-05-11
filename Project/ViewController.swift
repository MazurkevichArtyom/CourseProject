//
//  ViewController.swift
//  Project
//
//  Created by Artyom Mazurkevich on 27/04/16.
//  Copyright © 2016 Artyom Mazurkevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0].stringByAppendingString("/secrert.png")
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

