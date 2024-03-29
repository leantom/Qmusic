//
//  WEExtensions+UISlider.swift
//  FEMobile
//
//  Created by MrDatto on 12/08/2021.
//

import UIKit

extension UISlider {
    func addGradientMinTrack(image: UIImage) {
        superview?.layoutIfNeeded()
        setMinimumTrackImage(image, for: .normal)
    }
    
    func addGradientMaxTrack(image: UIImage) {
        superview?.layoutIfNeeded()
        setMaximumTrackImage(image, for: .normal)
    }
    
    
}

open class CustomSlider : UISlider {
    @IBInspectable open var trackWidth:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }

    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}
