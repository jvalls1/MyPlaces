//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by user143153 on 22/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Creating a singleton instance of ManagerPlaces
        ManagerPlaces.shared()
        
        // ****************************************************************************
        // Simulation. Discomment
        // ****************************************************************************
        
        // Adding places to test.
        // let pl = Place(name:"Test Place",description: "More Info", image_in: nil)
        // manager().append(_value: pl)
        // let pl2 = Place(name:"Test Place 2",description: "More Info2",image_in:nil)
        // manager().append(_value: pl2)
        // let pl3 = Place(name:"Cosmo Caixa",description: "More Info3",image_in:nil)
        // manager().append(_value: pl3)
        // let pl4 = PlaceTourist(name:"La Sagrada Familia",description: "La Sagrada Familia...com a personsa fisica",discount_tourist: "El 3%" ,image_in:nil)
        // manager().append(_value: pl4)
        // let pl5 = PlaceTourist(name:"La carretera de les Aigües",description: "Per veure vistes aeres de Barcelona",discount_tourist: "El 5%",image_in:nil)
        // manager().append(_value: pl5)
        
        return true		
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        ManagerPlaces.shared().store()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    // Storing applications data.
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

