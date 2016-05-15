//
//  AddReviewViewModel.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import ReactiveCocoa
import Result

class AddReviewViewModel {

    private let reviewEntityManager : ReviewEntityManagerType
    private let reviewAPI : ReviewAPIType

    private var id: Int?
    var author: String = ""
    var title: String = ""
    var message: String = ""
    var rating: Int = 5

    private var review : Review?

    lazy var didSaveReviewSuccessfully : Signal<Bool,NoError> = {
        return self.didSaveReview
    }()

    private let (didSaveReview, didSaveReviewSink) = Signal<Bool, NoError>.pipe()

    init(reviewEntityManager: ReviewEntityManagerType = ReviewEntityManager(),
         reviewAPI : ReviewAPIType = ReviewAPI()) {
        self.reviewEntityManager = reviewEntityManager
        self.reviewAPI = reviewAPI
    }

    func addReview() {

        guard !author.isEmpty && !title.isEmpty && !message.isEmpty else {
            didSaveReviewSink.sendNext(false)
            return
        }

        let review = reviewForRequest()
        reviewAPI.addReview(review).start { [unowned self] event in
            switch event {
            case .Next(let id):
                let updatedReview = self.updatedReviewFromReview(review, withID: id)
                self.review = updatedReview
                self.didSaveReviewSink.sendNext(true)
            case .Failed:
                self.didSaveReviewSink.sendNext(false)
            default:
                break
            }
        }
    }

    func cacheReview() {
        if let review = review {
            self.reviewEntityManager.cacheReviews([review])
        }
    }
    private func reviewForRequest() -> Review {
        return Review(id: 0, title: title, message: message, rating: rating, author: author)
    }
    private func updatedReviewFromReview(review: Review, withID id: Int) -> Review {
        return Review(id: id, title: review.title, message: review.message, rating: review.rating, author: review.author)
    }
}
