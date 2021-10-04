//
//  Extension+UIViewController.swift
//  Scantina
//
//  Created by Danny Copeland on 10/3/21.
//

import UIKit
import SafariServices

extension UIViewController {
 
    
    //MARK: - Safari VC
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = UIColor.primaryColor
        present(safariVC, animated: true)
    }
    
}
