//
//  ReviewAPI.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Alamofire
import ObjectMapper
import ReactiveCocoa
import Result 

enum ReviewAPIError : ErrorType {
    case ParsingFailed
    case NetworkFailed
    case APIError(message: String)
}

protocol ReviewAPIType {
    func reviews(count count: Int, pageNumber: Int) -> SignalProducer<[Review],ReviewAPIError>
    func addReview(review: Review) -> SignalProducer<Int,ReviewAPIError>
}

class ReviewAPI : ReviewAPIType {

    //MARK : Constants

    private let host : String = "https://www.getyourguide.com"
    private let city : String = "berlin-l17"
    private let tour : String = "tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776"

    // MARK: Dependencies

    private let reviewEntityManager : ReviewEntityManagerType

    init(reviewEntityManager: ReviewEntityManagerType = ReviewEntityManager()) {
        self.reviewEntityManager = reviewEntityManager
    }

    // MARK: Public Methods
    func reviews(count count: Int, pageNumber: Int) -> SignalProducer<[Review],ReviewAPIError> {

        return SignalProducer { observer, disposable in

            let request = ReviewAPIRequestBuilder.Reviews(
                city: self.city,
                tour: self.tour,
                count: count,
                page: pageNumber).URLRequest(host: self.host)

            Alamofire.request(request).validate().responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in

                if let _ = response.result.error {
                    observer.sendFailed(.NetworkFailed)
                } else if let success = Mapper<ReviewSuccessResponse>().map(response.result.value), reviews = success.reviews {
                    observer.sendNext(reviews)
                } else if let error = Mapper<ReviewErrorResponse>().map(response.result.value), message = error.message {
                    observer.sendFailed(.APIError(message: message))
                } else {
                    observer.sendFailed(.ParsingFailed)
                }
                observer.sendCompleted()
            })
        }
    }
    func addReview(review: Review) -> SignalProducer<Int,ReviewAPIError> {

        return SignalProducer { [unowned self] observer, disposable in

            let _ = ReviewAPIRequestBuilder.AddReview(
                city: self.city,
                tour: self.tour,
                author: review.author,
                title: review.title, 
                message: review.message,
                rating: review.rating,
                date: NSDate(),
                travelerType: review.travelerType
             ).URLRequest(host: self.host)

            //Should send request to backend, which will return the id for the review 

            //Request should be for example: 
            //https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/addreview.json?author=alessio&title=super&message=super&rating=5&type=solo&date_of_review=date

            //Response would be as a json for example:
            // {
            //    "review_id" : 456
            // }

            let id = self.reviewEntityManager.maxReviewID() + 1 //Should be managed by backend
            observer.sendNext(id)
            observer.sendCompleted()
        }
    }
}