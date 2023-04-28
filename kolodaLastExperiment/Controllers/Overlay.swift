//
//  Overlay.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/01/01.
//
import UIKit

class Overlay: ViewController {
    @IBOutlet var overlayImageArea: UIImageView!
    
    var overlayImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func resetOverlay() {
        DispatchQueue.main.async {
            self.overlayImageArea.image = self.overlayImage
        }
    }
}
