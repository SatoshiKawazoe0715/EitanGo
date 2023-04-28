//
//  OverlayoutPopUpViewController.swift
//  PopUpExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/24.
//

import UIKit

class OverlayoutPopUpViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var defaultLevelInstructionLabel: UILabel!
    @IBOutlet weak var maxReturnCardsQuantityInstructionLabel: UILabel!
    @IBOutlet weak var LevelInstructionLabel: UILabel!
    @IBOutlet weak var usualCardQuantityInstructionLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    init() {
        super.init(nibName: "OverlayoutPopUpViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        closeButton.layer.cornerRadius = 10
    }
    
    func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 20
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }

    @IBAction func contentViewButtonPressed(_ sender: Any) {
        hide()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
