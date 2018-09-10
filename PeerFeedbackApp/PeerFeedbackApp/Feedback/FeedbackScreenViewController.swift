//
//  FeedbackScreenViewController.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 10/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

class FeedbackScreenViewController: UIViewController {
    @IBOutlet weak var feedbackTableView: UITableView!
    
    override func viewDidLoad() {
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
    }
}

extension FeedbackScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedbackTableView.dequeueReusableCell(withIdentifier: "FeedbackTableViewCell", for: indexPath)
        cell.textLabel?.text = "EV FB4 Peer Feedback"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}
