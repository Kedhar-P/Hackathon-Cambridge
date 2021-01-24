//
//  MainViewController.swift
//  Tenant App
//
//  Created by Rhys Mahon on 27/07/2019.
//  Copyright © 2019 Rhys Mahon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollisionBehaviorDelegate {

    
    struct DragVars {
        static var dragStartPointY = CGFloat()
    }
    
    struct initialYPosition {
        static var paymentView = CGFloat()
        static var complaintsView = CGFloat()
        static var securityDepositView = CGFloat()
    }
    
    struct globalVars {
        static var pinnedViews = [9]
    }
    
    
    var views = [UIView]()
    var animator:UIDynamicAnimator!
    var gravity:UIGravityBehavior!
    var paymentSnap:UISnapBehavior!
    var complaintSnap:UISnapBehavior!
    var securityDeposit:UISnapBehavior!
    var previousTouchPoint:CGPoint!
    var viewDragging = false
    var viewPinned = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        
        animator.addBehavior(gravity)
        gravity.magnitude = 4
        
        
        var offset:CGFloat = 630 //Height of top tab 418
        
        //for i in 0 ... 2 {
            if let view = addViewController(atOffset: offset, call: 0) {
                views.append(view)
                offset -= 115 //Height between tabs
            }
        //}
        
    }
    
    
    func addViewController (atOffset offset:CGFloat, call:NSInteger) -> UIView? {
        let yPosition = self.view.bounds.size.height - offset
        let frameForView = self.view.bounds.offsetBy(dx: 0, dy: yPosition)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var stackElementVC = UIViewController()

        if call == 0 {
            stackElementVC = sb.instantiateViewController(withIdentifier: "PaymentElement")
            initialYPosition.paymentView = yPosition
        } else if call == 1 {
            stackElementVC = sb.instantiateViewController(withIdentifier: "ComplaintElement")
            initialYPosition.complaintsView = yPosition
        } else {
            stackElementVC = sb.instantiateViewController(withIdentifier: "SecurityDepositElement")
            initialYPosition.securityDepositView = yPosition
        }
        
        
        if let view = stackElementVC.view {
            view.frame = frameForView
            view.layer.cornerRadius = 40
            view.layer.shadowOffset = CGSize(width: 0, height: 75)
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowRadius = 50
            view.layer.shadowOpacity = 1
            if call == 0 {
                stackElementVC.view.tag = 1
            } else if call == 1 {
                stackElementVC.view.tag = 2
            } else {
                stackElementVC.view.tag = 3
            }
            
            
            self.addChild(stackElementVC)
            self.view.addSubview(view)
            stackElementVC.didMove(toParent: self)
            
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.handlePan(gestureRecognizer:)))
            view.addGestureRecognizer(panGestureRecognizer)
            
            let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.handleTap(gestureRecognizer:)))
            view.addGestureRecognizer(tapGestureReconizer)
            

            let collision = UICollisionBehavior(items: [view])
            collision.collisionDelegate = self
            animator.addBehavior(collision)
            
            let boundary = view.frame.origin.y + view.frame.size.height
            
            // lower boundary
            var boundaryStart = CGPoint(x: 0, y: boundary)
            var boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: boundary)
            collision.addBoundary(withIdentifier: 1 as NSCopying, from: boundaryStart, to: boundaryEnd)
            
            
            // upper boundary
            boundaryStart = CGPoint(x: 0, y: 0)
            boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: 0)
            collision.addBoundary(withIdentifier: 2 as NSCopying, from: boundaryStart, to: boundaryEnd)
            
            
            gravity.addItem(view)
            let itemBehavior = UIDynamicItemBehavior(items: [view])
            itemBehavior.allowsRotation = false //Key
            animator.addBehavior(itemBehavior)
            
            return view
        }
        
        return nil
    }
    

    
    
    @objc func handlePan (gestureRecognizer:UIPanGestureRecognizer) {
        
//        let touchPoint = gestureRecognizer.location(in: self.view)
//        let draggedView = gestureRecognizer.view!
//        //let draggedView =  view.viewWithTag(0)!
//
//        if gestureRecognizer.state == .began {
//            let dragStartPoint = gestureRecognizer.location(in: draggedView)
//
//            if dragStartPoint.y < 200 { //How much you can drag from top of each
//                viewDragging = true
//                previousTouchPoint = touchPoint
//            }
//            DragVars.dragStartPointY = gestureRecognizer.location(in: nil).y //changed to nil
//
//
//        } else if gestureRecognizer.state == .changed && viewDragging {
//
//            let yOffset = previousTouchPoint.y - touchPoint.y
//            let draggedViewX = draggedView.center.x
//            let draggedViewY = draggedView.center.y - yOffset
//
//            // Repositions views and changes alpha as you drag
//            let pinned = globalVars.pinnedViews[0]
            
//            if draggedView == views[1] {
//                if pinned == 9 {
//                    moveComplaintsAndPaymentsTabs(X: draggedViewX, Y: draggedViewY)
//                    changeAlphaOnPan(alphaView: draggedView, movingView: draggedView, show: true)
//                } else if pinned == 0 || pinned == 1 {
//                    draggedView.center = CGPoint(x: draggedViewX, y: draggedViewY)
//                    changeAlphaOnPan(alphaView: views[0], movingView: draggedView, show: false)
//                    changeAlphaOnPan(alphaView: draggedView, movingView: draggedView, show: true)
//                } else if pinned == 2 { //TODO: change to else???
//                    moveComplaintsAndSecurityTabs(X: draggedViewX, Y: draggedViewY)
//                    changeAlphaOnPan(alphaView: views[0], movingView: draggedView, show: false)
//                    changeAlphaOnPan(alphaView: views[2], movingView: draggedView, show: true)
//                }
//            if draggedView == views[0] {
//                if pinned == 9 {
//                    draggedView.center = CGPoint(x: draggedViewX, y: draggedViewY)
//                    changeAlphaOnPan(alphaView: draggedView, movingView: draggedView, show: true)
//                } else if pinned == 0 {
//                    draggedView.center = CGPoint(x: draggedViewX, y: draggedViewY)
//                    changeAlphaOnPan(alphaView: draggedView, movingView: draggedView, show: true)
//                } else if pinned == 1 {
//                    movePaymentsAndComplaintsTabs(X: draggedViewX, Y: draggedViewY)
//                    changeAlphaOnPan(alphaView: views[1], movingView: draggedView, show: true)
//                } else if pinned == 2{
//                    moveAllTabsDown(X: draggedViewX, Y: draggedViewY)
//                    changeAlphaOnPan(alphaView: views[2], movingView: draggedView, show: true)
//                }
//
//            }
            
//            } else if draggedView == views[2] {
//                if pinned == 9 {
//                    moveAllTabsUp(X: draggedViewX, Y: draggedViewY)
//                } else if pinned == 0 {
//                    moveSecurityAndComplaintsTabs(X: draggedViewX, Y: draggedViewY)
//                    changeAlphaOnPan(alphaView: views[0], movingView: draggedView, show: false)
//                } else if pinned == 1 {
//                    changeAlphaOnPan(alphaView: views[1], movingView: draggedView, show: false)
//                    draggedView.center = CGPoint(x: draggedViewX, y: draggedViewY)
//                } else {
//                    draggedView.center = CGPoint(x: draggedViewX, y: draggedViewY)
//                }
//                changeAlphaOnPan(alphaView: views[2], movingView: draggedView, show: true)
//            }
            
//            previousTouchPoint = touchPoint
//
//        } else if gestureRecognizer.state == .ended && viewDragging {
//
//            // Pins view once you stop dragging
//            let dragEndPoint = gestureRecognizer.location(in: nil).y
//            var swipeDown = false
//
//            let dragSensitivity = 5 //Measure in pixels
//            if (dragEndPoint - DragVars.dragStartPointY) > CGFloat(dragSensitivity) {
//                swipeDown = true //TODO: swipeDown remains false when swiped up less than 5 pixels
//            }
//
//            pin(view: draggedView, swipeDown: swipeDown)
//            addVelocity(toView: draggedView, fromGestureRecognizer: gestureRecognizer)
//            viewDragging = false
//
//        }
        
        
    }
    
    
    //TODO: change all 115 to variable difference between tabs
    func movePaymentsAndComplaintsTabs(X: CGFloat, Y: CGFloat) {
        //views[0].center = CGPoint(x: X, y: Y )
        //views[1].center = CGPoint(x: X, y: Y + 115 )
    }
    
    func moveComplaintsAndPaymentsTabs(X: CGFloat, Y: CGFloat) {
        //views[0].center = CGPoint(x: X, y: Y - 115)
       // views[1].center = CGPoint(x: X, y: Y)
    }
    
    func moveComplaintsAndSecurityTabs(X: CGFloat, Y: CGFloat) {
        //views[1].center = CGPoint(x: X, y: Y )
        //views[2].center = CGPoint(x: X, y: Y + 115 )
    }
    
    func moveSecurityAndComplaintsTabs(X: CGFloat, Y: CGFloat) {
       // views[2].center = CGPoint(x: X, y: Y )
       // views[1].center = CGPoint(x: X, y: Y - 115 )
    }
    
    func moveAllTabsDown(X: CGFloat, Y: CGFloat) {
        //views[0].center = CGPoint(x: X, y: Y)
        //views[1].center = CGPoint(x: X, y: Y + 115)
       // views[2].center = CGPoint(x: X, y: Y + 115 + 115)
    }
    
    func moveAllTabsUp(X: CGFloat, Y: CGFloat) {
        //views[2].center = CGPoint(x: X, y: Y)
        //views[1].center = CGPoint(x: X, y: Y - 115)
        //views[0].center = CGPoint(x: X, y: Y - 115 - 115)
    }
    

    func changeAlphaOnPan(alphaView: UIView, movingView: UIView, show: Bool) {
        //Works out percentage you have dragged the view to change the alpha
        var snapPosition = self.view.center
        snapPosition.y += 152 //TODO: make global or something
        var yPosition = initialYPosition.paymentView
        
//        if movingView == views[1] {
//            snapPosition.y += 115
//            yPosition = initialYPosition.complaintsView
//        } else if movingView == views[2] {
//            snapPosition.y += 115 + 115
//            yPosition = initialYPosition.securityDepositView
//        }
        
        let topViewY = movingView.center.y - movingView.frame.height / 2
        let snapPos = (view.center.y - snapPosition.y) // is negative 152 // COULD USE GLOBAL SNAPPOSITION INSTEAD??/
        var percentage = (topViewY + snapPos) / (yPosition + snapPos )
        
        if show {
            percentage = (percentage - 1) * (-1)
        }
        
        if alphaView == views[0] {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showPaymentsView"), object: nil, userInfo: ["percentage":percentage])
//        } else if alphaView == views[1] {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showComplaintsView"), object: nil, userInfo: ["percentage":percentage])
//        } else {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showSecurityView"), object: nil, userInfo: ["percentage":percentage])
//            //Notification for security
        }
        
    }
    
    
    
    func changeViewOnPinOrDrop(show: Bool, viewToChange: UIView) {
//        var alpha = 1
//        if show {
//            alpha = 0
//        }
//
//        if viewToChange == views[0] {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paymentOnPinOrDrop"), object: nil, userInfo: ["percentage":CGFloat(alpha)])
////        } else if viewToChange == views[1] {
////            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "complaintsOnPinOrDrop"), object: nil, userInfo: ["percentage":CGFloat(alpha)])
////        } else if viewToChange == views[2] {
////            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "securityOnPinOrDrop"), object: nil, userInfo: ["percentage":CGFloat(alpha)])
//        }

    }
    
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
//        let tappedView = gestureRecognizer.view!
//
//        pin(view: tappedView, swipeDown: false)
//       // changeViewOnPinOrDrop(alpha: 0)
//        animator.updateItem(usingCurrentState: tappedView)
    }
    
    
    
    func pin (view:UIView, swipeDown: Bool) {
        
       
        
    }
    
    
    
    
    
    
    func addVelocity (toView view:UIView, fromGestureRecognizer panGesture:UIPanGestureRecognizer) {
        var velocity = panGesture.velocity(in: self.view)
        velocity.x = 0
        
        if let behavior = itemBehavior(forView: view) {
            behavior.addLinearVelocity(velocity, for: view)
        }
        
    }
    
    
    func itemBehavior (forView view:UIView) -> UIDynamicItemBehavior? {
        for behavior in animator.behaviors {
            if let itemBehavior = behavior as? UIDynamicItemBehavior {
                if let possibleView = itemBehavior.items.first as? UIView, possibleView == view {
                    return itemBehavior
                }
            }
        }
        return nil
    }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        if NSNumber(integerLiteral: 2).isEqual(identifier) {
            let view = item as! UIView
            pin(view: view, swipeDown: false)
        }
        
    }
    
    
    func setVisibility (view:UIView, alpha:CGFloat) {
        for aView in views {
            if aView != view {
                aView.alpha = alpha
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

