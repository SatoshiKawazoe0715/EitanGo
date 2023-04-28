//
//  CertificateView.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/17.
//

import UIKit

class CertificateView: UIView {
    @IBOutlet weak var certificateLabel: UILabel!
    @IBOutlet weak var firstCommentLabel: UILabel!
    @IBOutlet weak var secondCommentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var showRecordButton: UIButton!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            nibInit()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            nibInit()
        }

        private func nibInit() {
            let nib = UINib(nibName: "CertificateView", bundle: nil)
            guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
            self.addSubview(view)
        }
}
