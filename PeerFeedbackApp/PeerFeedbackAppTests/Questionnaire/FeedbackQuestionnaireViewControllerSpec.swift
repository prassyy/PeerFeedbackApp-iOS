//
//  FeedbackQuestionnaireViewControllerSpec.swift
//  PeerFeedbackAppTests
//
//  Created by Prassyy on 27/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import XCTest

@testable import PeerFeedbackApp

class FeedbackQuestionnaireViewControllerSpec: XCTestCase {
    
    var subject: FeedbackQuestionnaireViewController!
    var testPeer: PeerDetailsModel!
//    var questions: [FeedbackQuestionModel]!
    
    override func setUp() {
        
        testPeer = PeerDetailsModel(role: "Android Developer", peerName: "Harshith", emailId: "pharshit@ford.com")
        subject = FeedbackQuestionnaireViewController.instantiateFromStoryboard(peer: testPeer)
        _ = subject.view
    }
    
    func test_containsTableView() {
        XCTAssertNotNil(subject.view.getFirstSubViewOfType(UITableView.self))
    }
    
    func test_tableViewContainsHeaderWithPeerName() {
        XCTAssertEqual(subject.title, testPeer.peerName! + " - Feedback")
    }
    
    func test_tableViewContainsOneSectionAndAppropriateNumberOfQuestions() {
        let tableView = subject.view.getFirstSubViewOfType(UITableView.self)
        tableView?.reloadData()
        
        XCTAssertEqual(tableView?.numberOfSections, 1)
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 10)
    }
    
    
}
