//
//  TextSelectingViewContrller.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/02/21.
//

import UIKit
import RealmSwift

class TextSelectingViewController: UIViewController, UICollectionViewDelegate {
    
    lazy var realm = try! Realm()
    var textbook : Results<Textbook>?
    var wordsDataInRealm : Results<WordData>?
    let defaults = UserDefaults.standard
    var cardDataAndLogic = CardDataAndLogic()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textbook = realm.objects(Textbook.self) //Realmからtextオブジェクトを読み込んで textプロパティに格納.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        navigationController?.title = "EitangoMax!"
        
        // レイアウト設定
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 30, bottom: 24, right: 30)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 35
        collectionView.collectionViewLayout = layout
        
        // 次の画面のBackボタンを"戻る"に変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:  "戻る", style:  .plain, target: nil, action: nil)
    }
}

//MARK: - UICollectionViewDataSource

extension TextSelectingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return textbook?.count ?? 5
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // 横方向のサイズを調整
            let cellSizeWidth:CGFloat = self.view.frame.width/2.7
            return CGSize(width: cellSizeWidth, height: cellSizeWidth*1.5)
        }
    //セルの情報
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.textNameLabel.text = textbook![indexPath.row].name
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.6
            cell.layer.shadowRadius = 4
            
            return cell
        }
    
    //セル選択時の処理
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            cardDataAndLogic.selectedTextbook = textbook?[indexPath.row]
            performSegue(withIdentifier: "goToAllWordsViewController", sender: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAllWordsViewController" {
            let destinationVC = segue.destination as! AllWordsViewController
            destinationVC.cardDataAndLogic = cardDataAndLogic
        }
    }
  
}



