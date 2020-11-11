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
}

