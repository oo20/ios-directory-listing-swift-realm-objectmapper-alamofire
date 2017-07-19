//
//  ScrollViewController.swift
//  DirectoryListing
//
//  Created by Michael Steele on 7/18/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView?.bounces = false
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView?.contentInset = UIEdgeInsets.zero
        self.scrollView?.scrollIndicatorInsets = UIEdgeInsets.zero
        self.scrollView?.contentOffset = CGPoint(x: 0.0, y: 0.0)
        
        guard let contentSize = self.scrollView?.contentSize else {
            return
        }
        
        self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: contentSize.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollViewController.keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        guard var contentInset = self.scrollView?.contentInset else {
            return
        }
        
        contentInset.bottom = keyboardSize.height
        
        self.scrollView?.contentInset = contentInset
        self.scrollView?.scrollIndicatorInsets = contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard var contentInset = self.scrollView?.contentInset else {
            return
        }
        contentInset.bottom = 0
        
        self.scrollView?.contentInset = contentInset
        self.scrollView?.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    func positionScrollViewTopCenter() {
        guard let scrollView = self.scrollView else {
            return
        }
        
        let newContentOffsetX : CGFloat = (scrollView.contentSize.width - scrollView.frame.size.width) / 2;
        scrollView.contentOffset = CGPoint(x: newContentOffsetX, y: 0)
    }
}
