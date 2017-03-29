//
//  PersonCell.swift
//  RealmSwiftApp
//
//  Created by Roman Rybachenko on 3/27/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell, ReusableCell {
    
    // MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var additionalLabel: UILabel!
    
    // MARK: Properties
    var person: Person? {
        didSet {
            if let p = person {
                nameLabel.text = p.name
                ageLabel.text = SharedDateFormatter.dateFormatter.stringFromDate(date: p.birthday!,
                                                                                 format: birthdayDateFormat)
                genderLabel.text = p.gender?.stringValue()
                
                if let pair = p.pair {
                    additionalLabel.text = "In relationship with: \(pair.name!)"
                } else {
                    additionalLabel.text = ""
                }
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // MARK: —ReusableCell
    static func height() -> CGFloat {
        return 87
    }
}
