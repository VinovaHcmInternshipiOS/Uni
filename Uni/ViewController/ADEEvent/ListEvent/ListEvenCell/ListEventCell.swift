//
//  ListEventCell.swift
//  Uni
//
//  Created by nguyen gia huy on 23/11/2020.
//

import UIKit

class ListEventCell: UICollectionViewCell {

    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var titleEvent: UILabel!
    @IBOutlet weak var dateEvent: UILabel!
    @IBOutlet weak var btUpdate: UIButton!
    @IBOutlet weak var btDelete: UIButton!
    var delete: (()->Void)? = nil
    var update: (()->Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleEvent.textColor = AppColor.YellowFAB32A
        btUpdate.setTitleColor(AppColor.YellowFAB32A, for: .normal)
        btUpdate.setTitle(AppLanguage.Update.localized, for: .normal)
        btDelete.setTitle(AppLanguage.Delete.localized, for: .normal)
    }
    @IBAction func tapOnUpdateButton(_ sender: Any) {
        update?()
    }
    
    @IBAction func tapOnDeleteButton(_ sender: Any) {
        delete?()
    }
}
