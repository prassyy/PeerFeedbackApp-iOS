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
        feedbackTableView.tableFooterView = nil
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
    
    private func choosePeerNameCell(for tableView: UITableView, index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosePeerNameTableViewCell", for: index)
        cell.textLabel?.text = "Peer Name"
        cell.detailTextLabel?.text = "Choose"
        
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
        case 1:
            return choosePeerNameCell(for: tableView, index: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let peerNameListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PeerNameListViewController")
            self.navigationController?.present(peerNameListViewController, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension FeedbackScreenViewController: FilterRolesCellDelegate {
    func chooseRole(from index: Int) {
        //Filter the values in Peer according to the value selected
        
    }
    
    var roles: [String] {
        return ["Project Manager","Android Developer","iOS Developer"]
    }
}
