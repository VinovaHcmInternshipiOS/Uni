//
//  UIButton+Extension.swift
//  Uni
//
//  Created by nguyen gia huy on 11/11/2020.
//

import Foundation
import UIKit
extension UIButton {
    
    func animationScale() {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                       },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.transform = CGAffineTransform(scaleX: 1, y: 1)
                            
                        }
                        
                       })
    }
    
    func alignTextBelow(spacing: CGFloat = 6.0) {
        guard let image = self.imageView?.image else {
            return
        }
        
        guard let titleLabel = self.titleLabel else {
            return
        }
        
        guard let titleText = titleLabel.text else {
            return
        }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])
        
        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}

