//
//  UITableView+ReusableType.swift
//
//
//  Created by Alessio Borraccino on 27.04.16.
//  Copyright © 2016 Mediteo. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  
  func registerCell<T: UITableViewCell where T: ReusableType>(_: T.Type) {
    registerClass(T.self, forCellReuseIdentifier: T.identifierForReuse)
  }
  
  func dequeueReusableCell<T: UITableViewCell where T: ReusableType>() -> T {
    guard let cell = dequeueReusableCellWithIdentifier(T.identifierForReuse) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.identifierForReuse)")
    }
    
    return cell
  }
}