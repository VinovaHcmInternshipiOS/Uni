//
//  AppHomeViewController.swift
//  Uni
//
//  Created nguyen gia huy on 02/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import SkeletonView
import SDWebImage
import FirebaseStorage

class AppHomeViewController:BaseViewController{
    @IBOutlet weak var lbNoDataEnded: UILabel!
    @IBOutlet weak var lbNoDataComingSoon: UILabel!
    @IBOutlet weak var lbNoDataHappening: UILabel!
    @IBOutlet var viewAppHome: UIView!
    @IBOutlet weak var lbAppHome: UILabel!
    @IBOutlet weak var lbEnded: UILabel!
    @IBOutlet weak var lbComingSoon: UILabel!
    @IBOutlet weak var lbHappenning: UILabel!
    @IBOutlet weak var lbFeatures: UILabel!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var lbFaculty: UILabel!
    @IBOutlet weak var btRank: UIButton!
    
    @IBOutlet weak var collectionEnded: UICollectionView!
    @IBOutlet weak var collectionHappenning: UICollectionView!
    @IBOutlet weak var collectionComingSoon: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    private var pullControl = UIRefreshControl()
    @IBOutlet weak var imageBookmart: UIImageView!
    @IBOutlet weak var lbRank: UILabel!
    @IBOutlet weak var lbSearch: UILabel!
    @IBOutlet weak var lbHistory: UILabel!
    @IBOutlet weak var lbBarcode: UILabel!
    
    var presenter: AppHomePresenterProtocol
    var item = [1,2,3,4,5,6,7,8,9,10]
    var indexPageControl = 0
    var menuState = false
    var ListEvent = [Event?]()
    var code = ""
    
    var listEventHappening = [Event?]()
    var listEventComingSoon = [Event?]()
    var listEventEnded = [Event?]()
    init(presenter: AppHomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "AppHomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        addNav()
        setupXIB()
        setupUI()
        presenter.checkStateLive()
        presenter.loadProfile()
        presenter.getInfoEventHappening(currentDateTime:getCurrentDateTime24h().formatStringToDateTime24h())
        presenter.getInfoEventComingSoon(currentDateTime:getCurrentDateTime24h().formatStringToDateTime24h())
        presenter.getInfoEventEnded(currentDateTime:getCurrentDateTime24h().formatStringToDateTime24h())
        movetoProfile()
        pullRefreshData()
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      
        setupLanguage()
    }
    
    func refreshListEvent(){
        listEventHappening.removeAll()
        listEventComingSoon.removeAll()
        listEventEnded.removeAll()
        presenter.getInfoEventHappening(currentDateTime:getCurrentDateTime24h().formatStringToDateTime24h())
        presenter.getInfoEventComingSoon(currentDateTime:getCurrentDateTime24h().formatStringToDateTime24h())
        presenter.getInfoEventEnded(currentDateTime:getCurrentDateTime24h().formatStringToDateTime24h())
    }
    
    func setupLanguage(){
        lbFeatures.text = AppLanguage.HomeApp.Features.localized
        lbHappenning.text = AppLanguage.HomeApp.Happening.localized
        lbComingSoon.text = AppLanguage.HomeApp.ComingSoon.localized
        lbEnded.text = AppLanguage.HomeApp.Ended.localized
        lbAppHome.text = AppLanguage.HomeApp.AppHome.localized
        lbNoDataHappening.text = AppLanguage.HandleError.noHappening.localized
        lbNoDataComingSoon.text = AppLanguage.HandleError.noComingSoon.localized
        lbNoDataEnded.text = AppLanguage.HandleError.noEnded.localized
        lbRank.text = AppLanguage.Rank.Rank.localized
        lbSearch.text = AppLanguage.SearchEvent.Search.localized
        lbHistory.text = AppLanguage.History.History.localized
    }
    
