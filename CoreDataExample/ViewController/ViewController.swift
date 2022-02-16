//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Lokesh Kumar Vyas on 26/03/21.
//  Copyright © 2021 Lokesh Kumar Vyas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var BeneficiaryList: UITableView!
    
    var beneficiaryData : [PayeeDataMO]?
    var payeeData : [PayeeDataMO]?
    var selectedOption : SendToMoneyList = SendToMoneyList.ACCOUNT
    override func viewDidLoad() {
        super.viewDidLoad()
        BeneficiaryList.delegate = self
        BeneficiaryList.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FundTransferDataWriter.sharedInstance.getRecentBeneficiary(parentID: selectedOption, id: SendToMoneyList.Beneficiary, completion: {response,error in
            self.payeeData = response?.filter({$0.childid == "Payee"})
            self.beneficiaryData = response?.filter({$0.childid == "Beneficiary"})
            self.BeneficiaryList.reloadData()
        })
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSection = 0
        if payeeData != nil , payeeData?.count ?? 0 > 0 {
            numberOfSection += 1
        }
        
        if beneficiaryData != nil , beneficiaryData?.count ?? 0 > 0 {
            numberOfSection += 1
        }
        
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section)
        {
        case 0:
            return "Recent"
        case 1:
            return "Beneficiary"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch(section)
        {
        case 0:
            return self.payeeData?.count ?? 0
        case 1:
            return self.beneficiaryData?.count ?? 0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            switch(indexPath.section)
            {
            case 0:
                let cell =
                    BeneficiaryList.dequeueReusableCell(withIdentifier: "Cell",
                                                        for: indexPath)
                if self.payeeData?[indexPath.row].favourites == "N" {
                    cell.textLabel?.textColor = .black
                } else {
                    cell.textLabel?.textColor = .green
                }
                cell.textLabel?.text = self.payeeData?[indexPath.row].benfullname
                return cell
            case 1:
                let cell =
                    BeneficiaryList.dequeueReusableCell(withIdentifier: "Cell",
                                                        for: indexPath)
                if self.beneficiaryData?[indexPath.row].favourites == "N" {
                    cell.textLabel?.textColor = .black
                } else {
                    cell.textLabel?.textColor = .green
                }
                cell.textLabel?.text = self.beneficiaryData?[indexPath.row].benfullname
                return cell
                
            default:
                let cell =
                    BeneficiaryList.dequeueReusableCell(withIdentifier: "Cell",
                                                        for: indexPath)
                cell.textLabel?.text = self.beneficiaryData?[indexPath.row].benfullname
                return cell
            }
            
            
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SecondViewController.instantiate(fromAppStoryboard: .main)
        switch(indexPath.section)
        {
        case 0:
            let bene = self.payeeData?[indexPath.row]
            vc.beneficary = bene
            vc.payeeData = self.payeeData
            vc.beneficiaryData = self.beneficiaryData
        case 1:
            let bene = self.beneficiaryData?[indexPath.row]
            vc.beneficary = bene
            vc.payeeData = self.payeeData
            vc.beneficiaryData = self.beneficiaryData
        default:
            let bene = self.beneficiaryData?[indexPath.row]
            vc.beneficary = bene
            vc.payeeData = self.payeeData
            vc.beneficiaryData = self.beneficiaryData
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
