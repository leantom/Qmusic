//
//  WEExtensions+Notification.Name.swift
//  facepay_v3
//
//  Created by Nguyen Thanh Duc on 27/11/2020.
//

import Foundation

public extension Notification.Name {
    static let noInternetConnection = Notification.Name("noInternetConnection")
    static let reconnectInternetConnection = Notification.Name("reconnectInternetConnection")
    static let cellularInternetConnection = Notification.Name("cellularInternetConnection")
    static let autoLockAppNotification = Notification.Name("auto.lock.app.notification")
    static let appBecomActive = Notification.Name("app.becom.active.notification")
    static let changeMailFromProfile = Notification.Name("changeMailFromProfile")
    static let updatedAvatarStatus = Notification.Name("updatedAvatarStatus")
    static let updatedAvatarStatusFromProfile = Notification.Name("updatedAvatarStatusFromProfile")
    static let updatedMailSuccess = Notification.Name("updatedMailSuccess")
    static let unlockAppFinish = Notification.Name("unlockAppFinish")
    static let hideKeyboard = Notification.Name("hideKeyboard")
    static let outToLogin = Notification.Name("outToLogin")
    
    static let didFinishedAddDisbursementBank = Notification.Name("didFinishedAddDisbursementBank")
    static let didFinishedRemoveBank = Notification.Name("didFinishedRemoveBank")
    static let showKeyboard = Notification.Name("showKeyboard")
    static let reloadAvatar = Notification.Name("reloadAvatar")
    static let checkLockVerifyMpin = Notification.Name("checkLockVerifyMpin")
    static let sessionExpire = Notification.Name("session_expire")
    static let anotherDevice = Notification.Name("another_device")
    static let updateLanguage = Notification.Name("update_language")
    static let getCustomerProfile = Notification.Name("getCustomerProfile")
    static let reloadBankList = Notification.Name("reloadBankList")
    static let reloadDisbursementBank = Notification.Name("reloadDisbursementBank")
    static let showInsurancePopup = Notification.Name("showInsurancePopup")
    static let newNotification = Notification.Name("new_notifications")
    static let refreshData = Notification.Name("refreshData")
    static let setupTimerLoadlistLoan = Notification.Name("setupTimerLoadlistLoan")
    static let reloadPendingTaskHome = Notification.Name("reloadPendingTaskHome")
    static let reloadLoanListInHome = Notification.Name("reloadLoanListInHome")
    static let getEmailInfor = Notification.Name("getEmailInfor")
    static let getWelcome = Notification.Name("getWelcome")
    static let reloadExplore = Notification.Name("reloadExplore")
    static let optionalLoanSave = Notification.Name("optionalLoanSave")
    
    static let pickupFaceAuthNoti = Notification.Name("pickupCash_faceAuth")
    static let endVideoCall = Notification.Name("endVideoCall")
    
    static let audioStateVideoCall = Notification.Name("audioStateVideoCall")
    static let speakerVideoCall = Notification.Name("speakerVideoCall")
    static let reloadHistoryPaidBillPayment = Notification.Name("reloadHistoryPaidBillPayment")
    static let refreshNotification = Notification.Name("refreshNotification")
    
    static let reloadisUserExists = Notification.Name("reloadisUserExists")
    static let refreshDCardData = Notification.Name("refreshDCardData")
    
    static let lendingEKYCSuccess = Notification.Name("lendingEKYCSuccess")
    static let lendingEKYCFailed = Notification.Name("lendingEKYCFailed")
    static let lendingEKYCCancel = Notification.Name("lendingEKYCCancel")
    static let EKYCSuccess = Notification.Name("EKYCSuccess")
    static let EKYCFailed = Notification.Name("EKYCFailed")
    static let EKYCRejected = Notification.Name("EKYCRejected")
    
    static let checkForceUpdate = Notification.Name("checkForceUpdate")
    
}
