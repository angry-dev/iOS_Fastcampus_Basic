//
//  CodePresentViewController.swift
//  ScreenTransactionExample
//
//  Created by 전혜성 on 2022/06/27.
//

import UIKit

class CodePresentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
       
    }
    

    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    

}
