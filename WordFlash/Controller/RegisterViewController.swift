//
//  RegisterViewController.swift
//  WordFlash
//
//  Created by Artemii Shabanov on 19.12.2017.
//  Copyright © 2017 Alexandr. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController, NetworkDelegate {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var firstPasswordTextField: UITextField!
    @IBOutlet weak var secondPasswordTextField: UITextField!
    
    
    //MARK: ViewController stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        nameTextField.layer.borderColor = (UIColor.white).cgColor
        nameTextField.delegate = self
        loginTextField.layer.borderColor = (UIColor.white).cgColor
        loginTextField.delegate = self
        firstPasswordTextField.layer.borderColor = (UIColor.white).cgColor
        firstPasswordTextField.delegate = self
        secondPasswordTextField.layer.borderColor = (UIColor.white).cgColor
        secondPasswordTextField.delegate = self
    }

    
    // MARK: custom buttons
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didButtonOkPressed(_ sender: Any) {
        guard loginTextField.text != "" else {
            loginTextField.shake()
            return
        }
        guard firstPasswordTextField.text != "" else {
            firstPasswordTextField.shake()
            return
        }
        guard (secondPasswordTextField.text != "" && secondPasswordTextField.text == firstPasswordTextField.text) else {
            secondPasswordTextField.shake()
            return
        }
        
        var user = NetworkUser()
        user.username = loginTextField.text!
        user.password = firstPasswordTextField.text!
        
        let manager = NetworkManager()
        manager.delegate = self
        manager.register(user)
        startLoadingAnimation()
    }
    
    
    //MARK: animation
    
    func startLoadingAnimation() {
        loginTextField.isEnabled = false
        firstPasswordTextField.isEnabled = false
        secondPasswordTextField.isEnabled = false
        okButton.isEnabled = false
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func stopLoadingAnimation() {
        spinner.isHidden = true
        spinner.stopAnimating()
        loginTextField.isEnabled = true
        firstPasswordTextField.isEnabled = true
        secondPasswordTextField.isEnabled = true
        okButton.isEnabled = true
    }
    
    
    //MARK: Networkmanager
    
    func didReceiveToken(token: String?) {
        //pass
    }
    
    func didRegisterUser(register flag: Bool) {
        stopLoadingAnimation()
        if flag {
            //TODO: defaults.set(token, forKey: "Token")
            defaults.set(loginTextField.text, forKey: "Username")
            let presentingViewController = self.presentingViewController
            let presentingViewController1 = presentingViewController?.presentingViewController
            let wasLoggedIn = (presentingViewController as! LoginViewController).wasLoggedIn
            self.dismiss(animated: false, completion: {
                presentingViewController!.dismiss(animated: false, completion: wasLoggedIn ? {presentingViewController1!.dismiss(animated: false, completion: {})} : nil )
            })
        } else {
            firstPasswordTextField.layer.borderColor = (UIColor.red).cgColor
            secondPasswordTextField.layer.borderColor = (UIColor.red).cgColor
            loginTextField.layer.borderColor = (UIColor.red).cgColor
        }
    }
    
    func didReceiveWords() {
        //pass
    }
}

