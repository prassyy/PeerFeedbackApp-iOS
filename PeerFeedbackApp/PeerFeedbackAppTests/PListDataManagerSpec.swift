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
        FeedbackQuestionModel(question: "Test question 1", isChoiceBased: false, choices: Dictionary(dictionaryLiteral:("option1", "Option 1"),
                                                                                           ("option2", "Option 2"),
                                                                                           ("option3", "Option 3"),
                                                                                           ("option4", "Option 4")), role: "Software Engineer"),
        FeedbackQuestionModel(question: "Test question 2", isChoiceBased: true, choices: Dictionary(dictionaryLiteral:("option1", "Option 1"),
                                                                                                    ("option2", "Option 2"),
                                                                                                    ("option3", "Option 3"),
                                                                                                    ("option4", "Option 4")), role: "Software Engineer"),
        FeedbackQuestionModel(question: "Test question 3", isChoiceBased: true, choices: Dictionary(dictionaryLiteral:("option1", "Option 1"),
                                                                                                    ("option2", "Option 2")), role: "Product Manager"),
        FeedbackQuestionModel(question: "Test question 4", isChoiceBased: false, choices: Dictionary(), role: "Software Engineer")
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

        XCTAssert(compareIfArrayEquals(lhs: androidFeedbackQuestions, rhs: expectedDevQuestions))
        XCTAssert(compareIfArrayEquals(lhs: iOSFeedbackQuestions, rhs: expectedDevQuestions))
        XCTAssert(compareIfArrayEquals(lhs: pmFeedbackQuestions , rhs: expectedPmQuestions))
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

extension FeedbackQuestionModel: Equatable {
    public static func == (lhs: FeedbackQuestionModel, rhs: FeedbackQuestionModel) -> Bool {
        return lhs.question == rhs.question &&
            lhs.role == rhs.role &&
            lhs.isChoiceBased == rhs.isChoiceBased &&
            NSDictionary(dictionary: lhs.choices ?? Dictionary<String, String>()).isEqual(to: rhs.choices ?? Dictionary<String, String>())
    }
}

func compareIfArrayEquals<T: Equatable>(lhs: [T], rhs: [T]) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (index, lhsItem) in lhs.enumerated() {
        let rhsItem = rhs[index]
        if lhsItem != rhsItem {
            return false
        }
    }
    return true
}
