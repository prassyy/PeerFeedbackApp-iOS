//
//  PListDataManager.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 24/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import Foundation

class PListDataManager {

    private let bundle: Bundle

    init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    convenience init() {
        self.init(bundle: Bundle.main)
    }

    func fetchPeerNameList(for role: String) -> [PeerDetailsModel] {
        if let path = bundle.path(forResource: "peerNames", ofType: "plist"),
           let dictArray = NSArray(contentsOfFile: path) {
            return dictArray.compactMap {
                if let dict = $0 as? NSDictionary,
                    let peerRole = dict["Role"] as? String,
                    let name = dict["Name"] as? String,
                    let email = dict["Email"] as? String,
                    peerRole == role {
                        return PeerDetailsModel(role: role, peerName: name, emailId: email)
                }
                return nil
            }
        }
        return []
    }
}
