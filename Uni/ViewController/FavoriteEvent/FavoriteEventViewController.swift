//
//  FavoriteEventViewController.swift
//  Uni
//
//  Created nguyen gia huy on 10/01/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import SkeletonView
import SVProgressHUD

class FavoriteEventViewController: BaseViewController {
    
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var pullControl = UIRefreshControl()
    
	var presenter: FavoriteEventPresenterProtocol
    var ListEvent = [Event?]()
	init(presenter: FavoriteEventPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "FavoriteEventViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        SVProgressHUD.show()
        presenter.getInfoEventFavorite()
        setupUI()
        setupLanguage()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func pullRefreshData() {
        skeletonCollectionView()
        pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
        collectionView.addSubview(pullControl)
        
    }
    
    @objc func pulledRefreshControl(sender:AnyObject) {
        refreshListEvent()
    }
    
    func refreshListEvent(){
        ListEvent.removeAll()
        presenter.getInfoEventFavorite()
    }
    
    func setupUI(){
        addNav()
        skeletonCollectionView()
        pullRefreshData()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ComingSoonEndedCellAppHome", bundle: nil), forCellWithReuseIdentifier: "ComingSoonEndedCellAppHome")
        collectionView.register(UINib(nibName: "HeaderAttendance", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderAttendance")
        
        collectionView.register(UINib(nibName: "HeaderAttendance", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderAttendance")
        pullControl.tintColor = AppColor.YellowFAB32A
        
    }
    
    func skeletonCollectionView(){
        collectionView.isSkeletonable = true
        collectionView.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    func setupLanguage(){
        lbNoData.text = AppLanguage.HandleError.noData.localized
    }
    
    func addNav() {
        addMenuButton()
        addButtonImageToNavigation(image: AppIcon.icBellYellow!, style: .right, action: #selector(notification))
        self.navigationController?.hideShadowLine()
    }
    
    @objc func notification(){
        let appHome = AppHomeViewController(presenter: AppHomePresenter())
        let notification = NotificationViewController(presenter: NotificationPresenter(code: appHome.code))
        navigationController?.pushViewController(notification, animated: true)
    }
    
    func checkEmptyData(){
        if ListEvent.count != 0 {
            lbNoData.isHidden = true
            collectionView.alwaysBounceVertical = true
        } else {
            lbNoData.isHidden = false
            collectionView.alwaysBounceVertical = false
        }
    }
    
    func remakeData(){
        ListEvent = presenter.listEvent
        collectionView.hideSkeleton()
        collectionView.insertItems(at: [IndexPath(row: ListEvent.count - 1, section: 0)])
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [IndexPath(row: ListEvent.count - 1, section: 0)])
        }){_ in
            // optional closure
            print("finished updating cell")
        }
        checkEmptyData()
        pullControl.endRefreshing()
        collectionView.reloadData()
        SVProgressHUD.dismiss()
    }

}

extension FavoriteEventViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ComingSoonEndedCellAppHome"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListEvent.count
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
}

extension FavoriteEventViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 1, height: 297 )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        
        case UICollectionView.elementKindSectionHeader:
            
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderAttendance", for: indexPath) as? HeaderAttendance {
                headerView.backgroundColor = .none
                headerView.lbTotal.isHidden = true
                headerView.lbHeader.text = AppLanguage.FavoriteEvent.FavoriteEvent.localized
                headerView.viewSearch.isHidden = true

               
                return headerView
            } else {
                return UICollectionReusableView()
            }
            
        case UICollectionView.elementKindSectionFooter:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderAttendance", for: indexPath) as? HeaderAttendance {
                    return headerView
            } else {return UICollectionReusableView()}
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0000001
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0000001
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
}

extension FavoriteEventViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListEvent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailEvent = DetailEventViewController(presenter: DetailEventPresenter())
            detailEvent.keyDetailEvent = (ListEvent[indexPath.row]?.key)!
            detailEvent.stateLike = (ListEvent[indexPath.row]?.stateLike)!
        detailEvent.updateStateLike = { [self] state in
            ListEvent[indexPath.row]?.stateLike = state
            ListEvent.remove(at: indexPath.row)
            collectionView.deleteItems(at: [IndexPath(row: indexPath.row, section: 0)])
            checkEmptyData()
        }
        self.navigationController?.pushViewController(detailEvent, animated: true)
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonEndedCellAppHome", for: indexPath) as? ComingSoonEndedCellAppHome,let listEvent = ListEvent[indexPath.row]{
                cell.timeEvent.text = "\(getFormattedDate(date: listEvent.date ?? ""))\n\((listEvent.checkin ?? "").toTimeFormat(format: checkFormatTime12h()))-\((listEvent.checkout ?? "").toTimeFormat(format: checkFormatTime12h()))"
                cell.titleEvent.text = listEvent.title
                listEvent.stateLike == true ? cell.btLike.setImage(AppIcon.icLove, for: .normal) : cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                cell.like = { [self] in
                    SVProgressHUD.show()
                    cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                    listEvent.stateLike = false
                    presenter.isLikeEvent(keyEvent: listEvent.key ?? "", stateLike: false)

                }
                if let imageURL = listEvent.urlImage {
                    cell.imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                }
                return cell
            } else {return UICollectionViewCell()}
    }
    
}

extension FavoriteEventViewController: FavoriteEventViewProtocol {
    func likeEventFailed() {
        presenter.getInfoEventFavorite()
    }
    
    func likeEventSuccess() {
        presenter.getInfoEventFavorite()
        if ListEvent.count == 1 {
            ListEvent.remove(at: 0)
            collectionView.reloadData()
        }
        SVProgressHUD.dismiss()
    }
    
    func fetchEventSuccess() {
        remakeData()
    }
    
    func fetchEventFailed() {
        collectionView.hideSkeleton()
        pullControl.endRefreshing()
        print("Fetch info event happening error")
        checkEmptyData()
        SVProgressHUD.dismiss()
        collectionView.reloadData()
    }
}
