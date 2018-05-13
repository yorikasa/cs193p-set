//
//  Card.swift
//  Concentration
//
//  Created by Yuki Orikasa on 2018/01/20.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import Foundation

struct PlayingCard {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    var hasOpened = false
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = PlayingCard.getUniqueIdentifier()
    }
}
