//
//  NetworkUser.swift
//  WordFlash
//
//  Created by xcode on 20.12.2017.
//  Copyright © 2017 Alexandr. All rights reserved.
//

import Foundation

public struct NetworkUser {
    var username: String?
    var password: String?
    var historyWords: [String] = []
    var favoriteWords: [String] = []
    var mainWords: [String] = []
}
