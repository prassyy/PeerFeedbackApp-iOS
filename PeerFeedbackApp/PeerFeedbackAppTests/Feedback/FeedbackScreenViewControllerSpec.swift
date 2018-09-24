//
//  FeedbackScreenViewControllerSpec.swift
//  PeerFeedbackAppTests
//
//  Created by Prassyy on 10/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import XCTest
import UIKit

@testable import PeerFeedbackApp

class FeedbackScreenViewControllerSpec: XCTestCase {
    
    var subject: FeedbackScreenViewController!
    var mockNavigationController: MockNavigationController!
    
    override func setUp() {
        subject = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "FeedbackScreenViewController") as! FeedbackScreenViewController
        mockNavigationController = MockNavigationController(rootViewController: subject)
        UIApplication.shared.keyWindow?.rootViewController = subject
        _ = subject.view
    }

    func test_containsTableView() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        XCTAssertNotNil(tableView)
    }
    
    func test_tableViewContainsHeaderWithAppName() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()
        
        let headerView = tableView!.tableHeaderView
        XCTAssertNotNil(headerView)
        
        let titleLabel = headerView?.getViewsOfType(UILabel.self).first(where: { $0.text == "Peer Feedback"})
        XCTAssertNotNil(titleLabel)
    }
    
    func test_tableViewContainsCellToFilterRole() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()
        
        let filterRoleCell = tableView!.cellForRow(at: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(filterRoleCell)
        XCTAssertEqual(filterRoleCell?.textLabel?.text, "Role")
        XCTAssertEqual(filterRoleCell?.detailTextLabel?.text, "Choose")
    }
    
    func test_tableViewContainsCellToChoosePeerFromList() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()
        
        let choosePeerCell = tableView!.cellForRow(at: IndexPath(item: 0, section: 1))
        XCTAssertNotNil(choosePeerCell)
        XCTAssertEqual(choosePeerCell?.textLabel?.text, "Peer Name")
        XCTAssertEqual(choosePeerCell?.detailTextLabel?.text, "Choose")
    }
    
    func test_tappingChoosePeerCellAfterChoosingRolePresentsPeersNameListViewController() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()
        subject.chooseRole(from: 0)
        tableView!.delegate?.tableView!(tableView!, didSelectRowAt: IndexPath(row: 0, section: 1))

        XCTAssert(mockNavigationController.viewControllerPresented != nil && mockNavigationController.viewControllerPresented!.isKind(of: PeerNameListViewController.self))
    }
    
    func test_tappingChoosePeerCellWithoutChoosingRoleShouldntRespond() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()

        tableView!.delegate?.tableView!(tableView!, didSelectRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertNil(mockNavigationController.viewControllerPresented)
    }
    
    func test_filterRoleCellTapShowsPickerWithDoneAndCancelButtons() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first!
        
        tableView.reloadData()
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))!.isSelected = true
        
        let keyboardWindow = UIApplication.shared.windows.first(where: { $0.isKind(of: NSClassFromString("UIRemoteKeyboardWindow")!) })
        let pickerView = keyboardWindow!.getFirstSubViewOfType(UIPickerView.self)
        XCTAssertNotNil(pickerView)
        XCTAssertEqual(pickerView?.numberOfComponents, 1)
        XCTAssertEqual(pickerView?.numberOfRows(inComponent: 0) , 3)

        let textEffectsWindow = UIApplication.shared.windows.first(where: { $0.isKind(of: NSClassFromString("UITextEffectsWindow")!) })
        let selectionBar = textEffectsWindow!.getFirstSubViewOfType(UIToolbar.self)
        XCTAssertNotNil(selectionBar)
        let barButtonItems = selectionBar!.items!
        XCTAssertEqual(barButtonItems[0].title, "Cancel")
        XCTAssertEqual(barButtonItems[2].title, "Done")
    }
    
    func test_rolePickerDoneTapShouldUpdateTheCellDetailWithRole() {
        //Given the role select pickerView with Done and Cancel button showing
        let tableView = subject.view.getViewsOfType(UITableView.self).first!
        tableView.reloadData()
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))!.isSelected = true

        let barButtonItems = UIApplication.shared.windows.first(where: { $0.isKind(of: NSClassFromString("UITextEffectsWindow")!) })!
            .getFirstSubViewOfType(UIToolbar.self)!.items!
        let doneButton = barButtonItems[2]
        
        //When a role is Selected and done button is tapped
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?
            .performSelector(onMainThread: doneButton.action!, with: nil, waitUntilDone: true)

        //Then it should update the role in the selection cell
        let filterRoleCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0))
        XCTAssertEqual(filterRoleCell!.detailTextLabel!.text, "Project Manager")
    }
    
    func test_selectingAPeerFromNameListShouldDisplayTheNameInChoosePeerCell() {
        let testPeer = PeerDetailsModel(role: "Android Developer", peerName: "Harshith", emailId: "pharshit@ford.com")
        let tableView = subject.view.getViewsOfType(UITableView.self).first!
        tableView.reloadData()

        subject.chooseRole(from: 0)
        subject.peerSelected(peer: testPeer)
        
        let choosePeerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))!
        XCTAssertEqual(choosePeerCell.detailTextLabel!.text, testPeer.peerName)
    }
    
    func test_containsAButtonWithTextAsNext() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first
        tableView?.reloadData()
        
        let actionCell = tableView!.cellForRow(at: IndexPath(item: 0, section: 2))
        XCTAssertNotNil(actionCell)

        let button = actionCell?.getFirstSubViewOfType(UIButton.self)
        XCTAssertNotNil(button)
        XCTAssertEqual(button?.titleLabel?.text, "Next")
    }
}
