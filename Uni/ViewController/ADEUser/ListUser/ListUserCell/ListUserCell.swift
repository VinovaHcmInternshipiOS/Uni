//
//  ListUserCell.swift
//  Uni
//
//  Created by nguyen gia huy on 01/12/2020.
//

import UIKit

class ListUserCell: UICollectionViewCell {

 
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var btState: UIButton!
    @IBOutlet weak var btUpdate: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbEmail.textColor = AppColor.YellowFAB32A
        btUpdate.setTitleColor(AppColor.YellowFAB32A, for: .normal)
        btUpdate.setTitle(AppLanguage.Update.localized, for: .normal)
    }

}
