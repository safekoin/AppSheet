//
//  ObjectTableCell.swift
//  AppSheetDemo
//
//  Created by mac on 9/7/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class PersonTableCell: UITableViewCell {

    //person object with property observer to configure cell
    var person: Person! {
        didSet {
            personNameLabel.text = person.name
            personNumberLabel.text = person.number
            personAgeLabel.text = "\(person.age) Years Old"
        }
    }

    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personNumberLabel: UILabel!
    @IBOutlet weak var personAgeLabel: UILabel!
    
    static let identifier = "PersonTableCell"
    
}
