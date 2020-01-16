//
//  ViewController.swift
//  HidableStepper
//
//  Created by Charles Prado on 14/01/2020.
//  Copyright © 2020 Holografix Inc. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var stepper: HidableStepper!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.type = .circular
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}

extension ViewController: HidableStepperDelegate {
    
    func stepperWillHideDecreaseButton() {
        button.isHidden = false
    }
    
    func stepperWillRevealDecreaseButton() {
        button.isHidden = true
    }
}
