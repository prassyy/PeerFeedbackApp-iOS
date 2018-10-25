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
    var questions: [FeedbackQuestionModel] = []
    var responses: [FeedbackResponseModel] = []
    
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
        questionsTableView.delegate = self
        questionsTableView.tableFooterView = UIView()
        questionsTableView.separatorColor = UIColor.clear
        questionsTableView.register(UINib(nibName: "FeedbackQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedbackQuestionsTableViewCell")
    }
    
    private func fetchQuestions() {
        if let role = peerModel.role {
            questions = dataManager.fetchFeedbackQuestions(for: role)
            responses = questions.map {
                FeedbackResponseModel(question: $0.question,
                                      response: nil,
                                      isResponded: false)
            }
        }
    }
    
    override func viewDidLoad() {
        setupTitle()
        fetchQuestions()
        setupTableView()
    }
}

extension FeedbackQuestionnaireViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackQuestionsTableViewCell", for: indexPath) as! FeedbackQuestionTableViewCell
        let question = questions[indexPath.row]
        cell.configure(with: question, delegate: self)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return questions.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

extension FeedbackQuestionnaireViewController: FeedbackQuestionTableViewCellDelegate {
    func isQuestionResponded(index: Int) -> Bool {
        return false
    }
}
