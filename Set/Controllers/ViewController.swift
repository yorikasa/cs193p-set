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
