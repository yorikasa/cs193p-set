//
//  Set.swift
//  Set
//
//  Created by Yuki Orikasa on 2018/02/11.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import Foundation

class Set {
    //    MARK: - Variables
    
    // card variations
    let figures = ["●", "▲", "■"]
    let number = 1...3
    let shading = ["solid", "striped", "open"]
    
    // game rules
    let initialVisibleCards: Int = 12
    var cardsSelecting: [Card] = []
    
    var cards: [Card]
    
    //    MARK: - Methods
    
    init() {
        // Initialize all 81 cards
        cards = []
        for f in figures {
            for n in number {
                for s in shading {
                    cards.append(Card(figure: f, number: n, shading: s))
                }
            }
        }
    }
}
