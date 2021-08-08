//
//  Created by James Cavallo
//  Copyright © 2021 James Cavallo. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    struct code {
        static var actionCode = ""
        static var email = ""
    }
    
    static func styleTextField(_ user_field:UITextField, text:String) {
        //create line text field
        
        user_field.attributedPlaceholder = NSAttributedString(string: text, attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Gill Sans", size: 19)!
        ])
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: user_field.frame.height, width: user_field.frame.width, height: 2)
        bottomLine.backgroundColor = #colorLiteral(red: 0, green: 0.409712255, blue: 1, alpha: 1)
        user_field.borderStyle = .none
        user_field.layer.addSublayer(bottomLine)
        
        user_field.font = UIFont(name: "Gill Sans", size: 19)!
        user_field.textColor = #colorLiteral(red: 0, green: 0.409712255, blue: 1, alpha: 1)
        
        
        
    }
    
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isEmailValid(_ email : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isUserValid(Input:String) -> Bool {
        let RegEx = "\\w{3,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
    
    static func setupLeftImage(imageName:String, button:UITextField){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        imageView.alpha = 0.85
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 40))
        imageContainerView.addSubview(imageView)
        
        button.leftView = imageContainerView
        button.leftViewMode = .always
        }
    
    static func setuprightImage(imageName:String, textField:UITextField, setupFlag:Bool){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: imageName)
        imageView.image = image
        textField.rightView = imageView
        textField.rightViewMode = .always
        if (setupFlag == true){
            imageView.alpha = 0
            
        }else{
            imageView.alpha = 1
        }
    }
    
    static func parseErrors(error:NSError) -> String{
        if(error.code == 17007){
            return "Email already in use"
        }
        return "Unhandled error thrown"
        
    }
    
    
    
    static func generateHttpPayload(toEmail:String, mode:String) -> String{
        
        let dataDict = ["email": toEmail, "mode": mode] as [String : Any]
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dataDict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding: .ascii)
            return theJSONText!
        }
        return "Can't convert to JSON"
    }
    
    static func generateCredentialsPayload() -> String{
        
        let dataDict = ["username": "app", "password": """
R)6bm"9kp5P2!@3zN;?w+z2B
"""] as [String : Any]
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dataDict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding: .ascii)
            return theJSONText!
        }
        return "Can't convert to JSON"
    }
    

    static func httpRequest(toEmail:String, mode:String){
            let token = "Token " + UserDefaults.standard.string(forKey: "token")!
            guard let url = URL(string: "http://127.0.0.1:8000/smtp/"),
                  let payload = generateHttpPayload(toEmail: toEmail, mode: mode).data(using: .utf8) else
            {
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "accept")
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            
            request.addValue(token, forHTTPHeaderField: "Authorization")
            request.httpBody = payload

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { print("Empty data"); return }

                if let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
            }.resume()
        
        
    }
    
    static func authenticate(){
        guard let url = URL(string: "http://127.0.0.1:8000/api-token-auth/"),
              let payload = generateCredentialsPayload().data(using: .utf8) else
        {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = payload

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }
            

            if let str = String(data: data, encoding: .utf8) {
                let dict = convertToDictionary(text: str)
                UserDefaults.standard.set(dict!["token"]!, forKey: "token")
                
            }
        }.resume()
        
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
}
