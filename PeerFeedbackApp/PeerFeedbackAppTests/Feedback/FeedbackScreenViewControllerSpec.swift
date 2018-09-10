//
//  FeedbackScreenViewControllerSpec.swift
//  PeerFeedbackAppTests
//
//  Created by Prassyy on 10/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import XCTest

@testable import PeerFeedbackApp

class FeedbackScreenViewControllerSpec: XCTestCase {
    
    let subject: FeedbackScreenViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackScreenViewController") as! FeedbackScreenViewController
    
    override func setUp() {
        _ = subject.view
    }

    func test_containsTableView() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        XCTAssertNotNil(tableView)
    }
    
    func test_tableViewContainsHeaderWithAppName() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()
        
        let headerCell = tableView!.cellForRow(at: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(headerCell)
        
        XCTAssertEqual(headerCell?.textLabel?.text, "EV FB4 Peer Feedback")
    }
    
    func test_tableViewContainsCellToChooseDeveloper() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()
        
        let developerChoiceCell = tableView!.cellForRow(at: IndexPath(item: 0, section: 1))
        XCTAssertNotNil(developerChoiceCell)
        XCTAssertEqual(developerChoiceCell?.textLabel?.text, "Developer")
        XCTAssertEqual(developerChoiceCell?.detailTextLabel?.text, "Choose")
    }
}

extension UIView {
    
    func getViewsOfType<T>(_ type: T.Type) -> [T] {
        return self.subviews
            .filter{ ($0 as? T) != nil } as! [T]
    }
}
