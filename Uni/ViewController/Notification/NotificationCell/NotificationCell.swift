//
//  NotificationCell.swift
//  Uni
//
//  Created by nguyen gia huy on 25/12/2020.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewState.backgroundColor = AppColor.YellowFAB32A
        lbDate.textColor = AppColor.YellowFBC459
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
