//
//  MessageCellViewModelFactory.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

protocol MessageCellViewModelFactoryType {
    func model(state state: MessageCellState) -> MessageCellViewModelType
}

struct MessageCellViewModelFactory: MessageCellViewModelFactoryType {

    func model(state state: MessageCellState) -> MessageCellViewModelType {
        return MessageCellViewModel(state: state)
    }
}