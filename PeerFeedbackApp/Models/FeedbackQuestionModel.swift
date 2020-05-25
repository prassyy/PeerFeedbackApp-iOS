//
//  FeedbackQuestionModel.swift
//  PeerFeedbackApp
//
//  Created by fordlabs on 05/10/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import Foundation

struct FeedbackQuestionModel: Decodable, Equatable {
    var id: Int?
    var question: String?
    var isChoiceBased: Bool?
    var choices: [String: String]?
    var role: Role?
}
