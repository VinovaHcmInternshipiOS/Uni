//
//  HappenningCellAppHome.swift
//  Uni
//
//  Created by nguyen gia huy on 03/11/2020.
//

import UIKit

class HappenningCellAppHome: UICollectionViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var btLike: UIButton!
    var like: (()->Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    @IBAction func btLike(_ sender: Any) {
        like?()
    }
    
    

}
