//
//  PeerNameListViewController.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 23/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

class PeerNameListViewController: UIViewController {

    let names = ["Aravind", "Saketh", "Hari", "Divya", "Kritika"]

    @IBOutlet weak var peerNameListTableView: UITableView!
    
    override func viewDidLoad() {
        setupTableView()
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

    }
    
    @objc private func cancelTapped() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension PeerNameListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PeerNameListTableViewCell") {
            cell.textLabel?.text = names[indexPath.row]
            cell.accessoryView?.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
