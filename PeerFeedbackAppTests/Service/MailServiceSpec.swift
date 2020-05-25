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
    var mailClient: FakeMailClient!
    
    override func setUp() {
        mailClient = FakeMailClient()
        subject = MailService(mailClient: mailClient)
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
    
    func test_submittingFeedbackResponseShouldCallMailClient() {
        subject.submitFeedback(responses: testResponses, for: testQuestions, peer: testPeer, completionHandler: {_ in })
        XCTAssert(mailClient.postCalled)
    }
    
    func test_submittingTheFeedbackResponseShouldGenerateTheCorrespondingReport() throws {
        subject.submitFeedback(responses: testResponses, for: testQuestions, peer: testPeer, completionHandler: {_ in })
        let data = mailClient.receivedData
        let mailRequest = try JSONDecoder().decode(MailRequestModel.self, from: data!)
        XCTAssertEqual(mailRequest.body, "====Feedback Report====\nTest question 1: Option 3\nTest question 2: Option 2\nTest question 3: Test response for Test question 3\n")
    }
}

class FakeMailClient: MailClient {
    var postCalled: Bool = false
    var receivedData: Data?
    func post(headers: [String: String], body: Data?, urlParams: [URLQueryItem], completion: ((Result<Void, Error>) -> Void)) {
        postCalled = true
        receivedData = body
    }
}
