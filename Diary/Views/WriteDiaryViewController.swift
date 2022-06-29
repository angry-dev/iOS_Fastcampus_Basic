//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 전혜성 on 2022/06/29.
//

import UIKit

enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectResister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate?
    var diaryEditorMode: DiaryEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.configureEditorMode()
        self.confirmButton.isEnabled = false //등록버튼 비활성화
    }
    
    private func configureEditorMode() {
        switch self.diaryEditorMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
        default:
            break
        }
    }
    
    // contentsTextView 테두리 설정 함수
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/225, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    // Date 타입 -> String 타입 함수
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter.string(from: date)
    }
    
    // datePicker 설정 함수
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.dateTextField.inputView = self.datePicker
    }
    
    private func configureInputField() {
        self.contentsTextView.delegate = self
        // titleTextField에 입력될 때 마다 vaildateInputField() 호출
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
   

    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        
        
        switch self.diaryEditorMode {
        case .new:
            let diary = Diary(title: title,
                              contents: contents,
                              date: date,
                              isStar: false,
                              uuidString: UUID().uuidString)
            
            self.delegate?.didSelectResister(diary: diary)
            
        case let .edit(indexPath, diary):
            let diary = Diary(title: title,
                              contents: contents,
                              date: date,
                              isStar: false,
                              uuidString: diary.uuidString)
            
            NotificationCenter.default.post(name: NSNotification.Name("editDiary"),
                                            object: diary,
                                            userInfo: nil)
        default:
            break
        }
        
        //self.delegate?.didSelectResister(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }
    
    // datePicker 값 설정 함수
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_kr")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date)
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    // 사용자가 화면을 터치할 때 마다 호출되는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // titleTextField, contentsTextView, dateTextField 모두 입력된 상태일때만 confirmButton 활성화
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.contentsTextView.text.isEmpty) && !(dateTextField.text?.isEmpty ?? true)
    }
}


extension WriteDiaryViewController: UITextViewDelegate {
    
    // contentsTextView에 입력 될 때 마다 호출되는 함수
    func textViewDidChange(_ textView: UITextView) {
        // textView에 입력 될 때 마다 validateInputField() 함수 호출
        validateInputField()
    }
}
