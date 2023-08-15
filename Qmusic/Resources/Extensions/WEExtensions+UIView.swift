//
//  WEExtensions+UIView.swift
//  facepay_v3
//
//  Created by LV on 10/13/20.
//

import Foundation
import UIKit

extension NSObject {
    func copyObject<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
extension UIView {
    
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    /// Load UIView from Nib
    /// - Parameter autolayout: Flag set translatesAutoresizingMaskIntoConstraints = !autoLayout
    /// - Returns: UIView
    static func instantiate(autolayout: Bool = true) -> Self {
        // generic helper function
        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
            let view = self.nib.instantiate() as! T
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return view
        }
        return instantiateUsingNib(autolayout: autolayout)
    }
    
    /// load UIView from Nib
    /// - Returns: UIView
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

	/// attaches the top of the current view to the given view's top if it's a superview of the current view, or to it's bottom if it's not (assuming this is then a sibling view).
	/// if view is not provided, the current view's super view is used
	@discardableResult
	func layoutAttachTop(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {
		let view: UIView? = to ?? superview
		let isSuperview = view == superview
		let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: isSuperview ? .top : .bottom, multiplier: 1.0, constant: margin)
		superview?.addConstraint(constraint)

		return constraint
	}

	/// attaches the bottom of the current view to the given view
	@discardableResult
	func layoutAttachBottom(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
		let view: UIView? = to ?? superview
		let isSuperview = (view == superview) || false
		let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: isSuperview ? .bottom : .top, multiplier: 1.0, constant: -margin)
		if let priority = priority {
			constraint.priority = priority
		}
		superview?.addConstraint(constraint)

