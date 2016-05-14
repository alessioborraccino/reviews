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

    private lazy var reviewsViewModel = ReviewsViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ReviewCell.self)
        tableView.registerCell(MessageCell.self)
        tableView.backgroundColor = UIColor.lightGrayColor()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        view.addSubview(tableView)
        setDefaultConstraints()
        bind()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reviewsViewModel.loadReviews()
    }
    private func setDefaultConstraints() {
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }

    private func bind() {

        let updateReviewsSignal = zip([
            reviewsViewModel.needsToInsertCellsAtIndexPaths,
            reviewsViewModel.needsToDeleteCellsAtIndexPaths,
            reviewsViewModel.needsToUpdateCellsAtIndexPaths
            ])
        
        updateReviewsSignal.observeOn(UIScheduler()).startWithNext { [unowned self] paths in
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(paths[0], withRowAnimation: .Fade)
            self.tableView.deleteRowsAtIndexPaths(paths[1], withRowAnimation: .Fade)
            self.tableView.reloadRowsAtIndexPaths(paths[2], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
        reviewsViewModel.needsToReloadMessage.observeOn(UIScheduler()).startWithNext { [unowned self] in
            self.tableView.reloadSections(NSIndexSet(index: ReviewTableSection.Message.rawValue), withRowAnimation: .None)
        }
    }
}

extension ReviewsViewController {

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
            return 200
        case .Message:
            return 100
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
            (cell as! MessageCell).bind(viewModel: messageCellViewModel)
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
}

