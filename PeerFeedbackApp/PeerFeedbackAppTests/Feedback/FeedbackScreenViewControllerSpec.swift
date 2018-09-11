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
    
    let subject: FeedbackScreenViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackScreenViewController") as! FeedbackScreenViewController

    override func setUp() {
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
        
        let titleLabel = headerView?.getViewsOfType(UILabel.self).first(where: { $0.text == "EV FB4 Peer Feedback"})
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
    
    func test_filterRoleCellTapShowsPickerWithDoneAndCancelButtons() {
        let tableView = subject.view.getViewsOfType(UITableView.self).first!
        
        tableView.reloadData()
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isSelected = true
        
        let keyboardWindow = UIApplication.shared.windows.first(where: { $0.isKind(of: NSClassFromString("UIRemoteKeyboardWindow")!) })
        let pickerView = keyboardWindow?.getFirstSubViewOfType(UIPickerView.self)
        XCTAssertNotNil(pickerView)
        XCTAssertEqual(pickerView?.numberOfComponents, 1)
        XCTAssertEqual(pickerView?.numberOfRows(inComponent: 0) , 3)

        let textEffectsWindow = UIApplication.shared.windows.first(where: { $0.isKind(of: NSClassFromString("UITextEffectsWindow")!) })
        let selectionBar = textEffectsWindow?.getFirstSubViewOfType(UIToolbar.self)
        XCTAssertNotNil(selectionBar)
        let barButtonItems = selectionBar!.items!
        XCTAssertEqual(barButtonItems[0].title, "Cancel")
        XCTAssertEqual(barButtonItems[2].title, "Done")
    }
}

extension UIView {
    
    func getViewsOfType<T>(_ type: T.Type) -> [T] {
        return self.subviews
            .filter{ ($0 as? T) != nil } as! [T]
    }
    
    func getFirstSubViewOfType<T>(_ type: T.Type) -> T? {
        guard self.subviews.count > 0 else { return nil }
        let subViewsOfType = self.getViewsOfType(type)
        if subViewsOfType.count > 0 {
            return subViewsOfType.first
        }
        
        for subView in self.subviews {
            if let subViewOfType = subView.getFirstSubViewOfType(type) {
                return subViewOfType
            }
        }
        return nil
    }
}
