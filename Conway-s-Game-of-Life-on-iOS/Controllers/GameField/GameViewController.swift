//
//  GameViewController.swift
//  Conway-s-Game-of-Life-on-iOS
//
//  Created by Dreik on 10/20/22.
//

import UIKit

protocol GameFieldViewDelegate: AnyObject {
    func didTapStartButton()
    func didTapRandomizeButton()
}

final class GameViewController: UIViewController {
    private lazy var isRandomized: Bool = false
    private lazy var isStarted: Bool = false
    private lazy var currentGeneration = 0
    private let startCellsAmount = Constants.startCellsAmount
    private var cells = Array(repeating: false, count: Constants.cellsCount)
    private lazy var timer = Timer()
    private let fieldView = GameFieldView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldView.delegate = self
        initiateGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: Button's Manager
extension GameViewController: GameFieldViewDelegate {
    func didTapStartButton() {
        if !isStarted {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
                self.updateGeneration()
            })
            fieldView.setStartButtonTo(.stop)
        } else {
            self.timer.invalidate()
            fieldView.setStartButtonTo(.start)
        }
        isStarted.toggle()
    }
    
    func didTapRandomizeButton() {
        currentGeneration = 0
        changeGenerationCounter(to: currentGeneration)
        self.timer.invalidate()
        isStarted = false
        isRandomized = true
        
        clearField()
        placeRandomly(startCellsAmount)
        
        fieldView.setStartButtonTo(.start)
        
        fieldView.updateField(with: cells)
    }
}

// MARK: - Game Initializer
extension GameViewController {
    private func initiateGame() {
        setupViews()
        setConstraints()
        configureAppearance()
        fieldView.fillFieldByCells()
    }
}

// MARK: - Field Manager
extension GameViewController {
    private func clearField() {
        for i in 0..<cells.count {
            killCell(at: i)
        }
    }
}

// MARK: - Cells Manager
extension GameViewController {
    private func resurrectCell(at index: Int) {
        cells[index] = true
    }
    
    private func killCell(at index: Int) {
        cells[index] = false
    }
    
    private func placeRandomly(_ amount: Int) {
        for _ in 0..<amount {
            let randomIndex = Int.random(in: 0..<Constants.cellsCount)
            
            resurrectCell(at: randomIndex)
        }
    }
}

// MARK: - Update Generation
extension GameViewController {
    private func updateGeneration() {
        var i = 0
        var row = 1
        let cellsCount = cells.count
        
        while i < cellsCount {
            if i >= Constants.fieldWidth && i % Constants.fieldWidth == 0 {
                row += 1
            }
            // check left neighbors
            let countOfAliveNeighbors = checkAllNeighbors(by: i, in: row)
            // check cell isAlive
            checkCellIsAlive(with: countOfAliveNeighbors, in: i)
            i += 1
        }
        currentGeneration += 1
        changeGenerationCounter(to: currentGeneration)
        fieldView.updateField(with: cells)
    }
    
    private func checkAllNeighbors(by i: Int, in row: Int) -> Int {
        var countOfAliveNeighbors = 0
        let shiftToTopNeighbors = i - Constants.fieldWidth
        
        if i != 0 && Constants.fieldWidth * (row - 1) - i != 0 {
            countOfAliveNeighbors += checkVerticalNeighbors(shiftToTopNeighbors - 1)
        }
        if i != Constants.fieldWidth - 1 && Constants.fieldWidth * row - 1 - i != 0 {
            countOfAliveNeighbors += checkVerticalNeighbors(shiftToTopNeighbors + 1 )
        }
        countOfAliveNeighbors += checkTopOrBottomNeighbors(shiftToTopNeighbors)
        countOfAliveNeighbors += checkTopOrBottomNeighbors(i + Constants.fieldWidth)
        
        return countOfAliveNeighbors
    }
    
    private func checkCellIsAlive(with aliveNeighbors: Int, in i: Int) {
        if !cells[i] {
            if aliveNeighbors == 3 {
                resurrectCell(at: i)
            }
        } else {
            switch aliveNeighbors {
            case 0...1, 4...8:
                killCell(at: i)
            default:
                resurrectCell(at: i)
            }
        }
    }
    
    private func checkVerticalNeighbors(_ index: Int) -> Int {
        var i = index
        var countOfAliveNeighbors = 0
        
        for _ in 1...3 {
            if i >= 0 && i < Constants.cellsCount && cells[i] == true {
                countOfAliveNeighbors += 1
            }
            i += Constants.fieldWidth
        }
        
        return countOfAliveNeighbors
    }
    private func checkTopOrBottomNeighbors(_ index: Int) -> Int {
        if index >= 0 && index < Constants.cellsCount && cells[index] == true {
            return 1
        }
        return 0
    }
    
    private func changeGenerationCounter(to amount: Int) {
        fieldView.updateGenerationCounterLabel(to: amount)
    }
}

// MARK: - Views Manager
extension GameViewController {
    private func setupViews() {
        fieldView.configure()
        view.setupView(fieldView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            fieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            fieldView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            fieldView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            fieldView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureAppearance() {
        view.backgroundColor = .systemIndigo
    }
}
