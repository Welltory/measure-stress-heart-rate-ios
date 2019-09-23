import UIKit

@IBDesignable
class GButton: UIButton {
    
    // MARK: - IBInspectable properties
    /// Renders vertical gradient if true else horizontal
    @IBInspectable public var verticalGradient: Bool = true {
        didSet {
            updateUI()
        }
    }
    
    /// Start color of the gradient
    @IBInspectable public var startColor: UIColor = .clear {
        didSet {
            updateUI()
        }
    }
    
    /// End color of the gradient
    @IBInspectable public var endColor: UIColor = .clear {
        didSet {
            updateUI()
        }
    }
    
    /// Border color of the view
    @IBInspectable public var borderColor: UIColor? = nil {
        didSet {
            updateUI()
        }
    }
    
    /// Border width of the view
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Variables
    
    /// Closure is called on click event of the button
    public var onClick = { () }
    
    private var gradientlayer = CAGradientLayer()
    
    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        gradientlayer = CAGradientLayer()
        updateUI()
        layer.addSublayer(gradientlayer)
    }
    
    // MARK: - Update frame
    private func updateFrame() {
        gradientlayer.frame = bounds
    }
    
    // MARK: - Update UI
    private func updateUI() {
        addTarget(self, action: #selector(clickAction(button:)), for: .touchUpInside)
        gradientlayer.colors = [startColor.cgColor, endColor.cgColor]
        if verticalGradient {
            gradientlayer.startPoint = CGPoint(x: 0, y: 0)
            gradientlayer.endPoint = CGPoint(x: 0, y: 1)
        } else {
            gradientlayer.startPoint = CGPoint(x: 0, y: 0)
            gradientlayer.endPoint = CGPoint(x: 1, y: 0)
        }
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor ?? tintColor.cgColor
        updateFrame()
    }
    
    // MARK: - On Click
    @objc private func clickAction(button: UIButton) {
        onClick()
    }
    
}
