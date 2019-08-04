//
//  PeerListManager.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 04/08/19.
//  Copyright © 2019 prassi. All rights reserved.
//

import Foundation

class PeerFeedbackDataManager {
    private let jsonFileManager: JsonFileManager
    
    init(jsonFileManager: JsonFileManager) {
        self.jsonFileManager = jsonFileManager
    }
    
    convenience init() {
        self.init(jsonFileManager: JsonFileManager())
    }
    
    func fetchPeersList(with role: Role) -> [PeerDetailsModel] {
        guard let peersListModel = jsonFileManager.fetchJsonObject(from: "peersList", ofType: PeerListModel.self) else {
            return []
        }
        return peersListModel.list.filter { $0.role == role }
    }
    
    func fetchFeedbackQuestions(for role: Role) -> [FeedbackQuestionModel] {
        guard let feedbackQuestionsModel = jsonFileManager.fetchJsonObject(from: "questionsList", ofType: FeedbackQuestionListModel.self) else {
            return []
        }
        return feedbackQuestionsModel.list.filter { $0.role == role }
    }
}
