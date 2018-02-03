//
//  LogoutViewController.swift
//  WordFlash
//
//  Created by Artemii Shabanov on 26.12.2017.
//  Copyright © 2017 Alexandr. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    
    
    //MARK: ViewController stuff
    
    override func viewDidLoad() {
        username.text = defaults.object(forKey: "Username") as? String
    }
    
    
    // MARK: custom buttons
    
    @IBAction func logout(_ sender: Any) {
        defaults.removeObject(forKey: "Username")
        defaults.removeObject(forKey: "Token")
        self.performSegue(withIdentifier: "NowLoginSegue", sender: self)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
