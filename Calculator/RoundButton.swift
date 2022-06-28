//
//  RoundButton.swift
//  Calculator
//
//  Created by 전혜성 on 2022/06/28.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable
    var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }

}
