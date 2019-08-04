//
//  MailServiceSpec.swift
//  PeerFeedbackAppTests
//
//  Created by fordlabs on 30/10/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import XCTest

@testable import PeerFeedbackApp

class MailServiceSpec: XCTestCase {
    
    var subject: MailService!
    var testQuestions: [FeedbackQuestionModel] = []
    var testResponses: Dictionary<Int, String>!
    var testPeer: PeerDetailsModel!
    
    override func setUp() {
        subject = MailService()
        testPeer = PeerDetailsModel(role: Role(rawValue: "pokemon"), peerName: "Harshith", emailId: "harshit@yopmail.com")
        testQuestions = [
            FeedbackQuestionModel(id: 0, question: "Test question 1", isChoiceBased: false, choices: [
                "0": "Option 1",
                "1": "Option 2",
                "2": "Option 3",
                "3": "Option 4"], role: Role(rawValue: "avengers")),
            FeedbackQuestionModel(id: 1, question: "Test question 2", isChoiceBased: true, choices: [
                "0": "Option 1",
                "1": "Option 2",
                "2": "Option 3",
                "3": "Option 4"], role: Role(rawValue: "justiceLeague")),
            FeedbackQuestionModel(id: 2, question: "Test question 3", isChoiceBased: false, choices: [:], role: Role(rawValue: "pokemon"))
        ]
        testResponses = Dictionary<Int, String>(dictionaryLiteral: (0, "Option 3"), (1, "Option 2"), (2, "Test response for Test question 3"))
    }
    
    func test_submittingFeedbackResponseShouldCallGmailApi() {
        subject.submitFeedback(responses: testResponses, for: testQuestions, peer: testPeer, completionHandler: {})
    }
}
