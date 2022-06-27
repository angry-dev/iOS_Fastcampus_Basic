//
//  SeguePresentViewController.swift
//  ScreenTransactionExample
//
//  Created by 전혜성 on 2022/06/27.
//

import UIKit

class SeguePresentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
