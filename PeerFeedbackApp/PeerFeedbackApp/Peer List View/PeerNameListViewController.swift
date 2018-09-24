//
//  PeerNameListViewController.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 23/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

protocol PeerNameListViewControllerDelegate: class {
    func peerSelected(peer: PeerDetailsModel)
}

class PeerNameListViewController: UIViewController {

    var role: String!
    var plistDataManager: PListDataManager!

    var names: [PeerDetailsModel] = []
    weak var delegate: PeerNameListViewControllerDelegate?
    
    @IBOutlet weak var peerNameListTableView: UITableView!
    
    override func viewDidLoad() {
        setupTableView()
        fetchNameList(for: role)
    }

    private func fetchNameList(for role: String) {
        names = plistDataManager.fetchPeerNameList(for: role)
        peerNameListTableView.reloadData()
    }
    
    private func setupTableView() {
        peerNameListTableView.tableHeaderView = buildToolBar()
        peerNameListTableView.tableFooterView = UIView()
        peerNameListTableView.delegate = self
        peerNameListTableView.dataSource = self
    }
    
    private func buildToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        return toolBar
    }
    
    @objc private func doneTapped() {
        guard let index = peerNameListTableView.indexPathForSelectedRow else { return }
        delegate?.peerSelected(peer: names[index.row])
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelTapped() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setDependencies(role: String, plistDataManager: PListDataManager) {
        self.role = role
        self.plistDataManager = plistDataManager
    }
}

extension PeerNameListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PeerNameListTableViewCell") {
            let peerDetail = names[indexPath.row]
            cell.textLabel?.text = peerDetail.peerName
            cell.accessoryView?.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension PeerNameListViewController {

    class func instantiateFromStoryboard(role: String,
                                         plistDataManager: PListDataManager = PListDataManager()) -> PeerNameListViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PeerNameListViewController") as! PeerNameListViewController
        viewController.setDependencies(role: role, plistDataManager: plistDataManager)
        return viewController
    }
}
