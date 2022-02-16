//
//  RecentBeneficiaryModal.swift
//  CoreDataExample
//
//  Created by Lokesh Kumar Vyas on 26/03/21.
//  Copyright © 2021 Lokesh Kumar Vyas. All rights reserved.
//

import Foundation
import UIKit

struct RecentPayeeBeneficiaryData :Codable {
    let status :Bool?
    let title : String?
    let message : String?
    let success : Bool?
    let data : RecentPayeeAllBeneficiaryData?
}

struct RecentPayeeAllBeneficiaryData :Codable {
    let IMPS :PayeeAllBeneficiaryData?
    let ACCOUNT:PayeeAllBeneficiaryData?
    let UPI :PayeeAllBeneficiaryData?
    let MOBILE :PayeeAllBeneficiaryData?
}

struct PayeeAllBeneficiaryData :Codable {
    let stauts : String?
    let beneficiaries : [BeneficiaryData]?
    let payee : [BeneficiaryData]?
}

struct BeneficiaryData :Codable {
    var bank, bank_logo,benacctno,benaccttype,beneficiaryID,beneficiaryType,benfullname : String?
    var bennickname, benstatus, coolinghour, createdtime,favourites,ifsccode,imps_ifsc,isBlocked,mmid : String
    var mobilenumber,notiid,time_remaining : String?
    var id,parentid : String?
}



enum AppStoryboard: String {
    case main = "Main"
 
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
 
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
 
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile")
        }
        return scene
    }
 
    func initialViewController() -> UIViewController? {
 
        return instance.instantiateInitialViewController()
    }
}
 
extension UIViewController {
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID: String {
        return "\(self)"
    }
 
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
