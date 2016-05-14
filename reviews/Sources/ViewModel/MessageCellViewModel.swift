//
//  MessageCellViewModel.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

class MessageCellViewModel {

    enum MessageCellState : CustomStringConvertible {
        case NoReviewsAvailable
        case NoConnection
        case WaitingToLoad
        case Loading
        case NoMoreReviews
        case Cached

        var description: String {
            switch self {
            case .NoReviewsAvailable:
                return "No Reviews Available"
            case .WaitingToLoad:
                return "Load new results"
            case .Loading:
                return "Loading..."
            case .NoMoreReviews:
                return "No More Reviews Available"
            case .NoConnection:
                return "No Internet Connection"
            case .Cached:
                return "Reviews might not be up to date"
            }
        }
    }

    let message : String

    init(state: MessageCellState) {
        self.message = state.description
    }
}