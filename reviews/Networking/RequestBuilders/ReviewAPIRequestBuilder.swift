//
//  GetYourGuideRequestBuilder.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Alamofire

enum ReviewAPIRequestBuilder {

    case SearchReviews(city: String, tour: String, count: Int, page: Int)
    case AddReview(city: String, tour: String, author: String, title: String, message: String, rating: Int, date: NSDate, travelerType: TravelerType?)

    func  URLRequest(host host: String) -> NSURLRequest {

        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: host)!.URLByAppendingPathComponent(path()))
        mutableURLRequest.HTTPMethod = "POST"

        switch self {

        case .SearchReviews(_,_, let count, let page):
            let parameters:[String: AnyObject] = [
                "count" : count,
                "page": page,
                "sortBy": "date_of_review",
                "direction": "DESC"]
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            
        case .AddReview(_,_, let author, let title, let message, let rating, let date, let travelerType):
            let travelerTypeTransform = TravelerTypeTransform()
            var parameters:[String: AnyObject] = [
                "author" : author,
                "title": title,
                "message": message,
                "rating": rating,
                "date": DateFormatter.getYourGuideStringFromDate(date),
            ]
            if let travelerTypeString = travelerTypeTransform.transformToJSON(travelerType) {
                parameters["traveler_type"] = travelerTypeString
            }
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        }
    }

    private func path() -> String {
        switch self {
        case .SearchReviews(let city, let tour, _, _):
            return city + "/" + tour + "/" + "reviews.json"
        case .AddReview(let city, let tour, _, _,_,_,_,_):
            return city + "/" + tour + "/" + "addreview.json"
        }
    }
}