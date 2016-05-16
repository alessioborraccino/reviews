//
//  MessageCellViewModel.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

// MARK: MessageCellState 

enum MessageCellState : CustomStringConvertible, Equatable {
    case WaitingToLoad
    case Loading
    case NoConnection
    case NoConnectionCached
    case APIError(message: String)

    var description: String {
        switch self {
        case .WaitingToLoad:
            return "Load new results"
        case .Loading:
            return "Loading..."
        case .NoConnection:
            return "No Connection. Try again"
        case .NoConnectionCached:
            return "No Connection. Reviews might not be up to date"
        case .APIError(let message):
            return message
        }
    }
}

// MARK: MessageCellState Equatable

func ==(lhs: MessageCellState, rhs: MessageCellState) -> Bool {
    switch (lhs, rhs) {

    case (.WaitingToLoad, .WaitingToLoad),
         (.NoConnection, .NoConnection),
         (.Loading, .Loading),
         (.NoConnectionCached, .NoConnectionCached):
        return true
    case  (.APIError(let messageLhs),.APIError(let messageRhs)):
        return messageLhs == messageRhs
    default:
        return false
    }
}

// MARK: MessageCellViewModel

protocol MessageCellViewModelType {
    var message : String { get }
    var isLoading : Bool { get }
}

class MessageCellViewModel : MessageCellViewModelType {

    let message : String
    let isLoading : Bool

    init(state: MessageCellState) {
        self.message = state.description
        self.isLoading = state == .Loading
    }
}