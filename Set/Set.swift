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
    let figuresNum: Int
    let numberNum: Int
    let shadingNum: Int
    let colorNum: Int
    
    var cardCount: Int {
        return figuresNum * numberNum * shadingNum * colorNum
    }
    
    // game rules
    let initialVisibleCards: Int = 12
    
    var allCards: [Card]
    var openCards: [Card] {
        return allCards.filter({$0.isOpen == true})
    }
    var selectedCards: [Card] {
        return allCards.filter({$0.isSelected == true})
    }
    
    //    MARK: - Methods
    
    func selectCard(at id: Int) {
        
        if selectedCards.count > 3 {
            for index in allCards.indices {
                allCards[index].isSelected = false
            }
        } else if selectedCards.count == 3 {
            // check if three cards match
            if formsSet(with: selectedCards) {
                // three cards formed a set
                for card in selectedCards {
                    allCards[card.id].isSet = true
                    allCards[card.id].isOpen = false
                    allCards[card.id].isSelected = false
                }
            } else {
                // cards didn't form a set
                for card in selectedCards {
                    allCards[card.id].isSelected = false
                }
            }
        }
        // If already selected, then deselect (true -> false)
        // If not selected, then select (false -> true)
        if let cardIndex = allCards.index(where: {$0.id == id}) {
            allCards[cardIndex].isSelected = !allCards[cardIndex].isSelected
        }
    }
    
    func formsSet(with cards: [Card]) -> Bool {
        // If all attributes of 3 cards are either different or same, they make a set
        // e.g. figures of all cards are same (●)
        //      number  of all cards are same (1)
        //      shading of all cards are different (solid, striped, and open)
        //      color   of all cards are same (blue)
        // these cards form a set!

        return true
    }
    
    // Return index of a random card, which is not yet open (is in card stack) from allCards
    func randomCardIndexFromStack() -> Int? {
        for _ in 1...cardCount {
            let randomCardId = Int(arc4random_uniform(UInt32(cardCount)))
            if let cardIndex = allCards.index(where: {$0.id == randomCardId}) {
                if allCards[cardIndex].isOpen == false {
                    return cardIndex
                }
            }
        }
        return nil
    }
    
    init(initialVisibleCards: Int, figures: Int, number: Int, shading: Int, color: Int) {
        Card.idGenerator = 0
        
        figuresNum = figures
        numberNum = number
        shadingNum = shading
        colorNum = color
        
        // Initialize all 81 cards
        allCards = []
        for f in 0..<figuresNum {
            for n in 0..<numberNum {
                for s in 0..<shadingNum {
                    for c in 0..<colorNum {
                        allCards.append(Card(figure: f, number: n, shading: s, color: c))
                    }
                }
            }
        }
        
        // Open <initialVisibleCards> cards randomly
        for _ in 1...initialVisibleCards {
            if let random = randomCardIndexFromStack() {
                allCards[random].isOpen = true
            }
        }
    }
}
