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

    var needsToInsertReviewsAtIndexPaths : Signal<[NSIndexPath],NoError> { get }
    var needsToUpdateReviewsAtIndexPaths : Signal<[NSIndexPath],NoError> { get }
    var needsToDeleteReviewsAtIndexPaths : Signal<[NSIndexPath],NoError> { get }
    var needsToReloadMessage : Signal<Void,NoError> { get }

    var reviewsCount : Int { get }
    func showForeignLanguageReviews(show: Bool)
    func loadReviews()
    func cacheReviews()
    
    func reviewCellViewModelForIndex(index: Int) -> ReviewCellViewModelType
    func messageCellViewModel() -> MessageCellViewModelType
}

class ReviewsViewModel : ReviewsViewModelType {

    // MARK: Constants

    private struct Constants {
        static let reviewsPerPage = 5
    }

    // MARK: Dependencies

    private let reviewEntityManager : ReviewEntityManagerType
    private let reviewAPI : ReviewAPIType
    private let reviewCellViewModelFactory : ReviewCellViewModelFactoryType
    private let messageCellViewModelFactory : MessageCellViewModelFactoryType

    // MARK: Model Properties

    private var reviews = MutableProperty<[Review]>([])
    private var messageCellState = MutableProperty<MessageCellState>(.WaitingToLoad)
    private var showForeignLanguage = true

    init(reviewEntityManager: ReviewEntityManagerType = ReviewEntityManager(),
         reviewAPI: ReviewAPIType = ReviewAPI(),
         reviewCellViewModelFactory: ReviewCellViewModelFactoryType = ReviewCellViewModelFactory(),
         messageCellViewModelFactory: MessageCellViewModelFactoryType = MessageCellViewModelFactory()
        ) {
        self.reviewEntityManager = reviewEntityManager
        self.reviewAPI = reviewAPI
        self.reviewCellViewModelFactory = reviewCellViewModelFactory
        self.messageCellViewModelFactory = messageCellViewModelFactory
    }

    var reviewsCount : Int {
        return self.filteredReviews(reviews.value).count
    }

    lazy var needsToInsertReviewsAtIndexPaths : Signal<[NSIndexPath],NoError> = {
        return self.reviews.signal.map { reviews in
            return self.filteredReviews(reviews)
        }.combinePrevious([]).map { previousReviews, newReviews in
            return newReviews.enumerate().filter { (index, _) in
                return index >= previousReviews.count
            }.map { (index,_) in
                return NSIndexPath(forRow: index, inSection: 0)
            }
        }
    }()

    lazy var needsToUpdateReviewsAtIndexPaths : Signal<[NSIndexPath],NoError> = {
        return self.reviews.signal.map { reviews in
            return self.filteredReviews(reviews)
        }.combinePrevious([]).map { previousReviews, newReviews in
            return newReviews.enumerate().filter { (index, _) in
                return index < previousReviews.count
            }.flatMap { (index,review) in
                if review == previousReviews[index] {
                    return nil 
                }
                return NSIndexPath(forRow: index, inSection: 0)
            }
        }
    }()
    lazy var needsToDeleteReviewsAtIndexPaths : Signal<[NSIndexPath],NoError> = {
        return self.reviews.signal.map { reviews in
            return self.filteredReviews(reviews)
        }.combinePrevious([]).map { previousReviews, newReviews in
            let newReviewsCount = newReviews.count
            return previousReviews.enumerate().filter { (index,_) in
                return index >= newReviewsCount
            }.map { (index,_) in
                return NSIndexPath(forRow: index, inSection: 0)
            }
        }
    }()

    lazy var needsToReloadMessage : Signal<Void,NoError> = {
        return self.messageCellState.signal.skipRepeats().map({ (state) -> Void in
            return
        })
    }()

    // MARK: Public Methods

    func loadReviews() {
        let areShownReviewsCached = self.messageCellState.value == .NoConnectionCached
        loadNextReviews(refreshExistingReviews: areShownReviewsCached)
    }
    func cacheReviews() {
        self.reviewEntityManager.cacheReviews(self.reviews.value)
    }
    func showForeignLanguageReviews(show: Bool) {
        self.showForeignLanguage = show 
        self.reviews.value = self.reviews.value
    }
    func reviewCellViewModelForIndex(index: Int) -> ReviewCellViewModelType {
        return reviewCellViewModelFactory.model(review: filteredReviews(reviews.value)[index])
    }
    func messageCellViewModel() -> MessageCellViewModelType {
        return messageCellViewModelFactory.model(state: messageCellState.value)
    }

    // MARK: Private Methods

    private func filteredReviews(reviews: [Review]) -> [Review] {
       return reviews.filter { review in
            self.isValidLanguage(review: review)
        }
    }

    private func isValidLanguage(review review: Review) -> Bool {

        if showForeignLanguage {
            return true
        } else {
            let isForeignLanguageFromRequest = review.isForeignLanguage
            let isForeignLanguageFromLanguageCode = review.languageCode != NSLocale.preferredLanguageCode()
            let reviewIsForeignLanguage = isForeignLanguageFromRequest || isForeignLanguageFromLanguageCode
            return !reviewIsForeignLanguage
        }
    }

    private func loadNextReviews(refreshExistingReviews refreshExistingReviews: Bool) {
        if refreshExistingReviews {
            searchReviews(numberOfReviews: self.reviews.value.count + Constants.reviewsPerPage, perPageNumber: 0)
        } else {
            searchReviews(perPageNumber: self.currentReviewPages())
        }
    }

    private func currentReviewPages() -> Int {
        return reviews.value.count / Constants.reviewsPerPage
    }

    private func searchReviews(numberOfReviews count: Int = Constants.reviewsPerPage, perPageNumber pageNumber: Int) {

        messageCellState.value = .Loading

        reviewAPI.reviews(count: count, pageNumber: pageNumber).start { [unowned self] event in
            switch event {
            case .Next(let reviews):
                self.updateReviewsWithNewReviews(reviews, isFirstPage: pageNumber == 0)
                self.messageCellState.value = .WaitingToLoad
            case .Failed(let error):
                let cachedReviews = self.reviewEntityManager.allReviews()
                self.updateReviewsWithNewReviews(cachedReviews, isFirstPage: true)
                self.updateMessageCellStateWithError(error, isShowingCachedReviews: !cachedReviews.isEmpty)
            default:
                break
            }
        }
    }

    private func updateReviewsWithNewReviews(reviews: [Review], isFirstPage: Bool) {
        var newReviews : [Review]
        if isFirstPage {
            newReviews = []
        } else {
            newReviews = self.reviews.value
        }
        newReviews.appendContentsOf(reviews)
        self.reviews.value = newReviews
    }

    private func updateMessageCellStateWithError(error: ReviewAPIError, isShowingCachedReviews: Bool) {
        switch error {
        case .NetworkFailed, .ParsingFailed:
            if !isShowingCachedReviews {
                self.messageCellState.value = .NoConnection
            } else {
                self.messageCellState.value = .NoConnectionCached
            }
        case .APIError(let message):
            self.messageCellState.value = .APIError(message: message)
        }
    }
}