//
//  BulkPaymentFileUploadSuccessViewController.swift
//  Burgan
//
//  Created by Pratik on 15/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit

class BulkPaymentFileUploadSuccessViewController: UIViewController {
    @IBOutlet var backBtnRef: UIButton!
    @IBOutlet var confirmAndSendBtnRef: UIButton!
    @IBOutlet var sendingLinkLblRef: UILabel!
    
    var noOfCustomerText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendingLinkLblRef.text = "Sending eZpay link to \(noOfCustomerText) Customers"
        
        confirmAndSendBtnRef.layer.cornerRadius = 15
        confirmAndSendBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }


}

//MARK:- BUTTON ACTION
extension BulkPaymentFileUploadSuccessViewController: UIViewControllerTransitioningDelegate{
    
    @IBAction func confirmAndSendBtnTap(_ sender: UIButton){
        let vc = BulkPaymentFileConfirmAndSendViewController(nibName: "BulkPaymentFileConfirmAndSendViewController", bundle: nil)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.emailSentToText = noOfCustomerText
        self.present(vc, animated: true, completion: nil)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return halfSizeBulkPaymentFileConfirmAndSendPresentation(presentedViewController: presented, presenting: presentingViewController)
    }
    
    @IBAction func backBtnTap(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}

class halfSizeBulkPaymentFileConfirmAndSendPresentation: UIPresentationController{
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    @objc func dismiss(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    override var frameOfPresentedViewInContainerView: CGRect{
        let theHeight = self.containerView!.frame.height

        return CGRect(origin: CGPoint(x: 0, y: theHeight - 370), size: CGSize(width: self.containerView!.frame.width, height: 370))
    }
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 1
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in

        })
    }
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 10
    }
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
}
