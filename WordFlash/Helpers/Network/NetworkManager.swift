//
//  NetworkManager.swift
//  WordFlash
//
//  Created by xcode on 19.12.2017.
//  Copyright © 2017 Alexandr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    private let urlString = "https://wordflash.herokuapp.com"
    private let getTokenPath = "/get-token/"
    
    public var delegate: NetworkDelegate?
    
    func token(from user: NetworkUser) -> String? {
        let parameters: Parameters = [
            "username": user.username ?? "",
            "password": user.password ?? ""
        ]
        
        let url = "https://wordflash.herokuapp.com/get-token/"
        
        Alamofire.request(url, method:.post, parameters:parameters).responseJSON { response in
            switch response.result {
            case .success, .failure:
                self.delegate?.didReceiveToken(token: JSON(response.data)["token"].stringValue)
            }
            
        }
        
        return nil
    }
    
    func register(_ user: NetworkUser) {
        let parameters: Parameters = [
            "username": user.username ?? "",
            "password": user.password ?? ""
        ]
        
        let url = "https://wordflash.herokuapp.com/register/"
        
        Alamofire.request(url, method:.post, parameters:parameters).responseJSON { response in
            switch response.result {
            case .success:
                self.delegate?.didRegisterUser(register: JSON(response.data)["username"].stringValue != "")
            case .failure:
                self.delegate?.didRegisterUser(register: false)
            }
            
        }
        
    }
    
}



