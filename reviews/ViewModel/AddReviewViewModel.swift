//
//  AddReviewViewModel.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import ReactiveCocoa
import Result

protocol AddReviewViewModelType {
    var author: String { get set }
    var title: String  { get set }
    var message: String { get set }
    var rating: Int { get set }

    var didSaveReview : Signal<Review?,NoError> { get }
    var didTryToSaveNotValidReview : Signal<Void,NoError> { get }

    func addReview()
}

class AddReviewViewModel : AddReviewViewModelType {

    // MARK: Dependencies

    private let reviewAPI : ReviewAPIType

    // MARK: Properties

    private var id: Int?
    var author: String = ""
    var title: String = ""
    var message: String = ""
    var rating: Int = 5

    // MARK: Reactive 

    private let (didSaveReviewOrNil, didSaveReviewSink) = Signal<Review?, NoError>.pipe()
    private(set) lazy var didSaveReview : Signal<Review?,NoError> = {
        return self.didSaveReviewOrNil
    }()

    private let (notValidReview, notValidReviewSink) = Signal<Void, NoError>.pipe()
    private(set) lazy var didTryToSaveNotValidReview : Signal<Void,NoError> = {
        return self.notValidReview
    }()

    // MARK: Initializers 

    init(reviewAPI : ReviewAPIType = ReviewAPI()) {
        self.reviewAPI = reviewAPI
    }

    // MARK: Public Methods

    func addReview() {

        guard areFieldsValid() else {
            notValidReviewSink.sendNext()
            return
        }

        let review = reviewForRequest()
        reviewAPI.addReview(review).start { [unowned self] event in
            switch event {
            case .Next(let id):
                let updatedReview = self.updatedReviewFromReview(review, withID: id)
                self.didSaveReviewSink.sendNext(updatedReview)
            case .Failed:
                self.didSaveReviewSink.sendNext(nil)
            default:
                break
            }
        }
    }

    // MARK: Helpers
    
    private func areFieldsValid() -> Bool {
        return !author.isEmpty && !title.isEmpty && !message.isEmpty
    }
    private func reviewForRequest() -> Review {
        return Review(id: 0, title: title, message: message, rating: rating, author: author)
    }
    private func updatedReviewFromReview(review: Review, withID id: Int) -> Review {
        return Review(id: id, title: review.title, message: review.message, rating: review.rating, author: review.author)
    }
}
