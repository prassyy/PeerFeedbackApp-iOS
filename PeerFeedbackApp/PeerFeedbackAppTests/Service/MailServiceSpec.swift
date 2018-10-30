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
        testPeer = PeerDetailsModel(role: "Android Developer", peerName: "Harshith", emailId: "harshit@yopmail.com")
        testQuestions = [
            FeedbackQuestionModel(id: 0, question: "Test question 1", isChoiceBased: false, choices: Dictionary(dictionaryLiteral:("0", "Option 1"),
                                                                                                         ("1", "Option 2"),
                                                                                                         ("2", "Option 3"),
                                                                                                         ("3", "Option 4")), role: "Software Engineer"),
            FeedbackQuestionModel(id: 1, question: "Test question 2", isChoiceBased: true, choices: Dictionary(dictionaryLiteral:("0", "Option 1"),
                                                                                                        ("1", "Option 2"),
                                                                                                        ("2", "Option 3"),
                                                                                                        ("3", "Option 4")), role: "Software Engineer"),
            FeedbackQuestionModel(id: 2, question: "Test question 3", isChoiceBased: false, choices: Dictionary(), role: "Software Engineer")
        ]
        testResponses = Dictionary<Int, String>(dictionaryLiteral: (0, "Option 3"), (1, "Option 2"), (2, "Test response for Test question 3"))
    }
    
    func test_submittingFeedbackResponse() {
        subject.submitFeedback(responses: testResponses, for: testQuestions, peer: testPeer, completionHandler: {})
    }
}
