//
//  LabelWithCounter.swift
//  Conway-s-Game-of-Life-on-iOS
//
//  Created by Dreik on 10/22/22.
//

import UIKit

class LabelWithCounter: UIView {
    let titleLabel = UILabel()
    let counterLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LabelWithCounter {
    func setupViews() {
        setupView(titleLabel)
        setupView(counterLabel)
    }
    
    func constraintViews() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            counterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            counterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
        ])
    }
    
    func configureAppearance() {
        titleLabel.text = "Current generation:"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        
        counterLabel.text = "0"
        counterLabel.textAlignment = .center
        counterLabel.textColor = .white
        counterLabel.font = Resources.Fonts.helveticaRegular(with: 24)
    }
}
