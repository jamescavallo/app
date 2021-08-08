//
//  Complete_ViewController.swift
//  Long Term
//
//  Created by James Cavallo on 7/26/21.
//

import UIKit
import FirebaseAuth

class Complete_ViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    var actionCode: String = ""
    var isValid: Bool = false
    var searchTimer: Timer?
    
    
    override func viewDidLoad() {
        Utilities.styleTextField(password, text: "Password")
        Utilities.styleTextField(password2, text: "Retype Password")
        Utilities.setupLeftImage(imageName: "password", button: password)
        Utilities.setupLeftImage(imageName: "password", button: password2)
        self.password.addTarget(self, action: #selector(textFieldDidEditingChanged(_:)), for: .editingChanged)
        self.password2.addTarget(self, action: #selector(password2DidEditingChanged(_:)), for: .editingChanged)
        assignCode()
        super.viewDidLoad()
        errorLabel.alpha = 0

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func assignCode(){
        actionCode = Utilities.code.actionCode
    }
    
    func handle_success() {
        
        _ = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "loginVC")
        self.present(loginViewController!, animated: true, completion: nil)
    }

    @IBAction func changePassword(_ sender: Any) {
        let pass = password.text!
        
        Auth.auth().confirmPasswordReset(withCode: actionCode, newPassword: pass){ error in
            if error != nil{
                print("Error changing password")
            }else{
                let alert = UIAlertController(title: "Password Reset Complete", message: "You can now sign in", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                        //run your function here
                        self.handle_success()
                    }))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    @objc func textFieldDidEditingChanged(_ textField: UITextField) {

            // if a timer is already active, prevent it from firing
            if searchTimer != nil {
                searchTimer?.invalidate()
                searchTimer = nil
            }

            // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
            searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchForKeyword(_:)), userInfo: password.text!, repeats: false)
        }

    
    
    @objc func searchForKeyword(_ timer: Timer) {

            // retrieve the keyword from user info
            let passwordInput = timer.userInfo!
        
        

        let result:Bool = Utilities.isPasswordValid(passwordInput as! String)
        
        if (result == false){
            self.errorLabel.text = "Password is weak"
            errorLabel.alpha = 1
            Utilities.setuprightImage(imageName: "x", textField: password, setupFlag: false)
            isValid = false
        }else{
            Utilities.setuprightImage(imageName: "check", textField: password, setupFlag: false)
            errorLabel.alpha = 0
            isValid = true
        }
        
        }
    
    @objc func password2DidEditingChanged(_ textField: UITextField) {

            // if a timer is already active, prevent it from firing
            if searchTimer != nil {
                searchTimer?.invalidate()
                searchTimer = nil
            }

            // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
            searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(password2SearchForKeyword(_:)), userInfo: password2.text!, repeats: false)
        }
    
    
    func verifyMatch(password1: String, password2: String) -> Bool{
        return password1 == password2
    }

    
    
    @objc func password2SearchForKeyword(_ timer: Timer) {

            // retrieve the keyword from user info
            let passwordInput = timer.userInfo!
        
        

        let result:Bool = verifyMatch(password1: password.text!, password2: passwordInput as! String)
        
        if (result == false){
            self.errorLabel.text = "Passwords much match"
            errorLabel.alpha = 1
            Utilities.setuprightImage(imageName: "x", textField: password2, setupFlag: false)
            isValid = false
        }else{
            Utilities.setuprightImage(imageName: "check", textField: password2, setupFlag: false)
            errorLabel.alpha = 0
            isValid = true
        }
        
        }

}
