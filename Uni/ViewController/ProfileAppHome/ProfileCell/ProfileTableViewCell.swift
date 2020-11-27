//
//  ProfileTableViewCell.swift
//  Uni
//
//  Created by nguyen gia huy on 19/11/2020.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lbTitle.textColor = AppColor.YellowFAB32A
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupTitle(title: String){
        lbTitle.text = title
    }
}
