//
//  ComingSoonEndedCellAppHome.swift
//  Uni
//
//  Created by nguyen gia huy on 05/11/2020.
//

import UIKit

class ComingSoonEndedCellAppHome: UICollectionViewCell {

    @IBOutlet weak var btLike: UIButton!
    @IBOutlet weak var timeEvent: UILabel!
    @IBOutlet weak var titleEvent: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var like: (()->Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleEvent.textColor = AppColor.YellowFAB32A
    }
    var model: Event?
    func setData(event: Event?) {
        guard let model = model else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateTime = dateFormatter.date(from: (model.date)!)
        dateFormatter.dateFormat = "dd MMM"
        titleEvent.text = model.title
        timeEvent.text = "\(dateFormatter.string(from: dateTime!))\n\(model.checkin ?? "")-\(model.checkout ?? "")"
    }
    @IBAction func btLike(_ sender: Any) {
        like?()
    }
}
