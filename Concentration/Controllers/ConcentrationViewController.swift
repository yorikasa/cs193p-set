//
//  ViewController.swift
//  Concentration
//
//  Created by Yuki Orikasa on 2018/01/07.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    // MARK: - Instance Variables
    
    // FIXME: DRY ( `initializeVariables()` )
    lazy var game: Concentration = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
    var flipCount: Int = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    var emojiList = ["😀", "👿", "👁", "🐶", "🍋", "🤡", "🌈", "🥨", "🏓"]
    var emoji: [Int:String] = [:]
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // MARK: - Outlets = [:]

    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
//            print("Chosen Card was not in the cardButtons")
        }
        flipCount = game.flipCount
        score = game.score
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        initializeVariables()
        updateViewFromModel()
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeVariables()
    }
    
    var theme: [String]? {
        didSet {
            emojiList = theme ?? [String]()
            emoji = [Int:String]()
            updateViewFromModel()
        }
    }
    
    func initializeVariables(){
        game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
        emoji = [Int:String]()
    }
    
    func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                }
            }
        }
    }
    
    func emoji(for card: PlayingCard) -> String {
            if emoji[card.identifier] == nil , emojiList.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiList.count)))
            emoji[card.identifier] = emojiList.remove(at: randomIndex)
        }
        
        //        if emoji[card.identifier] != nil {
        //            return emoji[card.identifier]!
        //        } else {
        //            return "?"
        //        }
        // these above 4 lines are equivalent to:
        return emoji[card.identifier] ?? "?"
    }

    

}


