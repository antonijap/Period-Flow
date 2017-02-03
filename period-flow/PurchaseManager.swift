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
    lazy var productIDs: Set<String> = [PURCHASE_PROPACK]
    
    // MARK: - Methods
    
    /// Requests available products for in app purchase
    func requestProducts() {
        let productRequest = SKProductsRequest(productIdentifiers: productIDs)
        productRequest.delegate = self
        productRequest.start()
    }
    
    // FIXME: Incomplete
    func getProductDetails() {
        for product in products {
            print(product.price)
            print(product.productIdentifier)
            print(product.localizedTitle)
        }
    }
    
    /// Creates a payment for a in app purchase product
    func createPayment(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    
    /// Restores previously completed transactions, required by Apple
    func restoreTransactions() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}


    // MARK: - Extension: SKProductsRequestDelegate

extension PurchaseManager: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }
}

    // MARK: - Extension: SKPaymentTransactionObserver

extension PurchaseManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchased:
                    DefaultsManager.unlockProPack()
                    print("PRO Pack is just unlocked.")
                    SKPaymentQueue.default().finishTransaction(transaction)
                    NotificationCenter.default.post(name: Notification.Name("UpdateUI"), object: nil)
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .purchasing:
                    break
                case .deferred:
                    break
            }
        }
    }
}
