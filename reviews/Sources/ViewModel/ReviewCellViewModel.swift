//
//  ReviewCellViewModel.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

protocol ReviewCellViewModelType {
    var title : String { get }
    var message : String { get }
    var footer : String { get }
    var rating : Int { get }
}

class ReviewCellViewModel : ReviewCellViewModelType {

    let title : String
    let message : String 
    let footer : String
    let rating : Int

    init(review: Review) {
        self.title = review.title
        self.message = review.message
        self.footer = review.author + "-" + review.date
        self.rating = review.rating 
    }
}