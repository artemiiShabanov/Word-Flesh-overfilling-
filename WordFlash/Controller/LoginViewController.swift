//
//  LoginViewController.swift
//  WordFlash
//
//  Created by Artemii Shabanov on 16.12.2017.
//  Copyright © 2017 Alexandr. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, NetworkDelegate {
    
    var wasLoggedIn = true
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    
    //MARK: ViewController stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.layer.borderColor = (UIColor.white).cgColor
        loginTextField.delegate = self
        passwordTextField.layer.borderColor = (UIColor.white).cgColor
        passwordTextField.delegate = self
        spinner.isHidden = true
    }
    
    
    //MARK: custom buttons
    
    
    @IBAction func back(_ sender: Any) {
        let presentingViewController = self.presentingViewController
        self.dismiss(animated: false, completion: {
            self.wasLoggedIn ? presentingViewController!.dismiss(animated: true, completion: {}) : nil
        })
    }
    
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if loginTextField.text == "" {
            loginTextField.shake()
            return
        }
        if passwordTextField.text == "" {
            passwordTextField.shake()
            return
        }
        loginTextField.layer.borderColor = (UIColor.white).cgColor
        passwordTextField.layer.borderColor = (UIColor.white).cgColor
        
        var user = NetworkUser()
        user.username = loginTextField.text!
        user.password = passwordTextField.text!
        
        let manager = NetworkManager()
        manager.delegate = self
        _ = manager.token(from: user)
        startLoadingAnimation()
    }
    
    
    //MARK: animation
    
    func startLoadingAnimation() {
        loginTextField.isEnabled = false
        passwordTextField.isEnabled = false
        createButton.isEnabled = false
        okButton.isEnabled = false
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func stopLoadingAnimation() {
        spinner.isHidden = true
        spinner.stopAnimating()
        loginTextField.isEnabled = true
        passwordTextField.isEnabled = true
        createButton.isEnabled = true
        okButton.isEnabled = true
    }
    
    
    //MARK: Networkmanager
    
    func didReceiveToken(token: String?) {
        stopLoadingAnimation()
        if token != "" {
            defaults.set(token, forKey: "Token")
            defaults.set(loginTextField.text, forKey: "Username")
            let presentingViewController = self.presentingViewController
            self.dismiss(animated: false, completion: {
                self.wasLoggedIn ? presentingViewController!.dismiss(animated: true, completion: {}) : nil
            })
        } else {
            loginTextField.layer.borderColor = (UIColor.red).cgColor
            loginTextField.shake()
            passwordTextField.layer.borderColor = (UIColor.red).cgColor
            passwordTextField.shake()
        }
    }
    
    func didRegisterUser(register flag: Bool) {
        print("register")
    }
    
    func didReceiveWords() {
        print("words")
    }
    
}








