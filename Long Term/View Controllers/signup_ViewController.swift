//
//  signup_ViewController.swift
//  Long Term
//
//  Created by James Cavallo on 7/10/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class signup_ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    var isValid: Bool = false
    var searchTimer: Timer?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeHideKeyboard()
        
        self.firstName.delegate = self
        self.username.delegate = self
        
        errorLabel.alpha = 0
        // declare textField as delegate
        self.password.delegate = self
        self.email.delegate = self

        // handle the editingChanged event by calling (textFieldDidEditingChanged(-:))
        self.password.addTarget(self, action: #selector(textFieldDidEditingChanged(_:)), for: .editingChanged)
        
        self.email.addTarget(self, action: #selector(emailDidEditingChanged(_:)), for: .editingChanged)
        
        self.username.addTarget(self, action: #selector(userDidEditingChanged(_:)), for: .editingChanged)
        
        
        Utilities.styleTextField(firstName, text: "First and Last Name")
        Utilities.styleTextField(email, text: "Email")
        Utilities.styleTextField(password, text: "Password")
        Utilities.styleTextField(username, text: "Username")
        Utilities.setupLeftImage(imageName: "name", button: firstName)
        Utilities.setupLeftImage(imageName: "email", button: email)
        Utilities.setupLeftImage(imageName: "password", button: password)
        Utilities.setupLeftImage(imageName: "username", button: username)
        Utilities.setuprightImage(imageName: "check", textField: password, setupFlag: true)

        // Do any additional setup after loading the view.
    }
    
    func sendVerifyEmail(emailText:String){
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        let user = Auth.auth().currentUser
        let linkText:String = String(format: "https://long-term-c473c.web.app/?email=%@", emailText)
        actionCodeSettings.url = URL(string: linkText)
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.dynamicLinkDomain = "jcavallo.page.link"
        user!.sendEmailVerification(with: actionCodeSettings) { error in
            if error != nil{
                print("Error sending email")
            }else{
                print("Verification email sent")
            }
        }
    }
    
    
    @IBAction func handle_signup(_ sender: Any) {
        let db = Firestore.firestore()
        let emailText = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordText = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameText = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameText = username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (emailText == "" || passwordText == "" || usernameText == "" || nameText == ""){
            self.errorLabel.text = "Please fill in all fields"
            self.errorLabel.alpha = 1
            return
        }
        
        if (isValid == false){
            return
        }
        
        let docRef = db.collection("users").document(usernameText)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.errorLabel.text = "@"+usernameText+" is already taken"
                self.errorLabel.alpha = 1
            } else {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if (error != nil){
                        self.errorLabel.text = Utilities.parseErrors(error: error! as NSError)
                        self.errorLabel.alpha = 1
                        return
                    }else{
                        //Store user data in firebase
                        db.collection("users").document(self.username.text!).setData([
                            "firstname": self.firstName.text!,
                            "email": self.email.text!,
                            "password": self.password.text!,
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        //send verification email
                        self.sendVerifyEmail(emailText: emailText)
                        
                         
                        
                        let alert = UIAlertController(title: "Account Created!", message: "You have been logged in", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                                //run your function here
                                self.handle_success()
                            }))
                        self.present(alert, animated: true)
                        
                        
                        
                    }
                
                }
            }
        }
            
        
        
        
        
    }
    
    func handle_success() {
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "homeVC")
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    
    @objc func textFieldDidEditingChanged(_ textField: UITextField) {

            // if a timer is already active, prevent it from firing
            if searchTimer != nil {
                searchTimer?.invalidate()
                searchTimer = nil
            }

            // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
            searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchForKeyword(_:)), userInfo: textField.text!, repeats: false)
        }

    
    
    @objc func searchForKeyword(_ timer: Timer) {

            // retrieve the keyword from user info
            let passwordInput = timer.userInfo!
        
        

        let result:Bool = Utilities.isPasswordValid(passwordInput as! String)
        
        if (result == false){
            self.errorLabel.text = "Password is too weak"
            errorLabel.alpha = 1
            Utilities.setuprightImage(imageName: "x", textField: password, setupFlag: false)
            isValid = false
        }else{
            Utilities.setuprightImage(imageName: "check", textField: password, setupFlag: false)
            errorLabel.alpha = 0
            isValid = true
        }
        
        }
    
    @objc func emailDidEditingChanged(_ textField: UITextField) {

            // if a timer is already active, prevent it from firing
            if searchTimer != nil {
                searchTimer?.invalidate()
                searchTimer = nil
            }

            // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
            searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(emailSearchForKeyword(_:)), userInfo: textField.text!, repeats: false)
        }

    
    
    @objc func emailSearchForKeyword(_ timer: Timer) {

            // retrieve the keyword from user info
            let emailInput = timer.userInfo!
        
        

        let result:Bool = Utilities.isEmailValid(emailInput as! String)
        
        if (result == false){
            self.errorLabel.text = "Please enter a valid email"
            errorLabel.alpha = 1
            Utilities.setuprightImage(imageName: "x", textField: email, setupFlag: false)
            isValid = false
        }else{
            Utilities.setuprightImage(imageName: "check", textField: email, setupFlag: false)
            errorLabel.alpha = 0
            isValid = true
            }
        
        }
    
    
    @objc func userDidEditingChanged(_ textField: UITextField) {

            // if a timer is already active, prevent it from firing
            if searchTimer != nil {
                searchTimer?.invalidate()
                searchTimer = nil
            }

            // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
            searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(userSearchForKeyword(_:)), userInfo: textField.text!, repeats: false)
        }

    
    
    @objc func userSearchForKeyword(_ timer: Timer) {

            // retrieve the keyword from user info
            let usernameInput = timer.userInfo!
        
        

        let result:Bool = Utilities.isUserValid(Input: usernameInput as! String)
        
        if (result == false){
            self.errorLabel.text = "Usernames: length 4-18, letters, numbers and underscores"
            errorLabel.alpha = 1
            Utilities.setuprightImage(imageName: "x", textField: username, setupFlag: false)
            isValid = false
        }else{
            Utilities.setuprightImage(imageName: "check", textField: username, setupFlag: false)
            errorLabel.alpha = 0
            isValid = true
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
