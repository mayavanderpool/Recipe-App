//
//  Recipe_AppApp.swift
//  Recipe App
//
//  Created by Maya Vanderpool on 7/15/25.
//
import SwiftUI
import FirebaseCore
import Firebase

#if os(iOS)
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
#endif

@main
struct YourApp: App {
    
    #if os(iOS)
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #else
    init(){
        FirebaseApp.configure()
    }
    #endif
    
  var body: some Scene {
    WindowGroup {
      NavigationView {
        WelcomeView()
      }
    }
  }
}
