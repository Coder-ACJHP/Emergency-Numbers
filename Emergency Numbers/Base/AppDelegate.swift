//
//  AppDelegate.swift
//  Emergency Numbers
//
//  Created by akademobi5 on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {

    var window: UIWindow?
    var maskBgView: UIView?
    var navigationController: UIViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Increament review counter
        StoreReviewHelper.incrementAppOpenedCount()
        
        launchScreenAnimation()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    private func launchScreenAnimation() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let coloredView = UIView(frame: self.window!.frame)
        coloredView.backgroundColor = UIColor(red:0.19, green:0.38, blue:0.59, alpha:1.0)
        self.window?.addSubview(coloredView)
        self.window!.makeKeyAndVisible()
        
        
        
        // rootViewController from StoryBoard
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        navigationController = mainStoryboard.instantiateViewController(withIdentifier: "navigationController")
        self.window!.rootViewController = navigationController
        
        
        
        // logo mask
        navigationController!.view.layer.mask = CALayer()
        navigationController!.view.layer.mask?.contents = UIImage(named: "IconMask")!.cgImage
        navigationController!.view.layer.mask?.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        navigationController!.view.layer.mask?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        navigationController!.view.layer.mask?.position = CGPoint(x: navigationController!.view.frame.width / 2, y: navigationController!.view.frame.height / 2)
        
        
        
        // logo mask background view
        maskBgView = UIView(frame: navigationController!.view.frame)
        maskBgView!.backgroundColor = UIColor.white
        navigationController!.view.addSubview(maskBgView!)
        navigationController!.view.bringSubview(toFront: maskBgView!)
        
        
        
        // logo mask animation
        
        let transformAnimation = CAKeyframeAnimation(keyPath: "bounds")
        transformAnimation.delegate = self
        
        transformAnimation.duration = 1
        transformAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue(cgRect: (navigationController!.view.layer.mask?.bounds)!)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 50, height: 50))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        transformAnimation.values = [initalBounds, secondBounds, finalBounds]
        transformAnimation.keyTimes = [0, 0.5, 1]
        transformAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = kCAFillModeForwards
        navigationController!.view.layer.mask?.add(transformAnimation, forKey: "maskAnimation")
        
        
        
        // logo mask background view animation
        
        UIView.animate(withDuration: 0.1, delay: 1.35, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.maskBgView!.alpha = 0.0
        },
                       completion: { finished in
                        self.maskBgView!.removeFromSuperview()
        })
        
        
        // root view animation
        
        UIView.animate(withDuration: 0.50, delay: 1.3, options: [], animations: {
            self.window!.rootViewController!.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { finished in
            
            UIView.animate(withDuration: 0.50, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut,  animations: {
                self.window!.rootViewController!.view.transform = .identity
                self.navigationController!.view.layer.mask = nil
            }, completion: nil)
        })
    }
}

