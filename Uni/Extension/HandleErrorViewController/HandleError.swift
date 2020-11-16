//
//  HandleError.swift
//  Uni
//
//  Created by nguyen gia huy on 16/11/2020.
//

import Foundation
import Firebase
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "You are not connected to the Internet"
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect"
        default:
            return "Something went wrong"
        }
    }
}
