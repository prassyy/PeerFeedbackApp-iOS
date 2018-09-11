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
        setupTableView()
    }
    
    private func setupTableView() {
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.tableHeaderView = headerView()
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
    
    private func filterRolesCell(for tableView: UITableView, index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRoleTableViewCell", for: index)
        if let cell = cell as? FilterRolesTableViewCell {
            cell.delegate = self
            cell.textLabel?.text = "Role"
            cell.detailTextLabel?.text = "Choose"
        }
        
        return cell
    }
    
}

extension FeedbackScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return filterRolesCell(for: tableView, index: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension FeedbackScreenViewController: FilterRolesCellDelegate {
    var roles: [String] {
        return ["Project Manager","Anchor","Software Engineer"]
    }
    
    
}
