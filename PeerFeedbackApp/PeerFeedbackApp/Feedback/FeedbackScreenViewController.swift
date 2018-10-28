//
//  FeedbackScreenViewController.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 10/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

enum Section: Int {
    case chooseRole = 0
    case choosePeer = 1
}

class FeedbackScreenViewController: UIViewController {
    private var peerDetailsModel = PeerDetailsModel() {
        didSet {
            if peerDetailsModel.role.exists,
                peerDetailsModel.peerName.exists,
                peerDetailsModel.emailId.exists {
                footerView.setButtonEnabled(isEnabled: true)
            } else {
                footerView.setButtonEnabled(isEnabled: false)
            }
        }
    }

    @IBOutlet weak var feedbackTableView: UITableView!
    
    lazy var headerView: UIView? = {
        let nib = UINib(nibName: "TitleView", bundle: Bundle(for: type(of: self)))
        let viewsList = nib.instantiate(withOwner: self, options: nil)
        if viewsList.count > 0,
            let headerView = viewsList[0] as? UIView {
            return headerView
        }
        return nil
    }()
    
    lazy var footerView: FooterView = {
        let nib = UINib(nibName: "FooterView", bundle: nil)
        let viewsList = nib.instantiate(withOwner: self, options: nil)
        if viewsList.count > 0,
            let footerView = viewsList[0] as? FooterView {
            footerView.footerButton.setTitle("Next", for: .normal)
            footerView.setButtonEnabled(isEnabled: false)
            footerView.footerButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
            return footerView
        }
        return FooterView()
    }()
    
    override func viewDidLoad() {
        setupTableView()
    }

    private func setupTableView() {
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.tableHeaderView = headerView
        feedbackTableView.tableFooterView = footerView
    }

    private func filterRolesCell(for tableView: UITableView, index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRoleTableViewCell", for: index)
        if let cell = cell as? FilterRolesTableViewCell {
            cell.delegate = self
            cell.textLabel?.text = "Role"
            cell.detailTextLabel?.text = peerDetailsModel.role ?? "Choose"
        }
        return cell
    }

    private func choosePeerNameCell(for tableView: UITableView, index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosePeerNameTableViewCell", for: index)
        cell.textLabel?.text = "Peer Name"
        cell.detailTextLabel?.text = peerDetailsModel.peerName ?? "Choose"
        return cell
    }
    
    @objc func nextAction() {
        guard peerDetailsModel.role.exists,
            peerDetailsModel.peerName.exists,
            peerDetailsModel.emailId.exists else { return }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(FeedbackQuestionnaireViewController
            .instantiateFromStoryboard(peer: peerDetailsModel),
                                                      animated: true)
    }
}

extension FeedbackScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .chooseRole:
            return filterRolesCell(for: tableView, index: indexPath)
        case .choosePeer:
            return choosePeerNameCell(for: tableView, index: indexPath)
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { return "" }

        switch section {
        case .chooseRole:
            return "Choose the role of your Peer"
        case .choosePeer:
            return "Choose the Name of your Peer from below"
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension FeedbackScreenViewController: FilterRolesCellDelegate {
    func chooseRole(from index: Int) {
        peerDetailsModel.role = roles[index]
        peerDetailsModel.peerName = nil
        peerDetailsModel.emailId = nil

        feedbackTableView.reloadData()
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
