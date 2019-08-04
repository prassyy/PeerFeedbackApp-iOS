//
//  UINib+Extension.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 04/08/19.
//  Copyright © 2019 prassi. All rights reserved.
//

import UIKit

extension UINib {
    public func toView<T: UIView>(owner: Any?) -> T? {
        return self.instantiate(withOwner: owner, options: nil).first as? T
    }
}
