//
//  PurchaseManager.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject {
    
    // MARK: - Properties
    lazy var products = [SKProduct]()
    
}

extension PurchaseManager: SKProductsRequestDelegate {
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        products = response.products
    }
}

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}