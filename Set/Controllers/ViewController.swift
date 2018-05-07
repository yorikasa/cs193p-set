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
    
    let initialVisibleCards = 12
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    var cardViews = [CardView]()
    
    lazy var game = Set()

    
    //    MARK: - Outlets
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardsMatView: UIView!
    
    
    
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
    
    
    private func removeCardViews() {
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
        cardViews.removeAll()
    }
    
    
    private func setup() {
        removeCardViews()
        game = Set()
        
        var grid = Grid(layout: .aspectRatio(64/89), frame: cardsMatView.bounds)
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
        cardViews.append(cardView)
        cardsMatView.addSubview(cardView)
        if let card = game.openCardFromDeck() {
            cardView.setAttributes(figure: Card.Figure(rawValue: card.figureId)!,
                                   number: Card.Number(rawValue: card.numberId)!,
                                   shade: Card.Shade(rawValue: card.shadingId)!,
                                   color: Card.Color(rawValue: card.colorId)!)
        }
    }
    
    
    
    //    MARK: - etc
    
    // when this view controller's `viewDidLoad()` gets called,
    // its subviews don't be adjusted their layout
    // for now I'm not sure its' recommended way of get subview's proper dimension
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
