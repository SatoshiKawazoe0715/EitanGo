//
//  EditViewController.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/04.
//

import UIKit
import RealmSwift
import FloatingPanel

class EditViewController: UIViewController {
    
    @IBAction func addLastWordButtonPressed(_ sender: Any) {
        fpc.move(to: .full, animated: true)
    }
    
    @IBOutlet weak var editTableView: UITableView!
    var fpc : FloatingPanelController!
    var launchVC : AddViewController!
    var wordsData: Results<WordData>?
    var numberOfRows = 5

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //以下は FloatingPanel に関するコード
        fpc = FloatingPanelController()
        fpc.delegate = self
    }
    
    
    func makeFloatingPannel() {
        fpc.surfaceView.grabberHandle.isHidden = true
        launchVC = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController
        // Set a content view controller
        fpc.set(contentViewController: launchVC)
        //        fpc.track(scrollView: launchVC.scrollView)
        fpc.addPanel(toParent: self)
        fpc.surfaceView.backgroundColor = UIColor(displayP3Red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        fpc.surfaceView.appearance.cornerRadius = 20
        fpc.surfaceView.appearance.shadows = []
        fpc.surfaceView.appearance.borderWidth = 1.5 / traitCollection.displayScale
        fpc.surfaceView.appearance.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        fpc.move(to: .hidden, animated: true)
    }
    
}


//MARK: - FloatingPanelControllerDelegate

extension EditViewController: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayoutForEditVC()
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

//MARK: - TableViewDataSource

extension EditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewCell()
        return cell
    }
    
}

//MARK: - TableViewDelegate

extension EditViewController: UITableViewDelegate {
    
}



