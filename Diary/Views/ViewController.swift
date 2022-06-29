//
//  ViewController.swift
//  Diary
//
//  Created by 전혜성 on 2022/06/29.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {
            self.saveDairyList()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        self.loadDiaryList()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(starDiaryNotification(_:)),
                                               name: NSNotification.Name("starDiary"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteDiaryNotification(_:)),
                                               name: NSNotification.Name("deleteDiary"),
                                               object: nil)
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let uuidString = notification.object as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString
        }) else { return }
        self.diaryList.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
        self.diaryList[indexPath.row].isStar = isStar
    
    }
    
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String : Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = starDiary["diary"] as? Diary else { return }
        if isStar {
            self.diaryList.append(diary)
            self.diaryList = self.diaryList.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            self.collectionView.reloadData()
        } else {
            guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString
            }) else { return }
            self.diaryList.remove(at: index)
            self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
        
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString
        }) else { return }
        self.diaryList[index] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
        
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
    
    private func saveDairyList() {
        let data = self.diaryList.map {
            [
                "title" : $0.title,
                "contents" : $0.contents,
                "date" : $0.date,
                "isStar" : $0.isStar,
                "uuidString" : $0.uuidString
            ]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "DiaryList")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "DiaryList") as? [[String : Any]] else { return }
        self.diaryList = data.compactMap{
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            guard let uuidString = $0["uuidString"] as? String else { return nil}

            return Diary(title: title, contents: contents, date: date, isStar: isStar, uuidString: uuidString)
        }
        
        // 최신날짜로 정렬
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    // Date 타입 -> String 타입 함수
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter.string(from: date)
    }
}

extension ViewController: WriteDiaryViewDelegate {
    func didSelectResister(diary: Diary) {
        self.diaryList.append(diary)
        self.collectionView.reloadData()
        
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        //viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//extension ViewController: DiaryDetailDelegate {
//    func didSelectDelete(indexPath: IndexPath) {
//        self.diaryList.remove(at: indexPath.row)
//        self.collectionView.deleteItems(at: [indexPath])
//    }
//    
//    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
//        self.diaryList[indexPath.row].isStar = isStar
//    }
//}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 20, height: 200)
    }
}
