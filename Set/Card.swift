//
//  Card.swift
//  Set
//
//  Created by Yuki Orikasa on 2018/02/11.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import Foundation

struct Card: Equatable {
    private let id: Int
    
    private let figureId: Int
    private let numberId: Int
    private let shadingId: Int
    private let colorId: Int
    
    static private var idGenerator = 0
    
    static private func createId() -> Int {
        self.idGenerator += 1
        return self.idGenerator
    }
    
    init(figure: Int, number: Int, shading: Int, color: Int){
        self.id = Card.createId()
        
        self.figureId = figure
        self.numberId = number
        self.shadingId = shading
        self.colorId = color
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    func matches(to card2: Card, and card3: Card) -> Bool {
        let card1 = self
        
        let figureIds = [card1.figureId, card2.figureId, card3.figureId]
        let numberIds = [card1.numberId, card2.numberId, card3.numberId]
        let shadingIds = [card1.shadingId, card2.shadingId, card3.shadingId]
        let colorIds = [card1.colorId, card2.colorId, card3.colorId]
        
        let cardIds = [figureIds, numberIds, shadingIds, colorIds]
        
        func canBeMatched(_ ids: [Int]) -> Bool {
            if ids.hasAllSameElements || ids.hasAllDifferentElements {
                return true
            }
            return false
        }
        return cardIds.map{ canBeMatched($0) }.reduce(true, {$0 && $1})
    }
}
