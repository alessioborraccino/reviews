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
    func addReviewViewModel() -> AddReviewViewModelType
}

class ReviewsViewModel : ReviewsViewModelType {

    // MARK: Constants

    private struct Constants {
        static let reviewsPerPage = 10
    }

    // MARK: Dependencies

    private let reviewEntityManager : ReviewEntityManagerType
    private let reviewAPI : ReviewAPIType
    private let reviewCellViewModelFactory : ReviewCellViewModelFactoryType
    private let messageCellViewModelFactory : MessageCellViewModelFactoryType
    private let addReviewViewModelFactory : AddReviewViewModelFactoryType

    // MARK: Reactive Model Properties

    private var showForeignLanguage = true

    private var reviews = MutableProperty<[Review]>([])
    private var messageCellState = MutableProperty<MessageCellState>(.WaitingToLoad)

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

    // MARK: Initializer

    init(reviewEntityManager: ReviewEntityManagerType = ReviewEntityManager(),
         reviewAPI: ReviewAPIType = ReviewAPI(),
         reviewCellViewModelFactory: ReviewCellViewModelFactoryType = ReviewCellViewModelFactory(),
         messageCellViewModelFactory: MessageCellViewModelFactoryType = MessageCellViewModelFactory(),
         addReviewViewModelFactory: AddReviewViewModelFactoryType = AddReviewViewModelFactory()
        ) {
        self.reviewEntityManager = reviewEntityManager
        self.reviewAPI = reviewAPI
        self.reviewCellViewModelFactory = reviewCellViewModelFactory
        self.messageCellViewModelFactory = messageCellViewModelFactory
        self.addReviewViewModelFactory = addReviewViewModelFactory

        self.reviews.value = self.reviewEntityManager.allReviews()
    }

    // MARK: Public Methods

    func loadReviews() {
        searchReviews(perPageNumber: self.currentReviewPages())
    }
    func cacheReviews() {
        self.reviewEntityManager.cacheReviews(self.reviews.value)
    }
    func showForeignLanguageReviews(show: Bool) {
        self.showForeignLanguage = show
        self.refreshIndexPaths()
    }
    func reviewCellViewModelForIndex(index: Int) -> ReviewCellViewModelType {
        return reviewCellViewModelFactory.model(review: filteredReviews(reviews.value)[index])
    }
    func messageCellViewModel() -> MessageCellViewModelType {
        return messageCellViewModelFactory.model(state: messageCellState.value)
    }
    func addReviewViewModel() -> AddReviewViewModelType {
        let addReviewViewModel = addReviewViewModelFactory.model()
        addReviewViewModel.didSaveReview.observeNext { review in
            if let review = review {
                self.updateAndSortReviewsWithNewReviews([review])
            }
        }
        return addReviewViewModel
    }
    // MARK: Private Methods

    private func refreshIndexPaths() {
        // Triggers Tableview Reload
        self.reviews.value = self.reviews.value
    }
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

    private func currentReviewPages() -> Int {
        return reviews.value.count / Constants.reviewsPerPage
    }

    private func searchReviews(numberOfReviews count: Int = Constants.reviewsPerPage, perPageNumber pageNumber: Int) {

        messageCellState.value = .Loading

        reviewAPI.reviews(count: count, pageNumber: pageNumber).start { [unowned self] event in
            switch event {
            case .Next(let reviews):
                self.updateAndSortReviewsWithNewReviews(reviews)
                self.messageCellState.value = .WaitingToLoad
            case .Failed(let error):
                self.updateMessageCellStateWithError(error, isTableEmpty: self.reviews.value.isEmpty)
            default:
                break
            }
        }
    }

    private func updateAndSortReviewsWithNewReviews(reviews: [Review]) {
        var newReviews = self.reviews.value
        newReviews.appendContentsOf(reviews)
        newReviews.sortInPlace { (first, second) -> Bool in
            return first.reviewID > second.reviewID
        }
        self.reviews.value = newReviews
    }

    private func updateMessageCellStateWithError(error: ReviewAPIError, isTableEmpty: Bool) {
        switch error {
        case .NetworkFailed, .ParsingFailed:
            if isTableEmpty {
                self.messageCellState.value = .NoConnection
            } else {
                self.messageCellState.value = .NoConnectionCached
            }
        case .APIError(let message):
            self.messageCellState.value = .APIError(message: message)
        }
    }
}