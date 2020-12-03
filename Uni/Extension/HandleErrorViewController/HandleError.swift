//
//  HandleError.swift
//  Uni
//
//  Created by nguyen gia huy on 16/11/2020.
//

import Foundation
import Firebase
import FirebaseAuth
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return AppLanguage.HandleError.emailAlreadyInUse.localized
        case .userNotFound:
            return AppLanguage.HandleError.userNotFound.localized
        case .userDisabled:
            return AppLanguage.HandleError.userDisabled.localized
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return AppLanguage.HandleError.invalidEmail.localized
        case .networkError:
            return AppLanguage.HandleError.networkError.localized
        case .weakPassword:
            return AppLanguage.HandleError.weakPassword.localized
        case .wrongPassword:
            return AppLanguage.HandleError.wrongPassword.localized
        default:
            return AppLanguage.HandleError.anotherError.localized
        }
    }
}
