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
    lazy var cardViewsGrid = Grid(layout: .aspectRatio(Constant.cardAspectRatio))
    var rotated = false

    
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
        assert(cardViews.count == game.openCards.count, "model \(cardViews.count) != view \(game.openCards.count)")
        let cardViewIds = cardViews.map({$0.id})
        let cardIds = game.openCards.map({$0.id})
        let diff = idDifference(cardIds: cardIds, cardViewIds: cardViewIds)

        for i in 0..<diff.missing.count {
            // the cards were removed from model because of matching etc
            // so i have to remove them from views too
            var cardRect = CGRect(origin: CGPoint.zero, size: CGSize.zero)
            if let index = cardViews.index(where: {$0.id == diff.missing[i]}) {
                cardRect = cardViews[index].frame
                cardViews[index].removeFromSuperview()
                cardViews.remove(at: index)
                
                if let cardIndex = game.openCards.index(where: {$0.id == diff.added[i]}) {
                    openCardView(of: game.openCards[cardIndex], with: cardRect, at: index)
                }
            }
            
        }
    }
    
    private func printCardViews() {
        var strings = [String]()
        for cardView in cardViews {
            var string: String = ""
            switch cardView.figure {
            case Card.Figure.circle:
                for _ in 0..<cardView.numbers.rawValue+1 {
                    string.append("◯")
                }
            case Card.Figure.square:
                for _ in 0..<cardView.numbers.rawValue+1 {
                        string.append("⬜︎")
                }
            case Card.Figure.triangle:
                for _ in 0..<cardView.numbers.rawValue+1 {
                    string.append("△")
                }
            }
            strings.append(string)
        }
        print(strings)
    }
    
    private func removeCardViews() {
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
        cardViews.removeAll()
    }
    
    //    MARK: - etc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection != nil {
            rotated = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if rotated {
            cardViewsGrid.frame = cardsMatView.bounds
            rearrangeCardViews()
            rotated = false
        }
        
    }
}


// ViewConrroller Private functions
extension ViewController {
    private func setup() {
        removeCardViews()
        cardViewsGrid.frame = cardsMatView.bounds
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
                    openCardView(of: card, with: cardRect)
                }
            }
        }
        rearrangeCardViews()
    }
    
    private func openCardView(of card: Card, with cardRect: CGRect, at index: Int? = nil) {
        let cardView = CardView(frame: cardRect)
        cardViews.insert(cardView, at: index ?? cardViews.endIndex)
        cardsMatView.addSubview(cardView)
        cardView.id = card.id
        cardView.setAttributes(figure: Card.Figure(rawValue: card.figureId)!,
                               number: Card.Number(rawValue: card.numberId)!,
                               shade: Card.Shade(rawValue: card.shadingId)!,
                               color: Card.Color(rawValue: card.colorId)!)
        registerCardViewGestures(cardView: cardView)
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
    
    private func idDifference(cardIds: [Int], cardViewIds: [Int]) -> (added: [Int], missing: [Int]) {
        var cardIdAdded =  cardIds
        var cardViewIdMissing = cardViewIds
        for cardIdIndex in cardIdAdded.indices {
            if let cardViewIdIndex = cardViewIds.index(where: {$0 == cardIds[cardIdIndex]}) {
                cardIdAdded[cardIdIndex] = 0
                cardViewIdMissing[cardViewIdIndex] = 0
            }
        }
        let added = cardIdAdded.filter({$0 != 0})
        let missing = cardViewIdMissing.filter({$0 != 0})
        return (added: added, missing: missing)
    }
}


//MARK: - Constants
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
    
    @objc private func tapCard(_ sender: UIGestureRecognizer) {
        switch sender.state {
        case .ended:
            if let cardView = sender.view as? CardView {
                game.selectCard(at: cardView.id)
                cardView.isSelected = !cardView.isSelected
                updateCardsView()
            }
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
    
    private func registerCardViewGestures(cardView: CardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
        cardView.addGestureRecognizer(tap)
    }
}


//MARK: - Other Extensions
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
