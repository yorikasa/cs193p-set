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
    var openCards: [Card] = []
    var selectedCards: [Card] = []
    var matchedCards: [Card] = []
    var cardsInDeck: [Card] = []
    
    //    MARK: - Methods
    
    func selectCard(at id: Int) {
        // if there's any card to replace, then replace them and do nothing
        _ = replaceCards()
        
        if let cardIndex = openCards.index(where: {$0.id == id}) {
            // If already selected, then deselect (true -> false)
            // If not selected, then select (false -> true)
            if let selectedCardIndex = selectedCards.index(where: {$0.id == id}) {
                selectedCards.remove(at: selectedCardIndex)
            } else {
                selectedCards.append(openCards[cardIndex])
            }
        }
        
        // New card selected after 3 cards were un/matched
        // (already 3 cards are selected)
        //
        // Reset all selected cards states to unselected, and select the new card
        if selectedCards.count > 3 {
            selectedCards.removeAll()
            if let cardIndex = openCards.index(where: {$0.id == id}) {
                selectedCards.append(openCards[cardIndex])
            }
        }
        // New card is the 3rd card to the selection
        //
        // Check if these 3 cards match
        else if selectedCards.count == 3 {
            if doesFormSet(with: selectedCards) {
                // three cards formed a set
                for card in selectedCards {
                    matchedCards.append(card)
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
    
    func cardsToReplace() -> [Card]? {
        var cards: [Card]? = nil
        for cardIndex in openCards.indices.reversed() {
            if matchedCards.contains(openCards[cardIndex]) {
                if cards == nil {
                    cards = [Card]()
                }
                cards?.append(openCards[cardIndex])
            }
        }
        return cards
    }
    
    // if there are cards to be replaced (matched in a previous selection)
    // close these cards and replace them with new cards from the deck
    func replaceCards() -> Bool{
        if let cards = cardsToReplace() {
            for card in cards {
                openCards.remove(at: openCards.index(of: card)!)
                _ = openCardFromDeck()
            }
            return true
        } else {
            return false
        }
    }
    
    // Open random card from the deck if there's enough space to open
    func openCardFromDeck() -> Card? {
        if cardsInDeck.count > 0 {
            let randomIndex = randomInt(within: 0...cardsInDeck.count)
            openCards.append(cardsInDeck[randomIndex])
            cardsInDeck.remove(at: randomIndex)
            return openCards.last
        }
        return nil
    }
    
    func doesFormSet(with cards: [Card]) -> Bool {
        // for the test purpose
        return true
        
        // If all attributes of 3 cards are either different or same, they make a set
        // e.g. figures of all cards are same (●)
        //      number  of all cards are same (1)
        //      shading of all cards are different (solid, striped, and open)
        //      color   of all cards are same (blue)
        // these cards form a set!
        var figures: [Int] = []
        var numbers: [Int] = []
        var shading: [Int] = []
        var colors: [Int] = []
        
        for card in cards {
            figures.append(card.figureId)
            numbers.append(card.numberId)
            shading.append(card.shadingId)
            colors.append(card.colorId)
        }
        
        if !(figures.hasAllSameElements || figures.hasAllDifferentElements) {
            return false
        }
        if !(numbers.hasAllSameElements || numbers.hasAllDifferentElements) {
            return false
        }
        if !(shading.hasAllSameElements || shading.hasAllDifferentElements) {
            return false
        }
        if !(colors.hasAllSameElements || colors.hasAllDifferentElements) {
            return false
        }
        
        return true
    }
    
    
    // randomInt(10...100) returns random value from 10 to 100 (10 and 100 both included)
    func randomInt(within range: CountableClosedRange<Int>) -> Int{
        return Int(arc4random_uniform(UInt32(range.upperBound))) + range.lowerBound
    }
    
    init(figures: Int, number: Int, shading: Int, color: Int) {
        Card.idGenerator = 0
        
        self.score = 0
        
        // Initialize all 81 cards
        for f in 0..<figures {
            for n in 0..<number {
                for s in 0..<shading {
                    for c in 0..<color {
                        let card = Card(figure: f, number: n, shading: s, color: c)
                        cardsInDeck.append(card)
                    }
                }
            }
        }
    }
}


extension Array where Element: Equatable {
    // If all the array's elements are same
    // like [1, 1, 1 ,1]
    var hasAllSameElements: Bool{
        if let firstElement = self.first {
            for e in self {
                if e != firstElement {
                    return false
                }
            }
        } else {
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
