//
//  ViewController.swift
//  Calculator
//
//  Created by 전혜성 on 2022/06/28.
//

import UIKit

enum Operation {
    case Plus
    case Minus
    case Divide
    case Multiply
    case unknown
}

class ViewController: UIViewController {

    @IBOutlet weak var numberOutputLabel: UILabel!
    
    var displayNumber = "" // numberOutput에 표시될 숫자
    var firstOperand = "" // 이전계산 값을 저장하는 프로퍼티 (첫번째 피연산자)
    var secondOperand = "" // 새롭게 입력된 값을 저장하는 프로퍼티 (두번째 피연산자)
    var result = "" // 계산의 결과 값
    var currentOperation: Operation = .unknown // 연산자의 값을 저장하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func tapNumberButton(_ sender: UIButton) {
        guard let numberValue = sender.title(for: .normal) else { return }
        if self.displayNumber.count < 9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
    }
    
    
    @IBAction func tapDotButton(_ sender: UIButton) {
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    
    @IBAction func tapMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    
    
    @IBAction func tapMinusButton(_ sender: UIButton) {
        self.operation(.Minus)
    }
    
    
    @IBAction func tapPlusButton(_ sender: UIButton) {
        self.operation(.Plus)
    }
    
    
    @IBAction func tapEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    
    func operation(_ operation: Operation) {
        if self.currentOperation != .unknown {
            if !self.displayNumber.isEmpty {
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOperand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(self.secondOperand) else { return }
                
                switch self.currentOperation {
                case .Plus:
                    self.result = "\(firstOperand + secondOperand)"
                case .Minus:
                    self.result = "\(firstOperand - secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                default:
                    break
                }
                
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            
            self.currentOperation = operation
        } else {
            self.firstOperand = self.displayNumber
            self.currentOperation = operation
            self.displayNumber = ""
        }
    }
}

