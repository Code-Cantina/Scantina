//
//  ScanTabBarController.swift
//  Scantina
//
//  Created by Danny Copeland on 10/4/21.
//

import UIKit

class ScanTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //building through XCode 13 creates some transparent/ unintended UI for tab bar style/appearance. The below code changes it back to desired look
        if #available(iOS 15.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor.primaryColor

            self.tabBar.standardAppearance = tabBarAppearance
            self.tabBar.scrollEdgeAppearance = tabBarAppearance
            UITabBar.appearance().tintColor = UIColor.secondaryColor

        } else {
            UITabBar.appearance().tintColor = UIColor.secondaryColor //this colors the buttons on the tab bar
        }
        
        viewControllers = [createInfoVC(), createScanVC(), createScanTypesVC()]
        self.selectedIndex = 1
    }
    
    func createInfoVC() -> UINavigationController {
        let infoVC = ScanSettingsVC()
        let tabImage = UIImage(systemName: "info.circle")
        let selectedImage = UIImage(systemName: "info.circle")
        infoVC.title = "Info"
        infoVC.tabBarItem = UITabBarItem(title: "Info", image: tabImage, selectedImage: selectedImage)
  
        return UINavigationController(rootViewController: infoVC)
    }
    
    func createScanVC() -> UINavigationController {
        let scannerVC = ScannerVC()
        let tabImage = UIImage(systemName: "barcode.viewfinder")
        scannerVC.title = "Scan"
        scannerVC.tabBarItem = UITabBarItem(title: "Scantina", image: tabImage, selectedImage: tabImage)
        
        return UINavigationController(rootViewController: scannerVC)
    }
    
    func createScanTypesVC() -> UINavigationController {
        let settingsVC = ScanSettingsVC()
        let tabImage = UIImage(systemName: "gearshape.2")
        let selectedImage = UIImage(systemName: "3gearshape.2.fill")
        settingsVC.title = "Settings"
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: tabImage, selectedImage: selectedImage)

        return UINavigationController(rootViewController: settingsVC)
    }
  
    
    
}
