//
//  FloatingPanel.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/05.
//

import UIKit
import FloatingPanel

/// anchorsプロパティでFloatingPanelがどれくらい移動するかを指定する。例えば、.full: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.size.height * 0.25 / 1, edge: .top, referenceGuide: .safeArea) の height * の後ろの数値
///LaunchViewControllerでつかうFloatingPanelの位置を決定する.  FloatingPanelControllerDelegate の func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout の返り値に使う.
///
class FloatingPanelStocksLayoutForAllWordsVC: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    //以下の変数anchorsを用いてfloatingPanelが作られる
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.size.height * 0.64 / 1, edge: .bottom, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.size.height *  0.317 / 1, edge: .bottom, referenceGuide: .safeArea),
             /* Visible + ToolView */
        .tip: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.size.height *  0 / 7.5, edge: .bottom, referenceGuide: .superview),
        ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.0
    }
}


class FloatingPanelStocksLayoutForEditVC: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    //以下の変数anchorsを用いてfloatingPanelが作られる
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 200, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.size.height *  0 / 1, edge: .bottom, referenceGuide: .superview),
             /* Visible + ToolView */
        .tip: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.size.height *  0 / 7.5, edge: .bottom, referenceGuide: .superview),
        ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.0
    }
}

