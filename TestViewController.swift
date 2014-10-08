import UIKit

class TestViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var feedViewImg: UIImageView!
    
    var weddingImg : UIImageView!
    var isPresenting : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the content size of the scroll view
        feedScrollView.contentSize = feedViewImg.image!.size
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func tapWedding(gestureRec: UITapGestureRecognizer) {
        
        // Pass the weddingImg through the gestureRec into the new view as a UIImageView!
        weddingImg = gestureRec.view as UIImageView!
        
        // Perform manual segue
        performSegueWithIdentifier("photoSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // When preparing for the segue, make sure you define the destinationViewController as PhotoViewController. Set up the custom modal presentation style as well as transition delegation and of course calling the weddingImg that you already passed through the gestureRec into the destination View Controller.
        
        var destinationViewController = segue.destinationViewController as PhotoViewController
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
        destinationViewController.image = self.image
        
        
    }
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.4
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        if (isPresenting) {
            
            var window = UIApplication.sharedApplication().keyWindow
            var frame = window.convertRect(weddingImg.frame, fromView: feedScrollView)
            var copyImageView = UIImageView(frame: frame)
            
            copyImageView.image = weddingImg.image
            copyImageView.contentMode = UIViewContentMode.ScaleAspectFill
            copyImageView.clipsToBounds = true
            
            window.addSubview(copyImageView)
            containerView.addSubview(toViewController.view)
            
            toViewController.view.alpha = 0
            
            window.addSubview(copyImageView)
            containerView.addSubview(toViewController.view)
            
            UIView.animateWithDuration(0.4, animations: {
                copyImageView.frame.size.width = 320
                copyImageView.frame.size.height = (copyImageView.image!.size.height / copyImageView.image!.size.width) * 320
                copyImageView.center = window.center
                
                toViewController.view.alpha = 1
                
                }) { (finished:Bool) -> Void in
                    transitionContext.completeTransition(true)
                    copyImageView.removeFromSuperview()
            }
            
        } else {
            
            var window = UIApplication.sharedApplication().keyWindow
            var copyImageView = UIImageView(image: weddingImg.image)
            var scale = copyImageView.frame.width / 320
            
            copyImageView.contentMode = UIViewContentMode.ScaleAspectFill
            copyImageView.clipsToBounds = true
            copyImageView.center = window.center
            copyImageView.transform = CGAffineTransformMakeScale(scale, scale)
            
            window.addSubview(copyImageView)
            
            fromViewController.view.alpha = 0
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                copyImageView.frame.size = CGSize(width: self.weddingImg.frame.width, height: self.weddingImg.frame.height)
                copyImageView.frame = window.convertRect(self.weddingImg.frame, fromView: self.feedScrollView)
                
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
                    copyImageView.removeFromSuperview()
            }
            
            
        }
    }
    
    
}