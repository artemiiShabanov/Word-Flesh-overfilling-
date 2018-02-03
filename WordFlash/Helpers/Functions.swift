//
//  Functions.swift
//  WordFlash
//
//  Created by Artemii Shabanov on 22.01.2018.
//  Copyright © 2018 Alexandr. All rights reserved.
//

import Foundation



enum Functions {
    
    
    // MARK: dictionary random n
    static func getRandomWords(on count: Int) -> [Word]
    {
        var alreadyHaveWords:[String] = []
        for word in realm.objects(Word.self) {
            alreadyHaveWords.append( word.word )
        }
        
        let allWords = Dictionary.sharedInstance.words
        var res: Set<Word> = []
        while (res.count < count) {
            let word = Word()
            word.word = allWords[Int(arc4random_uniform(UInt32(allWords.count)))]
            if alreadyHaveWords.contains(word.word) {
                continue
            }
            word.definition = Dictionary.sharedInstance[word.word]
            word.isAddedByUser = false
            res.insert(word)
        }
        return Array(res)
    }
}
