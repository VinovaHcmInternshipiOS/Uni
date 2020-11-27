//
//  AttendanceCell.swift
//  Uni
//
//  Created by nguyen gia huy on 23/11/2020.
//

import UIKit

class AttendanceCell: UICollectionViewCell {
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var codeUser: UILabel!
    @IBOutlet weak var dateCheckin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameUser.textColor = AppColor.YellowFAB32A
        // Initialization code
    }

}
