//
//  ManageCell.swift
//  Uni
//
//  Created by nguyen gia huy on 01/12/2020.
//

import UIKit

class ManageCell: UICollectionViewCell {

    @IBOutlet weak var titleFunction: UILabel!
    @IBOutlet weak var viewFunction: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewFunction.shadowColor = AppColor.YellowShadow
    }

}
