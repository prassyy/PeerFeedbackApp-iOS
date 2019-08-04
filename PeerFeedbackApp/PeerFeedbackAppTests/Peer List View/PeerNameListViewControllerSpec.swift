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
    var mockPeerFeedbackDataManager: MockPeerFeedbackDataManager!
    var mockPeerNameListViewControllerDelegate: MockPeerNameListViewControllerDelegate!

    override func setUp() {
        mockPeerFeedbackDataManager = MockPeerFeedbackDataManager()
        baseViewController = MockUIViewController()
        mockPeerNameListViewControllerDelegate = MockPeerNameListViewControllerDelegate()
        
        UIApplication.shared.keyWindow?.rootViewController = baseViewController
        _ = baseViewController.view
        subject = PeerNameListViewController.instantiateFromStoryboard(role: Role(rawValue: "pokemon")!, peerFeedbackDataManager: mockPeerFeedbackDataManager)
        subject.delegate = mockPeerNameListViewControllerDelegate
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
        mockPeerFeedbackDataManager.peerNameList = [ PeerDetailsModel(role: Role(rawValue: "pokemon"), peerName: "Harshith", emailId: "pharshit@ford.com"),
                                                     PeerDetailsModel(role: Role(rawValue: "pokemon"), peerName: "Mukesh", emailId: "bmukesh@ford.com"),
                                                     PeerDetailsModel(role: Role(rawValue: "pokemon"), peerName: "Karpagam", emailId: "ekarpaga@ford.com")]
        subject.viewDidLoad()

        let tableView = subject.view.getFirstSubViewOfType(UITableView.self)
        tableView?.reloadData()
        XCTAssertEqual(tableView!.numberOfSections, 1)
        XCTAssertEqual(tableView!.numberOfRows(inSection: 0), 3)
        for (index, peer) in mockPeerFeedbackDataManager.peerNameList.enumerated() {
            XCTAssertEqual(tableView!.cellForRow(at: IndexPath(row: index, section: 0))?.textLabel!.text, peer.peerName)
        }
    }
    
    func test_tappingCancelDismissesTheViewController() {
        let tableView = subject.view.getFirstSubViewOfType(UITableView.self)
        tableView?.reloadData()
        let cancelButton = tableView!.getFirstSubViewOfType(UIToolbar.self)!.items![0]
        subject.performSelector(onMainThread: cancelButton.action!, with: nil, waitUntilDone: true)
        XCTAssert(baseViewController.dismissCalled)
    }
    
    func test_tappingDoneButtonWithoutSelectingPeerShouldntRespond() {
        let tableView = subject.view.getFirstSubViewOfType(UITableView.self)
        tableView?.reloadData()
        let doneButton = tableView!.getFirstSubViewOfType(UIToolbar.self)!.items![2]
        subject.performSelector(onMainThread: doneButton.action!, with: nil, waitUntilDone: true)
        
        XCTAssert(baseViewController.dismissCalled == nil || !baseViewController.dismissCalled)
    }
    
    func test_tappingDoneAfterChoosingPeerShouldSendThePeerDetailsToDelegate() {
        let testPeer = PeerDetailsModel(role: Role(rawValue: "avengers"), peerName: "Harshith", emailId: "pharshit@ford.com")
        mockPeerFeedbackDataManager.peerNameList = [ testPeer ]
        subject.viewDidLoad()
        
        let tableView = subject.view.getFirstSubViewOfType(UITableView.self)
        tableView?.reloadData()
        let doneButton = tableView!.getFirstSubViewOfType(UIToolbar.self)!.items![2]
        
        tableView!.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        subject.performSelector(onMainThread: doneButton.action!, with: nil, waitUntilDone: true)

        XCTAssert(baseViewController.dismissCalled)
        XCTAssertNotNil(mockPeerNameListViewControllerDelegate.selectedPeer)
        XCTAssertEqual(mockPeerNameListViewControllerDelegate.selectedPeer!, testPeer)
    }
}

class MockUIViewController: UIViewController {
    var dismissCalled: Bool!

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
        super.dismiss(animated: false, completion: nil)
    }
}

class MockPeerFeedbackDataManager: PeerFeedbackDataManager {
    var peerNameList: [PeerDetailsModel] = []
    
    override func fetchPeersList(with role: Role) -> [PeerDetailsModel] {
        return peerNameList
    }
}

class MockPeerNameListViewControllerDelegate: PeerNameListViewControllerDelegate {
    var selectedPeer: PeerDetailsModel!

    func peerSelected(peer: PeerDetailsModel) {
        selectedPeer = peer
    }
}

extension PeerDetailsModel: Equatable {
    public static func == (lhs: PeerDetailsModel, rhs: PeerDetailsModel) -> Bool {
        return lhs.emailId == rhs.emailId
            && lhs.isValid == rhs.isValid
            && lhs.peerName == rhs.peerName
            && lhs.role?.rawValue == rhs.role?.rawValue
    }
}
