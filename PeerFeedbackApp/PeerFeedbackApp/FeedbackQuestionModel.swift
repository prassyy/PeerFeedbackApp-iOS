//
//  FeedbackQuestionModel.swift
//  PeerFeedbackApp
//
//  Created by fordlabs on 05/10/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import Foundation

struct FeedbackQuestionModel {
    var question: String?
    var isChoiceBased: Bool?
    var choices: Dictionary<String, String>?
    var role: String?
    
    func belongsTo(peerRole: String) -> Bool {
        if peerRole == "iOS Developer"
            || peerRole == "Android Developer" {
            return role == "Software Engineer"
        }
        return role == peerRole
    }
}
