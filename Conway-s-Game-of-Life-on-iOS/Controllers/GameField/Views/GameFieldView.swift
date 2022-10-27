//
//  GameFieldView.swift
//  Conway-s-Game-of-Life-on-iOS
//
//  Created by RedOrcDron on 10/27/22.
//

import UIKit

enum StartButtonState {
    case start
    case stop
}

final class GameFieldView: BaseView {
    
    weak var delegate: GameFieldViewDelegate?
    
    private var fieldView = UIView()
    private var cells = [UIView]()
    private let controlPanel = ControlPanelView()
    
    func configure() {
        setupViews()
        constraintViews()
        configureAppearance()
    }
}

extension GameFieldView {
    func updateField(with cells: [Bool]) {
        for (i, cellState) in cells.enumerated() {
            if cellState == true {
                self.cells[i].backgroundColor = .black
            } else {
                self.cells[i].backgroundColor = .white
            }
        }
    }
    
    func updateGenerationCounterLabel(to amount: Int) {
        controlPanel.generationLabel.counterLabel.text = "\(amount)"
    }
}

extension GameFieldView {
    // MARK: - Start Button
    @objc private func startButtonTapped() {
        delegate?.didTapStartButton()
    }
    
    func setStartButtonTo(_ state: StartButtonState) {
        let stateName: String
        
        switch state {
        case .start:
            controlPanel.startButton.isEnabled = true
            stateName = "Start"
            controlPanel.startButton.backgroundColor = .systemBlue
        case .stop:
            stateName = "Stop"
            controlPanel.startButton.backgroundColor = .systemRed
        }
        controlPanel.startButton.setTitle(stateName, for: .normal)
    }
    
    // MARK: - Randomize Button
    @objc private func randomizeButtonTapped() {
        delegate?.didTapRandomizeButton()
    }
}

// MARK: - Create Field View
extension GameFieldView {
    func fillFieldByCells() {
        var row = 0
        var column: Int
        var x: CGFloat = Constants.halfOfCellWidth
        var y: CGFloat = Constants.halfOfCellWidth
        
        while row < Constants.fieldHeight {
            column = 0
            while column < Constants.fieldWidth {
                let cell = createCell()
                
                cell.center.x = x
                cell.center.y = y
                
                x += Constants.fieldCellWidth
                column += 1
                
                self.cells.append(cell)
                fieldView.setupView(cell)
            }
            x = Constants.halfOfCellWidth
            y += Constants.fieldCellWidth
            row += 1
        }
    }
    
    private func createCell() -> UIView {
        let cell = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constants.fieldCellWidth, height: Constants.fieldCellWidth)))

        cell.backgroundColor = .white
        cell.layer.cornerRadius = 2
        cell.layer.borderWidth = .zero
        
        return cell
    }
}

// MARK: - Views Manager
extension GameFieldView {
    override func setupViews() {
        super.setupViews()
        
        controlPanel.configure()
        controlPanel.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        controlPanel.randomizeButton.addTarget(self, action: #selector(randomizeButtonTapped), for: .touchUpInside)
        
        setupView(controlPanel)
        setupView(fieldView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            fieldView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            fieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldView.heightAnchor.constraint(equalToConstant: Constants.screenWidth),
            
            controlPanel.topAnchor.constraint(equalTo: fieldView.bottomAnchor, constant: 15),
            controlPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            controlPanel.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        backgroundColor = .clear
    }
}
