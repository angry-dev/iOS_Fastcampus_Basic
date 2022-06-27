//
//  ViewController.swift
//  AutoLayoutExample
//
//  Created by 전혜성 on 2022/06/27.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapColorChangeButton(_ sender: UIButton) {
        self.colorView.backgroundColor = UIColor.blue
        print("tap ColorChangeButton")
    }
    
}

