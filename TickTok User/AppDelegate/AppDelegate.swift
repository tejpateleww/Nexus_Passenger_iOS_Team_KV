//
//  AppDelegate.swift
//  TickTok User
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Fabric
import Crashlytics
import SideMenuController
import SocketIO
import UserNotifications
import Firebase


let googlApiKey = "AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo"         // AIzaSyB08IH_NbumyQIAUCxbpgPCuZtFzIT5WQo
let googlPlacesApiKey = "AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo"   //   AIzaSyBBQGfB0ca6oApMpqqemhx8-UV-gFls_Zk

//AIzaSyBBQGfB0ca6oApMpqqemhx8-UV-gFls_Zk
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?

     let SocketManager = SocketIOClient(socketURL: URL(string: "http://54.206.55.185:8080")!, config: [.log(false), .compress])

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        
        IQKeyboardManager.sharedManager().enable = true
        GMSServices.provideAPIKey(googlApiKey)
        GMSPlacesClient.provideAPIKey(googlPlacesApiKey)
        Fabric.with([Crashlytics.self])
        // TODO: Move this to where you establish a user session
     //   self.logUser()
        
        // ------------------------------------------------------------
        
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = (((window?.frame.width)! / 2) + ((window?.frame.width)! / 4))
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        
        
        // ------------------------------------------------------------

        if ((UserDefaults.standard.object(forKey: "profileData")) != nil)
        {
            SingletonClass.sharedInstance.dictProfile = UserDefaults.standard.object(forKey: "profileData") as! NSMutableDictionary
            SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)
            SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array:  UserDefaults.standard.object(forKey: "carLists") as! NSArray)
            SingletonClass.sharedInstance.isUserLoggedIN = true
        }
        else
        {
            SingletonClass.sharedInstance.isUserLoggedIN = false
        }
        
        
        if UserDefaults.standard.object(forKey: "Passcode") as? String == nil {
            SingletonClass.sharedInstance.setPasscode = ""
        }
        else {
            SingletonClass.sharedInstance.setPasscode = UserDefaults.standard.object(forKey: "Passcode") as! String
        }
        
        
        // Push Notification Code
        registerForPushNotification()
        /*
         if let notification = launchOptions?[.remoteNotification] as? [String:AnyObject] {
         
         //            let aps = notification["aps"] as! [String:AnyObject]
         //            _ = NewsItems.makeNewsItems(aps)
         
         //            (window?.rootViewController as? UITabBarController)?.selectedIndex = 0
         }
         */
        
        
        
        
        return true
    }
    
//    func logUser() {
//        // TODO: Use the current user's information
//        // You can call any combination of these three methods
//
//        if ((UserDefaults.standard.object(forKey: "profileData")) != nil)
//        {
//            SingletonClass.sharedInstance.dictProfile = UserDefaults.standard.object(forKey: "profileData") as! NSMutableDictionary
//            Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
//            Crashlytics.sharedInstance().setUserIdentifier("12345")
//            Crashlytics.sharedInstance().setUserName("Test User")
//        }
//
//    }


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
    }

    // Push Notification Methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let toketParts = deviceToken.map({ (data)-> String in
            return String(format: "%0.2.2hhx", data)
        })
        
        let token = toketParts.joined()
        print("Device Token: \(token)")

        
        Messaging.messaging().apnsToken = deviceToken as Data
        
        print("deviceToken : \(deviceToken)")
        
        
        let fcmToken = Messaging.messaging().fcmToken
        print("FCM token: \(fcmToken ?? "")")
        
        if fcmToken == nil {
            
        }
        else {
            SingletonClass.sharedInstance.deviceToken = fcmToken!
            UserDefaults.standard.set(SingletonClass.sharedInstance.deviceToken, forKey: "Token")
        }
        
        
        print("SingletonClass.sharedInstance.deviceToken : \(SingletonClass.sharedInstance.deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        
        let currentDate = Date()
        print("currentDate : \(currentDate)")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        /*
         //        let aps = userInfo["aps"] as! [String:AnyObject]
         // 1
         if aps["content-available"] as? Int == 1 {
         let podcastStore = PodcastStore.sharedStore
         // Refresh Podcast
         // 2
         podcastStore.refreshItems { didLoadNewItems in
         // 3
         completionHandler(didLoadNewItems ? .newData : .noData)
         }
         } else  {
         // News
         // 4
         //        _ = NewsItems.makeNewsItems(aps)
         completionHandler(.newData)
         }
         */
        /*
         {
         "aps": {
         "content-available": 1
         }
         }
         */
        
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
        
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        /*
         // 1
         let userInfo = response.notification.request.content.userInfo
         let aps = userInfo["aps"] as! [String:AnyObject]
         
         // 2
         if let newsItem = NewsItem.makeNewsItems(aps) {
         (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
         
         // 3
         if response.actionIdentifier == "viewActionIdentifier",
         let url = URL(string: newsItem.link) {
         let safari = SFSafariViewController(url: url)
         window?.rootViewController?.present(safari, animated: true, completion: nil)
         }
         }
         // 4
         completionHandler()
         */
    }
    
    //-------------------------------------------------------------
    // MARK: - Push Notification Methods
    //-------------------------------------------------------------
    
    func registerForPushNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            
            print("Permissin granted: \(granted)")
            
//            guard granted else { return }
 /*
            // 1
            let viewAction = UNNotificationAction(identifier: "ViewActionIndentifier", title: "View", options: [.foreground])
            
            // 2
            let newsCategory = UNNotificationCategory(identifier: "newsCategoryIndentifier", actions: [viewAction], intentIdentifiers: [], options: [])
            
            // 3
            UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
*/
            self.getNotificationSettings()
            
        })
        
        /*        {
         "aps": {
         "alert": "Breaking News!",
         "sound": "default",
         "link_url": "https://raywenderlich.com",
         "category": "NEWS_CATEGORY"
         }
         }
         */
    }
    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {(settings) in
            
            print("Notification Settings: \(settings)")
  
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()

            }
            
        })
    }
    
    //-------------------------------------------------------------
    // MARK: - FireBase Methods
    //-------------------------------------------------------------
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
    }
  

}

