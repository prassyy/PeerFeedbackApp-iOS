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
        if selected { self.becomeFirstResponder() }
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
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
        rolesSelectionBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    }
    
    override func awakeFromNib() {
        setupPickerView()
        setupToolBar()
    }
}

protocol FilterRolesCellDelegate: class {
    var roles: [String] { get }
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
