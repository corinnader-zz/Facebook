//
//  NewsFeedViewController.swift
//  Facebook
//
//  Created by Timothy Lee on 8/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var homeFeedImageView: UIImageView!
    @IBOutlet weak var wedding1Image: UIImageView!
    @IBOutlet weak var wedding2Image: UIImageView!
    @IBOutlet weak var wedding3Image: UIImageView!
    @IBOutlet weak var wedding4Image: UIImageView!
    @IBOutlet weak var wedding5Image: UIImageView!
    
    var imageViewToPass: UIImageView!
    var isPresenting: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the content size of the scroll view
        scrollView.contentSize = CGSizeMake(320, feedImageView.image!.size.height)
        scrollView.alpha = 0
        
        // associate tap gesture with images
        self.wedding1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
        self.wedding2Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
        self.wedding3Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
        self.wedding4Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
        self.wedding5Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        delay(2){
            self.loadingSpinner.alpha = 0
            self.scrollView.alpha = 1
        }
        scrollView.contentInset.top = 0
        scrollView.contentInset.bottom = 50
        scrollView.scrollIndicatorInsets.top = 0
        scrollView.scrollIndicatorInsets.bottom = 50
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // function responding to image tapping
    func onTapImage(gestureRecognizer: UITapGestureRecognizer) {
        
        // Set the image passing to be image that is tapped
        imageViewToPass = gestureRecognizer.view as UIImageView
        
        // Perform manual segue
        self.performSegueWithIdentifier("segueToPhotoDetail", sender: self)
    }
    
    // before segue happens
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationViewController = segue.destinationViewController as PhotoViewController
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
        // Pass image to new view controller
        destinationViewController.selectedPhoto = self.imageViewToPass.image
    }

    
    // paste more shit
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    // paste more shit
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    // paste more shit
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method below
        return 0.4
    }
    
    
    // Custom transition for segue
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("animating transition")
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let destinationImageCenter = CGPoint(x: 320/2, y: 284)
        let destinationImageHeight = CGFloat(480)
        var originImageCenter = self.imageViewToPass.center
        
        if (isPresenting) {
            println("animating to transition")
            var window = UIApplication.sharedApplication().keyWindow
            var frame = window.convertRect(imageViewToPass.frame, fromView: scrollView)
            var imageCopy = UIImageView()

            imageCopy.frame = window.convertRect(imageViewToPass.frame, fromView: scrollView)
            imageCopy.image = imageViewToPass.image
            imageCopy.contentMode = UIViewContentMode.ScaleAspectFit
            imageCopy.clipsToBounds = true
            
            var scaleFactor = CGFloat()
            let scaleWidth = window.frame.width / imageCopy.frame.width
            let scaleHeight = destinationImageHeight / imageCopy.frame.height
            let minScale = min(scaleWidth, scaleHeight)
            let maxScale = max(scaleWidth, scaleHeight)
            if (imageCopy.image!.size.height > imageViewToPass.image!.size.width) {
                scaleFactor = scaleHeight
            } else {
                scaleFactor = minScale
            }
            
            toViewController.view.alpha = 0
            
            // Add subview
            window.addSubview(imageCopy)
            containerView.addSubview(toViewController.view)
            
            // Do animation stuff to transition to new view controller
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                imageCopy.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
                imageCopy.center = destinationImageCenter
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    imageCopy.removeFromSuperview()
            }
        } else {
            // Do animation stuff here to transition back to the previous controller
            println("animating return transition")
            var photoViewController = fromViewController as PhotoViewController
            var feedViewController = toViewController as? NewsFeedViewController
            
            var window = UIApplication.sharedApplication().keyWindow
            var imageCopy = UIImageView()
            var scaleFactor =  self.imageViewToPass.frame.width / photoViewController.photoImage.frame.width
            
            var photoViewScrollPositionY = photoViewController.scrollPosition
            var photoFrame = photoViewController.photoImage.frame
            var originImageCenter = self.imageViewToPass.center
            
            imageCopy.image = photoViewController.photoImage.image
            imageCopy.contentMode = UIViewContentMode.ScaleAspectFit
            imageCopy.clipsToBounds = true
            imageCopy.frame = photoViewController.photoImage.frame
            
            
            window.addSubview(imageCopy)
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                imageCopy.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
                imageCopy.center = window.convertPoint(originImageCenter, fromView: self.scrollView)
                imageCopy.alpha = 0
                fromViewController.view.alpha = 0
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
                    imageCopy.removeFromSuperview()
            }
        }
    }


    
    }
