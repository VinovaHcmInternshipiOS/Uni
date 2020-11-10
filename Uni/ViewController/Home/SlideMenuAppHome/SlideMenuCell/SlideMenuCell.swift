//
//  SlideMenuCell.swift
//  Uni
//
//  Created by nguyen gia huy on 10/11/2020.
//

import UIKit

class SlideMenuCell: UITableViewCell {

    @IBOutlet weak var viewChoose: UIView!
    @IBOutlet weak var titleFeature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //viewChoose.roundCorners([.topRight,.bottomRight], radius: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
