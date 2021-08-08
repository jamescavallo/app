//
//  login_ViewController.swift
//  Long Term
//
//  Created by James Cavallo on 7/10/21.
//

import UIKit
import FirebaseAuth



class login_ViewController: UIViewController, UITextFieldDelegate {

  
    @IBOutlet weak var user_field: UITextField!
    @IBOutlet weak var pass_field: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        self.pass_field.delegate = self
        self.user_field.delegate = self
        
        Utilities.styleTextField(user_field, text: "Email")
        Utilities.styleTextField(pass_field, text: "Password")
        Utilities.setupLeftImage(imageName: "username", button: user_field)
        Utilities.setupLeftImage(imageName: "password", button: pass_field)
        errorLabel.alpha = 0
        
    }
    
    
     @IBAction func handleLogin(_ sender: Any) {
        let usernameText = user_field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordText = pass_field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Sign the user in from the given email and password combo
        
        Auth.auth().signIn(withEmail: usernameText, password: passwordText) {
            (result, error) in
            if error != nil{
                //sign in failed
                self.errorLabel.alpha = 1
            }else{
                let homeViewController = self.storyboard?.instantiateViewController(identifier: "homeVC")
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
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
