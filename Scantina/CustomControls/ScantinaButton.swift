//
//  ScantinaButton.swift
//  Scantina
//
//  Created by Danny Copeland on 10/3/21.
//

import UIKit

class ScantinaButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
    }
    
    private func setup() {
        backgroundColor = UIColor.buttonColor
        layer.cornerRadius = 6
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
