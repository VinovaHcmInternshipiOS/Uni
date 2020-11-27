//
//  SemesterCell.swift
//  Uni
//
//  Created by nguyen gia huy on 09/11/2020.
//

import UIKit

class SemesterCell: UITableViewCell {


    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewDateTime: UIView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewDate: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // viewDateTime.roundCorners([.topRight], radius: 20)
        lbScore.textColor = AppColor.YellowFAB32A
        viewDate.backgroundColor = AppColor.YellowFAB32A
        imgView.roundCorners([.topLeft,.bottomLeft], radius: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
