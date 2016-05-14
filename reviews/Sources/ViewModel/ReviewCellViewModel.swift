//
//  ReviewCellViewModel.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

class ReviewCellViewModel {

    let title : String
    let message : String 

    init(review: Review) {
        self.title = review.title
        self.message = review.message
    }
}