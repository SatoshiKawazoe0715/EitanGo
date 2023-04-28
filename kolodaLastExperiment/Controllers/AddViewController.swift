//
//  File.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/04.
//

import UIKit

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var englishTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
}

