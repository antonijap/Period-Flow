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
    func createPayment(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    
    /// Restores previously completed transactions, required by Apple
    func restoreTransactions() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
}


    // MARK: - Extension: SKProductsRequestDelegate

extension PurchaseManager: SKProductsRequestDelegate {
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        products = response.products
    }
}

    // MARK: - Extension: SKPaymentTransactionObserver

extension PurchaseManager: SKPaymentTransactionObserver {
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                case .Purchased:
                    DefaultsManager.unlockProPack()
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                case .Failed:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                case .Restored:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                case .Purchasing:
                    break
                case .Deferred:
                    break
            }
        }
    }
}