//
//  DashedBorderView.swift
//  Tradesman Tech
//
//  Created by satyam dwivedi on 18/02/25.
//

import UIKit

class DashedBorderView: UIView {
    private let dashedBorderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBorder()
    }
    
    private func setupBorder() {
        dashedBorderLayer.strokeColor = UIColor.gray.cgColor
        dashedBorderLayer.lineDashPattern = [6, 3] // Dash length and gap
        dashedBorderLayer.fillColor = nil
        dashedBorderLayer.lineWidth = 2
        layer.addSublayer(dashedBorderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedBorderLayer.frame = bounds
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        dashedBorderLayer.path = path
    }
}
