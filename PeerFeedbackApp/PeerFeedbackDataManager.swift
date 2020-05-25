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
    private let mailService: MailService
    
    init(jsonFileManager: JsonFileManager,
         mailService: MailService) {
        self.jsonFileManager = jsonFileManager
        self.mailService = mailService
    }
    
    convenience init() {
        self.init(jsonFileManager: JsonFileManager(),
                  mailService: MailService())
    }
    
    func fetchPeersList(with role: Role) -> [PeerDetailsModel] {
        guard let peersListModel = jsonFileManager.fetchJsonObject(from: "peersList", ofType: PeerListModel.self) else {
            return []
        }
        return peersListModel.list
                .filter { $0.role == role }
    }
    
    func fetchFeedbackQuestions(for role: Role) -> [FeedbackQuestionModel] {
        guard let feedbackQuestionsModel = jsonFileManager.fetchJsonObject(from: "questionsList", ofType: FeedbackQuestionListModel.self) else {
            return []
        }
        return feedbackQuestionsModel.list.filter { $0.role == role }
    }
    
    func sendResponse(for peer: PeerDetailsModel,
                      questions: [FeedbackQuestionModel],
                      responses: Dictionary<Int, String>,
                      completion: (Result<Void, Error>) -> Void) {
        mailService.submitFeedback(responses: responses,
                                   for: questions,
                                   peer: peer, completionHandler: completion)
    }
}
