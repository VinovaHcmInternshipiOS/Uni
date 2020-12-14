//
//  AppLanguage.swift
//  Uni
//
//  Created by nguyen gia huy on 30/11/2020.
//

import Foundation
import UIKit
class AppLanguage {
    static let Male = "Male"
    static let Female = "Female"
    static let User = "User"
    static let Admin = "Admin"
    static let True = "true"
    static let False = "false"
    static let Ok = "OK"
    static let Cancel = "Cancel"
    static let Password = "Password"
    static let Save = "Save"
    static let Update = "Update"
    static let Delete = "Delete"
    static let Disable = "Disable"
    static let Enable = "Enable"
    static let Confirm = "Confirm"
    static let Checking = "Checking..."
    static let FooterCamera = "Place the barcode within the window to scan.\nThe search will start automatically."
    static let titleCamera = "Scan Barcode"
    static let Opps = "Opps"
    static let Title = "Title"
    static let Content = "Content"
    
    //MARK: -- HandleError
    class HandleError {
        static let anError = "An Error"
        static let error = "Error"
        static let emailAlreadyInUse = "The email is already in use with another account."
        static let userNotFound = "Account not found for the specified user. Please check and try again."
        static let userDisabled = "Your account has been disabled. Please contact support."
        static let invalidEmail = "Please enter a valid email."
        static let networkError = "You are not connected to the Internet."
        static let weakPassword = "Your password is too weak. The password must be 6 characters long or more."
        static let wrongPassword = "Your password is incorrect."
        static let anotherError = "Something went wrong."
        static let NewnotsameConfirm = "The new password is not the same as the confirmation password."
        static let changeStateAccount = "Account status change failed."
        static let createAccount = "Account created failed."
        static let idAlreadyInUse = "ID already exists belong another account."
        static let createEvent  = "The event created failed."
        static let updateEvent = "The event update failed."
        static let fillIn = "Please fill in all information."
        static let noData = "No Data."
        static let noHappenning = "no ongoing events."
        static let noComingSoon = "no upcoming events."
        static let noEnded = "no event has ended."
        static let attendanceAlready = "Already exists ID in event list."
        static let invalidID = "Invalid ID."
    }
    //MARK: -- HandleSuccess
    class HandleSuccess {
        static let Success = "Success"
        static let changePassword = "Your Password has been changed."
        static let changeStateAccount = "Account status changed successfully."
        static let createAccount = "Account created successfully."
        static let createEvent = "The event has been successfully created."
        static let updateEvent = "The event has been successfully updated."
        static let updateInformationID = "Please update information of the ID."
        static let attendance = "Attendance success for ID."
        static let sendMailPassword = "Please check your email to change your password."

    }
    
    //MARK: -- HandleConfirm
    class HandleConfirm {
        static let Enable = "Do you want to enable account?"
        static let Disable = "Do you want to disable account?"
    }
    
    
    
    //MARK:-- LoginView
    class Login {
        static let lbWelcomeBack = "Welcome Back"
        static let lbSignInContinue = "Sign in continue using our app"
        static let lbLogin = "Login"
        static let btForgotPassword = "Forgot password?"
        static let lbDontAccount = "Don't have an account?"
        static let btSignup = "Sign Up"
    }
    
    //MARK:-- ForgotPasswordView
    class ForgotPassword {
        static let lbForgotPassword = "Forgot\nPassword?"
        static let lbSent = "Send"
    }
    
    //MARK:-- HomeApp
    class HomeApp {
        static let Features = "Features"
        static let Happenning = "Happenning"
        static let ComingSoon = "Coming Soon"
        static let Ended = "Ended"
        static let AppHome = "App\nHome"
    }
    
    //MARK:-- Slide Menu
    class SlideMenu {
        static let Home = "Home"
        static let About = "About"
        static let Setting = "Setting"
        static let Manage = "Manage"
        static let Privacy = "Privacy"
        static let btLogout = "Logout"
    }
    
    //MARK:-- Profile
    class Profile {
        static let Gender = "Gender"
        static let Class = "Class"
        static let Course = "Course"
        static let Faculty = "Faculty"
    }
    
    //MARK:-- Barcode
    class Barcode {
        static let YourBarcode = "Your\nBarcode"
        static let Pleasegive = "Please give barcode to the event for attendance."
    }
    
    //MARK:-- SearchEvent
    class SearchEvent {
        static let SearchEvent = "Search\nEvent"
        static let Search = "Search"
    }
    
    //MARK:-- DetailEvent
    class DetailEvent {
        static let Detail = "Detail"
        static let Overview = "Overview"
    }
    
    //MARK:-- History
    class History {
        static let YourHistory = "Your\nHistory"
        static let TotalEvent = "Total Event:"
        static let TotalScore = "Total Score:"
        static let Semester = "SEMESTER"
    }
    
    //MARK:-- Semester
    class Semester {
        static let TotalEvent = "Total Event:"
        static let TotalScore = "Total Score:"
        static let Semester = "Semester"
    }
    
