//
//  FeedbackQuestionTableViewCell.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 26/10/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import UIKit

protocol FeedbackQuestionTableViewCellDelegate: class {
    func isQuestionResponded(index: Int) -> Bool
}

class FeedbackQuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var answerChoiceLabel: UILabel!
    
    var questionModel: FeedbackQuestionModel!
    var answerPickerView: UIPickerView!
    var answerSelectionBar: UIToolbar!
    
    weak var delegate: FeedbackQuestionTableViewCellDelegate?
    
    override var inputView: UIView? {
        return answerPickerView
    }
    
    override var inputAccessoryView: UIView? {
        return answerSelectionBar
    }
    
    open override var canBecomeFirstResponder: Bool {
        return questionModel.exists
            && questionModel.isChoiceBased.exists
            && questionModel.isChoiceBased!
    }
    
    open override var canResignFirstResponder: Bool {
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if let question = questionModel,
            let isChoiceBased = question.isChoiceBased,
            isChoiceBased, selected {
            becomeFirstResponder()
        }
    }

    override func awakeFromNib() {
        responseTextView.layer.borderWidth = 0.5
        responseTextView.layer.borderColor = UIColor.lightGray.cgColor
        setupPickerView()
        setupToolBar()
    }
    
    private func setupPickerView() {
        answerPickerView = UIPickerView()
        answerPickerView.delegate = self
        answerPickerView.dataSource = self
    }
    
    private func setupToolBar() {
        answerSelectionBar = UIToolbar()
        answerSelectionBar.barStyle = .default
        answerSelectionBar.isTranslucent = true
        answerSelectionBar.sizeToFit()
        answerSelectionBar.isUserInteractionEnabled = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        answerSelectionBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    }
    
    @objc private func doneTapped() {
        let selectedIndex = answerPickerView.selectedRow(inComponent: 0)
        if let question = questionModel,
            let choices = question.choices {
            answerChoiceLabel.text = choices[String(selectedIndex)]
        }
        resignFirstResponder()
    }
    
    @objc private func cancelTapped() {
        resignFirstResponder()
    }
    
    func configure(with questionModel: FeedbackQuestionModel,
                   delegate: FeedbackQuestionTableViewCellDelegate?) {
        self.questionModel = questionModel
        self.delegate = delegate
        
        questionLabel.text = questionModel.question
        if let isChoiceBased = questionModel.isChoiceBased {
            responseTextView.isHidden = isChoiceBased
            answerChoiceLabel.isHidden = !isChoiceBased
            accessoryType = isChoiceBased ? UITableViewCellAccessoryType.disclosureIndicator : UITableViewCellAccessoryType.none
        }
    }
}

extension FeedbackQuestionTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let question = questionModel,
            let choices = question.choices {
            return choices.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let question = questionModel,
            let choices = question.choices {
            return choices[String(row)]
        }
        return nil
    }
}
