//
//  ReviewCellViewModel.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import ReactiveCocoa
import Result

protocol ReviewsViewModelType {

    var needsToInsertReviewsAtIndexPaths : SignalProducer<[NSIndexPath],NoError> { get }
    var needsToUpdateReviewsAtIndexPaths : SignalProducer<[NSIndexPath],NoError> { get }
    var needsToDeleteReviewsAtIndexPaths : SignalProducer<[NSIndexPath],NoError> { get }
    var needsToReloadMessage : SignalProducer<Void,NoError> { get }

    var reviewsCount : Int { get }
    func loadReviews()

    func reviewCellViewModelForIndex(index: Int) -> ReviewCellViewModelType
    func messageCellViewModel() -> MessageCellViewModelType
}

class ReviewsViewModel : ReviewsViewModelType {

    // MARK: Constants

    private struct Constants {
        static let reviewsPerPage = 30
    }

    // MARK: Dependencies

    private let reviewEntityManager : ReviewEntityManagerType
    private let reviewAPI : ReviewAPIType
    private let reviewCellViewModelFactory : ReviewCellViewModelFactoryType
    private let messageCellViewModelFactory : MessageCellViewModelFactoryType

    // MARK: Model Properties

    private var reviews = MutableProperty<[Review]>([])
    private var messageCellState = MutableProperty<MessageCellState>(.WaitingToLoad)
    private var currentReviewPages = 0

    init(reviewEntityManager: ReviewEntityManager = ReviewEntityManager(),
         reviewAPI: ReviewAPIType = ReviewAPI(),
         reviewCellViewModelFactory: ReviewCellViewModelFactoryType = ReviewCellViewModelFactory(),
         messageCellViewModelFactory: MessageCellViewModelFactoryType = MessageCellViewModelFactory()
        ) {
        self.reviewEntityManager = reviewEntityManager
        self.reviewAPI = reviewAPI
        self.reviewCellViewModelFactory = reviewCellViewModelFactory
        self.messageCellViewModelFactory = messageCellViewModelFactory
        bindPageNumberToNumberOfReviews()
    }

    var reviewsCount : Int {
        return reviews.value.count
    }

    lazy var needsToInsertReviewsAtIndexPaths : SignalProducer<[NSIndexPath],NoError> = {
        return self.reviews.producer.combinePrevious([]).map { previousReviews, totalReviews in
            return totalReviews.enumerate().filter { (index, review) in
                return index >= previousReviews.count
            }.map { (index,review) in
                return NSIndexPath(forRow: index, inSection: 0)
            }
        }
    }()
    lazy var needsToUpdateReviewsAtIndexPaths : SignalProducer<[NSIndexPath],NoError> = {
        return self.reviews.producer.combinePrevious([]).map { previousReviews, totalReviews in
            return totalReviews.enumerate().filter { (index, review) in
                return index < previousReviews.count
            }.flatMap { (index,review) in
                if review == previousReviews[index] {
                    return nil 
                }
                return NSIndexPath(forRow: index, inSection: 0)
            }
        }
    }()
    lazy var needsToDeleteReviewsAtIndexPaths : SignalProducer<[NSIndexPath],NoError> = {
        return self.reviews.producer.combinePrevious([]).map { previousReviews, totalReviews in
            return previousReviews.enumerate().filter { (index, review) in
                return index >= totalReviews.count
                }.map { (index,review) in
                    return NSIndexPath(forRow: index, inSection: 0)
            }
        }
    }()

    lazy var needsToReloadMessage : SignalProducer<Void,NoError> = {
        return self.messageCellState.producer.skipRepeats().map({ (state) -> Void in
            return
        })
    }()

    // MARK: Public Methods

    func loadReviews() {
        let areShownReviewsCached = self.messageCellState.value == .Cached
        loadNextReviews(refreshExistingReviews: areShownReviewsCached)
    }
    func reviewCellViewModelForIndex(index: Int) -> ReviewCellViewModelType {
        return reviewCellViewModelFactory.model(review: reviews.value[index])
    }
    func messageCellViewModel() -> MessageCellViewModelType {
        return messageCellViewModelFactory.model(state: messageCellState.value)
    }

    // MARK: Private Methods

    private func bindPageNumberToNumberOfReviews() {
        reviews.producer.startWithNext { [unowned self] (reviews) in
            self.currentReviewPages = reviews.count / Constants.reviewsPerPage
        }
    }
    private func loadNextReviews(refreshExistingReviews refreshExistingReviews: Bool) {
        if refreshExistingReviews {
            addReviews(numberOfReviews: self.reviews.value.count + Constants.reviewsPerPage, perPageNumber: 0)
        } else {
            addReviews(perPageNumber: self.currentReviewPages)
        }
    }

    private func addReviews(numberOfReviews count: Int = Constants.reviewsPerPage, perPageNumber pageNumber: Int) {

        messageCellState.value = .Loading

        reviewAPI.reviews(count: count, pageNumber: pageNumber).start { [unowned self] event in
            switch event {
            case .Next(let reviews):
                let isFirstPage = pageNumber == 0
                self.updateModelsWithNewReviews(reviews, isFirstPage: isFirstPage)
            case .Failed(let error):
                self.updateModelsWithError(error)
            default:
                break
            }
        }
    }

    private func updateModelsWithNewReviews(reviews: [Review], isFirstPage: Bool) {
        var totalReviews : [Review]
        if isFirstPage {
            totalReviews = []
        } else {
            totalReviews = self.reviews.value
        }
        totalReviews.appendContentsOf(reviews)

        self.reviews.value = totalReviews
        self.messageCellState.value = .WaitingToLoad
        cacheReviews(totalReviews)
    }

    private func cacheReviews(reviews: [Review]) {
        dispatch_async(dispatch_get_main_queue(), { [unowned self] in
            do {
                //TODO better caching
                try self.reviewEntityManager.saveContentsOf(reviews)
                try self.reviewEntityManager.deleteReviewsNotContainedIn(reviews)
            } catch {
                print("error")
            }
        })
    }

    private func updateModelsWithError(error: ReviewAPIError) {
        switch error {
        case .NetworkFailed, .ParsingFailed:
            dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                let cachedReviews = self.reviewEntityManager.all()
                if cachedReviews.isEmpty {
                    self.messageCellState.value = .NoConnection
                } else {
                    self.reviews.value = cachedReviews
                    self.messageCellState.value = .Cached
                }
                })
        case .APIError(let message):
            self.messageCellState.value = .APIError(message: message)
        }
    }
}