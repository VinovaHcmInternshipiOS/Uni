//
//  SearchResultCell.swift
//  Uni
//
//  Created by nguyen gia huy on 06/11/2020.
//

import UIKit

class SearchResultCell: UITableViewCell {


    @IBOutlet weak var btLike: UIButton!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var titleEvent: UILabel!
    @IBOutlet weak var dateEvent: UILabel!
    var likeEvent: (()->Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btLike(_ sender: Any) {
        likeEvent?()
    }
    
}
