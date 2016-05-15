//
//  AddReviewViewModelFactory.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

protocol AddReviewViewModelFactoryType {
    func model() -> AddReviewViewModelType
}

struct AddReviewViewModelFactory: AddReviewViewModelFactoryType {

    let reviewAPI : ReviewAPIType

    init(reviewAPI: ReviewAPIType = ReviewAPI()) {
        self.reviewAPI = reviewAPI
    }
    
    func model() -> AddReviewViewModelType {
        return AddReviewViewModel(reviewAPI: reviewAPI)
    }
}