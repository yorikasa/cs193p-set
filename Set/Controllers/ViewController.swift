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
    
    lazy var game = Set()
    var cardViews = [CardView]()
    lazy var cardViewsGrid = Grid(layout: .aspectRatio(Constant.cardAspectRatio), frame: cardsMatView.bounds)

    
    //    MARK: - Outlets
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardsMatView: UIView!
    
    
    
    //    MARK: - Actions
    @IBAction func startNewGame(_ sender: UIButton) {
        setup()
        updateCardsView()
    }
    
    @IBAction func touchDealCardsButton(_ sender: UIButton) {
        dealCards(3)
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


// ViewConrroller Private functions
extension ViewController {
    private func setup() {
        removeCardViews()
        cardViewsGrid.cellCount = 0
        game = Set()
        
        dealCards(initialVisibleCards)
    }
    
    private func dealCards(_ number: Int) {
        for _ in 0..<number {
            if let card = game.openCardFromDeck() {
                cardViewsGrid.cellCount += 1
                if let lastCellRect = cardViewsGrid[cardViewsGrid.cellCount - 1] {
                    let cardRect = CGRect(origin: cardOrigin(origin: lastCellRect.origin, size: lastCellRect.size), size: cardSize(from: lastCellRect.size))
                    openCardView(of: card, at: cardRect)
                }
            }
        }
        rearrangeCardViews()
    }
    
    private func openCardView(of card: Card, at cardRect: CGRect) {
        let cardView = CardView(frame: cardRect)
        cardViews.append(cardView)
        cardsMatView.addSubview(cardView)
        cardView.setAttributes(figure: Card.Figure(rawValue: card.figureId)!,
                               number: Card.Number(rawValue: card.numberId)!,
                               shade: Card.Shade(rawValue: card.shadingId)!,
                               color: Card.Color(rawValue: card.colorId)!)
    }
    
    private func rearrangeCardViews() {
        for i in cardViews.indices {
            if let cell = cardViewsGrid[i] {
                cardViews[i].frame.origin = cardOrigin(origin: cell.origin, size: cell.size)
                cardViews[i].frame.size = cardSize(from: cell.size)
            }
        }
    }
    
    private func cardOrigin(origin: CGPoint, size: CGSize) -> CGPoint {
        let offsetWidth = (size.width - size.width*Constant.cardShrinkRatio) / 2
        let offsetHeight = (size.height - size.height*Constant.cardShrinkRatio) / 2
        return origin.offset(x: offsetWidth, y: offsetHeight)
    }
    private func cardSize(from size: CGSize) -> CGSize {
        return size.shrink(to: Constant.cardShrinkRatio)
    }
}


extension ViewController {
    private struct Constant {
        static let cardAspectRatio: CGFloat = 64/89
        static let cardShrinkRatio: CGFloat = 0.9
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
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(touchDealCardsButton(_:)))
        swipe.direction = [UISwipeGestureRecognizerDirection.down]
        view.addGestureRecognizer(swipe)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(_:)))
        view.addGestureRecognizer(rotation)
    }
}



extension CGSize {
    func shrink(to ratio: CGFloat) -> CGSize {
        return CGSize(width: self.width*ratio, height: self.height*ratio)
    }
}

extension CGPoint {
    func offset(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}
