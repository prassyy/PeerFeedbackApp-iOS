//
//  FooterView.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 28/10/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    @IBOutlet weak public var footerButton: UIButton!
    
    public func setButtonEnabled(isEnabled: Bool) {
        footerButton.isEnabled = isEnabled
        footerButton.backgroundColor = isEnabled
            ? UIColor(red: 0, green: 0.5, blue: 1, alpha: 1) : .gray
    }
}