		return constraint
	}

	/// attaches the leading edge of the current view to the given view
	@discardableResult
	func layoutAttachLeading(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {
		let view: UIView? = to ?? superview
		let isSuperview = (view == superview) || false
		let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: isSuperview ? .leading : .trailing, multiplier: 1.0, constant: margin)
		superview?.addConstraint(constraint)

		return constraint
	}

	/// attaches the trailing edge of the current view to the given view
	@discardableResult
	func layoutAttachTrailing(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
		let view: UIView? = to ?? superview
		let isSuperview = (view == superview) || false
		let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: isSuperview ? .trailing : .leading, multiplier: 1.0, constant: -margin)
		if let priority = priority {
			constraint.priority = priority
		}
		superview?.addConstraint(constraint)

		return constraint
	}

	/// attaches all sides of the receiver to its parent view
	func layoutAttachAll(margin: CGFloat = 0.0) {
		let view = superview
		layoutAttachTop(to: view, margin: margin)
		layoutAttachBottom(to: view, margin: margin)
		layoutAttachLeading(to: view, margin: margin)
		layoutAttachTrailing(to: view, margin: margin)
	}
    
    func layoutAttachByTopMargin(margin: CGFloat = 0.0) {
        let view = superview
        layoutAttachTop(to: view, margin: ConstantsUI.heightScreen - self.frame.height)
        layoutAttachBottom(to: view, margin: margin)
        layoutAttachLeading(to: view, margin: margin)
        layoutAttachTrailing(to: view, margin: margin)
    }

	@discardableResult
	func fromNib<T: UIView>() -> T? {
		guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
			return nil
		}
		addSubview(contentView)
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.layoutAttachAll()
		return contentView
	}
    
    /// Apply shadow to UIView
    /// - Parameters:
    ///   - color: Color shadow
    ///   - alpha: Alpha shadow
    ///   - x: x position shadow
    ///   - y: y position shadow
    ///   - blur: blur value shadow
    ///   - spread: spread value shadow
    func applyShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat, cornerRadius: CGFloat? = nil) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            if cornerRadius == nil {
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            } else {
                layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius!).cgPath
            }
            
        }
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIView {
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
    
    // different inner shadow styles
    
    func addGradient(colors: [UIColor] = [.blue, .white], locations: [NSNumber] = [0, 2], startPoint: CGPoint = CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0), type: CAGradientLayerType = .axial, cornerRadius: CGFloat = 0){
        
        let gradient = CAGradientLayer()
        
        gradient.frame.size = self.frame.size
        gradient.frame.origin = CGPoint(x: 0.0, y: 0.0)
        
        // Iterates through the colors array and casts the individual elements to cgColor
        // Alternatively, one could use a CGColor Array in the first place or do this cast in a for-loop
        gradient.colors = colors.map{ $0.cgColor }
        gradient.cornerRadius = cornerRadius
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        // Insert the new layer at the bottom-most position
        // This way we won't cover any other elements
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    public enum innerShadowSide
    {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    
    func addBorder(with color: UIColor, width: CGFloat = 0.3){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
    
    func addBorder(with color: UIColor =  UIColor.clear, width: CGFloat = 0.3, radius: CGFloat, backgroundColor: UIColor){
        self.layer.borderWidth = width
        self.layer.cornerRadius =  radius
        self.layer.borderColor = color.cgColor
        self.backgroundColor = backgroundColor
        self.clipsToBounds = true
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
    
    @IBInspectable
    var cornerRadius_: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var roundTop: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
        }
    }
    
    @IBInspectable
    var roundBottom: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
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
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor_: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func roundCorners(rect: CGRect,
                      corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        self.translatesAutoresizingMaskIntoConstraints = true
        layer.position = position
        layer.anchorPoint = point
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView {
    func addGradient(colors: [UIColor] = [.blue, .white], locations: [NSNumber] = [0, 2], startPoint: CGPoint = CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0), type: CAGradientLayerType = .axial){
        
        let gradient = CAGradientLayer()
        
        gradient.frame.size = self.frame.size
        gradient.frame.origin = CGPoint(x: 0.0, y: 0.0)
        
        // Iterates through the colors array and casts the individual elements to cgColor
        // Alternatively, one could use a CGColor Array in the first place or do this cast in a for-loop
        gradient.colors = colors.map{ $0.cgColor }
        
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        // Insert the new layer at the bottom-most position
        // This way we won't cover any other elements
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil, cornerRadius: nil)
    }
    
    func applyGradient(colours: [UIColor], cornerRadius: CGFloat) -> Void {
        self.applyGradient(colours: colours, locations: nil, cornerRadius: cornerRadius)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, cornerRadius: CGFloat?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        if let corner = cornerRadius {
            gradient.cornerRadius = corner
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradientLeftRight(colours: [UIColor], cornerRadius: CGFloat) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = .init(x: 1, y: 0)
        gradient.endPoint = .init(x: 0, y: 1)
        gradient.cornerRadius = cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
        //        self.layer.addSublayer(gradient)
    }
    
    func removeGradient() {
        if let sublayers = self.layer.sublayers {
            if let layer = sublayers.filter({$0 is CAGradientLayer}).first {
                layer.removeFromSuperlayer()
            }
        }
    }
    
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(blurEffectView, at: 0)
        blurEffectView.layoutAttachAll()
    }
    
}

extension UIView {
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}

extension UIView {
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
    }
    
    func removeAllGesture() {
        if let recognizers = self.gestureRecognizers {
            for recognizer in recognizers {
                self.removeGestureRecognizer(recognizer )
            }
        }
    }
    
    
    func applyShadow(color: UIColor = AppColors.kBlack!) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: -10, height: -10)
        self.layer.shadowRadius = 10
    }
    
    func applyShadowBottom(color: UIColor = AppColors.kBlack!) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowRadius = 10
    }

	/// Created a shadow layer then add to the view itself,
	/// - Returns: The layer
	func createAndAddShadowLayer(background: UIColor = AppColors.kBlack!,
								 shadowRadius: CGFloat = 8,
								 shadowColor: UIColor = UIColor(white: 0, alpha: 0.1),
								 cornerRadius: CGFloat = 5,
								 shadowWid: CGFloat,
								 shadowHei: CGFloat) -> CAShapeLayer {
		let shadowLayer = CAShapeLayer()
		shadowLayer.fillColor = background.cgColor
		shadowLayer.shadowColor = shadowColor.cgColor
		shadowLayer.shadowOffset = CGSize(width: shadowWid, height: shadowHei)
		shadowLayer.shadowOpacity = 1
		shadowLayer.shadowRadius = shadowRadius
		shadowLayer.cornerRadius = cornerRadius
		shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
		shadowLayer.shadowPath = shadowLayer.path
		self.layer.insertSublayer(shadowLayer, at: 0)

		return shadowLayer
	}
    
    func addSubViewFullConstraint(sub: UIView){
        self.addSubview(sub)
        NSLayoutConstraint.activate([
            sub.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            sub.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            sub.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            sub.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        self.layoutIfNeeded()
    }
    // MARK:  apply for uiview is FULL Screen
    func showAnimationFromBottom() {
        self.frame.origin.y = ConstantsUI.heightScreen
        self.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut]) {
            self.frame.origin.y = 0
        }
    }
    // MARK:  apply for uiview is FULL Screen
    
    func hideAnimationFromBottom() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
            self.frame.origin.y = ConstantsUI.heightScreen
        }, completion: { finished in
            self.alpha = 0
        })
    }
    
    func drawDottedLine() {
        let start = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
        let end = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the  .

        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    func snapshot() -> UIImage? {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UIScrollView {
    
    func snapshotContent() -> UIImage? {
        UIGraphicsBeginImageContext(self.contentSize)

        let savedContentOffset = self.contentOffset
        let savedFrame = self.frame

        self.contentOffset = CGPoint.zero
        self.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)

        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        self.contentOffset = savedContentOffset
        self.frame = savedFrame

        UIGraphicsEndImageContext()

        return image
    }
    
    func captureScreen() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let offset = self.contentOffset
        let thisContext = UIGraphicsGetCurrentContext()
        thisContext?.translateBy(x: -offset.x, y: -offset.y)
        self.layer.render(in: thisContext!)
        let visibleScrollViewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return visibleScrollViewImage
    }
    
    
}
