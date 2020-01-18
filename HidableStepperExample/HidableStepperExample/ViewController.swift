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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.type = .circular
        stepper.delegate = self
    }
}

extension ViewController: HidableStepperDelegate {
    
    func stepperWillHideDecreaseButton() {
        
    }
    
    func stepperWillRevealDecreaseButton() {

    }
}
