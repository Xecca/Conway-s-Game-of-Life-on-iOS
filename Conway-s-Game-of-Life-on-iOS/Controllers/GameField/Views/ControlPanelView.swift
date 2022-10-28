//
//  ControlPanelView.swift
//  Conway-s-Game-of-Life-on-iOS
//
//  Created by RedOrcDron on 10/27/22.
//

import UIKit

final class ControlPanelView: BaseView {
    lazy var startButton = Button(with: .startStop)
    lazy var randomizeButton = Button(with: .randomize)
    let generationLabel = LabelWithCounter()
}

// MARK: - Views Manager
extension ControlPanelView {
    override func setupViews() {
        super.setupViews()
        
        startButton.isEnabled = false
        setupView(generationLabel)
        setupView(startButton)
        setupView(randomizeButton)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            generationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            generationLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -25),
            
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            randomizeButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor),
            randomizeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        backgroundColor = .clear
    }
}
