//
//  CardView.swift
//  Set
//
//  Created by Yuki Orikasa on 2018/05/05.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import UIKit

class CardView: UIView {
    var figure = Card.Figure.square {
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
    var shading = Card.Shade.solid {
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
        
        //createCardFace(figure: figure, number: numbers, shade: shading, color: color)'
        drawFigure(number: Card.Number.three, color: UIColor.blue, figure: Card.Figure.circle, shading: Card.Shade.striped)
    }
}

// MARK: - CardView Private Methods
extension CardView {
    private func drawFigure(number: Card.Number, color: UIColor,
                            figure: Card.Figure, shading: Card.Shade) {
        let originX = bounds.center.x - figureWidth/2
        let originY = bounds.center.y - figureHeight/2
        
        switch shading {
        case Card.Shade.open:
            color.setStroke()
        case Card.Shade.solid:
            color.setFill()
        case Card.Shade.striped:
            let stripePath = UIBezierPath()
            let stripeWidth = figureWidth / CGFloat(SizeRatio.stripeWidth)
            let stripeHeight = figureHeight*3 + figureMargin*2
            
            for i in 0...SizeRatio.stripeWidth {
                if i%2 == 1 {
                    continue
                }
                let stripeRect = CGRect(x: originX + CGFloat(i)*stripeWidth, y: originY-figureMargin-figureHeight, width: stripeWidth, height: stripeHeight)
                let newRect = UIBezierPath(rect: stripeRect)
                stripePath.append(newRect)
            }
            stripePath.addClip()
            color.setFill()
        }
        
        let originYs = figuresYPoints(number: number, originY: originY)
        
        for y in originYs {
            var path: UIBezierPath
            
            switch figure {
            case Card.Figure.square:
                let rect = CGRect(x: originX, y: y, width: figureWidth, height: figureHeight)
                path = UIBezierPath(rect: rect)
            case Card.Figure.circle:
                path = UIBezierPath(arcCenter: CGPoint(x: bounds.center.x, y: y+figureHeight/2), radius: figureWidth/2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
            case Card.Figure.triangle:
                path = UIBezierPath()
                path.move(to: CGPoint(x: originX+figureWidth/2, y: y))
                path.addLine(to: CGPoint(x: originX+figureWidth, y: y+figureHeight))
                path.addLine(to: CGPoint(x: originX, y: y+figureHeight))
                path.addLine(to: CGPoint(x: originX+figureWidth/2, y: y))
                path.close()
            }
            switch shading {
            case Card.Shade.solid:
                path.fill()
            case Card.Shade.open:
                path.lineWidth = 1.5
                path.stroke()
            case Card.Shade.striped:
                path.fill()
            }
        }
    }
    
    private func createPath(of figure: Card.Figure, at origin: CGPoint) -> UIBezierPath {
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
    
    private func figuresYPoints(number: Card.Number, originY: CGFloat) -> [CGFloat] {
        let originYs: [CGFloat]
        switch number {
        case Card.Number.one:
            originYs = [originY]
        case Card.Number.two:
            originYs = [bounds.center.y-figureMargin/2-figureHeight, bounds.center.y+figureMargin/2]
        case Card.Number.three:
            originYs = [originY, originY-figureHeight-figureMargin, originY+figureMargin+figureHeight]
        }
        return originYs
    }
    
    private func figureOrigins(number: Card.Number) -> [CGPoint] {
        var origins: [CGPoint]
        let x = bounds.center.x - figureWidth/2
        let y = bounds.center.y - figureHeight/2
        
        switch number {
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


extension CGRect {
    var center: CGPoint {
        return CGPoint(x: (maxX-minX)/2, y: (maxY-minY)/2)
    }
}

