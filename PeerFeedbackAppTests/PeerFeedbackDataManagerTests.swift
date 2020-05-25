//
//  PeerFeedbackDataManagerTests.swift
//  PeerFeedbackAppTests
//
//  Created by Prassyy on 25/05/20.
//  Copyright © 2020 prassi. All rights reserved.
//

import XCTest

@testable import PeerFeedbackApp

class PeerFeedbackDataManagerTests: XCTestCase {
    var subject: PeerFeedbackDataManager!
    var jsonFileManager: JsonFileManager!
    var mailService: FakeMailService!

    override func setUp() {
        jsonFileManager = JsonFileManager()
        mailService = FakeMailService()
        subject = PeerFeedbackDataManager(jsonFileManager: jsonFileManager,
                                          mailService: mailService)
    }
    
    func test_whenFetchPeerListCalled_shouldReturnAppropriateResponse() {
        XCTAssert(subject.fetchPeersList(with: .pokemon).count == 2)
        XCTAssert(subject.fetchPeersList(with: .justiceLeague).count == 2)
        XCTAssert(subject.fetchPeersList(with: .avengers).count == 2)
    }
    
    func test_whenFetchFeedbackQuestionsCalled_shouldReturnAppropriateResponse() {
        XCTAssert(subject.fetchFeedbackQuestions(for: .avengers).count == 4)
        XCTAssert(subject.fetchFeedbackQuestions(for: .justiceLeague).count == 4)
        XCTAssert(subject.fetchFeedbackQuestions(for: .pokemon).count == 4)
    }
    
    func test_whenSendResponseCalled_shouldSendTheQuestionsAndResponsesToMailService() {
        let testPeer = PeerDetailsModel(role: Role(rawValue: "pokemon"), peerName: "Harshith", emailId: "harshit@yopmail.com")
        let testQuestions = [
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
        let testResponses = Dictionary<Int, String>(dictionaryLiteral: (0, "Option 3"), (1, "Option 2"), (2, "Test response for Test question 3"))
        subject.sendResponse(for: testPeer, questions: testQuestions, responses: testResponses) {_ in }
        XCTAssertEqual(mailService.receivedPeer, testPeer)
        XCTAssertEqual(mailService.receivedQuestions, testQuestions)
        XCTAssertEqual(mailService.receivedResponses, testResponses)
    }
}

class FakeMailService: MailService {
    init() {
        super.init(mailClient: FakeMailClient())
    }
    
    var receivedPeer: PeerDetailsModel!
    var receivedQuestions: [FeedbackQuestionModel] = []
    var receivedResponses: Dictionary<Int, String> = [:]
    
    override func submitFeedback(responses: Dictionary<Int, String>, for questions: [FeedbackQuestionModel], peer: PeerDetailsModel, completionHandler: (Result<Void, Error>) -> ()) {
        self.receivedPeer = peer
        self.receivedQuestions = questions
        self.receivedResponses = responses
    }
}
