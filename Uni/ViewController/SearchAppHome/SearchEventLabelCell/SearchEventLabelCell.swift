//
//  SearchEventLabelCell.swift
//  Uni
//
//  Created by nguyen gia huy on 06/11/2020.
//

import UIKit

class SearchEventLabelCell: UITableViewCell {

    @IBOutlet weak var lbSearch: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbSearch.text = AppLanguage.SearchEvent.SearchEvent.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
