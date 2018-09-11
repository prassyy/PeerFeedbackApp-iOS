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
    
    func test_containsPickerViewAndMustBeHidden() {
        let pickerView = subject.view.getViewsOfType(UIPickerView.self).first
        XCTAssertNotNil(pickerView)
        XCTAssert(pickerView!.isHidden)
    }
    
    func test_tableViewContainsHeaderWithAppName() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()
        
        let headerView = tableView!.tableHeaderView
        XCTAssertNotNil(headerView)
        
        let titleLabel = headerView?.getViewsOfType(UILabel.self).first(where: { $0.text == "EV FB4 Peer Feedback"})
        XCTAssertNotNil(titleLabel)
    }
    
    func test_tableViewContainsCellToChooseDeveloper() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()
        
        let developerChoiceCell = tableView!.cellForRow(at: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(developerChoiceCell)
        XCTAssertEqual(developerChoiceCell?.textLabel?.text, "Developer")
        XCTAssertEqual(developerChoiceCell?.detailTextLabel?.text, "Choose")
    }
    
    func test_chooseDeveloperCellTapShowsPicker() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first!
        let pickerView = subject.view.getViewsOfType(UIPickerView.self).first

        tableView.reloadData()
        tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertFalse(pickerView!.isHidden)
    }
}

extension UIView {
    
    func getViewsOfType<T>(_ type: T.Type) -> [T] {
        return self.subviews
            .filter{ ($0 as? T) != nil } as! [T]
    }
}
