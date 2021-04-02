//
//  NoteCellTableViewCell.swift
//  CategorizeNote
//
//  Created by Yoan on 26/03/2021.
//

import UIKit

class NoteCellTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func noteButton() {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure (title: String, description: String, date: Date) {
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
    }
   

}
