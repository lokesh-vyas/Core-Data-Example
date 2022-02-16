////
////  RecentDataCoreData.swift
////  CoreDataExample
////
////  Created by Lokesh Kumar Vyas on 28/03/21.
////  Copyright © 2021 Lokesh Kumar Vyas. All rights reserved.
////
//
import Foundation
import CoreData


public class PayeeDataMO: NSManagedObject {

}

extension PayeeDataMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PayeeDataMO> {
        return NSFetchRequest<PayeeDataMO>(entityName: "PayeeDataMO")
    }
    @NSManaged public var bank: String?
    @NSManaged public var bank_logo: String?
    @NSManaged public var benacctno: String?
    @NSManaged public var benaccttype: String?
    @NSManaged public var beneficiaryID: String?
    @NSManaged public var beneficiaryType: String?
    @NSManaged public var benfullname: String?
    @NSManaged public var bennickname: String?
    @NSManaged public var benstatus: String?
    @NSManaged public var coolinghour: String?
    @NSManaged public var createdtime: String?
    @NSManaged public var favourites: String?
    @NSManaged public var ifsccode: String?
    @NSManaged public var imps_ifsc: String?
    @NSManaged public var isBlocked: String?
    @NSManaged public var mmid: String?
    @NSManaged public var mobilenumber: String?
    @NSManaged public var notiid: String?
    @NSManaged public var time_remaining: String?
    @NSManaged public var parentid : String? // ACCOUNT, IMPS,MOBILE,UPI
    @NSManaged public var childid : String?  // Beneficiary , Payee
    @NSManaged public var id : String?

}

extension PayeeDataMO {

    @objc(addPayeeObject:)
    @NSManaged public func addPayeeData(_ value: PayeeDataMO)

    @objc(removePayeeObject:)
    @NSManaged public func removePayeeData(_ value: PayeeDataMO)

}



