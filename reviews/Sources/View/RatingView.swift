//
//  RatingView.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit
import SnapKit

class RatingView : UIView {

    let stars : [UIImageView]

    init(totalRating: Int) {
        var starArray = [UIImageView]()
        for _ in 0..<totalRating {
            let starView = UIImageView(image: UIImage(named: "star"))
            starView.contentMode = .ScaleAspectFit
            starArray.append(starView)
        }
        self.stars = starArray
        super.init(frame: CGRectZero)
        for star in stars {
            star.contentMode = .ScaleAspectFit
            addSubview(star)
        }
        setDefaultConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setDefaultConstraints() {

        let padding = 10

        var previousStar : UIImageView?
        for star in stars {
            star.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(snp_centerY)
                if let previousStar = previousStar {
                    make.left.equalTo(previousStar.snp_right).offset(padding)
                } else {
                    make.left.equalTo(snp_left)
                }
                previousStar = star
            })
        }
    }

    func configureWithRating(rating: Int) {
        for (index, star) in stars.enumerate() {
            if (index + 1) <= rating {
                star.tintColor = AppColor.main
            } else {
                star.tintColor = AppColor.main.colorWithAlphaComponent(0.5)
            }
        }
    }
}
