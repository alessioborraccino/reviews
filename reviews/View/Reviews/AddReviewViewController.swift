//
//  AddReviewViewController.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit
import ReactiveCocoa

class AddReviewViewController: UIViewController {

    // MARK: ViewModel 

    private var viewModel : AddReviewViewModelType

    // MARK: SubViews 

    private lazy var scrollView : UIScrollView =  {
        return UIScrollView()
    }()

    private lazy var authorLabel : UILabel = {
        let label = UILabel()
        label.font = AppFont.bold
        label.textColor = AppColor.textDark
        label.text = "Author:"
        return label
    }()
    private lazy var authorTextField: UITextField = {
        let textField = UITextField()
        textField.font = AppFont.regular
        textField.textColor = AppColor.textDark
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = AppColor.textLight.CGColor
        return textField
    }()
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = AppFont.bold
        label.textColor = AppColor.textDark
        label.text = "Title:"
        return label
    }()
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = AppFont.regular
        textField.textColor = AppColor.textDark
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = AppColor.textLight.CGColor
        return textField
    }()
    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.font = AppFont.bold
        label.textColor = AppColor.textDark
        label.text = "Message:"
        return label
    }()
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = AppFont.regular
        textView.textColor = AppColor.textDark
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = AppColor.textLight.CGColor
        return textView
    }()

    // MARK: Initializers 

    init(addReviewViewModel: AddReviewViewModelType) {
        self.viewModel = addReviewViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Methods 

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Review"
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(scrollView)
        scrollView.addSubview(authorLabel)
        scrollView.addSubview(authorTextField)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(messageLabel)
        scrollView.addSubview(messageTextView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(didTapSave))
        setDefaultConstraints()
        bind()
    }

    private func setDefaultConstraints() {

        let padding = 5
        let textFieldHeight = 55
        let textAreaHeight = 55 * 3
        let titleLabelHeight = 22

        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        authorLabel.snp_makeConstraints { (make) in
            make.top.equalTo(scrollView.snp_top).offset(padding)
            make.leading.equalTo(scrollView.snp_leading).offset(padding)
            make.height.equalTo(titleLabelHeight)
        }
        authorTextField.snp_makeConstraints { (make) in
            make.top.equalTo(authorLabel.snp_bottom).offset(padding)
            make.leading.equalTo(authorLabel.snp_leading)
            make.width.equalTo(view.snp_width).offset(-padding * 2)
            make.height.equalTo(textFieldHeight)
        }
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(authorTextField.snp_bottom).offset(padding)
            make.leading.equalTo(authorLabel.snp_leading)
            make.height.equalTo(titleLabelHeight)
        }
        titleTextField.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(padding)
            make.leading.equalTo(authorLabel.snp_leading)
            make.trailing.equalTo(authorTextField.snp_trailing)
            make.height.equalTo(textFieldHeight)
        }
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(titleTextField.snp_bottom).offset(padding)
            make.leading.equalTo(authorLabel.snp_leading)
            make.height.equalTo(titleLabelHeight)
        }
        messageTextView.snp_makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp_bottom).offset(padding)
            make.leading.equalTo(authorLabel.snp_leading)
            make.trailing.equalTo(authorTextField.snp_trailing)
            make.height.greaterThanOrEqualTo(textAreaHeight)
            make.bottom.equalTo(scrollView.snp_bottom).offset(-padding)
        }
    }

    // MARK: Binders
    private func bind() {
        authorTextField.racTextChanged().startWithNext { [unowned self] text in
            self.viewModel.author = text ?? ""
        }
        titleTextField.racTextChanged().startWithNext { [unowned self] text in
            self.viewModel.title = text ?? ""
        }
        messageTextView.racTextChanged().startWithNext { [unowned self] text in
            self.viewModel.message = text ?? ""
        }
        viewModel.didSaveReview.observeOn(UIScheduler()).observeNext { [unowned self] review in
            if let _ = review {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                let alert = UIAlertController(title: "Sorry", message: "Could not send it", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        viewModel.didTryToSaveNotValidReview.observeOn(UIScheduler()).observeNext { [unowned self]  in
            let alert = UIAlertController(title: "Sorry", message: "You need to write in all the fields!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @objc private func didTapSave() {
        viewModel.addReview()
    }
}
