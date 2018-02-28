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
    let figures: [String]
    let number: Range<Int>
    let shading: [String]
    let color: [Int]
    
    var cardCount: Int {
        return figures.count * number.count * shading.count * color.count
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
        // If already selected, then deselect (true -> false)
        // If not selected, then select (false -> true)
        if let cardIndex = allCards.index(where: {$0.id == id}) {
            allCards[cardIndex].isSelected = !allCards[cardIndex].isSelected
        }
        
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
    
    init(initialVisibleCards: Int) {
        Card.idGenerator = 0
        
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
            if let random = randomCardIndexFromStack() {
                allCards[random].isOpen = true
            }
        }
    }
}
