//
//  UIView+Extension.swift
//  Uni
//
//  Created by nguyen gia huy on 09/11/2020.
//

import Foundation
import UIKit
@IBDesignable
extension UIView {

    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowOffset : CGSize{

        get{
            return layer.shadowOffset
        }set{

            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity : Float {

        get{
            return layer.shadowOpacity
        }
        set {

            layer.shadowOpacity = newValue

        }
    }
    
    @IBInspectable
    var shadowBlur: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue / 2.0
            }
    }

    @IBInspectable
    var shadowSpread: CGFloat {
        get {
            return layer.shadowPath as! CGFloat
        }
        set {
            let dx = -newValue
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
//    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//             let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//             let mask = CAShapeLayer()
//             mask.path = path.cgPath
//             self.layer.mask = mask
//    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    
    func dropShadowBlack() {
        layer.cornerRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = AppColor.BlackShadow.cgColor
        layer.shadowRadius = 7.5
        layer.shadowOpacity = 15
    }
    func dropShadowYellow() {
        layer.cornerRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowColor = AppColor.YellowShadow.cgColor
        layer.shadowRadius = 7.5
        layer.shadowOpacity = 15
    }
}
