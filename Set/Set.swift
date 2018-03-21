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
    
    let maxOpenedCards: Int
    
    var cardCount: Int {
        return figuresNum * numberNum * shadingNum * colorNum
    }
    
    // game rules
    var allCards: [Card]
    var openCards: [Card] {
        return allCards.filter({$0.isOpen == true})
    }
    var selectedCards: [Card] {
        return allCards.filter({$0.isSelected == true})
    }
    var cardsInDeck: [Card] {
        return allCards.filter({!$0.isOpen && !$0.isSet })
    }
    
    //    MARK: - Methods
    
    func selectCard(at id: Int) {
        // If already selected, then deselect (true -> false)
        // If not selected, then select (false -> true)
        if let cardIndex = allCards.index(where: {$0.id == id}) {
            allCards[cardIndex].isSelected = !allCards[cardIndex].isSelected
        }
        
        // New card selected after 3 cards were un/matched
        // (already 3 cards are selected)
        //
        // Reset all selected cards states to unselected, and select the new card
        if selectedCards.count > 3 {
            for index in allCards.indices {
                allCards[index].isSelected = false
            }
            if let cardIndex = allCards.index(where: {$0.id == id}) {
                allCards[cardIndex].isSelected = true
            }
        }
        // New card is the 3rd card to the selection
        //
        // Check if these 3 cards match
        else if selectedCards.count == 3 {
            if doesFormSet(with: selectedCards) {
                // three cards formed a set
                for card in selectedCards {
                    if let cardIndex = allCards.index(where: {$0.id == card.id}) {
                        allCards[cardIndex].isSet = true
                        allCards[cardIndex].isOpen = false
                    }
                }
                // Deal 3 new cards
                for _ in 1...3 {
                    _ = openCardFromDeck()
                }
            }
        }
        // This is the first/2nd card selected
        else {
            // Do nothing
        }
    }
    
    func open(_ card: Card) -> Card? {
        if openCards.count < maxOpenedCards {
            if let index = allCards.index(of: card) {
                allCards[index].isOpen = true
                return card
            }
        }
        return nil
    }
    
    func openCardFromDeck() -> Card? {
        if let random = randomCardIndexFromStack() {
            if let card = open(allCards[random]) {
                return card
            }
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
    
    // Return index of a random card from allCards
    // The card is not yet open (is in card stack) and not yet set
    func randomCardIndexFromStack() -> Int? {
        if cardsInDeck.count > 0 {
            let randomId = randomInt(within: 0...cardsInDeck.count)
            return allCards.index(of: cardsInDeck[randomId])
        } else {
            return nil
        }
    }
    
    // randomInt(10...100) returns random value from 10 to 100 (10 and 100 both included)
    func randomInt(within range: CountableClosedRange<Int>) -> Int{
        return Int(arc4random_uniform(UInt32(range.upperBound))) + range.lowerBound
    }
    
    init(initialVisibleCards: Int, maxOpenedCards: Int, figures: Int, number: Int, shading: Int, color: Int) {
        Card.idGenerator = 0
        
        figuresNum = figures
        numberNum = number
        shadingNum = shading
        colorNum = color
        self.maxOpenedCards = maxOpenedCards
        
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