    func setupUI(){
        lbID.textColor = AppColor.YellowFAB32A
        lbFaculty.textColor = AppColor.YellowFAB32A
        imgUser.borderColor = AppColor.YellowFAB32A
        pullControl.tintColor = AppColor.YellowFAB32A
        imageBookmart.image = AppIcon.icBookmartYellow
        scrollView.alwaysBounceVertical = true
        skeletonCollectionView()
        skeletonProfile()
        btRank.alignTextBelow()
        reloadHomeVC = { [self] in
            refreshListEvent()
            collectionHappenning.reloadData()
            collectionComingSoon.reloadData()
            collectionEnded.reloadData()
            presenter.loadProfile()
        }
    }
    func skeletonProfile(){
        imgUser.isSkeletonable = true
        imgUser.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        
        lbName.isSkeletonable = true
        lbName.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        
        lbID.isSkeletonable = true
        lbID.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        
        lbFaculty.isSkeletonable = true
        lbFaculty.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    func skeletonCollectionView(){
        collectionComingSoon.isSkeletonable = true
        collectionComingSoon.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        
        collectionHappenning.isSkeletonable = true
        collectionHappenning.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        
        collectionEnded.isSkeletonable = true
        collectionEnded.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    @objc func pulledRefreshControl(sender:AnyObject) {
        refreshListEvent()
        collectionHappenning.reloadData()
        collectionComingSoon.reloadData()
        collectionEnded.reloadData()
        presenter.loadProfile()
        
    }
    
    private func pullRefreshData() {
        skeletonCollectionView()
        pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
        scrollView.addSubview(pullControl)
        
    }
    func movetoProfile(){
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileVC))
        viewProfile.addGestureRecognizer(gesture)
    }
    @objc func profileVC(){
        let profileUser = ProfileViewController(presenter: ProfilePresenter())
        profileUser.fromAppHome = true
        self.navigationController?.pushViewController(profileUser, animated: true)
    }
    @objc func moveToNextPage (){
        
        let pageWidth:CGFloat = self.collectionHappenning.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(listEventHappening.count)
        let contentOffset:CGFloat = self.collectionHappenning.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        indexPageControl = indexPageControl + 1
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
            indexPageControl = 0
        }
        pageControl.currentPage = indexPageControl
        self.collectionHappenning.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.collectionHappenning.frame.height), animated: true)
    }
    
    func setupXIB() {
        collectionHappenning.delegate = self
        collectionHappenning.dataSource = self
        collectionHappenning.register(UINib(nibName: "HappenningCellAppHome", bundle: nil), forCellWithReuseIdentifier: "HappenningCellAppHome")
        // Reused Cell Comming Soon & Ended
        collectionComingSoon.delegate = self
        collectionComingSoon.dataSource = self
        collectionComingSoon.register(UINib(nibName: "ComingSoonEndedCellAppHome", bundle: nil), forCellWithReuseIdentifier: "ComingSoonEndedCellAppHome")
        
        collectionEnded.delegate = self
        collectionEnded.dataSource = self
        collectionEnded.register(UINib(nibName: "ComingSoonEndedCellAppHome", bundle: nil), forCellWithReuseIdentifier: "ComingSoonEndedCellAppHome")
        pageControl.currentPage = indexPageControl
        //
    }
    func addNav() {
        addMenuButton()
        addButtonImageToNavigation(image: AppIcon.icBellYellow!, style: .right, action: #selector(notification))
        self.navigationController?.hideShadowLine()
    }
    
    func checkEmptyDataHappenning(){
        if listEventHappening.count != 0 {
            lbNoDataHappening.isHidden = true
        } else {
            lbNoDataHappening.isHidden = false
        }
    }
    
    func checkEmptyDataComingSoon(){
        if listEventComingSoon.count != 0 {
            lbNoDataComingSoon.isHidden = true
        } else {
            lbNoDataComingSoon.isHidden = false
        }
    }
    
    func checkEmptyDataEnded(){
        if listEventEnded.count != 0 {
            lbNoDataEnded.isHidden = true
        } else {
            lbNoDataEnded.isHidden = false
        }
    }
    
    
    @objc func notification(){
        let notification = NotificationViewController(presenter: NotificationPresenter(code: code))
        navigationController?.pushViewController(notification, animated: true)
    }
    @IBAction func btLeaderboard(_ sender: UIButton) {
        sender.animationScale()
        let leaderBoard = RankViewController(presenter: RankPresenter(code: code))
        self.navigationController?.pushViewController(leaderBoard, animated: true)
    }
    @IBAction func btSearchEvent(_ sender: UIButton) {
        sender.animationScale()
        let searchEvent = SearchAppHomeViewController(presenter: SearchAppHomePresenter())
        searchEvent.updateLikeHomeVC = { [self] keyEvent,stateLike in
            if listEventHappening.contains(where: {$0?.key == keyEvent}) {
                if let i = listEventHappening.firstIndex(where: { $0!.key == keyEvent }) {
                    listEventHappening[i]?.stateLike = stateLike
                    collectionHappenning.reloadItems(at: [IndexPath(row: i, section: 0)])
                } else {return}
                
                
            } else if listEventComingSoon.contains(where: {$0?.key == keyEvent}) {
                if let i = listEventComingSoon.firstIndex(where: { $0!.key == keyEvent }) {
                    listEventComingSoon[i]?.stateLike = stateLike
                    collectionComingSoon.reloadItems(at: [IndexPath(row: i, section: 0)])
                } else {return}
            } else {
                if let i = listEventEnded.firstIndex(where: { $0!.key == keyEvent }) {
                    listEventEnded[i]?.stateLike = stateLike
                    collectionEnded.reloadItems(at: [IndexPath(row: i, section: 0)])
                } else {return}
            }
        }
        self.navigationController?.pushViewController(searchEvent, animated: true)
    }
    @IBAction func btHistoryEvent(_ sender: UIButton) {
        sender.animationScale()
        let historyEvent = HistoryEventViewController(presenter: HistoryEventPresenter())
        self.navigationController?.pushViewController(historyEvent, animated: true)
    }
    @IBAction func btBarcode(_ sender: UIButton) {
        sender.animationScale()
        let barcode = BarcodeViewController(presenter: BarcodePresenter(code: code))
        self.navigationController?.pushViewController(barcode, animated: true)
    }
    
    
}
extension AppHomeViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView {
        case collectionHappenning:
            return "HappenningCellAppHome"
        default:
            return "ComingSoonEndedCellAppHome"
        }
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    //  func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
    //    return "HeaderSearch"
    //  }
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
}

