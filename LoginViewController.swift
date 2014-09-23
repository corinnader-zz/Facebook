//
//  LoginViewController.swift
//  Facebook
//
//  Created by Corin Nader on 9/20/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var formBgImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register keyboard events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
        loginButton.enabled = false
        loadingSpinner.alpha = 0
        
    }
    
    func toggleLoginButtonState() {
        if (passwordTextField.text.isEmpty) || (emailTextField.text.isEmpty){
            loginButton.enabled = false
            loadingSpinner.alpha = 0
        } else {
            loginButton.enabled = true
            loadingSpinner.alpha = 0
        }

    }
    
    @IBAction func onEditingEmailChanged(sender: AnyObject) {
        toggleLoginButtonState()
    }
   
    @IBAction func onEditingPasswordChanged(sender: AnyObject) {
        toggleLoginButtonState()
    }
    
    //Dimiss keyboard by tapping outside
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func onClickLoginButton(sender: UIButton) {
        loadingSpinner.alpha = 1
        self.loginButton.selected = true
        delay(2){
            
            if (self.emailTextField.text == "me") && (self.passwordTextField.text == "pass"){
                self.performSegueWithIdentifier("signInSegue", sender: self)
                
            } else {
                var alertViewWrong = UIAlertView(title: "Wrong", message: "Your email or password is incorrect. Try again", delegate: self, cancelButtonTitle: "OK")
                alertViewWrong.show()
                self.toggleLoginButtonState()
                self.loginButton.selected = false

            }

        }
        
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        
        // Get the keyboard height and width from the notification
        // Size varies depending on OS, language, orientation
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size
        var durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        var animationDuration = durationValue.doubleValue
        var curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
        var animationCurve = curveValue.integerValue
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions.fromRaw(UInt(animationCurve << 16))!, animations: {
            
            // Set view properties in here that you want to match with the animation of the keyboard
            // If you need it, you can use the kbSize property above to get the keyboard width and height.
            self.logoImageView.frame.origin.y -= 30
            self.emailTextField.frame.origin.y -= 30
            self.passwordTextField.frame.origin.y -= 30
            self.formBgImageView.frame.origin.y -= 30
            self.loginButton.frame.origin.y -= 30
            self.loadingSpinner.frame.origin.y -= 30

            
            }, completion: nil)

    }
    
    func keyboardWillHide(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        
        // Get the keyboard height and width from the notification
        // Size varies depending on OS, language, orientation
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size
        var durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        var animationDuration = durationValue.doubleValue
        var curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
        var animationCurve = curveValue.integerValue
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions.fromRaw(UInt(animationCurve << 16))!, animations: {
            
            // Set view properties in here that you want to match with the animation of the keyboard
            // If you need it, you can use the kbSize property above to get the keyboard width and height.
           self.logoImageView.frame.origin.y += 30
            self.emailTextField.frame.origin.y += 30
            self.passwordTextField.frame.origin.y += 30
            self.formBgImageView.frame.origin.y += 30
            self.loginButton.frame.origin.y += 30
            self.loadingSpinner.frame.origin.y += 30
            
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
