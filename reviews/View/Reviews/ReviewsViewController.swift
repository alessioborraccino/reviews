//
//  ReviewsViewController.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import ReactiveCocoa

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: ViewModel 

    private let reviewsViewModel : ReviewsViewModelType

    // MARK: SubViews 

    private lazy var foreignLanguageFilterSwitch : FilterSwitchView =  {
        let filterSwitch = FilterSwitchView()
        filterSwitch.configureWithTitle("Only from your country")
        return filterSwitch
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ReviewCell.self)
        tableView.registerCell(MessageCell.self)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .SingleLine
        return tableView
    }()

    // MARK: Initializers

    init(reviewsViewModel: ReviewsViewModelType) {
        self.reviewsViewModel = reviewsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Methods 

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviews"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(didTapAdd))
        view.addSubview(tableView)
        view.addSubview(foreignLanguageFilterSwitch)
        setDefaultConstraints()
        bind()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (reviewsViewModel.reviewsCount == 0) {
            reviewsViewModel.loadReviews()
        }
    }

    private func setDefaultConstraints() {
        foreignLanguageFilterSwitch.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.leading.equalTo(view.snp_leading)
            make.trailing.equalTo(view.snp_trailing)
            make.height.equalTo(66)
        }

        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(foreignLanguageFilterSwitch.snp_bottom)
            make.leading.equalTo(view.snp_leading)
            make.trailing.equalTo(view.snp_trailing)
            make.bottom.equalTo(view.snp_bottom)
        }
    }

    // MARK: Binders 
    
    private func bind() {
        let updateReviewsSignal = zip([
            reviewsViewModel.needsToInsertReviewsAtIndexPaths,
            reviewsViewModel.needsToUpdateReviewsAtIndexPaths,
            reviewsViewModel.needsToDeleteReviewsAtIndexPaths
        ])
        updateReviewsSignal.observeOn(UIScheduler()).observeNext { [unowned self] paths in
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(paths[0], withRowAnimation: .Fade)
            self.tableView.reloadRowsAtIndexPaths(paths[1], withRowAnimation: .Fade)
            self.tableView.deleteRowsAtIndexPaths(paths[2], withRowAnimation: .Fade)
            self.tableView.endUpdates()
            self.reviewsViewModel.cacheReviews()
        }
        reviewsViewModel.needsToReloadMessage.observeOn(UIScheduler()).observeNext{ [unowned self] in
            self.tableView.reloadSections(NSIndexSet(index: ReviewTableSection.Message.rawValue), withRowAnimation: .None)
        }
        foreignLanguageFilterSwitch.didChangeSwitchTo.startWithNext{ [unowned self] on in
            self.reviewsViewModel.showForeignLanguageReviews(!on)
        }
    }

    @objc private func didTapAdd() {
        let addReviewViewController = AddReviewViewController(addReviewViewModel: reviewsViewModel.addReviewViewModel())
        navigationController?.pushViewController(addReviewViewController, animated: true)
    }
}

extension ReviewsViewController {

    //MARK: TableView Methods

    enum ReviewTableSection : Int {
        case Reviews
        case Message

        static func all() -> [ReviewTableSection] {
            return [.Reviews, .Message]
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ReviewTableSection.all().count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ReviewTableSection(rawValue: section)! {
        case .Reviews:
            return reviewsViewModel.reviewsCount
        case .Message:
            return 1
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch ReviewTableSection(rawValue: indexPath.section)! {
        case .Reviews:
            return ReviewCell.heightWithViewModel(reviewsViewModel.reviewCellViewModelForIndex(indexPath.row))
        case .Message:
            return MessageCell.height()
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch ReviewTableSection(rawValue: indexPath.section)! {
        case .Reviews:
            let reviewCell: ReviewCell = tableView.dequeueReusableCell()
            return reviewCell
        case .Message:
            let messageCell: MessageCell = tableView.dequeueReusableCell()
            return messageCell
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch ReviewTableSection(rawValue: indexPath.section)! {
        case .Reviews:
            let reviewCellViewModel = reviewsViewModel.reviewCellViewModelForIndex(indexPath.row)
            (cell as! ReviewCell).bind(reviewCellViewModel)
        case .Message:
            let messageCellViewModel = reviewsViewModel.messageCellViewModel()
            (cell as! MessageCell).bind(messageCellViewModel: messageCellViewModel)
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch ReviewTableSection(rawValue: indexPath.section)! {
        case .Message:
            reviewsViewModel.loadReviews()
        default:
            break 
        }
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let lastVisibleCell = tableView.visibleCells.last
        let path = tableView.indexPathForCell(lastVisibleCell!)
        if path?.section == 1 {
            reviewsViewModel.loadReviews()
        }
    }
}

