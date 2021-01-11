//
//  HeaderAttendance.swift
//  Uni
//
//  Created by nguyen gia huy on 16/12/2020.
//

import UIKit

class HeaderAttendance: UICollectionReusableView {


    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var filterData: UISegmentedControl!
    @IBOutlet weak var lbHeader: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var btSearch: UIButton!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewButton.backgroundColor = AppColor.YellowFAB32A
        btSearch.backgroundColor = AppColor.YellowFAB32A
        lbTotal.textColor = AppColor.YellowFAB32A
        // Initialization code
    }
    
}
