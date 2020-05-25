//
//  UIView+Spec.swift
//  PeerFeedbackAppTests
//
//  Created by Prassyy on 23/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

extension UIView {
    
    func getViewsOfType<T>(_ type: T.Type) -> [T] {
        return self.subviews
            .filter{ ($0 as? T) != nil } as! [T]
    }
    
    func getFirstSubViewOfType<T>(_ type: T.Type) -> T? {
        guard self.subviews.count > 0 else { return nil }
        let subViewsOfType = self.getViewsOfType(type)
        if subViewsOfType.count > 0 {
            return subViewsOfType.first
        }
        
        for subView in self.subviews {
            if let subViewOfType = subView.getFirstSubViewOfType(type) {
                return subViewOfType
            }
        }
        return nil
    }
}
