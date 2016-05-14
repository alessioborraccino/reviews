//
//  ReviewCellViewModelFactory.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

protocol ReviewCellViewModelFactoryType {
    func model(review review: Review) -> ReviewCellViewModelType
}

struct ReviewCellViewModelFactory: ReviewCellViewModelFactoryType {

    func model(review review: Review) -> ReviewCellViewModelType {
        return ReviewCellViewModel(review: review)
    }
}