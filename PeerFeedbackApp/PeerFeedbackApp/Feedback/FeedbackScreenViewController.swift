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
    @IBOutlet weak var peerPicker: UIPickerView!
    
    override func viewDidLoad() {
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.tableHeaderView = headerView()

        peerPicker.isHidden = true
    }
}

extension FeedbackScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return chooseDeveloperCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    private func headerView() -> UIView {
        let nib = UINib(nibName: "TitleView", bundle: Bundle(for: type(of: self)))
        let viewsList = nib.instantiate(withOwner: self, options: nil)
        if viewsList.count > 0,
            let headerView = viewsList[0] as? UIView {
            return headerView
        }
        return UIView()
    }
    
    private func chooseDeveloperCell(for index: IndexPath) -> UITableViewCell {
        let cell = feedbackTableView.dequeueReusableCell(withIdentifier: "ChooseDeveloperTableViewCell", for: index)
        cell.textLabel?.text = "Developer"
        cell.detailTextLabel?.text = "Choose"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            peerPicker.isHidden = false
        }
    }
}
