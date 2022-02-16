//
//  MainViewController.swift
//  CoreDataExample
//
//  Created by Lokesh Vyas on 25/06/21.
//  Copyright © 2021 Lokesh Kumar Vyas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FundTransferDataWriter.sharedInstance.deleteAllBatch()
        if let localData = self.readLocalFile(forName: "Recent") {
            self.parse(jsonData: localData)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func accountOpen(_ sender: Any) {
        self.redirectToNextView(selectedOption: .ACCOUNT)
    }
    @IBAction func sendToMMID(_ sender: Any) {
        self.redirectToNextView(selectedOption: .IMPS)
    }
    
    @IBAction func sendToMobile(_ sender: Any) {
        self.redirectToNextView(selectedOption: .MOBILE)
    }
    
    @IBAction func sendToUPI(_ sender: Any) {
        self.redirectToNextView(selectedOption: .UPI)
    }
    
    private func redirectToNextView(selectedOption:SendToMoneyList){
        let vc = ViewController.instantiate(fromAppStoryboard: .main)
        vc.selectedOption = selectedOption
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(RecentPayeeBeneficiaryData.self,
                                                       from: jsonData)
            FundTransferDataWriter.sharedInstance.saveMenuToLocalDB(recentPayeeData: decodedData, completion: {_ in
            })
            print("===================================")
        } catch {
            print("decode error")
        }
    }
}
