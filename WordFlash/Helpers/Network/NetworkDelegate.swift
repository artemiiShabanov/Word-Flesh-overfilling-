//
//  NetworkDelegate.swift
//  WordFlash
//
//  Created by xcode on 20.12.2017.
//  Copyright © 2017 Alexandr. All rights reserved.
//

import Foundation

protocol NetworkDelegate {
    func didReceiveToken(token: String?)
    
    func didRegisterUser(register flag: Bool)
    
    func didReceiveWords()
}
