//
//  GetYourGuideAPI.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ReactiveCocoa
import Result 

class GetYourGuideAPI {

    enum ReviewError : ErrorType {
        case Unknown
        case ParsingFailed
        case NetworkFailed
    }

    private let host : String = "https://www.getyourguide.com"
    private let city : String = "berlin-l17"
    private let tour : String = "tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776"

    func reviews(count count: Int, pageNumber: Int) -> SignalProducer<[Review],ReviewError> {

        return SignalProducer { observer, disposable in

            let request = GetYourGuideRequestBuilder.Reviews(city: self.city,
                tour: self.tour,
                count: count,
                page: pageNumber).URLRequest(host: self.host)

            Alamofire.request(request).responseArray(queue: dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), keyPath: "data") { (response : Response<[Review], NSError>) in

                if let error = response.result.error {
                    if error.domain == NSURLErrorDomain {
                        observer.sendFailed(.NetworkFailed)
                    } else {
                        observer.sendFailed(.Unknown)
                    }
                    print(error)
                } else {
                    if let value = response.result.value {
                        observer.sendNext(value)

                    } else {
                        observer.sendFailed(.ParsingFailed)
                    }
                }
                observer.sendCompleted()
            }
        }
    }
}