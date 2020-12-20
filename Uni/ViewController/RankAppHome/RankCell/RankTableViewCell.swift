//
//  RankTableViewCell.swift
//  Uni
//
//  Created by nguyen gia huy on 05/11/2020.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    @IBOutlet weak var imageRank: UIImageView!
    @IBOutlet weak var lbRank: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageRank.image = AppIcon.icWreathYellow
        lbRank.textColor = AppColor.YellowFAB32A
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData() {
        
    }
    
}
