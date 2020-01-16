//
// Created by Charles Prado on 14/01/2020.
// Copyright (c) 2020 Holografix Inc. All rights reserved.
//

import UIKit

protocol HidableStepperDelegate: class {
    func stepperWillHideDecreaseButton()
    func stepperWillRevealDecreaseButton()
}

@IBDesignable open class HidableStepper: UIControl {
    
    weak var delegate: HidableStepperDelegate?
    
    public enum ButtonType {
        case normal
        case allRounded
        case bottomRounded
        case circular
    }
    
    var type: ButtonType = .normal
    
    var quantityOfItems: Int = 0 {
        didSet {
            quantityOfItemsLabel.text = "\(quantityOfItems) \(quantityOfItemsUnityOfMeasure)"
        }
    }
    
    /// Component will be hidden when `quantityOfItems` is equal to this value
    var minimumNumberOfItems: Int = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    lazy var decreaseButton: UIButton = {
        let _button = button(withTitle: "-", withColor: decreaseButtonColor)
        _button.addTarget(self, action: #selector(decrease), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        return _button
    }()
    
    lazy var additionButton: UIButton = {
        let _button = button(withTitle: "+", withColor: additionButtonColor)
        _button.addTarget(self, action: #selector(add), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        return _button
    }()
    
    lazy var spacerView: UIView = {
        let _spacerView: UIView = UIView()
        _spacerView.backgroundColor = stepperBackgroundColor
        return _spacerView
    }()
    
    lazy var quantityOfItemsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = quantityOfItemsUnityOfMeasure
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    @IBInspectable var additionButtonColor: UIColor = UIColor(red:0.64, green:0.79, blue:0.16, alpha:1.0) {
        didSet {
            additionButton.backgroundColor = additionButtonColor
        }
    }
    
    @IBInspectable var decreaseButtonColor: UIColor = UIColor(red:0.64, green:0.79, blue:0.16, alpha:1.0) {
        didSet {
            decreaseButton.backgroundColor = decreaseButtonColor
        }
    }
    
    @IBInspectable var stepperBackgroundColor: UIColor = UIColor(red:0.90, green:0.94, blue:0.78, alpha:1.0) {
        didSet {
            backgroundColor = stepperBackgroundColor
        }
    }
    
    @IBInspectable var quantityOfItemsLabelFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            quantityOfItemsLabel.font = quantityOfItemsLabelFont
        }
    }
    
    @IBInspectable var quantityOfItemsUnityOfMeasure: String = ""
    
    var hiddableView: UIView!
    
    private func sharedInit() {
        clipsToBounds = true
    
        hiddableView = UIView()
        
        spacerView.addSubview(quantityOfItemsLabel)
    
        hiddableView.addSubview(spacerView)
        hiddableView.addSubview(decreaseButton)
        hiddableView.clipsToBounds = false
        
        addSubview(hiddableView)
        addSubview(additionButton)
    }
    
    public override func layoutSubviews() {
        let buttonWidth = frame.height

        decreaseButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonWidth)
        additionButton.frame = CGRect(x: frame.width - buttonWidth, y: 0, width: buttonWidth, height: buttonWidth)
        
        let hidableViewWidth = frame.width - frame.height
        hiddableView.frame = CGRect(x: hidableViewWidth, y: 0, width: hidableViewWidth, height: frame.height)
        spacerView.frame = CGRect(x: frame.height - frame.height / 2, y: 0, width: frame.width - (frame.height * 2) + ((frame.height / 2) * 2), height: frame.height)
        quantityOfItemsLabel.frame.size = CGSize(width: spacerView.frame.size.width * 0.8, height: spacerView.frame.size.height)
        quantityOfItemsLabel.center = CGPoint(x: spacerView.frame.width / 2, y: spacerView.frame.height / 2)
        setupForType()
    }
    
    private func setupForType() {
        switch type {
        case .normal:
            additionButton.layer.cornerRadius = 0
            decreaseButton.layer.cornerRadius = 0
        case .allRounded:
            additionButton.layer.cornerRadius = 8
            decreaseButton.layer.cornerRadius = 8
            layer.cornerRadius = additionButton.layer.cornerRadius
        case .bottomRounded:
            additionButton.layer.cornerRadius = 10
            additionButton.layer.maskedCorners = [.layerMaxXMaxYCorner]
            decreaseButton.layer.cornerRadius = 10
            decreaseButton.layer.maskedCorners = [.layerMinXMaxYCorner]
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .circular:
            let buttonWidth = frame.height
            additionButton.layer.cornerRadius = buttonWidth / 2
            decreaseButton.layer.cornerRadius = buttonWidth / 2
            layer.cornerRadius = buttonWidth / 2
        }
    }
    
    private var isHiddableViewRevealead: Bool = false
    
    @objc func add(_ sender: UIButton) {
        quantityOfItems += 1
        if !isHiddableViewRevealead { revealDecreaseButton() }
    }

    @objc func decrease(_ sender: UIButton) {
        quantityOfItems -= 1
        
        if quantityOfItems == minimumNumberOfItems { hideDecreaseButton() }
    }
    
    private func button(withTitle title: String, withColor buttonColor: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = buttonColor
        button.clipsToBounds = true
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setBackgroundColor(color: UIColor.black.withAlphaComponent(0.15), for: .highlighted)
        return button
    }
    
    var animationDuration: Double {
        return Double(layer.frame.width) / 1000
    }
    
    func revealDecreaseButton() {
        delegate?.stepperWillRevealDecreaseButton()
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: {
                self.hiddableView.layer.position.x -= self.hiddableView.frame.width
        })
        isHiddableViewRevealead = true
    }
    
    func hideDecreaseButton() {
        delegate?.stepperWillHideDecreaseButton()
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: {
                self.hiddableView.layer.position.x += self.hiddableView.frame.width
        })
        isHiddableViewRevealead = false
    }
    
    override open func prepareForInterfaceBuilder() {
        sharedInit()
    }
}
