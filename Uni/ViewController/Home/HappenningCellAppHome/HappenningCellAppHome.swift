//
//  HappenningCellAppHome.swift
//  Uni
//
//  Created by nguyen gia huy on 03/11/2020.
//

import UIKit

class HappenningCellAppHome: UICollectionViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCell.layer.cornerRadius = 20
        // Initialization code
    }
    

}
