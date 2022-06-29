//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 전혜성 on 2022/06/29.
//

import UIKit

//protocol DiaryDetailDelegate:AnyObject {
//    func didSelectDelete(indexPath: IndexPath)
//    func didSelectStar(indexPath: IndexPath, isStar: Bool)
//}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    var starButton: UIBarButtonItem?
    
    var diary: Diary?
    var indexPath: IndexPath?
    //weak var delegate: DiaryDetailDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(starDiaryNotification(_:)),
                                               name: NSNotification.Name("starDiary"),
                                               object: nil)
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String : Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = self.diary else { return }
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            self.configureView()
        }
    }
    
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = dateToString(date: diary.date)
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    
    // Date 타입 -> String 타입 함수
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter.string(from: date)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditorMode = .edit(indexPath, diary)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        //guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        self.configureView()
    }
    
    @objc func tapStarButton() {
        guard let isStar = self.diary?.isStar else { return }
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar = !isStar
        
        //guard let indexPath = self.indexPath else { return }
        //self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
        
        NotificationCenter.default.post(name: NSNotification.Name("starDiary"),
                                        object: [
                                            "diary" : self.diary,
                                            "isStar" : self.diary?.isStar ?? false,
                                            "uuidString": diary?.uuidString
                                        ],
                                        userInfo: nil)

    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let uuidString = self.diary?.uuidString else { return }
        //self.delegate?.didSelectDelete(indexPath: indexPath)
        
        NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"),
                                        object: uuidString,
                                        userInfo: nil)
        
        self.navigationController?.popViewController(animated: true)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
