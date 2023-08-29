//
//  CymeButton.swift
//  Qmusic
//
//  Created by QuangHo on 29/08/2023.
//

import UIKit
protocol CymeButtonDelegate: AnyObject {
    func actionSelect(btn: UIButton)
}
class CymeButton: UIView {
    weak var delegate: CymeButtonDelegate?
    
    @IBOutlet weak var btnAction: UIButton!
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    @IBAction func action(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            
            self.btnAction.alpha = 0
        }
        var frame = btnAction.frame
        frame.size.width = 44
        
        self.addLoadingLotties(frame: frame, name: "loading")
        if let delegate = self.delegate {
            delegate.actionSelect(btn: sender as! UIButton)
        }
        
    }
    // MARK: resetUI
    func resetUI() {
        self.btnAction.alpha = 1
        self.removeLotties()
    }

}
