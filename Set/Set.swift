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
    let color = ["blue", "green", "red"]
    
    var cardCount: Int {
        return figures.count * number.count * shading.count * color.count
    }
    
    // game rules
    let initialVisibleCards: Int = 12
    var cardsSelecting: [Card] = []
    
    var allCards: [Card]
    var openCards: [Card] {
        return allCards.filter({$0.isOpen == true})
    }
    
    //    MARK: - Methods
    
    // Return index of a random card, which is not yet open (is in card stack) from allCards
    func randomCardIndexFromStack() -> Int {
        repeat {
            let randomCardNumber = Int(arc4random_uniform(UInt32(cardCount)))
            if let cardIndex = allCards.index(where: {$0.id == randomCardNumber}) {
                if allCards[cardIndex].isOpen == false {
                    return cardIndex
                }
            }
        }while(true)
    }
    
    init() {
        // Initialize all 81 cards
        allCards = []
        for f in figures {
            for n in number {
                for s in shading {
                    for c in color{
                        allCards.append(Card(figure: f, number: n, shading: s, color: c))
                    }
                }
            }
        }
        
        // Open <initialVisibleCards> cards randomly
        for _ in 1...initialVisibleCards {
            allCards[randomCardIndexFromStack()].isOpen = true
        }
    }
}
