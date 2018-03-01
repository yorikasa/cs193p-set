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
    
    lazy var game = Set(initialVisibleCards: cardButtons.count,
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
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game = Set(initialVisibleCards: cardButtons.count,
                   figures: figures.count, number: number.count,
                   shading: shading.count, color: color.count)
        for i in cardButtons.indices {
            cardButtons[i].tag = game.openCards[i].id
            drawCardButton(cardButton: cardButtons[i])
        }
    }
    
    // MARK: - Functions
    func drawCardButton(cardButton : UIButton) {
        // TODO: Remove Force unwrapping (!)
        let card = game.allCards.filter({$0.id == cardButton.tag}).first!
        let attributes: [NSAttributedStringKey : Any] = [
            .strokeColor : UIColor.blue
        ]
        let attributedString = NSAttributedString(string: String(repeating: card.figure, count: card.number), attributes: attributes)
        cardButton.setAttributedTitle(attributedString, for: UIControlState.normal)
    }
    
    
    //    MARK: - etc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for i in cardButtons.indices {
            cardButtons[i].tag = game.openCards[i].id
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


