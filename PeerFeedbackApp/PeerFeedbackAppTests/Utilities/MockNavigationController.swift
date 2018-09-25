//
//  MockNavigationController.swift
//  PeerFeedbackAppTests
//
//  Created by Prassyy on 23/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

class MockNavigationController: UINavigationController {
    
    var viewControllerPresented: UIViewController?
    var viewControllerPushed: UIViewController?
    var dismissCalled: Bool!
    
    init() {
        super.init(navigationBarClass: nil, toolbarClass: nil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewControllerPresented = viewControllerToPresent
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.dismissCalled = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.viewControllerPushed = viewController
        super.pushViewController(viewController, animated: false)
    }
}
