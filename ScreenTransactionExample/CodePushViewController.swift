//
//  CodePushViewController.swift
//  ScreenTransactionExample
//
//  Created by 전혜성 on 2022/06/27.
//

import UIKit

protocol SendDataDelegate: AnyObject {
    func sendData(name: String)
}

class CodePushViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    weak var delegate: SendDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
       
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.delegate?.sendData(name: "Apple")
        self.navigationController?.popViewController(animated: true)
    }
    
}
