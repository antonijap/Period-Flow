//
//  PurchaseViewController.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController {
    
    // MARK: - Properties
    
    var purchaseManager: PurchaseManager?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPurchaseManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func setupPurchaseManager() {
        purchaseManager = PurchaseManager()
        purchaseManager?.requestProducts()
    }
    
    // MARK: - IBActions
    
    @IBAction func purchaseProPackPressed(sender: AnyObject) {
        if let product = purchaseManager?.products.first where product.productIdentifier == "com.antonijapek.periodflow.propack" {
            purchaseManager?.createPayment(product)
        }

    }
    
    @IBAction func restorePressed(sender: AnyObject) {
        purchaseManager?.restoreTransactions()
    }
    
}