extension AppHomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == collectionHappenning) {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 183 , height: 297)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = listEventHappening.count
        switch collectionView {
        case collectionHappenning:
            return listEventHappening.count
        case collectionComingSoon:
            return listEventComingSoon.count
        case collectionEnded:
            return listEventEnded.count
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailEvent = DetailEventViewController(presenter: DetailEventPresenter())

        if collectionView == collectionHappenning {
            detailEvent.keyDetailEvent = (listEventHappening[indexPath.row]?.key)!
            detailEvent.stateLike = (listEventHappening[indexPath.row]?.stateLike)!
            detailEvent.updateStateLike = { [self] state in
                listEventHappening[indexPath.row]?.stateLike = state
                collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
            }
            
        } else if collectionView == collectionComingSoon {
            detailEvent.keyDetailEvent = (listEventComingSoon[indexPath.row]?.key)!
            detailEvent.stateLike = (listEventComingSoon[indexPath.row]?.stateLike)!
            detailEvent.updateStateLike = { [self] state in
                listEventComingSoon[indexPath.row]?.stateLike = state
                collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
            }
            
        } else {
            detailEvent.keyDetailEvent = (listEventEnded[indexPath.row]?.key)!
            detailEvent.stateLike = (listEventEnded[indexPath.row]?.stateLike)!
            detailEvent.updateStateLike = { [self] state in
                listEventEnded[indexPath.row]?.stateLike = state
                collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
            }
            
        }
        self.navigationController?.pushViewController(detailEvent, animated: true)
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionHappenning.visibleCells {
            if let indexPath = collectionHappenning.indexPath(for: cell) {
                indexPageControl = indexPath.row
                pageControl.currentPage = indexPageControl
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionHappenning {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HappenningCellAppHome", for: indexPath) as? HappenningCellAppHome else {return UICollectionViewCell()}
            if let listEventHappening = listEventHappening[indexPath.row] {
                listEventHappening.stateLike == true ? cell.btLike.setImage(AppIcon.icLove, for: .normal) : cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                cell.like = { [self] in
                    switch listEventHappening.stateLike {
                    case true:
                        cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                        listEventHappening.stateLike = false
                        presenter.isLikeEvent(keyEvent: listEventHappening.key ?? "", stateLike: false)
                    default:
                        cell.btLike.setImage(AppIcon.icLove, for: .normal)
                        listEventHappening.stateLike = true
                        presenter.isLikeEvent(keyEvent: listEventHappening.key ?? "", stateLike: true)
                    }
                }
                if let imageURL = listEventHappening.urlImage {
                    cell.imageCell.sd_setImage(with: URL(string: imageURL), completed: nil)
                }
                return cell
            } else {return UICollectionViewCell()}

        }
        else if collectionView == collectionComingSoon {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonEndedCellAppHome", for: indexPath) as? ComingSoonEndedCellAppHome,let listEventComingSoon = listEventComingSoon[indexPath.row]{
                cell.timeEvent.text = "\(getFormattedDate(date: listEventComingSoon.date ?? ""))\n\((listEventComingSoon.checkin ?? "").toTimeFormat(format: checkFormatTime12h()))-\((listEventComingSoon.checkout ?? "").toTimeFormat(format: checkFormatTime12h()))"
                cell.titleEvent.text = listEventComingSoon.title
                listEventComingSoon.stateLike == true ? cell.btLike.setImage(AppIcon.icLove, for: .normal) : cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                cell.like = { [self] in
                    switch listEventComingSoon.stateLike {
                    case true:
                        cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                        listEventComingSoon.stateLike = false
                        presenter.isLikeEvent(keyEvent: listEventComingSoon.key ?? "", stateLike: false)
                    default:
                        cell.btLike.setImage(AppIcon.icLove, for: .normal)
                        listEventComingSoon.stateLike = true
                        presenter.isLikeEvent(keyEvent: listEventComingSoon.key ?? "", stateLike: true)
                    }
                }
                
                if let imageURL = listEventComingSoon.urlImage {
                    cell.imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                }
                return cell
            } else {return UICollectionViewCell()}
        }
        else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonEndedCellAppHome", for: indexPath) as? ComingSoonEndedCellAppHome,let listEventEnded = listEventEnded[indexPath.row] {
                cell.timeEvent.text = "\(getFormattedDate(date: listEventEnded.date ?? ""))\n\((listEventEnded.checkin ?? "").toTimeFormat(format: checkFormatTime12h()))-\((listEventEnded.checkout ?? "").toTimeFormat(format: checkFormatTime12h()))"
                cell.titleEvent.text = listEventEnded.title
                listEventEnded.stateLike == true ? cell.btLike.setImage(AppIcon.icLove, for: .normal) : cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                cell.like = { [self] in
                    switch listEventEnded.stateLike {
                    case true:
                        cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                        listEventEnded.stateLike = false
                        presenter.isLikeEvent(keyEvent: listEventEnded.key ?? "", stateLike: false)
                    default:
                        cell.btLike.setImage(AppIcon.icLove, for: .normal)
                        listEventEnded.stateLike = true
                        presenter.isLikeEvent(keyEvent: listEventEnded.key ?? "", stateLike: true)
                    }
                }
                
                if let imageURL = listEventEnded.urlImage {
                cell.imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                }
                return cell
            } else {return UICollectionViewCell()}
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case collectionHappenning:
            return 0.00000000000000001
        case collectionComingSoon:
            return 0.00000000000000001
        case collectionEnded:
            return 0.00000000000000001
        default:
            return 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case collectionHappenning:
            return 0.00000000000000001
        case collectionComingSoon:
            return 0.00000000000000001
        case collectionEnded:
            return 0.00000000000000001
        default:
            return 0
        }
        
    }
    
    
}

