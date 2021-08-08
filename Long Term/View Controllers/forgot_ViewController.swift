//
//  forgot_ViewController.swift
//  Long Term
//
//  Created by James Cavallo on 7/20/21.
//

import UIKit
import Firebase
import FirebaseAuth

class forgot_ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        self.email_field.delegate = self
        Utilities.setupLeftImage(imageName: "email", button: email_field)
        Utilities.styleTextField(email_field, text: "Account Email")
        errorLabel.alpha = 0

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func continueButton(_ sender: Any) {
        
        let emailText = email_field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().fetchSignInMethods(forEmail: emailText) { complete, error in
            if (error != nil || complete == nil){
                self.errorLabel.alpha = 1
            }else{
                Utilities.httpRequest(toEmail: emailText, mode: "resetPassword") //main a request to the api so it sends a reset email
                _ = UIStoryboard(name: "Main", bundle: nil)
                let completeViewController = self.storyboard?.instantiateViewController(identifier: "completeVC")
                self.present(completeViewController!, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
 
    
}
