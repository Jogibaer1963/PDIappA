//
//  FinalFCViewController.swift
//  PDIapp
//
//  Created by Lauren Shultz on 2/12/18.
//  Copyright © 2018 Lauren Shultz. All rights reserved.
//

import UIKit

class FinalFCViewController: UIViewController, UITextFieldDelegate
{
    //Machine object currently being inspected
    var machine: Machine!
    //Name of user performing pdi
    var name: String!
    //Holds the value of the final fuel consumption
    var finalFC: Double!
    //Connection point to database
    var Port: port!
    var override = false
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var machineLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var finalFCField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Final FC View Loaded")
        
        machine.thisPDI.position = "ffc"
        
        finalFCField.delegate = self
        //intializes screen elements
        machineLabel.text = machine.name
        nameLabel.text = name
    }
    /*
     * FUNCTION: touchesBegan
     * PURPOSE: Is called when touch begins
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
     * FUNCTION: textFieldDidBeginEditing
     * PURPOSE: If text box editing is started, this function exceutes
     * PARAMS: textField -> UITextField object for senseing edit
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
    }
    /*
     * FUNCTION: textFieldShouldReturn
     * PURPOSE: When text field is done editing, resigns responder
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    /*
     * FUNCTION: backPressed
     * PURPOSE: If the back button is pressed, returns user to previous screen
     */
    @IBAction func backPressed(_ sender: Any)
    {
        self.performSegue(withIdentifier: "FFCBackToCheckpoints", sender: machine)
    }
    /*
     * FUNCTION: completePressed
     * PURPOSE: Verifys fuel consumption input is valid and sends the results to the database and marks the machine as completed
     */
    @IBAction func completePressed(_ sender: Any)
    {
        print("Complete Pressed")
        
        let isFilled = finalFCField.hasText
        var isDouble = false
        if let lat = finalFCField.text,
            let _ = Double(lat) {
            isDouble = true
        }
        if (isDouble && isFilled)
        {
            /*machine.thisPDI.setFinalFuelConsumption(fuelConsumptionIn: Double(finalFCField.text!)!)
            //send pdi results to db
            Port.pushFinalFuelConsumption()
            //Set status to complete
            Port.macStatus(status: 1)
            self.performSegue(withIdentifier: "ffcToMain", sender: machine)
            print("ALL DATA EXPORTED")*/
            startActivity()
            DispatchQueue.global().async {
                
                self.machine.thisPDI.setFinalFuelConsumption(fuelConsumptionIn: Double(self.finalFCField.text!)!)
                //send pdi results to db
                self.Port.pushFinalFuelConsumption()
                //Set status to complete
                self.Port.macStatus(status: 1)
                DispatchQueue.main.async {
                    self.stopActivity()
                    self.performSegue(withIdentifier: "ffcToMain", sender: self.machine)
                    print("ALL DATA EXPORTED")                }
            }
        }
        else
        {
            //CHANGE TO POP UP OR DISPLAY LABEL, REMOVE IN FIELD ALERT
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "textButtonPopUp") as! TextPopUpViewController
            popOverVC.message = "Response must be a number"
            self.addChildViewController(popOverVC)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
            finalFCField.text = ""
        }
    }
    func startActivity()
    {
        print("Activity Started")
        self.view.alpha = 0.5
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func stopActivity()
    {
        print("Activity Stoped")
        self.view.alpha = 1
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    /*func onPopOptionPressed (_ selected: Int)
    {
        override = true
    }*/
    /*
     * FUNCTION: preare
     * PURPOSE: This function sends current machine and individuals name onto Checkpoints scene
     * VARIABLES: Machine machine - current machine PDI is being performed on
     *              String name - Name of the individual completeing the PDI
     */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FFCBackToCheckpoints" {
            if let vc = segue.destination as? PDIViewController {
                vc.machine = self.machine
                vc.name = self.name
                vc.Port = self.Port
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