extension AppHomeViewController: AppHomeViewProtocol {
    func likeEventSuccess() {

    }
    
    func likeEventFailed() {

    }
    
    func fetchInfoEventHappeningSuccess() {
        listEventHappening = presenter.happeningEvent
        collectionHappenning.hideSkeleton()
        collectionHappenning.insertItems(at: [IndexPath(row: listEventHappening.count - 1, section: 0)])
        collectionHappenning.performBatchUpdates({
            collectionHappenning.reloadItems(at: [IndexPath(row: listEventHappening.count - 1, section: 0)])
        }){_ in
            // optional closure
            print("finished updating cell")
        }
        pullControl.endRefreshing()
        collectionHappenning.reloadData()
        checkEmptyDataHappenning()
    }
    
    func fetchInfoEventHappeningFailed() {
        collectionHappenning.hideSkeleton()
        pullControl.endRefreshing()
        print("Fetch info event happening error")
        checkEmptyDataHappenning()
    }
    
    func fetchInfoEventComingSoonSuccess() {
        listEventComingSoon = presenter.comingsoonEvent
        collectionComingSoon.hideSkeleton()
        collectionComingSoon.insertItems(at: [IndexPath(row: listEventComingSoon.count - 1, section: 0)])
        collectionComingSoon.performBatchUpdates({
            collectionComingSoon.reloadItems(at: [IndexPath(row: listEventComingSoon.count - 1, section: 0)])
        }){_ in
            // optional closure
            print("finished updating cell")
        }
        pullControl.endRefreshing()
        //collectionComingSoon.reloadData()
        checkEmptyDataComingSoon()
    }
    
