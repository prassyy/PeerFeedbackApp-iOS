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
    var dataManager: PeerFeedbackDataManager!
    var questions: [FeedbackQuestionModel] = []

    var responses: Dictionary<Int, String> = Dictionary<Int, String>() {
        didSet {
            footerView.setButtonEnabled(isEnabled: questions.map { $0.id }
                .reduce(true) { (allQuestionsResponded, questionId) -> Bool in
                    if let id = questionId, let response = responses[id] {
                        return !response.isEmpty && allQuestionsResponded
                    }
                    return false
                })
        }
    }
    
    @IBOutlet weak var questionsTableView: UITableView!
    
    lazy var footerView: FooterView = {
        let nib = UINib(nibName: "FooterView", bundle: nil)
        let viewsList = nib.instantiate(withOwner: self, options: nil)
        if viewsList.count > 0,
            let footerView = viewsList[0] as? FooterView {
            footerView.footerButton.setTitle("Submit", for: .normal)
            footerView.setButtonEnabled(isEnabled: false)
            footerView.footerButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
            return footerView
        }
        return FooterView()
    }()
    
    private func setupTitle() {
        if let peerName = peerModel.peerName {
            self.title = String(format: "%@ - Feedback", peerName)
        }
    }
    
    private func setupTableView() {
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        questionsTableView.tableFooterView = footerView
        questionsTableView.separatorColor = UIColor.clear
        questionsTableView.register(UINib(nibName: "FeedbackQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedbackQuestionsTableViewCell")
    }
    
    @objc func submitButtonTapped() {
        //
    }
    
    private func fetchQuestions() {
        if let role = peerModel.role {
            questions = dataManager.fetchFeedbackQuestions(for: role)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackQuestionsTableViewCell", for: indexPath)
        if let questionCell = cell as? FeedbackQuestionTableViewCell {
            questionCell.configure(with: questions[indexPath.row],
                                   isFirstQuestion: indexPath.row == 0,
                                   isLastQuestion: indexPath.row == questions.count - 1,
                                   delegate: self)
        }
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
                                         peerFeedbackDataManager: PeerFeedbackDataManager = PeerFeedbackDataManager()) -> FeedbackQuestionnaireViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackQuestionnaireViewController") as! FeedbackQuestionnaireViewController
        viewController.setDependencies(peer: peer, peerFeedbackDataManager: peerFeedbackDataManager)
        return viewController
    }
    
    func setDependencies(peer: PeerDetailsModel, peerFeedbackDataManager: PeerFeedbackDataManager) {
        peerModel = peer
        dataManager = peerFeedbackDataManager
    }
}

extension FeedbackQuestionnaireViewController: FeedbackQuestionTableViewCellDelegate {

    func response(for question: FeedbackQuestionModel) -> String? {
        if let questionId = question.id {
            return responses[questionId]
        }
        return nil
    }
    
    func selectedResponse(for question: FeedbackQuestionModel, response: String) {
        if let questionId = question.id {
            responses[questionId] = response
        }
    }
}
