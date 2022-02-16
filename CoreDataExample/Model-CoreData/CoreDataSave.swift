//
//  CoreDataSave.swift
//  CoreDataExample
//
//  Created by Lokesh Kumar Vyas on 28/03/21.
//  Copyright © 2021 Lokesh Kumar Vyas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum SendToMoneyList :String {
    case ACCOUNT     = "ACCOUNT"
    case UPI         = "UPI"
    case IMPS        = "IMPS"
    case MOBILE      = "MOBILE"
    case Beneficiary = "Beneficiary"
    case Payee       = "Payee"
}
struct Entities {
    static let PayeeDataMO = "PayeeDataMO"
}

struct Entities1 {
    static let IMPS        = "IMPS"
    static let UPI         = "UPI"
    static let MOBILE      = "MOBILE"
    static let ACCOUNT     =  "ACCOUNT"
}

var coreDataUniqueNumber = 0

class FundTransferDataWriter: NSObject {
    
    static let sharedInstance: FundTransferDataWriter = FundTransferDataWriter.init()
    
    func getMOC() -> NSManagedObjectContext {
        return CoreDataStack.sharedInstance.managedObjectContext
    }
    
    func deleteAllBatch() {
        
        let moc = getMOC()
        moc.perform() {
            let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.PayeeDataMO)
            let deleteRequest = NSBatchDeleteRequest.init(fetchRequest: fetchRequest)
            do {
                try moc.execute(deleteRequest)
                DispatchQueue.main.async {
                    CoreDataStack.sharedInstance.saveContext() { error in
                        
                    }
                }
            }
            catch {
                
            }
        }
    }
    
    func getRecentBeneficiary(parentID: SendToMoneyList,id:SendToMoneyList, completion: @escaping (_ response: [PayeeDataMO]?, _ error: NSError?) -> ()) {
        let context = self.getMOC()
        context.perform {
            let fetchRequest : NSFetchRequest<PayeeDataMO> = PayeeDataMO.fetchRequest()
            
            var predicateArray: [NSPredicate] = []
            let pred = NSPredicate(format: "parentid == %@", parentID.rawValue)
            predicateArray.append(pred)
            let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicateArray)
            fetchRequest.predicate = orPredicate
            do {
                let objects = try context.fetch(fetchRequest)
                completion(objects, nil)
            } catch let error {
                completion(nil, error as NSError)
            }
        }
    }
    
    func updateRecentBeneficiary(forDelete:Bool = false, forUpdate:Bool = false,id:String,favourites:String)
    {
        let context = self.getMOC()
        context.perform {
            let fetchRequest : NSFetchRequest<PayeeDataMO> = PayeeDataMO.fetchRequest()
            
            let _recentPayeeData = NSEntityDescription.entity(forEntityName: Entities.PayeeDataMO, in: context)!
            
            let beneficaryMO: PayeeDataMO = NSManagedObject(entity: _recentPayeeData, insertInto: context) as! PayeeDataMO
            
            var predicateArray: [NSPredicate] = []
            let pred = NSPredicate(format: "id == %@", id)
            predicateArray.append(pred)
            let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicateArray)
            fetchRequest.predicate = orPredicate
            do {
                let objects = try context.fetch(fetchRequest)
                if forDelete == true {
                    for entity in objects {
                        context.delete(entity)
                    }
                } else if forUpdate == true {
                    if objects.count != 0 { // Atleast one was returned
                        
                        // In my case, I only updated the first item in results
                        objects[0].setValue(favourites, forKey: "favourites")
                    }
                }
            } catch _ {
            }
            CoreDataStack.sharedInstance.saveContext() { error in
            }
        }
    }
    
    func saveMenuToLocalDB(recentPayeeData: RecentPayeeBeneficiaryData, completion: @escaping (_ error: NSError?) -> ()) {
        
        let context = self.getMOC()
        
        guard let recentTypeData = recentPayeeData.data else { return }
        
        if let accountData = recentTypeData.ACCOUNT {
            
            if let beneficaryData = accountData.beneficiaries, beneficaryData.count > 0 {
                for beneficary in beneficaryData {
                    
                    self.saveBeneficaryData(context:context,beneficary:beneficary,parentId: SendToMoneyList.ACCOUNT.rawValue, id: SendToMoneyList.Beneficiary.rawValue)
                }
            }
            
            if let payeeData = accountData.payee, payeeData.count > 0 {
                for beneficary in payeeData {
                    self.saveBeneficaryData(context:context,beneficary:beneficary,parentId: SendToMoneyList.ACCOUNT.rawValue, id: SendToMoneyList.Payee.rawValue)
                }
            }
        }
        
        if let accountData = recentTypeData.IMPS {
            
            if let beneficaryData = accountData.beneficiaries, beneficaryData.count > 0 {
                for beneficary in beneficaryData {
                    
                    self.saveBeneficaryData(context:context,beneficary:beneficary,parentId: SendToMoneyList.IMPS.rawValue, id: SendToMoneyList.Beneficiary.rawValue)
                }
            }
            
            if let payeeData = accountData.payee, payeeData.count > 0 {
                for beneficary in payeeData {
                    self.saveBeneficaryData(context:context,beneficary:beneficary,parentId: SendToMoneyList.IMPS.rawValue, id: SendToMoneyList.Payee.rawValue)
                }
            }
        }
        if let accountData = recentTypeData.UPI {
            
            if let beneficaryData = accountData.beneficiaries, beneficaryData.count > 0 {
                for beneficary in beneficaryData {
                    
                    self.saveBeneficaryData(context:context,beneficary:beneficary,parentId: SendToMoneyList.UPI.rawValue, id: SendToMoneyList.Beneficiary.rawValue)
                }
            }
            
            if let payeeData = accountData.payee, payeeData.count > 0 {
                for beneficary in payeeData {
                    self.saveBeneficaryData(context:context,beneficary:beneficary,parentId: SendToMoneyList.UPI.rawValue, id: SendToMoneyList.Payee.rawValue)
                }
            }
        }
        if let accountData = recentTypeData.MOBILE {
            
            if let beneficaryData = accountData.beneficiaries, beneficaryData.count > 0 {
                for beneficary in beneficaryData {
                    
                    self.saveBeneficaryData(context:context,beneficary:beneficary,parentId: SendToMoneyList.MOBILE.rawValue, id: SendToMoneyList.Beneficiary.rawValue)
                }
            }
            
            if let payeeData = accountData.payee, payeeData.count > 0 {
                for beneficary in payeeData {
                    self.saveBeneficaryData(context:context,beneficary:beneficary,parentId: SendToMoneyList.MOBILE.rawValue, id: SendToMoneyList.Payee.rawValue)
                }
            }
        }
        
        CoreDataStack.sharedInstance.saveContext() { error in
            completion(error)
        }
    }
    
    private func saveBeneficaryData(context:NSManagedObjectContext,beneficary:BeneficiaryData,parentId:String,id:String) {
        
        let _recentPayeeData = NSEntityDescription.entity(forEntityName: Entities.PayeeDataMO, in: context)!
        
        let beneficaryMO: PayeeDataMO = NSManagedObject(entity: _recentPayeeData, insertInto: context) as! PayeeDataMO
        
        beneficaryMO.bank = beneficary.bank
        beneficaryMO.bank_logo = beneficary.bank_logo
        beneficaryMO.benacctno = beneficary.benacctno
        beneficaryMO.benaccttype = beneficary.benaccttype
        beneficaryMO.beneficiaryID = beneficary.beneficiaryID
        beneficaryMO.beneficiaryType = beneficary.beneficiaryType
        beneficaryMO.benfullname = beneficary.benfullname
        beneficaryMO.bennickname = beneficary.bennickname
        beneficaryMO.benstatus = beneficary.benstatus
        beneficaryMO.coolinghour = beneficary.coolinghour
        
        beneficaryMO.createdtime = beneficary.createdtime
        beneficaryMO.favourites = beneficary.favourites
        beneficaryMO.ifsccode = beneficary.ifsccode
        beneficaryMO.imps_ifsc = beneficary.imps_ifsc
        beneficaryMO.isBlocked = beneficary.isBlocked
        
        beneficaryMO.mmid = beneficary.mmid
        beneficaryMO.mobilenumber = beneficary.mobilenumber
        beneficaryMO.notiid = beneficary.notiid
        beneficaryMO.time_remaining = beneficary.time_remaining
        beneficaryMO.parentid = parentId
        beneficaryMO.childid = id
        beneficaryMO.id = FundTransferDataWriter.sharedInstance.uniqueNumber()
        
    }
    
    func uniqueNumber() -> String {
        coreDataUniqueNumber += 1
        return String(coreDataUniqueNumber)
    }
}

