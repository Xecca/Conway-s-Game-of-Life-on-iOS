//
//  Button.swift
//  Conway-s-Game-of-Life-on-iOS
//
//  Created by Dreik on 10/22/22.
//

import UIKit

public enum GoLButtonType {
    case startStop
    case randomize
}

class Button: UIButton {
    private var type: GoLButtonType = .startStop
    private let label = UILabel()
    
    init(with type: GoLButtonType) {
        super.init(frame: .zero)
        self.type = type
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
}

private extension Button {
    func setupViews() {
        setupView(label)
    }
    
    func constraintViews() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func configureAppearance() {
        layer.cornerRadius = 5
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        switch type {
        case .startStop:
            setTitle("Start", for: .normal)
            setTitleColor(.white, for: .normal)
            setTitleColor(.systemGray, for: .highlighted)
            backgroundColor = .systemGray5
        case .randomize:
            setTitle("Randomize", for: .normal)
            setTitleColor(.white, for: .normal)
            setTitleColor(.systemGray3, for: .highlighted)
            backgroundColor = .systemGreen
        }
    }
}
