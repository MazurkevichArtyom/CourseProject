//
//  SettingsViewController.swift
//  Stego
//
//  Created by Artyom Mazurkevich on 22/05/16.
//  Copyright © 2016 Artyom Mazurkevich. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var valueOfHideData: UISlider!
    
    @IBAction func changeValue(sender: AnyObject) {
        let value = String.init(format: "%.1f",valueOfHideData.value*100)
        valueLabel.text = value + " %"
    }
    
    var attSize : Float!
    
    weak var delegate : SetSizeAttachment?
    
    @IBAction func saveSettings(sender: AnyObject) {
        delegate?.setSA(valueOfHideData.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        valueOfHideData.value = 1.0
        valueOfHideData.value = attSize
        let value = String.init(format: "%.1f",valueOfHideData.value*100)
        valueLabel.text = value + " %"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pixels")!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
