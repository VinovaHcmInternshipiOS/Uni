//
//  ListUserCell.swift
//  Uni
//
//  Created by nguyen gia huy on 01/12/2020.
//

import UIKit

class ListUserCell: UICollectionViewCell {

 
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbEmail.textColor = AppColor.YellowFAB32A
        lbName.textColor = AppColor.YellowFAB32A
        imgProfile.borderColor = AppColor.YellowFBC459
    }

}
