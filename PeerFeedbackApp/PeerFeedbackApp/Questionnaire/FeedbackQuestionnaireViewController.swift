//
//  FeedbackQuestionnaireViewController.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 25/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

class FeedbackQuestionnaireViewController: UIViewController {
    var peerModel: PeerDetailsModel!
    var dataManager: PListDataManager!
    
    @IBOutlet weak var questionsTableView: UITableView!
    
    func setDependencies(peer: PeerDetailsModel, plistDataManager: PListDataManager) {
        peerModel = peer
        dataManager = plistDataManager
    }
    
    private func setupTitle() {
        if let peerName = peerModel.peerName {
            self.title = String(format: "%@ - Feedback", peerName)
        }
    }
    
    private func setupTableView() {
        questionsTableView.dataSource = self
        questionsTableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        setupTitle()
        setupTableView()
    }
}

extension FeedbackQuestionnaireViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackQuestionsTableViewCell", for: indexPath)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        }
        return 0
    }
}

extension FeedbackQuestionnaireViewController {
    class func instantiateFromStoryboard(peer: PeerDetailsModel,
                                         plistDataManager: PListDataManager = PListDataManager()) -> FeedbackQuestionnaireViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackQuestionnaireViewController") as! FeedbackQuestionnaireViewController
        viewController.setDependencies(peer: peer, plistDataManager: plistDataManager)
        return viewController
    }
}
