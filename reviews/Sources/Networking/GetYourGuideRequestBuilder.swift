//
//  GetYourGuideRequestBuilder.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Alamofire


enum GetYourGuideRequestBuilder {
    case Reviews(city: String, tour: String, count: Int, page: Int)

    func  URLRequest(host host: String) -> NSURLRequest {

        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: host)!.URLByAppendingPathComponent(path()))
        mutableURLRequest.HTTPMethod = "POST"

        switch self {
        case .Reviews(_,_, let count, let page):
            let parameters:[String: AnyObject] = [
                "count" : count,
                "page": page,
                "sortBy": "date_of_review",
                "direction": "DESC"]
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        }
    }

    func path() -> String {
        switch self {
        case .Reviews(let city, let tour, _, _):
            return city + "/" + tour + "/" + "reviews.json"
        }
    }
}