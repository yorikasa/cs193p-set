//
//  Concentration.swift
//  Concentration
//
//  Created by Yuki Orikasa on 2018/01/20.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import Foundation

class Concentration{
    var cards = Array<PlayingCard>()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    var flipCount: Int
    var score: Int
    
    func score(index1: Int, index2: Int) -> Int{
        var score = 0
        if cards[index1].hasOpened {
            score -= 1
        }
        if cards[index2].hasOpened {
            score -= 1
        }
        return score
    }
    
    func chooseCard(at index: Int){
        // 下の条件以外のとき
        // - すでにマッチしているカードが2枚開いているとき、そのいずれかを再びクリックしたとき
        // - すでにマッチ済みで非表示になっているカードをクリックしたとき
        if !cards[index].isMatched {
            flipCount += 1
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else{
                    score += score(index1: index, index2: matchIndex)
                    cards[index].hasOpened = true
                    cards[matchIndex].hasOpened = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
                for flipdownIndex in cards.indices {
                    cards[flipdownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }else{
            
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        flipCount = 0
        score = 0
        
        for _ in 1...numberOfPairsOfCards {
            let card = PlayingCard()
            cards += [card, card]
        }
        // Shuffle the cards
        for _ in cards.indices {
            cards.swapAt(Int(arc4random_uniform(UInt32(cards.count))), Int(arc4random_uniform(UInt32(cards.count))))
        }
    }
}
