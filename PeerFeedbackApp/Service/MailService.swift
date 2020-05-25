//
//  MailService.swift
//  PeerFeedbackApp
//
//  Created by fordlabs on 30/10/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import Foundation

protocol MailClient {
    func post(headers: [String: String], body: Data?, urlParams: [URLQueryItem], completion: ((Result<Void, Error>) -> Void))
}

class MailService {
    private let mailClient: MailClient
    
    init(mailClient: MailClient) {
        self.mailClient = mailClient
    }
    
    convenience init() {
        self.init(mailClient: SampleMailClient())
    }
    
    func submitFeedback(responses: Dictionary<Int, String>, for questions: [FeedbackQuestionModel], peer: PeerDetailsModel, completionHandler: (Result<Void, Error>) -> ()) {
        do {
            let feedbackReport = getFeedbackReport(from: questions, responses: responses)
            let data = try JSONEncoder().encode(MailRequestModel(body: feedbackReport))
            mailClient.post(headers: [:], body: data, urlParams: [], completion: completionHandler)
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    private func getFeedbackReport(from questions: [FeedbackQuestionModel], responses: Dictionary<Int, String>) -> String {
        var report = "====Feedback Report====\n"
        for question in questions {
            if let questionString = question.question,
                let questionId = question.id,
                let response = responses[questionId] {
                report.append(contentsOf: "\(questionString): \(response)\n")
            }
        }
        return report
    }
}
