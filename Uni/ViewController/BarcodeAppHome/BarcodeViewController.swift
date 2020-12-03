//
//  BarcodeViewController.swift
//  Uni
//
//  Created nguyen gia huy on 10/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import SwiftOTP
class BarcodeViewController: BaseViewController {

	var presenter: BarcodePresenterProtocol

    @IBOutlet weak var lbYourBarcode: UILabel!
    @IBOutlet weak var lbAttention: UILabel!
    @IBOutlet weak var lbBarcode: UILabel!
    @IBOutlet weak var barcodeView: UIImageView!
    init(presenter: BarcodePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "BarcodeViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        setupLanguage()
        presenter.view = self
        presenter.fetchProfile()
        lbAttention.textColor = AppColor.YellowFAB32A
        
        
        //_ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(generate), userInfo: nil, repeats: true)

        
    }
    
    func setupLanguage(){
        lbYourBarcode.text = AppLanguage.Barcode.YourBarcode.localized
        lbAttention.text = AppLanguage.Barcode.Pleasegive.localized
    }
    func generate(){
        guard let data = base32DecodeToData("ABCDEFGHIJKLMNOP") else { return }
//        if let hotp = TOTP(secret: data, digits: 6, timeInterval: 5, algorithm: .sha1) {
//            print(hotp.generate(secondsPast1970: 42))
//        }
//        if let totp = TOTP(secret: data, digits: 6, timeInterval: 30, algorithm: .sha1) {
//            let otpString = totp.generate(time: Date(timeIntervalSince1970: 123))
//            print("1234111",otpString)
//        }
  
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
           UIScreen.main.brightness = CGFloat(0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           UIScreen.main.brightness = CGFloat(1)
    }
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil}
            colorFilter.setValue(filter.outputImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 255/255, green: 255/255, blue: 255/255), forKey: "inputColor1") //background color
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0") //tint color
            
            guard colorFilter.outputImage != nil
            else
            {
                return nil
            }
            let transform = CGAffineTransform(scaleX: 30, y: 30)
            
            if let output = colorFilter.outputImage?.transformed(by: transform) {
                
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }

}

extension BarcodeViewController: BarcodeViewProtocol {
    func fetchProfileSuccess() {
        let profile = presenter.profileUser
        if let profile = profile {
            lbBarcode.text = profile.code
            barcodeView.image = generateBarcode(from: profile.code ?? "")
        } else { return }
    }
    
    func fetchProfileFailed() {
        print("create barcode failed")
    }
    
    
}
