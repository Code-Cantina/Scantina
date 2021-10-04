//
//  ScanAlertVC.swift
//  Scantina
//
//  Created by Danny Copeland on 10/3/21.
//

import UIKit

class ScanAlertVC: UIViewController {
    
    let containerView = UIView()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    let messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 15)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Ok", for: .normal)
        btn.backgroundColor = UIColor.primaryColor
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
        containerView.layer.borderColor = UIColor.white.cgColor
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
