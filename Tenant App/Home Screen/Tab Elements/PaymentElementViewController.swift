//
//  PaymentElementViewController.swift
//  Tenant App
//
//  Created by Rhys Mahon on 27/07/2019.
//  Copyright © 2019 Rhys Mahon. All rights reserved.
//

import UIKit

class PaymentElementViewController: UIViewController {

    @IBOutlet weak var viewCover: UIView!
    @IBOutlet weak var pullIcon: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewCover.alpha = 1
        //pullIcon.alpha = 100
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "showPaymentsView"), object: nil, queue: nil, using: showView)

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "paymentOnPinOrDrop"), object: nil, queue: nil, using: changeViewOnPinOrDrop)
        // Do any additional setup after loading the view.
    }
    
    func showView(notification: Notification) {
        guard let percentage = notification.userInfo!["percentage"] as? CGFloat else {print("failed to convert to CGFLOat")
            return}
        //self.viewCover.alpha = CGFloat(1.0) - percentage
        //self.pullIcon.alpha = 100;
        
    }
    
    func changeViewOnPinOrDrop(notification: Notification) {
        guard let percentage = notification.userInfo!["percentage"] as? CGFloat else {print("failed to convert to CGFLOat")
            return}
                UIView.animate(withDuration: 0.2) {
                    //self.viewCover.alpha = percentage
                    //self.pullIcon.alpha = 100
                }
    }


}
