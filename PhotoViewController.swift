//
//  PhotoViewController.swift
//  Facebook
//
//  Created by Corin Nader on 10/4/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    // store var for image passing
    var selectedPhoto: UIImage!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoActionsImage: UIImageView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!

        
    var photoViewOrigin = CGPoint()
    
    var scrollPosition = CGFloat()
    var scrollHeight = CGFloat()
    var scrollPercentage = CGFloat()
    var opacity = CGFloat()
    
    let translationThreshold = CGFloat(50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure image
        let imageOffsetY = photoImage.frame.origin.y
        
        // Do any additional setup after loading the view.
        photoImage.image = selectedPhoto
        photoImage.frame.origin = CGPoint(x: 0, y: imageOffsetY)
        //photoImage.frame.size = selectedImage.size
        photoImage.alpha = 0
        photoImage.contentMode = UIViewContentMode.ScaleAspectFit
        photoImage.clipsToBounds = true
        
        // pan the photo
        var panPhoto = UIPanGestureRecognizer(target: self, action: "onPanPhoto:")
        self.photoImage.addGestureRecognizer(panPhoto)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        photoImage.alpha = 1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDoneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onPanPhoto(gestureRecognizer: UIPanGestureRecognizer) {
        var window = UIApplication.sharedApplication().keyWindow
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.velocityInView(view)

        if gestureRecognizer.state == UIGestureRecognizerState.Began {
           println("began")
            photoViewOrigin = photoImage.frame.origin
            self.doneButton.alpha = 0
            self.photoActionsImage.alpha = 0
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
            self.photoImage.frame.origin.y = translation.y + photoViewOrigin.y
            opacity = (1 - abs(translation.y/window.frame.size.height))
            
            println(translation.y)
            
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            println("end")
            if (translation.y == 0 || abs(translation.y) <= translationThreshold) {
                self.doneButton.alpha = 1
                self.photoActionsImage.alpha = 1
                UIView.animateWithDuration(0.2) {
                    
                    self.photoImage.frame.origin.y = self.photoViewOrigin.y
                    
                }
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
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
