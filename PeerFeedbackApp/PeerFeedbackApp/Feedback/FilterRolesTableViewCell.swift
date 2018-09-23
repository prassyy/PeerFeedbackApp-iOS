//
//  FilterRolesTableViewCell.swift
//  PeerFeedbackApp
//
//  Created by fordlabs on 17/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

class FilterRolesTableViewCell: UITableViewCell {

    var rolesPickerView: UIPickerView!
    var rolesSelectionBar: UIToolbar!
    
    weak var delegate: FilterRolesCellDelegate?

    override var inputView: UIView? {
        return rolesPickerView
    }
    
    override var inputAccessoryView: UIView? {
        return rolesSelectionBar
    }

    open override var canBecomeFirstResponder: Bool {
        return true
    }

    open override var canResignFirstResponder: Bool {
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected { becomeFirstResponder() }
    }

    private func setupPickerView() {
        rolesPickerView = UIPickerView()
        rolesPickerView.delegate = self
        rolesPickerView.dataSource = self
    }
    
    private func setupToolBar() {
        rolesSelectionBar = UIToolbar()
        rolesSelectionBar.barStyle = .default
        rolesSelectionBar.isTranslucent = true
        rolesSelectionBar.sizeToFit()
        rolesSelectionBar.isUserInteractionEnabled = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        rolesSelectionBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    }
    
    override func awakeFromNib() {
        setupPickerView()
        setupToolBar()
    }
    
    @objc private func doneTapped() {
        let selectedIndex = rolesPickerView.selectedRow(inComponent: 0)
        delegate?.chooseRole(from: selectedIndex)

        detailTextLabel?.text = delegate?.roles[selectedIndex]
        resignFirstResponder()
    }
    
    @objc private func cancelTapped() {
        resignFirstResponder()
    }
}

protocol FilterRolesCellDelegate: class {
    var roles: [String] { get }
    func chooseRole(from index: Int)
}

extension FilterRolesTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let delegate = delegate else { return 0 }
        return delegate.roles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.roles[row]
    }
}
