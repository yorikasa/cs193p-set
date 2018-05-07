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
    
    var cardViews = [CardView]()
    
    lazy var game = Set(figures: figures.count, number: number.count,
                        shading: shading.count, color: color.count)

    
    //    MARK: - Outlets
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    //    MARK: - Actions
    @IBAction func touchCard(_ sender: UIButton) {
        game.selectCard(at: sender.tag)
        updateCardsView()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        setup()
        updateCardsView()
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        if dealCardsButton.isEnabled == false { return }
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
            
            if game.selectedCards.count == 3 {
                cardButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
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

    
    func updateCardsView() {
    }
    
    
    private func setup() {
        cardViews.removeAll()
        game = Set(figures: figures.count, number: number.count,
                   shading: shading.count, color: color.count)
        
        var grid = Grid(layout: .aspectRatio(64/89), frame: view.bounds)
        grid.cellCount = initialVisibleCards
        
        for i in 0..<initialVisibleCards {
            if let gridRect = grid[i] {
                let width = gridRect.width * 0.9
                let height = width * 89/64
                openCardView(at: gridRect.origin, size: CGSize(width: width, height: height))
            }
        }
    }
    
    private func openCardView(at origin: CGPoint, size: CGSize) {
        let cardRect = CGRect(origin: origin, size: size)
        let cardView = CardView(frame: cardRect)
        view.addSubview(cardView)
        if let card = game.openCardFromDeck() {
            cardView.setAttributes(figure: Card.Figure(rawValue: card.figureId)!,
                                   number: Card.Number(rawValue: card.numberId)!,
                                   shade: Card.Shade(rawValue: card.shadingId)!,
                                   color: Card.Color(rawValue: card.colorId)!)
        }
    }
    
    
    
    //    MARK: - etc
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //reset()
        setup()
        registerGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



// MARK: - ViewController Gestures
extension ViewController {
    // sorry it actually is reversed
    @objc func shuffleCards(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            print("rotated: \(sender.rotation)")
            updateCardsView()
        default:
            break
        }
    }
    
    private func registerGestures() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealCards(_:)))
        swipe.direction = [UISwipeGestureRecognizerDirection.down]
        view.addGestureRecognizer(swipe)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(_:)))
        view.addGestureRecognizer(rotation)
    }
}
