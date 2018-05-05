//
//  CardView.swift
//  Set
//
//  Created by Yuki Orikasa on 2018/05/05.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var rank: String = "12" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var suit: String = "♥️" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var figure: String = "square" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var numbers: Int = 2 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var shading: String = "solid" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var color: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    lazy var upperLeftLabel: UILabel = createCornerLabel()

    // draw subviews on this "CardView" view
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftLabel)
        upperLeftLabel.frame.origin = bounds.origin
    }
    
    // draw card itself
    override func draw(_ rect: CGRect) {
        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundRect.addClip()
        UIColor.white.setFill()
        roundRect.fill()
    }
}

// MARK: - CardView Private Methods
extension CardView {
    private func createCornerLabel() -> UILabel {
        let label =  UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func createFace() -> UIBezierPath {
        let path = UIBezierPath()
        return path
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        return NSAttributedString(string: string,
                                  attributes: [.font: font, .paragraphStyle: paragraphStyle])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString("\(rank)\n\(suit)", fontSize: cornerFontSize)
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        // label.isHidden = !isFaceUp
    }
}

// why should I extend instead of simply implement these variables and functions???
// ...so i googled and found: https://www.natashatherobot.com/using-swift-extensions/
// MARK: - CardView Constants
extension CardView {
    private struct SizeRatio {
        static let cornerRadius: CGFloat = 0.05
        static let cornerFontSize: CGFloat = 0.1
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSize
    }
}
