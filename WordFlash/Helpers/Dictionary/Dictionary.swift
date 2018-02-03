//
//  Dictionary.swift
//  WordFlash
//
//  Created by Alexandr on 01/12/2017.
//  Copyright © 2017 Alexandr. All rights reserved.
//

import Foundation
import SwiftyJSON

class Dictionary {
    private static let jsonFilename = "dictionary"
    static let sharedInstance = Dictionary()
    
    var json: JSON
    var words: [String]
    
    private init() {
        json = Dictionary.loadJson(from: Dictionary.jsonFilename)
        words = Dictionary.allWords(from: json)//.sorted()
    }
    
    private static func loadJson(from path: String) -> JSON {
        let jsonPath = Bundle.main.path(forResource: path, ofType: "json")!
        let jsonString = try? String(contentsOfFile: jsonPath, encoding: String.Encoding.utf8)
        
        return JSON(parseJSON: jsonString!)
    }
    
    private static func write(_ json: JSON, to path: String) {
        let jsonPath = Bundle.main.path(forResource: path, ofType: "json")!
        let str = json.description
        let data = str.data(using: String.Encoding.utf8)!
        
        if let file = FileHandle(forWritingAtPath: jsonPath) {
            file.write(data)
        }
    }
    
    private static func allWords(from json: JSON) -> [String] {
        return json
            .dictionary!
            .keys
            .map { $0 }
    }
    
    //API
    
    var count: Int {
        return words.count
    }
    
    func word(at index: Int) -> String? {
        return words[index]
    }
    
    subscript(word: String) -> String {
        return json[word].stringValue
    }
}
