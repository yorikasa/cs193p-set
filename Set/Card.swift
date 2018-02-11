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
    
    let figure: String
    let number: Int
    let shading: String
    
    static var idGenerator = 0
    
    static func createId() -> Int {
        self.idGenerator += 1
        return self.idGenerator
    }
    
    init(figure: String, number: Int, shading: String){
        self.id = Card.createId()
        
        self.figure = figure
        self.number = number
        self.shading = shading
    }
}
