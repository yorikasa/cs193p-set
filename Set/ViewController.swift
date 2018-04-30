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
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    lazy var game = Set(figures: figures.count, number: number.count,
                        shading: shading.count, color: color.count)
    
    var openedCardButtons: [UIButton]? {
        return cardButtons.filter({$0.tag != 0})
    }

    
    //    MARK: - Outlets

    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    //    MARK: - Actions
    
    @IBAction func touchCard(_ sender: UIButton) {
        game.selectCard(at: sender.tag)
        updateCardsView()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        reset()
        updateCardsView()
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        if !game.replaceCards() {
            for _ in 1...3 {
                _ = game.openCardFromDeck()
            }
        }
        updateCardsView()
    }
    
    
    // MARK: - Functions
    
    func drawCardButton(cardButton : UIButton) {
        if let card = card(of: cardButton) {
            cardButton.layer.opacity = 1.0
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
        } else {
            cardButton.setAttributedTitle(nil, for: UIControlState.normal)
        }
    }
    
    // de/highlight the card button depends on the corresponding card
    func highlightCard(cardButton: UIButton) {
        // default: de-highlight
        cardButton.layer.borderWidth = 0
        cardButton.layer.borderColor = nil
        
        if game.selectedCards.contains(where: {$0.id == cardButton.tag}) {
            cardButton.layer.borderWidth = 2.0
            cardButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
        if game.matchedCards.contains(where: {$0.id == cardButton.tag}) {
            cardButton.layer.borderWidth = 2.0
            cardButton.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        }
    }
    
    // return a corresponding card object from a card button
    func card(of cardButton: UIButton) -> Card? {
        let cards = game.openCards.filter({$0.id == cardButton.tag})
        if cards.count == 1 {
            return cards.first
        } else {
            return nil
        }
    }
    
    func hideCard(of cardButton: UIButton) {
        cardButton.layer.opacity = 0
        cardButton.tag = 0
    }
    
    func openCard(of cardButton: UIButton) {
        if game.openCards.count < cardButtons.count {
            if let card = game.openCardFromDeck() {
                cardButton.tag = card.id
                drawCardButton(cardButton: cardButton)
            }
        }
    }
    
    func reset() {
        for cardButton in cardButtons {
            hideCard(of: cardButton)
            drawCardButton(cardButton: cardButton)
        }
        game = Set(figures: figures.count, number: number.count,
                   shading: shading.count, color: color.count)
        for i in 0..<initialVisibleCards {
            openCard(of: cardButtons[i])
            highlightCard(cardButton: cardButtons[i])
        }
        score = game.score
    }
    
    func updateCardsView() {
        var cardButtonIndicesToReplace: [Int] = []
        var newlyOpenedCardTags: [Int] = []
        
        // Find out which cardButton indices are going to be replaced
        // and which cards (tags) are newly opened.
        // Then replace the cards' tags which have that indices with newly opened cards' tags.
        for i in 0..<game.openCards.count {
            if !cardButtons.contains(where: {$0.tag == game.openCards[i].id}) {
                newlyOpenedCardTags.append(game.openCards[i].id)
            }
            if !game.openCards.contains(where: {$0.id == cardButtons[i].tag}) {
                cardButtonIndicesToReplace.append(i)
            }
        }
        
        // TODO: if there are no cards to replace (empty deck), what will happen
        // workaround
        for i in 0..<newlyOpenedCardTags.count {
            cardButtons[cardButtonIndicesToReplace[i]].tag = newlyOpenedCardTags[i]
            drawCardButton(cardButton: cardButtons[cardButtonIndicesToReplace[i]])
        }
        
        for cardButton in cardButtons {
            if card(of: cardButton) != nil {
            } else {
                // hide matched cards when there's no cards to deal from the deck
                hideCard(of: cardButton)
            }
            highlightCard(cardButton: cardButton)
        }
        // when cards matched these cards are keep opened until a next card is selected
        // so exclude these already matched but open cards to deal new cards
        if (game.cardsInDeck.count == 0) || (game.openCards.count == cardButtons.count) {
            dealCardsButton.isEnabled = false
        } else {
            dealCardsButton.isEnabled = true
        }
        score = game.score
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



