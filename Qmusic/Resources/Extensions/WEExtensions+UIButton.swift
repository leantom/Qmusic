//
//  WEExtensions+UIButton.swift
//  FEMobile
//
//  Created by MrDatto on 4/16/21.
//

import Foundation
import UIKit

extension UIButton{
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                      else { return }
                DispatchQueue.main.async() { [weak self] in
                    let resizedImage = image.imageResized(to: CGSize(width: 15, height: 15))
                    self?.setImage(resizedImage, for: .normal)
                }
            }.resume()
        }
        func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
    func adjustImageAndTitleOffsetsForButton() {
        
        let spacing: CGFloat = 6.0
        
        let imageSize = self.imageView!.frame.size
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        
        let titleSize = self.titleLabel!.frame.size
        
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
    
    func centerVertically(padding: CGFloat = 8.0) {
           guard
               let imageViewSize = self.imageView?.frame.size,
               let titleLabelSize = self.titleLabel?.frame.size else {
               return
           }
           
           let totalHeight = imageViewSize.height + titleLabelSize.height + padding
           
           self.imageEdgeInsets = UIEdgeInsets(
               top: -35,
               left: 0.0,
               bottom: 0.0,
               right: -titleLabelSize.width
           )
        
           self.titleEdgeInsets = UIEdgeInsets(
               top: (totalHeight - imageViewSize.height) + 30,
               left: -imageViewSize.width,
               bottom: 0,
               right: 0.0
           )
        self.contentHorizontalAlignment = .center
           self.contentEdgeInsets = UIEdgeInsets(
               top: 0.0,
               left: 0.0,
               bottom: 0,
               right: 0.0
           )
       }
    
    func centerVerticallyHome(padding: CGFloat = 8.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
                return
            }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -40,
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: (totalHeight - imageViewSize.height - padding),
            left: -imageViewSize.width,
            bottom: 0,
            right: 0.0
        )
        
        self.contentHorizontalAlignment = .center
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: 0,
            right: 0.0
        )
    }
    
    
    func alignVertical(spacing: CGFloat = 8.0) {
        guard let imageSize = imageView?.image?.size,
          let text = titleLabel?.text,
          let font = titleLabel?.font
        else { return }

        titleEdgeInsets = UIEdgeInsets(
          top: 0.0,
          left: -imageSize.width,
          bottom: -(imageSize.height + spacing),
          right: 0.0
        )

        let titleSize = text.size(withAttributes: [.font: font])
        imageEdgeInsets = UIEdgeInsets(
          top: -(titleSize.height + spacing),
          left: 0.0,
          bottom: 0.0,
          right: -titleSize.width
        )

        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        contentEdgeInsets = UIEdgeInsets(
          top: edgeOffset,
          left: 0.0,
          bottom: edgeOffset,
          right: 0.0
        )
      }

}
@IBDesignable class GradientButton: UIButton {
    
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
   
    @IBInspectable var startPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 0.5{
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
        
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
        
    }
    
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey:"animateGradient")
    }
}
