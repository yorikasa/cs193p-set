//
//  CardView.swift
//  Set
//
//  Created by Yuki Orikasa on 2018/05/05.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    var id: Int =  0
    
    var figure = Card.Figure.circle {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var numbers = Card.Number.two {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var shading = Card.Shade.striped {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var color = Card.Color.blue {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBInspectable
    var isFaceUp: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var status: Status = Status.normal {
        didSet {
            setNeedsDisplay()
        }
    }
    
    enum Status {
        case matched
        case unmatched
        case normal
    }
    

    // draw subviews on this "CardView" view
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // draw card itself
    override func draw(_ rect: CGRect) {
        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundRect.addClip()
        UIColor.white.setFill()
        roundRect.fill()
        
        if isSelected {
            UIColor.blue.setStroke()
            roundRect.lineWidth = 1.5
            roundRect.stroke()
        }
        switch status {
        case Status.matched:
            UIColor.red.setStroke()
            roundRect.lineWidth = 1.5
            roundRect.stroke()
        case Status.unmatched:
            UIColor.gray.setStroke()
            roundRect.lineWidth = 1.5
            roundRect.stroke()
        default:
            break
        }

        if isFaceUp {
            drawFigure()
        } else {
            if let cardBackImage = UIImage(named: "cardBack", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setAttributes(figure: Card.Figure, number: Card.Number, shade:Card.Shade, color:Card.Color) {
        self.figure = figure
        self.numbers = number
        self.shading = shade
        self.color = color
    }
}

// MARK: - CardView Private Methods
extension CardView {
    private func setup() {
        self.isOpaque = false
        registerGestures()
    }
    
    private func drawFigure() {
        // find out the number of figures and their origins (x,y)
        let origins = figureOrigins()
        
        for origin in origins {
            let path = createPath(at: origin)
            drawPath(path)
        }
    }
    
    // this method will be called unnecessarily many time
    // it should be called only once, but i can't find a smart answer
    private func stripedClippingPath(bounds: CGRect) -> UIBezierPath {
        let origin = CGPoint(x: bounds.minX, y: self.bounds.minY)
        let stripePath = UIBezierPath()
        let stripeWidth = bounds.width / CGFloat(SizeRatio.stripeWidth)
        let stripeHeight = self.bounds.height
        
        for i in 0...SizeRatio.stripeWidth {
            if i%2 == 1 {
                continue
            }
            let stripeRect = CGRect(x: origin.x + CGFloat(i)*stripeWidth, y: origin.y,
                                    width: stripeWidth, height: stripeHeight)
            let newRect = UIBezierPath(rect: stripeRect)
            stripePath.append(newRect)
        }
        return stripePath
    }
    
    private func drawPath(_ path: UIBezierPath) {
        let drawingColor = self.uiColor()
        
        switch shading {
        case Card.Shade.solid:
            drawingColor.setFill()
            path.fill()
        case Card.Shade.open:
            drawingColor.setStroke()
            path.lineWidth = 1.5
            path.stroke()
        case Card.Shade.striped:
            stripedClippingPath(bounds: path.bounds).addClip()
            drawingColor.setFill()
            path.fill()
        }
    }
    
    private func createPath(at origin: CGPoint) -> UIBezierPath {
        var path: UIBezierPath
        
        switch figure {
        case Card.Figure.square:
            let rect = CGRect(origin: origin, size: CGSize(width: figureWidth, height: figureHeight))
            path = UIBezierPath(rect: rect)
        case Card.Figure.circle:
            let center = CGPoint(x: origin.x+figureWidth/2, y: origin.y+figureHeight/2)
            path = UIBezierPath(arcCenter: center, radius: figureWidth/2,
                                startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        case Card.Figure.triangle:
            path = UIBezierPath()
            path.move(to: CGPoint(x: origin.x+figureWidth/2, y: origin.y))
            path.addLine(to: CGPoint(x: origin.x+figureWidth, y: origin.y+figureHeight))
            path.addLine(to: CGPoint(x: origin.x, y: origin.y+figureHeight))
            path.addLine(to: CGPoint(x: origin.x+figureWidth/2, y: origin.y))
            path.close()
        }
        return path
    }
    
    private func figureOrigins() -> [CGPoint] {
        var origins: [CGPoint]
        let x = bounds.center.x - figureWidth/2
        let y = bounds.center.y - figureHeight/2
        
        switch numbers {
        case Card.Number.one:
            origins = [CGPoint(x: x, y: y)]
        case Card.Number.two:
            let point1 = CGPoint(x: x, y: bounds.center.y-figureMargin/2-figureHeight)
            let point2 = CGPoint(x: x, y: bounds.center.y+figureMargin/2)
            origins = [point1, point2]
        case Card.Number.three:
            let point1 = CGPoint(x: x, y: y)
            let point2 = CGPoint(x: x, y: y-figureHeight-figureMargin)
            let point3 = CGPoint(x: x, y: y+figureMargin+figureHeight)
            origins = [point1, point2, point3]
        }
        return origins
    }
    
    private func uiColor() -> UIColor {
        switch color {
        case Card.Color.blue:
            return UIColor.blue
        case Card.Color.green:
            return UIColor.green
        case Card.Color.red:
            return UIColor.red
        }
    }
}

// CardView Gestures
extension CardView {
    @objc private func tapCard(_ sender: UIGestureRecognizer) {
        switch sender.state {
        case .ended:
            self.isSelected = !self.isSelected
        default:
            break
        }
    }
    
    private func registerGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
        self.addGestureRecognizer(tap)
    }
}

// why should I extend instead of simply implement these variables and functions???
// ...so i googled and found: https://www.natashatherobot.com/using-swift-extensions/
// MARK: - CardView Constants
extension CardView {
    private struct SizeRatio {
        static let cornerRadius: CGFloat = 0.05
        static let cornerFontSize: CGFloat = 0.1
        
        static let figureWidth: CGFloat = 0.28
        static let figureMargin: CGFloat = 0.2
        
        static let stripeWidth: Int = 9
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSize
    }
    
    private var figureWidth: CGFloat {
        return bounds.size.width * SizeRatio.figureWidth
    }
    private var figureHeight: CGFloat {
        return bounds.size.width * SizeRatio.figureWidth
    }
    private var figureMargin: CGFloat {
        return figureHeight * SizeRatio.figureMargin
    }
}

// MARK: - other extensions

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: (maxX-minX)/2, y: (maxY-minY)/2)
    }
}
