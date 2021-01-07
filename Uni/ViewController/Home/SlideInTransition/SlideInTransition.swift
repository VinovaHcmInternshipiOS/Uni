//
//  SlideInTransition.swift
//  Uni
//
//  Created by nguyen gia huy on 10/11/2020.
//

import Foundation
import UIKit
class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    let dimingView = UIView()
    var closeSlideMenu : (()->Void)?
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        
        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = UIScreen.main.bounds.height
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapCloseMenu(_:)))
        dimingView.addGestureRecognizer(tap)
        
        if isPresenting {
            //add dimingview
            dimingView.backgroundColor = .black
            dimingView.alpha = 0.0
            containerView.addSubview(dimingView)
            dimingView.frame = containerView.bounds
            //Add menu view controller to container
            containerView.addSubview(toViewController.view)
            //Init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        //Animate on screen
        let transform = {
            self.dimingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        //Animate back off screen
        let identity = {
            self.dimingView.alpha = 0.5
            fromViewController.view.transform = .identity
        }
        //Animation of transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }, completion: {(_) in
            transitionContext.completeTransition(!isCancelled)
        })
        
    }
    
    @objc func handleTapCloseMenu(_ sender: UITapGestureRecognizer? = nil) {
        closeSlideMenu?()
    }
    
}
