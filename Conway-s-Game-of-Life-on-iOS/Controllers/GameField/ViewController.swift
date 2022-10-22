//
//  ViewController.swift
//  Conway-s-Game-of-Life-on-iOS
//
//  Created by Dreik on 10/20/22.
//

import UIKit

final class ViewController: UIViewController {
    private var currentGeneration = 0
    private var isStarted = false
    private lazy var timer = Timer()
    private lazy var isRanomized = false
    private let startCellsAmount = 200
    
    private let controlPanel = UIView()
    private var cells = [UIView]()
    private let field = UIView()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.backgroundColor = .systemGray5
        button.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    private lazy var randomizeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Randomize", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray3, for: .highlighted)
        button.addTarget(self, action: #selector(randomizeButtonPressed), for: .touchUpInside)
        button.backgroundColor = .systemGreen
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        configureAppearance()
        fillTheField()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

// MARK: - Field Manager
extension ViewController {
    private func fillTheField() {
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
                
                cells.append(cell)
                field.addSubview(cell)
            }
            x = Constants.halfOfCellWidth
            y += Constants.fieldCellWidth
            row += 1
        }
    }
    
    private func clearField() {
        for cell in cells {
            cell.backgroundColor = .white
        }
    }
}

// MARK: - Cells Manager
extension ViewController {
    private func createCell() -> UIView {
        let cell = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constants.fieldCellWidth, height: Constants.fieldCellWidth)))

        cell.backgroundColor = .white
        cell.layer.cornerRadius = 2
        cell.layer.borderWidth = .zero
//        cell.layer.borderColor = UIColor.systemGray.cgColor
        
        return cell
    }
    
    private func resurrectCell(at index: Int) {
        cells[index].backgroundColor = .black
    }
    
    private func killCell(at index: Int) {
        cells[index].backgroundColor = .white
    }
    
    private func placeRandomly(_ amount: Int) {
        for _ in 0..<amount {
            let randomIndex = Int.random(in: 0..<Constants.cellsCount)
            
            resurrectCell(at: randomIndex)
        }
    }
}

// MARK: - Update Generation
extension ViewController {
    private func updateGeneration() {
        var i = 0
        var row = 1
        let cellsCount = cells.count
        
        while i < cellsCount {
            if i >= Constants.fieldWidth && i % Constants.fieldWidth == 0 {
                row += 1
            }
            var countOfAliveNeighbors = 0
            // check left neighbors
            let shiftToTopNeighbors = i - Constants.fieldWidth
            
            if i != 0 && Constants.fieldWidth * (row - 1) - i != 0 {
                countOfAliveNeighbors += checkVerticalNeighbors(shiftToTopNeighbors - 1)
            }
            if i != Constants.fieldWidth - 1 && Constants.fieldWidth * row - 1 - i != 0 {
                countOfAliveNeighbors += checkVerticalNeighbors(shiftToTopNeighbors + 1 )
            }
            countOfAliveNeighbors += checkTopOrBottomNeighbors(shiftToTopNeighbors)
            countOfAliveNeighbors += checkTopOrBottomNeighbors(i + Constants.fieldWidth)
            // check cell isAlive
            if cells[i].backgroundColor == .white {
                if countOfAliveNeighbors == 3 {
                    resurrectCell(at: i)
                }
            } else {
                switch countOfAliveNeighbors {
                case 0...1, 4...8:
                    killCell(at: i)
                default:
                    resurrectCell(at: i)
                }
            }
            i += 1
        }
        currentGeneration += 1
        print("Current generation: \(currentGeneration)")
    }
    
    private func checkVerticalNeighbors(_ index: Int) -> Int {
        var i = index
        var countOfAliveNeighbors = 0
        
        for _ in 1...3 {
            if i >= 0 && i < Constants.cellsCount {
                if cells[i].backgroundColor == .black {
                    countOfAliveNeighbors += 1
                }
            }
            i += Constants.fieldWidth
        }
        
        return countOfAliveNeighbors
    }
    private func checkTopOrBottomNeighbors(_ index: Int) -> Int {
        if index >= 0 && index < Constants.cellsCount {
            if cells[index].backgroundColor == .black {
                return 1
            }
        }
        return 0
    }
}

extension ViewController {
    // MARK: - Start Button
    @objc private func startButtonPressed() {
        print(Constants.cellsCount)
        if !isRanomized {
            startButton.isEnabled = false
        } else {
            if !isStarted {
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
                    self.updateGeneration()
                })
                startButton.setTitle("Stop", for: .normal)
                startButton.backgroundColor = .systemRed
            } else {
                self.timer.invalidate()

                startButton.setTitle("Start", for: .normal)
                startButton.backgroundColor = .systemBlue
                print("game stoped")
            }
            isStarted.toggle()
        }
    }
    // MARK: - Randomize Button
    @objc private func randomizeButtonPressed() {
        self.timer.invalidate()
        isStarted = false
        isRanomized = true
        currentGeneration = 0
        
        clearField()
        placeRandomly(startCellsAmount)
        
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = .systemBlue
    }
}

// MARK: - Views Manager
extension ViewController {
    private func setupViews() {
        field.translatesAutoresizingMaskIntoConstraints = false
        controlPanel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        randomizeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(controlPanel)
        controlPanel.addSubview(startButton)
        controlPanel.addSubview(randomizeButton)
        view.addSubview(field)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            controlPanel.topAnchor.constraint(equalTo: view.topAnchor),
            controlPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlPanel.heightAnchor.constraint(equalToConstant: 150),
            
            startButton.centerXAnchor.constraint(equalTo: controlPanel.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: field.topAnchor, constant: -20),
            
            randomizeButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor),
            randomizeButton.trailingAnchor.constraint(equalTo: field.trailingAnchor, constant: -20),
            
            field.topAnchor.constraint(equalTo: controlPanel.bottomAnchor),
            field.widthAnchor.constraint(equalToConstant: Constants.screenWidth),
            field.heightAnchor.constraint(equalToConstant: Constants.screenWidth),
        ])
    }
    
    private func configureAppearance() {
        field.backgroundColor = .systemRed
        view.backgroundColor = .systemIndigo
    }
}
