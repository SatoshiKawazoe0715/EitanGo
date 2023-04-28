//
//  AllWordsListController.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/01/14.
//

import UIKit
import FloatingPanel
import RealmSwift

class AllWordsViewController: UIViewController {
    
    @IBAction func startLearningButtonPressed(_ sender: Any) {
        fpc.move(to: .half, animated: true)
    }
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSetting", sender: self)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        isEditingMode = !isEditingMode
        if isEditingMode == true {
            startLearningButton.setTitle("一番後ろに単語を追加", for: .normal)
            tableView.isEditing = true
        } else {
            startLearningButton.setTitle("学習を開始する", for: .normal)
            tableView.isEditing = false
        }
        tableView.reloadData()
        fpc.move(to: .hidden, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            // (6)
            return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            // (7)
//            let itemToMove = values.remove(at: sourceIndexPath.row)
//            values.insert(itemToMove, at: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            // (8)
            return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            // (9)
            return false
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            let destinationVC = segue.destination as! EditViewController
            destinationVC.wordsData = cardDataAndLogic?.allWordsInTextBook_Data
        }
    }
    
    @IBOutlet weak var startLearningButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var allWordsListView: UIView!
    @IBOutlet var additionalNavigationBar: UINavigationBar!
    
    let defaults = UserDefaults.standard
    let realm = try! Realm()
    var fpc: FloatingPanelController!
    var launchVC: LaunchViewController!
    var cardDataAndLogic: CardDataAndLogic? ///TextSelectingViewから送られてくるデータ.
    var isEditingMode = false

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = cardDataAndLogic?.selectedTextbook?.name
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            outputText.text = inputText.text
            self.view.endEditing(true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "wordCell", bundle: nil), forCellReuseIdentifier: "WordsCell")
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        //以下は FloatingPanel に関するコード
        fpc = FloatingPanelController()
        fpc.delegate = self
        makeInitialInterface()
    }

    
    func makeInitialInterface() {
        ///「スタート」ボタンの外観を設定する.
        startLearningButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        startLearningButton.layer.borderWidth = 1.5
        startLearningButton.layer.cornerRadius = 10
        /// FloatingPannelの外観を設定する.
        launchVC = storyboard?.instantiateViewController(withIdentifier: "launch") as? LaunchViewController
        launchVC.cardDataAndLogic = cardDataAndLogic
        fpc.set(contentViewController: launchVC) // ここで LaunchVC のインスタンスのViewDidLoad が呼ばれる.
        fpc.move(to: .hidden, animated: false)
        //        fpc.track(scrollView: launchVC.scrollView)
        fpc.addPanel(toParent: self)
//        fpc.surfaceView.backgroundColor = UIColor(displayP3Red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        fpc.surfaceView.appearance.cornerRadius = 26.0
        fpc.surfaceView.appearance.shadows = []
        fpc.surfaceView.appearance.borderWidth = 1.0 / traitCollection.displayScale
        fpc.surfaceView.appearance.borderColor = UIColor.black.withAlphaComponent(0.2)
        fpc.surfaceView.appearance.backgroundColor = .white
        fpc.surfaceView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        fpc.surfaceView.layer.shadowColor = UIColor.black.cgColor
        fpc.surfaceView.layer.shadowOpacity = 0.6
        fpc.surfaceView.layer.shadowRadius = 7
    }
    
}


//MARK: - FloatingPanelControllerDelegate

extension AllWordsViewController: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayoutForAllWordsVC()
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        if vc.isAttracting == false {
            let loc = vc.surfaceLocation
            let minY = vc.surfaceLocation(for: .full).y + 6.0
            let maxY = vc.surfaceLocation(for: .tip).y - 6.0
            vc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        }
    }
}


//MARK: - UITableViewDataSource

extension AllWordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardDataAndLogic!.allWordsInTextBook_Data!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isEditingMode == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.wordData = cardDataAndLogic!.allWordsInTextBook_Data![indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WordsCell", for: indexPath) as! WordCell
            cell.wordData = cardDataAndLogic!.allWordsInTextBook_Data![indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.5
        }
}

//MARK: - UISearchBarDelegate

extension AllWordsViewController: UISearchBarDelegate {
    // 編集が開始されたら、キャンセルボタンを有効にする
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.showsCancelButton = true
            return true
        }

        // キャンセルボタンが押されたらキャンセルボタンを無効にしてフォーカスを外す
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
        }
}