    func fetchInfoEventComingSoonFailed() {
        collectionComingSoon.hideSkeleton()
        pullControl.endRefreshing()
        print("Fetch info event comingsoon error")
        checkEmptyDataComingSoon()
    }
    
    func fetchInfoEventEndedSuccess() {
        listEventEnded = presenter.endedEvent
        collectionEnded.hideSkeleton()
        collectionEnded.insertItems(at: [IndexPath(row: listEventEnded.count - 1, section: 0)])
        collectionEnded.performBatchUpdates({
            collectionEnded.reloadItems(at: [IndexPath(row: listEventEnded.count - 1, section: 0)])
        }){_ in
            // optional closure
            print("finished updating cell")
        }
        pullControl.endRefreshing()
        // collectionEnded.reloadData()
        checkEmptyDataEnded()
    }
    
    func fetchInfoEventEndedFailed() {
        
        collectionEnded.hideSkeleton()
        pullControl.endRefreshing()
        print("Fetch info event ended error")
        checkEmptyDataEnded()
    }
    
    
    
    func fetchProfileSuccess() {
        let profile = presenter.profileUser
        if let profile = profile {
            lbName.text = profile.name
            lbID.text = profile.code
            code = profile.code ?? ""
            lbFaculty.text = profile.faculty?.localized
            imgUser.sd_setImage(with: URL(string: profile.urlImage!), completed: nil)
            if profile.urlImage! == "" {
                imgUser.borderColor = AppColor.YellowFAB32A
            } else {
                imgUser.borderColor = .clear
            }
        } else { return }
        
        lbName.hideSkeleton()
        lbID.hideSkeleton()
        lbFaculty.hideSkeleton()
        imgUser.hideSkeleton()
    }
    
    func fetchProfileFailed() {
        lbName.hideSkeleton()
        lbID.hideSkeleton()
        lbFaculty.hideSkeleton()
        imgUser.hideSkeleton()
        print("Fetch profile user error")
    }
    
    func checkStateLiveSuccess() {
        presentAlertWithTitle(title: AppLanguage.Opps.localized, message: AppLanguage.HandleError.userDisabled.localized, options: AppLanguage.Ok.localized) { (Int) in
            Switcher.updateRootVC()
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
}

