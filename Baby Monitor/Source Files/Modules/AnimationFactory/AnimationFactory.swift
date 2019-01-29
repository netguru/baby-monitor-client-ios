//
//  AnimationFactory.swift
//  Baby Monitor
//

import UIKit

final class AnimationFactory: NSObject {
    
    static var shared = AnimationFactory()
    
    private override init() {
        super.init()
    }
    
    func firePulse(onView view: UIView, fromColor from: UIColor, toColor to: UIColor, radius: CGFloat = 4) {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.fillColor = from.cgColor
        let point = view.bounds.origin
        let frame = view.frame
        pulsatingLayer.position =  CGPoint(
            x: point.x + (frame.width / 2),
            y: point.y + (frame.height / 2)
        )
        view.layer.addSublayer(pulsatingLayer)
        let scaleAnimation = CALayerBasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 4
        let colorAnimation = CALayerBasicAnimation(keyPath: "fillColor")
        colorAnimation.toValue = to.cgColor
        [scaleAnimation, colorAnimation].forEach {
            $0.duration = 2
            $0.delegate = self
            $0.layer = pulsatingLayer
            pulsatingLayer.add($0, forKey: nil)
        }
    }
}
extension AnimationFactory: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let layerAnimation = anim as? CALayerBasicAnimation else {
            return
        }
        layerAnimation.layer?.removeFromSuperlayer()
    }
}
