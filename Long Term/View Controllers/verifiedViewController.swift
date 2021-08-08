//
//  verifiedViewController.swift
//  Long Term
//
//  Created by James Cavallo on 7/29/21.
//

import UIKit
import FirebaseAuth

class verifiedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func `continue`(_ sender: Any) {
        _ = UIStoryboard(name: "Main", bundle: nil)
        if Auth.auth().currentUser != nil {
            let completeViewController = self.storyboard?.instantiateViewController(identifier: "mainVC")
            self.present(completeViewController!, animated: true, completion: nil)
        } else {
            let completeViewController = self.storyboard?.instantiateViewController(identifier: "loginVC")
            self.present(completeViewController!, animated: true, completion: nil)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
