//
//  PeerNameListViewControllerSpec.swift
//  PeerFeedbackAppTests
//
//  Created by Prassyy on 23/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//
import XCTest

@testable import PeerFeedbackApp

class PeerNameListViewControllerSpec: XCTestCase {
    
    var subject: PeerNameListViewController!
    var baseViewController: MockUIViewController!
    
    override func setUp() {
        baseViewController = MockUIViewController()
        UIApplication.shared.keyWindow?.rootViewController = baseViewController
        _ = baseViewController.view

        subject = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PeerNameListViewController") as! PeerNameListViewController
        baseViewController.present(subject, animated: false)
        _ = subject.view
    }
    
    func test_shouldHaveCancelAndDoneButtonsInHeader() {
        let tableView = subject.view.getFirstSubViewOfType(UITableView.self)
        XCTAssertNotNil(tableView)

        tableView?.reloadData()
        let selectionBar = tableView!.getFirstSubViewOfType(UIToolbar.self)
        XCTAssertNotNil(selectionBar)

        let barButtonItems = selectionBar!.items!
        XCTAssertEqual(barButtonItems[0].title, "Cancel")
        XCTAssertEqual(barButtonItems[2].title, "Done")
    }

    func test_populatesTheListWithNames() {
        let tableView = subject.view.getFirstSubViewOfType(UITableView.self)
        tableView?.reloadData()
        
        XCTAssertEqual(tableView!.numberOfSections, 1)
    }
    
    func test_tappingCancelDismissesTheViewController() {
        let tableView = subject.view.getFirstSubViewOfType(UITableView.self)
        tableView?.reloadData()
        let cancelButton = tableView!.getFirstSubViewOfType(UIToolbar.self)!.items![0]
        subject.performSelector(onMainThread: cancelButton.action!, with: nil, waitUntilDone: true)
        XCTAssert(baseViewController.dismissCalled)
    }
}

class MockUIViewController: UIViewController {
    var dismissCalled: Bool!

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
        super.dismiss(animated: false, completion: nil)
    }
}
