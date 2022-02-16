//
//  SecondViewController.swift
//  CoreDataExample
//
//  Created by Lokesh Kumar Vyas on 26/03/21.
//  Copyright © 2021 Lokesh Kumar Vyas. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var beneName: UILabel!
    @IBOutlet weak var accNu: UILabel!
    @IBOutlet weak var benID: UILabel!
    @IBOutlet weak var Fav: UILabel!
    
    var beneficary : PayeeDataMO?
    var beneficiaryData : [PayeeDataMO]?
    var payeeData : [PayeeDataMO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beneName.text = "ID: \(beneficary?.id ?? "" )"
        self.name.text = "Name: \(beneficary?.benfullname ?? "")"
        self.benID.text = "Ben ID: \(beneficary?.beneficiaryID ?? "")"
        self.accNu.text = "Ben Acc: \(beneficary?.benacctno ?? "")"
        self.Fav.text = "Favourites: \(beneficary?.favourites ?? "") "
        if beneficary?.favourites == "N" {
            self.Fav.textColor = .black
        } else {
            self.Fav.textColor = .green
        }
    }
    
    @IBAction func deleteRecord(_ sender: Any) {
        self.databaseAction(forUpadte: false, forDelete: true, value: "")
    }
    
    @IBAction func updateAction(_ sender: Any) {
        var updateValue = ""
        if beneficary?.favourites == "N" {
            updateValue = "Y"
        } else {
            updateValue = "N"
        }
        self.databaseAction(forUpadte: true, forDelete: false, value: updateValue)
    }
    
    private func databaseAction(forUpadte:Bool,forDelete:Bool,value:String){
        let _ids = self.getId(beneficiary: self.beneficary, payeeData: payeeData, beneficiaryData: beneficiaryData)
        if _ids.contains(self.beneficary?.id ?? "") {
            for id in _ids {
                FundTransferDataWriter.sharedInstance.updateRecentBeneficiary(forDelete: forDelete, forUpdate: forUpadte,id:id,favourites:value)
            }
        } else {
            FundTransferDataWriter.sharedInstance.updateRecentBeneficiary(forDelete: forDelete, forUpdate: forUpadte,id:self.beneficary?.id ?? "",favourites:value)
        }
    }
    
    func getId(beneficiary:PayeeDataMO?,payeeData:[PayeeDataMO]?,beneficiaryData:[PayeeDataMO]?) -> [String] {
        if let _beneficiary = beneficiary {
            var id = [String]()
            if let _payeeData = payeeData {
                let payeeID = _payeeData.filter({$0.beneficiaryID == _beneficiary.beneficiaryID}).first
                if payeeID != nil {
                    id.append(payeeID?.id ?? "")
                }
            }
            if let _beneficiaryData = beneficiaryData {
                let beneficaryId = _beneficiaryData.filter({$0.beneficiaryID == _beneficiary.beneficiaryID}).first
                if beneficaryId != nil {
                    id.append(beneficaryId?.id ?? "")
                }
            }
            return id
        }
        return [""]
    }
    
    
}
