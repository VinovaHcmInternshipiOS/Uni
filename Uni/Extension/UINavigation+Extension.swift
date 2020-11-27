//
//  UINavigation+Extension.swift
//  Uni
//
//  Created by nguyen gia huy on 27/11/2020.
//
import Foundation
import UIKit
enum NavigationBarMode {
    case normal
    case clear
}

extension UINavigationController {

    func themeNavigationBar(mode: NavigationBarMode) {
        self.navigationBar.isTranslucent = true
        switch mode {
        case .normal:
            let image = UIImage.fromColor(.white)
            navigationBar.setBackgroundImage(image, for: .default)
            navigationBar.isTranslucent = false
            navigationBar.shadowImage = UIImage.fromColor(.white)
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)]
        case .clear:
            let image = UIImage()
            navigationBar.setBackgroundImage(image, for: .default)
            navigationBar.shadowImage = image
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)]
        }
    }
    func showNavigation(bottomLine: Bool = true) {
      self.navigationController?.navigationBar.isHidden = false
      self.navigationController?.navigationBar.barTintColor = UIColor.white
      if bottomLine {
       self.navigationController?.showShadowLine(color: AppColor.YellowFAB32A)
      } else {
        self.navigationController?.hideShadowLine()
      }
    }
}

extension UIImage {
    static func fromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
