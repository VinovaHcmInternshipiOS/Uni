//
//  HeaderSearch.swift
//  Uni
//
//  Created by nguyen gia huy on 23/11/2020.
//

import UIKit

class HeaderSearch: UICollectionReusableView {
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btSearch: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewButton.backgroundColor = AppColor.YellowFAB32A
        btSearch.backgroundColor = AppColor.YellowFAB32A
        lbTotal.textColor = AppColor.YellowFAB32A
    }
    
}
