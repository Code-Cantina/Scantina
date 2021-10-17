//
//  ScanAlertVC.swift
//  Scantina
//
//  Created by Danny Copeland on 10/3/21.
//

import UIKit

class ScanAlertVC: UIViewController {
    
    let containerView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    lazy var messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 15)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    lazy var actionButton: ScantinaButton = {
        let btn = ScantinaButton(title: "Close")
        return btn
    }()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        setupContainerView()
        setupTitleLabel()
        setupMessageLabel()
        setupActionButton()
        containerView.sizeToFit()
    }
    
    func setupContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = UIColor.primaryColor
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
        ])
        
    }
    
    func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? ""
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Layout.sidePadding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Layout.sidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Layout.sidePadding),
        ])
    }
    
    func setupMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? ""
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Layout.sidePadding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Layout.sidePadding)
        ])
    }
    
    func setupActionButton() {
        containerView.addSubview(actionButton)
        
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Layout.sidePadding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Layout.sidePadding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Layout.sidePadding),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Layout.sidePadding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//import Foundation
//import Contacts
//
//struct ContactsManager {
//
//    static let contactSavedSuccessMsg = "The contact has been saved to your device."
//    static let contactSavedFailedMsg = "An error occurred trying to save the contact to your device. Please try again."
//
//    static func saveVCardContacts (vCard : Data) -> Bool { // assuming you have alreade permission to acces contacts
//        let contactStore = CNContactStore()
//
//        do {
//            let saveRequest = CNSaveRequest() // create saveRequests
//            let contacts = try CNContactVCardSerialization.contacts(with: vCard) // get contacts array from vCard
//            for person in contacts {
//                saveRequest.add(person.mutableCopy() as! CNMutableContact, toContainerWithIdentifier: nil) // add contacts to saveRequet
//            }
//
//            try contactStore.execute(saveRequest) // save to contacts
//            //if the above fails will fall into the catch..
//            return true
//
//        } catch {
//            return false
//        }
//    }
//
//    static func saveNewContact (name: String, phone: String, email: String = "", address: String = "", city: String = "", state: String = "", zip: String = "") -> Bool {
//
//        do {
//            let store = CNContactStore()
//            let contact = CNMutableContact()
//
//            contact.givenName = name
//            contact.phoneNumbers.append(CNLabeledValue(label: "mobile", value: CNPhoneNumber(stringValue: phone)))
//
//            let homeAddress = CNMutablePostalAddress()
//            homeAddress.street = address
//            homeAddress.city = city
//            homeAddress.state = state
//            homeAddress.postalCode = zip
//            contact.postalAddresses = [CNLabeledValue(label: CNLabelHome, value: homeAddress)]
//
//            let email = CNLabeledValue(label: CNLabelWork, value: email as NSString)
//            contact.emailAddresses = [email]
//
//            // Save
//            let saveRequest = CNSaveRequest()
//            saveRequest.add(contact, toContainerWithIdentifier: nil)
//            try store.execute(saveRequest)
//            return true
//        } catch {
//            return false
//        }
//
//    }
//
//}
//
//struct EmailUtils {
//
//    static func createEmailUrl(to: String, subject: String, body: String) -> URL? {
//        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//
//        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
//        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
//        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
//
//        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
//            return gmailUrl
//        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
//            return outlookUrl
//        }
//
//        return defaultUrl
//    }
//
//}
//
//import MessageUI
//
//struct PhoneUtils {
//
//    static func dialNumber(number : String) {
//        var urlString = ""
//        if number .hasPrefix("tel:") {
//            urlString = number
//        }
//        else {
//            urlString = "tel://" + number
//        }
//
//        if let url = URL(string: urlString),
//           UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler:nil)
//        }
//    }
//
//    static func textNumber(number : String) {
//        var urlString = ""
//        if number .hasPrefix("sms:") {
//            urlString = number
//        }
//        else {
//            urlString = "sms://" + number
//        }
//
//        if let url = URL(string: urlString),
//           UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler:nil)
//        }
//    }
//
//}

