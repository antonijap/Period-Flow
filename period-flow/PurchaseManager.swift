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
    lazy var productIDs: Set<String> = ["com.antonijapek.periodflow.propack"]
    
    // MARK: - Methods
    
    func requestProducts() {
        let productRequest = SKProductsRequest(productIdentifiers: productIDs)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func getProductDetails() {
        for product in products {
            print(product.price)
            print(product.localizedTitle)
        }
    }
    
}


    // MARK: - Extension: SKProductsRequestDelegate

extension PurchaseManager: SKProductsRequestDelegate {
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print(response.products)
        print(response.invalidProductIdentifiers)
        
        products = response.products
        getProductDetails()
    }
}

    // MARK: - Extension: SKPaymentTransactionObserver

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}