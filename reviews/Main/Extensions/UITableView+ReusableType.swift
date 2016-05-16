//
//  UITableView+ReusableType.swift
//
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    /**
     Register cells directly using the class name as identifier

     parameters:
     - Class type
     */

    func registerCell<T: UITableViewCell where T: ReusableType>(_: T.Type) {
        registerClass(T.self, forCellReuseIdentifier: T.identifierForReuse)
    }

    /**
     Dequeue strongly typed cell directly

     returns:
     - Strongly typed cell
     */

    func dequeueReusableCell<T: UITableViewCell where T: ReusableType>() -> T {
        guard let cell = dequeueReusableCellWithIdentifier(T.identifierForReuse) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifierForReuse)")
        }
        return cell
    }
}