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

    private var peerDetailsModel = PeerDetailsModel()
    
    override func viewDidLoad() {
        setupTableView()
    }
    
    private func setupTableView() {
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.tableHeaderView = headerView()
        feedbackTableView.tableFooterView = UIView()
    }

    private func headerView() -> UIView? {
        let nib = UINib(nibName: "TitleView", bundle: Bundle(for: type(of: self)))
        let viewsList = nib.instantiate(withOwner: self, options: nil)
        if viewsList.count > 0,
            let headerView = viewsList[0] as? UIView {
            return headerView
        }
        return nil
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
    
    private func choosePeerNameCell(for tableView: UITableView, index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosePeerNameTableViewCell", for: index)
        cell.textLabel?.text = "Peer Name"
        cell.detailTextLabel?.text = peerDetailsModel.peerName ?? "Choose"
        return cell
    }
    
    private func actionCell(for tableView: UITableView, index: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell") {
            return cell
        }
        return UITableViewCell()
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
        case 1:
            return choosePeerNameCell(for: tableView, index: indexPath)
        case 2:
            return actionCell(for: tableView, index: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1, let selectedRole = peerDetailsModel.role {
            let peerNameListViewController = PeerNameListViewController.instantiateFromStoryboard(role: selectedRole)
            peerNameListViewController.delegate = self
            self.navigationController?.present(peerNameListViewController, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

extension FeedbackScreenViewController: FilterRolesCellDelegate {
    func chooseRole(from index: Int) {
        peerDetailsModel.role = roles[index]
    }
    
    var roles: [String] {
        return ["Project Manager","Android Developer","iOS Developer"]
    }
}

extension FeedbackScreenViewController: PeerNameListViewControllerDelegate {
    func peerSelected(peer: PeerDetailsModel) {
        peerDetailsModel.peerName = peer.peerName
        peerDetailsModel.emailId = peer.emailId
        feedbackTableView.reloadData()
    }
}
