//
//  ShopCheckoutVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 02/02/2022.
//

import UIKit
import StoreKit
import LanguageManager_iOS

class ShopCheckoutVC: UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblPackageDes: UILabel!
    @IBOutlet weak var lblPackageFeatures2: UILabel!
    @IBOutlet weak var lblPackageFeatures: UILabel!
    
    @IBOutlet weak var viewPromoCode: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var viewDiscount: UIView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
        
    var myProduct: SKProduct?


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        if Shared.shared.packageIsFree == true{
            viewPromoCode.isHidden = true
        }
        lblTitle.text = Shared.shared.btnBack
        lblPackageName.text = Shared.shared.packageName
        lblDuration.text = Shared.shared.packageDuration
        lblPrice.text = Shared.shared.packagePrice
        lblPackageDes.text = Shared.shared.packageDes
        lblPackageFeatures.text = Shared.shared.packageFeatures
        lblPackageFeatures2.text = "Package features\n"

    }
    

    
    func fetchProducts(){
        let request = SKProductsRequest(productIdentifiers: ["\(Shared.shared.packagePurchaseAppleId)"])
        request.delegate = self
        request.start()
    }
    
    

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCheckout(_ sender: Any) {
        guard let myProduct = myProduct else{
            return
        }
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }

    }

}

extension ShopCheckoutVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            myProduct = product
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
               case .purchased:
                 complete(transaction: transaction)
                 break
               case .failed:
                 fail(transaction: transaction)
                 break
               case .restored:
                 restore(transaction: transaction)
                 break
               case .deferred:
                 break
               case .purchasing:
                 break
               }
        }
    }
    private func complete(transaction: SKPaymentTransaction) {
      SKPaymentQueue.default().finishTransaction(transaction)
        SKPaymentQueue.default().remove(self)
                Spinner.instance.showSpinner(onView: view)
                    var parameter = [:] as [String:Any]
                    parameter = ["package_id" : Shared.shared.packageId,
                                 "payment_method":"purchase",
                                 "txn_id":"\(Int.random(in: 0..<10000000000000))",
                                 "coach_id":"\(Shared.shared.getCoachId() ?? 0)"]

                ControllerService.instance.packagePost(param: parameter) { data, bool in
                    Spinner.instance.removeSpinner()
                    if bool{
                        let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "PurchaseSuccesfulVC")
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: true, completion: nil)
                    }else{
                        ToastView.shared.short(self.view, txt_msg: data)
                    }
                }

    }

    private func restore(transaction: SKPaymentTransaction) {
      guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }

      SKPaymentQueue.default().finishTransaction(transaction)
        SKPaymentQueue.default().remove(self)
//        deliverPurchaseNotificationFor(identifier: productIdentifier)
    }

    private func fail(transaction: SKPaymentTransaction) {
      print("fail...")
      if let transactionError = transaction.error as NSError?,
        let localizedDescription = transaction.error?.localizedDescription,
          transactionError.code != SKError.paymentCancelled.rawValue {
          print("Transaction Error: \(localizedDescription)")
        }

      SKPaymentQueue.default().finishTransaction(transaction)
        SKPaymentQueue.default().remove(self)
    }

}