fileprivate struct CoreDataStackConst {
    static let resourceName = "CoreDataExample"
    static let resourceType = "momd"
    static let persistentStore = "CoreDataExample.sqlite"
}

class CoreDataStack: NSObject {
    
    let storeType = NSSQLiteStoreType
    let modelName: String = CoreDataStackConst.resourceName
    let resourceType = CoreDataStackConst.resourceType
    let persistentStore: String = CoreDataStackConst.persistentStore
    static let sharedInstance = CoreDataStack.init()
    
    override init() {
        super.init()
        setupNotificationHandling()
    }
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(CoreDataStack.saveChanges(_:)), name: NSNotification.Name.NSExtensionHostDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(CoreDataStack.saveChanges(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    // MARK: - Notification Handling
    
    func saveContext(completion: @escaping (_ error: NSError?) -> () ) {
        
        managedObjectContext.perform {
            do {
                if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Managed Object Context")
                //dprint("\(saveError), \(saveError.localizedDescription)")
                completion(saveError)
                return
            }
            
            self.privateManagedObjectContext.perform {
                do {
                    if self.privateManagedObjectContext.hasChanges {
                        try self.privateManagedObjectContext.save()
                    }
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Changes of Private Managed Object Context")
                    //dprint("\(saveError), \(saveError.localizedDescription)")
                    completion(saveError)
                    return
                }
            }
        }
        completion(nil)
    }
    
    @objc func saveChanges(_ notification: NSNotification) {
        saveContext { (_) in }
    }
    
    // MARK: - Managed object contexts
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    // MARK: - Private Core Data Stack methods
    lazy private var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        return urls.last!
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: self.resourceType)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let options : [AnyHashable: Any] = [NSInferMappingModelAutomaticallyOption : true,
                                            NSMigratePersistentStoresAutomaticallyOption : true,
                                            NSPersistentStoreFileProtectionKey: FileProtectionType.complete]
        
        let url = storePath()
        do {
            try coordinator.addPersistentStore(ofType: self.storeType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data." as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.nuclei.FlightCoreDataStack", code: 9999, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    func storePath() -> URL {
        let sqliteFileLocation = "\(self.persistentStore)"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(sqliteFileLocation)
        return url
    }
    
}