    //MARK:-- ListEvent
    class ListEvent {
        static let ListEvent = "List\nEvent"
    }
    
    //MARK:-- ListAttendance
    class ListAttendance {
        static let ListAttendance = "List\nAttendance"
        static let Attendance = "Attendance"
        static let EnterIDStudent = "Please Enter ID Student"
        static let Title = "Title:"
        static let Date = "Date:"
        static let Location = "Location:"
        static let CheckIn = "Check-In:"
        static let CheckOut = "Check-Out:"
        static let StudentID = "Student ID"
        static let FirstName = "First Name"
        static let LastName = "Last Name"
        static let Checkin = "Check-In"
        static let TotalJoiner = "Total Participants:"
        static let RerportEvent = "Report Event"
        static let Total = "Total:"
    }
    
    //MARK:-- CreateEvent
    class CreateEvent {
        static let CreateEvent = "Create\nEvent"
        static let Title = "Title"
        static let Overview = "Overview"
        static let Location = "Location"
        static let Date = "Date"
        static let Time = "Time"
        static let Score = "Score"
        static let ChooseDate = "Choose Date"
        static let Checkin = "Check-in"
        static let Checkout = "Check-out"
        static let btDone = "Done"
        
    }
    
    //MARK:-- UpdateEvent
    class UpdateEvent {
        static let UpdateEvent = "Update\nEvent"
        static let Title = "Title"
        static let Overview = "Overview"
        static let Location = "Location"
        static let Date = "Date"
        static let Time = "Time"
        static let Score = "Score"
        static let ChooseDate = "Choose Date"
        static let Checkin = "Check-in"
        static let Checkout = "Check-out"
        static let btDone = "Done"
        
    }
    
    //MARK:-- Rank
    class Rank {
        static let Rank = "Rank"
        static let Score = "Score:"
        
    }
    
    //MARK:-- Setting
    class Setting {
        static let Setting = "Setting"
        static let Language = "Language"
        static let ChangePassword = "Change Password"
        
    }
    
    //MARK:-- About
    class About {
        static let About = "About\nUs"
        static let Versison = "Versison"
        static let UpdateOn = "Update on"
        static let OurTeam = "Our Team"
        static let ContactUs = "Contact Us"
        static let Feedback = "Feedback"
        static let PleaseSend = "Please send your feedbback to:"
        static let Location = "Location:"
        static let Phone = "Phone:"
    }
    
    //MARK:-- Manage
    class Manage {
        static let EventManage = "Event\nManage"
        static let UserManage = "Users\nManage"
        static let HiAdmin = "Hi,\nAdmin"
        static let SendNotice = "Send\nNotification"
    }
    
    //MARK:-- Privacy
    class Privacy {
        static let PrivacyPolicy = "Privacy\nPolicy"
    }
    
    //MARK:-- ListUser
    class ListUser {
        static let ListUser = "List\nUser"
        
    }
    
    //MARK: -- CreateUser
    class CreateUser {
        static let CreateUser = "Create\nUser"
        static let Account = "Account"
        static let Role = "Role"
        static let State = "State"
        static let Infomation = "Infomation"
        static let Name = "Name"
        static let Gender = "Gender"
        static let Class = "Class"
        static let Course = "Course"
        static let Faculty = "Faculty"
        static let Done = "Done"
        static let placeHolderEmail = "Please enter Email"
        static let placeHolderID = "Please enter ID"
        static let placeHolderRole = "Please choose Role"
        static let placeHolderState = "Please choose State"
        static let placeHolderName = "Please enter Name"
        static let placeHolderGender = "Please choose Gender"
        static let placeHolderClass = "Please choose Class"
        static let placeHolderCourse = "Please choose Course"
        static let placeHolderFaculty = "Please choose Faculty"
        static let BA = "Business Administration"
        static let AF = "Accounting Finance"
        static let ISC = "Infomation Systems Commerce"
        static let LIC = "Linguistics International Cultures"
        static let LAW = "Law"
        static let HMT = "Hospitality Management Tourism"
        static let IRC = "International Relations Communications"
        
    }
    
    //MARK:-- ConfirmPassword
    class ConfirmPassword {
        static let EnterPassword = "Enter your password"
        
    }
    
    //MARK:-- ChangePassword
    class ChangePassword {
        static let ChangePassword = "Change\nPassword"
        static let EnterYourNew = "Enter your new password bellow.\nPassword has at least 6 characters."
        static let NewPassword = "New Password"
        static let ConfirmPassword = "Confirm Password"
        
    }
    
    //MARK:-- DetailAccount
    class DetailAccount {
        static let DetailAccount = "Detail\nAccount"
        static let Created = "Created:"
        static let SignedIn = "Signed In:"
        static let State = "State:"
        static let Role = "Role:"
    }
    //MARK:-- ResetPassword
    class ResetPassword {
        static let EnterYourEmail = "Please enter your Email"
    }
    
}
