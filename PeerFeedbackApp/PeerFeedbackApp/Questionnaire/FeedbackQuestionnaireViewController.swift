//
//  FeedbackQuestionnaireViewController.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 25/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

class FeedbackQuestionnaireViewController: UIViewController {
    func setDependencies(peer: PeerDetailsModel) {
        
    }
}

extension FeedbackQuestionnaireViewController {
    class func instantiateFromStoryboard(peer: PeerDetailsModel) -> FeedbackQuestionnaireViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackQuestionnaireViewController") as! FeedbackQuestionnaireViewController
        viewController.setDependencies(peer: peer)
        return viewController
    }
}
