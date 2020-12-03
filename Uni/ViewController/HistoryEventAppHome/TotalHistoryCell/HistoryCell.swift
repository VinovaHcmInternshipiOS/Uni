//
//  HistoryCell.swift
//  Uni
//
//  Created by nguyen gia huy on 06/11/2020.
//

import UIKit

class HistoryCell: UICollectionViewCell {

    @IBOutlet weak var lbNumberSemester: UILabel!
    @IBOutlet weak var lbSemester: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbSemester.text = AppLanguage.History.Semester.localized
        lbNumberSemester.textColor = AppColor.YellowFAB32A
        lbSemester.textColor = AppColor.YellowFAB32A
    }

}
