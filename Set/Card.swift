//
//  Card.swift
//  Set
//
//  Created by Yuki Orikasa on 2018/02/11.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import Foundation

struct Card {
    let id: Int
    
    let figureId: Int
    let numberId: Int
    let shadingId: Int
    let colorId: Int
    
    var isOpen: Bool
    var isSelected: Bool
    var isSet: Bool
    
    static var idGenerator = 0
    
    static func createId() -> Int {
        self.idGenerator += 1
        return self.idGenerator
    }
    
    init(figure: Int, number: Int, shading: Int, color: Int){
        self.id = Card.createId()
        
        self.figureId = figure
        self.numberId = number
        self.shadingId = shading
        self.colorId = color
        
        self.isOpen = false
        self.isSelected = false
        self.isSet = false
    }
}
