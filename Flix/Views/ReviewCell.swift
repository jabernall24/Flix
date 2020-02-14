//
//  ReviewCell.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 2/13/20.
//  Copyright © 2020 Jesus Bernal Lopez. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    var review: Review! {
        didSet {
            authorLabel.text = review.author
            commentLabel.text = review.content
        }
    }
}
