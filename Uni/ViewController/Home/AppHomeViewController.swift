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

        presenter.loadProfile()
        presenter.getInfoEventHappening()
        presenter.getInfoEventComingSoon()
        presenter.getInfoEventEnded()
        presenter.checkStateLive()
        movetoProfile()
        pullRefreshData()
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
    }
    
    func refreshListEvent(){
        presenter.happeningEvent = []
        presenter.comingsoonEvent = []
        presenter.endedEvent = []
        presenter.getInfoEventHappening()
        presenter.getInfoEventComingSoon()
        presenter.getInfoEventEnded()
    }
    
    func setupLanguage(){
        lbFeatures.text = AppLanguage.HomeApp.Features.localized
        lbHappenning.text = AppLanguage.HomeApp.Happenning.localized
        lbComingSoon.text = AppLanguage.HomeApp.ComingSoon.localized
        lbEnded.text = AppLanguage.HomeApp.Ended.localized
        lbAppHome.text = AppLanguage.HomeApp.AppHome.localized
        lbNoDataHappening.text = AppLanguage.HandleError.noHappenning.localized
        lbNoDataComingSoon.text = AppLanguage.HandleError.noComingSoon.localized
        lbNoDataEnded.text = AppLanguage.HandleError.noEnded.localized
    }
    
    func setupUI(){
        lbID.textColor = AppColor.YellowFAB32A
        lbFaculty.textColor = AppColor.YellowFAB32A
        imgUser.borderColor = AppColor.YellowFAB32A
        pullControl.tintColor = AppColor.YellowFAB32A
        scrollView.alwaysBounceVertical = true
        skeletonCollectionView()
        skeletonProfile()
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
   
    }
    @IBAction func btLeaderboard(_ sender: UIButton) {
        sender.animationScale()
        let leaderBoard = RankViewController(presenter: RankPresenter(code: code))
        self.navigationController?.pushViewController(leaderBoard, animated: true)
    }
    @IBAction func btSearchEvent(_ sender: UIButton) {
        sender.animationScale()
        let searchEvent = SearchAppHomeViewController(presenter: SearchAppHomePresenter())
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
           
        } else if collectionView == collectionComingSoon {
            detailEvent.keyDetailEvent = (listEventComingSoon[indexPath.row]?.key)!
            
        } else {
            detailEvent.keyDetailEvent = (listEventEnded[indexPath.row]?.key)!
           
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
                if let profileURL = listEventHappening[indexPath.row]?.urlImage {
                    cell.imageCell.loadImage(urlString: profileURL)
                }
            return cell
        }
        else if collectionView == collectionComingSoon {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonEndedCellAppHome", for: indexPath) as? ComingSoonEndedCellAppHome else {return UICollectionViewCell()}

                cell.timeEvent.text = "\(getFormattedDate(date: listEventComingSoon[indexPath.row]!.date ?? ""))\n\(formatterTime(time: listEventComingSoon[indexPath.row]!.checkin ?? ""))-\(formatterTime(time: listEventComingSoon[indexPath.row]!.checkout ?? ""))"
            cell.titleEvent.text = listEventComingSoon[indexPath.row]?.title
                if let profileURL = listEventComingSoon[indexPath.row]?.urlImage {
                    cell.imageView.loadImage(urlString: profileURL)
                }
                return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonEndedCellAppHome", for: indexPath) as? ComingSoonEndedCellAppHome else {return UICollectionViewCell()}
                cell.timeEvent.text = "\(getFormattedDate(date: listEventEnded[indexPath.row]!.date ?? ""))\n\(formatterTime(time: listEventEnded[indexPath.row]!.checkin ?? ""))-\(formatterTime(time: listEventEnded[indexPath.row]!.checkout ?? ""))"

                cell.titleEvent.text = listEventEnded[indexPath.row]?.title
                //cell.setData(event: listEventEnded[indexPath.row])
                if let profileURL = listEventEnded[indexPath.row]?.urlImage {
                    cell.imageView.loadImage(urlString: profileURL)
                }
                return cell
            
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

    
    func fetchInfoEventHappeningSuccess() {
        listEventHappening = presenter.happeningEvent
        collectionHappenning.hideSkeleton()
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
        pullControl.endRefreshing()
        collectionComingSoon.reloadData()
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
        pullControl.endRefreshing()
        collectionEnded.reloadData()
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
            imgUser.loadImage(urlString: profile.urlImage!)
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

