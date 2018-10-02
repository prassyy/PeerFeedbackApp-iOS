//
//  PListDataManagerSpec.swift
//  PeerFeedbackAppTests
//
//  Created by Prassyy on 24/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import XCTest

@testable import PeerFeedbackApp

class PListDataManagerSpec: XCTestCase {
    var subject: PListDataManager!
    let testPeers = [ PeerDetailsModel(role: "Android Developer", peerName: "Harshith", emailId: "pharshit@ford.com"),
                      PeerDetailsModel(role: "Android Developer", peerName: "Mukesh", emailId: "bmukesh@ford.com"),
                      PeerDetailsModel(role: "iOS Developer", peerName: "Karpagam", emailId: "ekarpaga@ford.com"),
                      PeerDetailsModel(role: "iOS Developer", peerName: "Prasanna", emailId: "kprasan6@ford.com"),
                      PeerDetailsModel(role: "iOS Developer", peerName: "Elumalai", emailId: "relumal2@ford.com")]
    let testQuestions = [
        FeedbackQuestionModel(question: "Test question 1", isChoiceBased: false, choices: [], role: "Software Engineer"),
        FeedbackQuestionModel(question: "Test question 2", isChoiceBased: true, choices: [], role: "Software Engineer"),
        FeedbackQuestionModel(question: "Test question 3", isChoiceBased: true, choices: [], role: "Product Manager"),
        FeedbackQuestionModel(question: "Test question 4", isChoiceBased: false, choices: [], role: "Software Engineer")
    ]
    
    override func setUp() {
        subject = PListDataManager(bundle: Bundle(for: type(of: self)))
    }
    
    func test_readsFromPlistAndReturnsPeerDetailsModelForGivenRole() {
        let expectedAndroidPeers = getTestPeers(for: "Android Developer")
        let expectediOSPeers = getTestPeers(for: "iOS Developer")

        let androidPeersList = subject.fetchPeerNameList(for: "Android Developer")
        XCTAssertEqual(androidPeersList.count, 2)
        for (index, actualPeer) in androidPeersList.enumerated() {
            XCTAssert(actualPeer.equals(peer: expectedAndroidPeers[index]))
        }

        let iOSPeersList = subject.fetchPeerNameList(for: "iOS Developer")
        XCTAssertEqual(iOSPeersList.count, 3)
        for (index, actualPeer) in iOSPeersList.enumerated() {
            XCTAssert(actualPeer.equals(peer: expectediOSPeers[index]))
        }
    }
    
    func test_returnsFeedbackQuestionsFromPlist() {
        let expectedDevQuestions = getTestQuestions(for: "Software Engineer")
        let expectedPmQuestions = getTestQuestions(for: "Product Manager")
        
        let androidFeedbackQuestions = subject.fetchFeedbackQuestions(for: "Android Developer")
        let iOSFeedbackQuestions = subject.fetchFeedbackQuestions(for: "iOS Developer")
        let pmFeedbackQuestions = subject.fetchFeedbackQuestions(for: "Product Manager")
        
        compareQuestions(lhs: androidFeedbackQuestions, rhs: expectedDevQuestions)
        compareQuestions(lhs: iOSFeedbackQuestions, rhs: expectedDevQuestions)
        compareQuestions(lhs: pmFeedbackQuestions , rhs: expectedPmQuestions)
    }
    
    func compareQuestions(lhs: [FeedbackQuestionModel], rhs: [FeedbackQuestionModel]) {
        for (index, lhsQuestion) in lhs.enumerated() {
            let rhsQuestion = rhs[index]
            XCTAssert(lhsQuestion.equals(questionModel: rhsQuestion))
        }
    }
}

extension PListDataManagerSpec {
    private func getTestPeers(for role: String) -> [PeerDetailsModel] {
        return testPeers.filter { $0.role == role }
    }
    
    private func getTestQuestions(for role: String) -> [FeedbackQuestionModel] {
        return testQuestions.filter { $0.role == role }
    }
}

extension PeerDetailsModel {

    func equals(peer: PeerDetailsModel) -> Bool {
        return self.peerName == peer.peerName &&
                self.role == peer.role &&
                self.emailId == peer.emailId
    }
}

extension FeedbackQuestionModel {
    
    func equals(questionModel: FeedbackQuestionModel) -> Bool {
        return self.question == questionModel.question &&
            self.role == questionModel.role &&
            self.isChoiceBased == questionModel.isChoiceBased &&
            self.choices?.count == questionModel.choices?.count
    }
}
