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
    var score: Int
    
    // cards
    var openCards = [Card]()
    var selectedCards: [Card] {
        return openCards.filter({$0.isSelected == true})
    }
    var matchedCards: [Card] {
        return openCards.filter({$0.isMatched == true})
    }
    var cardsInDeck = [Card]()
    
    //    MARK: - Methods
    
    func selectCard(at id: Int) {
        // if there's any card to replace, then replace them
        _ = replaceCards()
        
        if let cardIndex = openCards.index(where: {$0.id == id}) {
            // If already selected, then deselect (true -> false)
            // If not selected, then select (false -> true)
            openCards[cardIndex].isSelected = !openCards[cardIndex].isSelected
        }
        
        // New card was selected after 3 cards were un/matched
        // (already 3 cards are selected)
        if selectedCards.count > 3 {
            // Reset all selected cards states to unselected
            for i in openCards.indices {
                openCards[i].isSelected = false
                openCards[i].isMatched = false
            }
            // then select a new card
            if let cardIndex = openCards.index(where: {$0.id == id}) {
                openCards[cardIndex].isSelected = true
            }
        }
            
        // The 3rd card was selected
        else if selectedCards.count == 3 {
            // Check if these 3 cards match
            if doesFormSet(with: selectedCards) {
                for card in selectedCards {
                    if let index = openCards.index(where: {$0.id == card.id}) {
                        openCards[index].isMatched = true
                    }
                }
                score += 3
            } else {
                score -= 3
            }
        }
            
        // This is the first/2nd card selected
        else {
            // Do nothing
        }
    }

    // if there are cards to be replaced (matched in a previous selection)
    // close these cards and replace them with new cards from the deck
    func replaceCards() -> Bool{
        if matchedCards.count > 0 {
            for card in matchedCards {
                print(card)
                if let index = openCards.index(of: card) {
                    openCards[index].isMatched = false
                    openCards.remove(at: index)
                    _ = openCardFromDeck()
                }
            }
            return true
        } else {
            return false
        }
    }
    
    // Open random card from the deck if there's enough space to open
    func openCardFromDeck() -> Card? {
        if cardsInDeck.count > 0 {
            let randomIndex = (0...cardsInDeck.count).random
            openCards.append(cardsInDeck[randomIndex])
            cardsInDeck.remove(at: randomIndex)
            return openCards.last
        }
        return nil
    }
    
    private func doesFormSet(with cards: [Card]) -> Bool {
        // for the test purpose
        return true
        
        // If all attributes of 3 cards are either different or same, they make a set
        // e.g. figures of all cards are same (●)
        //      number  of all cards are same (1)
        //      shading of all cards are different (solid, striped, and open)
        //      color   of all cards are same (blue)
        // these cards form a set!
        return cards[0].matches(to: cards[1], and: cards[2])
    }
    

    init() {
        Card.resetIdGenerator()
        self.score = 0
        
        // Initialize all 81 cards
        for f in 0..<3 {
            for n in 0..<3 {
                for s in 0..<3 {
                    for c in 0..<3 {
                        let card = Card(figure: f, number: n, shading: s, color: c)
                        cardsInDeck.append(card)
                    }
                }
            }
        }
    }
}

// randomInt(10...100) returns random value from 10 to 100 (10 and 100 both included)
extension CountableClosedRange where Element == Int {
    var random: Int {
        return Int(arc4random_uniform(UInt32(self.upperBound))) + self.lowerBound
    }
}

extension Array where Element: Equatable {
    // If all the array's elements are same
    // like [1, 1, 1 ,1]
    var hasAllSameElements: Bool {
        if self.filter({$0 == first}).count != count {
            return false
        }
        return true
    }
    
    // If all the array's elements are different
    // like [1, 2, 3, 4]
    var hasAllDifferentElements: Bool {
        for element in self {
            if self.filter({$0 == element}).count > 1 {
                return false
            }
        }
        return true
    }
}
