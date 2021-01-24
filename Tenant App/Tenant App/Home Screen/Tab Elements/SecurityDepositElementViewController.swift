//
//  SecurityDepositElementViewController.swift
//  Tenant App
//
//  Created by Rhys Mahon on 28/07/2019.
//  Copyright © 2019 Rhys Mahon. All rights reserved.
//

import UIKit

class SecurityDepositElementViewController: UIViewController {

    @IBOutlet weak var viewCover: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCover.alpha = 1
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "showSecurityView"), object: nil, queue: nil, using: showView)
         NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "securityOnPinOrDrop"), object: nil, queue: nil, using: changeViewOnPinOrDrop)
        
        // Do any additional setup after loading the view.
    }
    
    
    func showView(notification: Notification) {
        guard let percentage = notification.userInfo!["percentage"] as? CGFloat else {print("failed to convert to CGFLOat")
            return}
        self.viewCover.alpha = CGFloat(1.0) - percentage
        //self.pullIcon.alpha = percentage
        
    }
    
    func changeViewOnPinOrDrop(notification: Notification) {
        guard let percentage = notification.userInfo!["percentage"] as? CGFloat else {print("failed to convert to CGFLOat")
            return}
        UIView.animate(withDuration: 0.2) {
            self.viewCover.alpha = percentage
            //self.pullIcon.alpha = (percentage - 1) * (-1)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
