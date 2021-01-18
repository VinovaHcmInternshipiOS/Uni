//
//  DetailEventAtDayViewController.swift
//  Uni
//
//  Created nguyen gia huy on 18/01/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import SkeletonView
import SDWebImage

class DetailEventAtDayViewController: UIViewController {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: DetailEventAtDayPresenterProtocol
    var eventDate = ""
	init(presenter: DetailEventAtDayPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "DetailEventAtDayViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        presenter.fetchEvent(date: eventDate)
        setupUI()
        setupLanguage()
    }
    
    func checkEmptyData(){
        if presenter.listEvent.count == 0 {
            lbNoData.isHidden = false
        } else {
            lbNoData.isHidden = true
        }
    }
    
    @objc func handleTapCloseMenu(_ sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: false, completion: nil)
    }
    
    func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ComingSoonEndedCellAppHome", bundle: nil), forCellWithReuseIdentifier: "ComingSoonEndedCellAppHome")
        skeletonCollectionView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapCloseMenu(_:)))
        viewParent.addGestureRecognizer(tap)
    }
    
    func skeletonCollectionView(){
        collectionView.isSkeletonable = true
        collectionView.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    func setupLanguage(){
        lbNoData.text = AppLanguage.HandleError.noData.localized
    }

}
extension DetailEventAtDayViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ComingSoonEndedCellAppHome"
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
}

extension DetailEventAtDayViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 183 , height: 300)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.listEvent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailEvent = DetailEventViewController(presenter: DetailEventPresenter())
        detailEvent.keyDetailEvent = (presenter.listEvent[indexPath.row]?.key)!
        detailEvent.stateLike = (presenter.listEvent[indexPath.row]?.stateLike)!
            detailEvent.updateStateLike = { [self] state in
                presenter.listEvent[indexPath.row]?.stateLike = state
                collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
            }
        present(detailEvent, animated: false, completion: nil)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonEndedCellAppHome", for: indexPath) as? ComingSoonEndedCellAppHome,let listEvent = presenter.listEvent[indexPath.row]{
                cell.timeEvent.text = "\(getFormattedDate(date: listEvent.date ?? ""))\n\((listEvent.checkin ?? "").toTimeFormat(format: checkFormatTime12h()))-\((listEvent.checkout ?? "").toTimeFormat(format: checkFormatTime12h()))"
                cell.titleEvent.text = listEvent.title
            listEvent.stateLike == true ? cell.btLike.setImage(AppIcon.icLove, for: .normal) : cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                cell.like = { [self] in
                    switch listEvent.stateLike {
                    case true:
                        cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                        listEvent.stateLike = false
                        presenter.isLikeEvent(keyEvent: listEvent.key ?? "", stateLike: false)
                    default:
                        cell.btLike.setImage(AppIcon.icLove, for: .normal)
                        listEvent.stateLike = true
                        presenter.isLikeEvent(keyEvent: listEvent.key ?? "", stateLike: true)
                    }
                }

                if let imageURL = listEvent.urlImage {
                    cell.imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                }
                return cell
            } else {return UICollectionViewCell()}

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.00000000000000001
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.00000000000000001
        
    }
    
    
}

extension DetailEventAtDayViewController: DetailEventAtDayViewProtocol {
    func likeEventSuccess() {
        
    }
    
    func likeEventFailed() {
        
    }
    
    func fetchEventSuccess() {
        collectionView.hideSkeleton()
        collectionView.insertItems(at: [IndexPath(row: presenter.listEvent.count - 1, section: 0)])
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [IndexPath(row: presenter.listEvent.count - 1, section: 0)])
        }){_ in
            // optional closure
            print("finished updating cell")
        }
        removeSpinner()
        checkEmptyData()
    }
    
    func fetchEventFailed() {
        collectionView.hideSkeleton()
        checkEmptyData()
    }
    
    
}