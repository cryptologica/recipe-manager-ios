//
//  AppDelegate.swift
//  final_project
//
//  Created by JT Newsome on 4/23/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let recipeListViewController: RecipeListViewController = RecipeListViewController()
        let navController: UINavigationController = UINavigationController()
        navController.navigationBar.translucent = true
        navController.view.backgroundColor = nil
        navController.pushViewController(recipeListViewController, animated: false)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navController
        window!.makeKeyAndVisible()
        
        return true;
    }

}

