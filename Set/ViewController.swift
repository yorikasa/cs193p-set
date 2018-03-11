//
//  ViewController.swift
//  Set
//
//  Created by Yuki Orikasa on 2018/01/29.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //    MARK: - Instance Variables
    
    // card variations
    let figures = ["●", "▲", "■"]
    let number = [1,2,3]
    let shading = ["solid", "striped", "open"]
    let color = [UIColor.blue, UIColor.green, UIColor.red]
    
    let initialVisibleCards = 12
    
    lazy var game = Set(initialVisibleCards: initialVisibleCards,
                        figures: figures.count, number: number.count,
                        shading: shading.count, color: color.count)
    

    
    //    MARK: - Outlets

    @IBOutlet var cardButtons: [UIButton]!
    
    //    MARK: - Actions
    
    
    // Battle of how UI (view) and Model come together...
    // I, first, was going to compare sender with cards like:
    //
    //     if game.cards.contains(where: sender) { ... }
    //
    // but it I happened to know it won't work because Card and sender (UIButton) aren't comparable.
    // or I should say I should make connection between model and view HERE.
    // UI Elements (View) has its attributes and Model (Cards struct) has its attributes.
    // But there's no connection between them. I have to connect them somewhere, or, here.
    @IBAction func touchCard(_ sender: UIButton) {
        game.selectCard(at: sender.tag)
        
        updateCardsView()
        
        for card in game.allCards {
            if let cardButton = cardButtons.filter({$0.tag == card.id}).first {
                if card.isSelected {
                    highlightCard(cardButton: cardButton)
                } else {
                    dehighlightCard(cardButton: cardButton)
                }
            }
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        reset()
    }
    
    // MARK: - Functions
    func drawCardButton(cardButton : UIButton) {
        // TODO: Remove Force unwrapping (!)
        let card = game.allCards.filter({$0.id == cardButton.tag}).first!
        var attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor: color[card.colorId]
        ]
        if card.shadingId == shading.index(of: "open") {
            attributes[.strokeColor] = color[card.colorId]
            attributes[.strokeWidth] = 10.0
        } else if card.shadingId == shading.index(of: "striped") {
            attributes[.underlineColor] = color[card.colorId]
            attributes[.underlineStyle] = NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.styleSingle.rawValue
        }
        let attributedString = NSAttributedString(string: String(repeating: figures[card.figureId], count: number[card.numberId]), attributes: attributes)
        cardButton.setAttributedTitle(attributedString, for: UIControlState.normal)
    }
    
    func highlightCard(cardButton: UIButton) {
        cardButton.layer.borderWidth = 2.0
        cardButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    
    func dehighlightCard(cardButton: UIButton) {
        cardButton.layer.borderWidth = 0
        cardButton.layer.borderColor = nil
    }
    
    func reset() {
        game = Set(initialVisibleCards: initialVisibleCards,
                   figures: figures.count, number: number.count,
                   shading: shading.count, color: color.count)
        for i in 0..<initialVisibleCards {
            cardButtons[i].tag = game.openCards[i].id
            drawCardButton(cardButton: cardButtons[i])
            dehighlightCard(cardButton: cardButtons[i])
        }
    }
    
    func updateCardsView() {
        for i in 0..<game.openCards.count {
            // FIXME: it should not refresh all open cards
            // because `openCards` array would not always sorted
            // that is, [10, 22, 24, 54, 71] might change to [8, 10, 24, 71, 76]
            // so every ID should be checked (is it practical?)
            cardButtons[i].tag = game.openCards[i].id
            drawCardButton(cardButton: cardButtons[i])
        }
    }
    
    
    //    MARK: - etc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


