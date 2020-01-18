//
//  UIButton+Extension.swift
//  HidableStepper
//
//  Created by Charles Prado on 16/01/20.
//  Copyright © 2020 Holografix Inc. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor, for state: UIControl.State) {
        let image = UIImage(color: color)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let stretchable = image!.resizableImage(withCapInsets: insets, resizingMode: .tile)
        self.setBackgroundImage(stretchable, for: state)
    }
}
