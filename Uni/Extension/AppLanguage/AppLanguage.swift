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
    static let DeleteEvent = "Do you want to delete this event?"
    static let Notifications = "Notifications"
    static let JustNow = "just now"
    static let Seen = "Seen"
    static let Total = "Total"
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
        static let pushNotification = "Send failure notification."
        static let eventExistUser = "The event could not be deleted because a user already exists in the list."
        static let noDate = "Please select an event date."
        static let timeInCheckin = "It's not time to take attendance yet, please come back later."
        static let timeOutCheckout = "It's time to take attendance has passed."
        static let updateOngoingEvent = "Ongoing events cannot be updated information."
        static let updateEndedEvent = "The event has ended cannot be updated information."
        static let scanBarcodeEndedEvent = "Cannot scan the code at this time because the event has not taken place yet or the event has ended."
        static let updateAvatar = "Updated avatar failed."
        static let deleteNotification = "Delete failed message."
        
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
        static let pushNotification = "Notification has been sent."
        static let updateAvatar = "Successful avatar update."
        static let deleteNotification = "Successfully deleted message."
        
        

    }
    
    //MARK: -- HandleConfirm
    class HandleConfirm {
        static let Enable = "Do you want to enable account?"
        static let Disable = "Do you want to disable account?"
        static let DeleteNotification = "Do you want to delete this message?"
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
        static let newEvent = "New event!!!"
        static let havejustAdded = "Hi, we have just added event"
        static let letExlore = "in the Uni.\nWe will be happy if you join us.\nLets explore."
        
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
        static let editEvent = "Update event!!!"
        static let havejustUpdate = "Hi, we have just update event information"
        static let letCheck = "in the Uni.\nPlease check the event information to avoid being missed."
        
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
        static let EventManage = "Events\nManage"
        static let UserManage = "Users\nManage"
        static let HiAdmin = "Hi,\nAdmin"
        static let NotificationManage = "Notifications\nManage"
        
    }
    
    //MARK:-- Privacy
    class Privacy {
        static let PrivacyPolicy = "Privacy\nPolicy"
        static let ContentPrivacyPolicy = "Your privacy is important to us. It is The Uni Company's policy to respect your privacy regarding any information we may collect from you through our app, The Uni.\nWe only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.\nWe only retain collected information for as long as necessary to provide you with your requested service.\nWhat data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.\nWe don’t share any personally identifying information publicly or with third-parties, except when required to by law.\nOur app may link to external sites that are not operated by us. Please be aware that we have no control over the content and practices of these sites, and cannot accept responsibility or liability for their respective privacy policies.\nYou are free to refuse our request for your personal information, with the understanding that we may be unable to provide you with some of your desired services.\nYour continued use of our app will be regarded as acceptance of our practices around privacy and personal information. If you have any questions about how we handle user data and personal information, feel free to contact us.\nThis policy is effective as of 30 October 2020."
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
    
    //MARK: -- Send Notification
    class SendNotification {
        static let SendNotification = "Send\nNotification"
    }
    
    //MARK: -- List Notification
    class ListNotification {
        static let ListNotification = "List\nNotifications"
    }
}
