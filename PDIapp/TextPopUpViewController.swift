//
//  TextPopUpViewController.swift
//  PDIapp
//
//  Created by Lauren Shultz on 3/9/18.
//  Copyright © 2018 Lauren Shultz. All rights reserved.
//

import UIKit

class TextPopUpViewController: UIViewController
{
    var message = "No Machine is Selected"
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = message
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    @IBAction func okPressed(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
