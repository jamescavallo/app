//
//  ViewController.swift
//  Long Term
//
//  Created by James Cavallo on 7/10/21.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        Utilities.authenticate()
        button.layer.borderColor = UIColor.white.cgColor
        super.viewDidLoad()
    }
    
    
    @IBAction func handle_login(_ sender: Any) {
        
    }
    

    
    
    
    
    
    
}

