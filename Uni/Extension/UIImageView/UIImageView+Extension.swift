//
//  UIImageView+Extension.swift
//  Uni
//
//  Created by nguyen gia huy on 16/11/2020.
//

import Foundation
import UIKit
import FirebaseStorage
let imageCache = NSCache<AnyObject, AnyObject>()

public enum typeImage {
    case Landscape
    case Portal
}

extension UIImageView {
    func loadImage(urlString: String) {
        self.image = AppIcon.defaultImagenil
        let url = NSURL(string: urlString)
        if let cachedImage = imageCache.object(forKey: url!) as? UIImage {
            self.image = cachedImage
            return
        }
        let storageRef = Storage.storage().reference()
        let ref = storageRef.child("\(urlString)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        _ = ref.getData(maxSize: 1 * 2048 * 2048, completion:  { [self] data,error in
            if error != nil{
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: url!)
                    self.image = downloadedImage
                }
            }
        })
        
    }
}
public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?,type: typeImage)
    
}

open class ImagePicker: NSObject {
    

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    public var type: typeImage?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView, type: typeImage) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
        self.type = type
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image,type: type!)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //self.pickerController(picker, didSelect: nil)
        self.pickerController.dismiss(animated: true, completion: nil)

    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
