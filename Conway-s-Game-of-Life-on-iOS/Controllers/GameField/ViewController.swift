//
//  ViewController.swift
//  Conway-s-Game-of-Life-on-iOS
//
//  Created by Dreik on 10/20/22.
//

import UIKit

class ViewController: UIViewController {
    var currentGeneration = 0
    var isStarted = false
    lazy var timer = Timer()
    
    var controlPanel = ControlPanel()
    var cells = [UIView]()
    var field = UIView()
    
    let startButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Start"
        configuration.titlePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let button = UIButton(configuration: configuration)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    let restartButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Restart"
        configuration.titlePadding = 10
        configuration.background.backgroundColor = .systemMint
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(restartButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        configureAppearance()
        fillTheField()
        placeRandomly(100)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

extension ViewController {
    func fillTheField() {
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
    
    func clearField() {
        for cell in cells {
            cell.backgroundColor = .white
        }
    }
}

extension ViewController {
    func createCell() -> UIView {
        let cell = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constants.fieldCellWidth, height: Constants.fieldCellWidth)))

        cell.backgroundColor = .white
        cell.layer.cornerRadius = 1
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemGray.cgColor
        
        return cell
    }
    
    func resurrectCell(at index: Int) {
        cells[index].backgroundColor = .black
    }
    
    func killCell(at index: Int) {
        cells[index].backgroundColor = .white
    }

    func removeCellFromTheField() {
        let cell = cells.removeLast()
        cell.removeFromSuperview()
    }
    
    func placeRandomly(_ amount: Int) {
        for _ in 0...amount {
            let randomIndex = Int.random(in: 0..<Constants.cellsCount)
            
            resurrectCell(at: randomIndex)
        }
    }
}

// MARK: - Update Generation
extension ViewController {
    func updateGeneration() {
        var i = 0
        let cellsCount = cells.count
        
        while i < cellsCount {
            var countOfAliveNeighbors = 0
            // check left neighbors
            let shiftToTopNeighbors = i - Constants.fieldWidth
            
            if i % 50 != 0 {
                countOfAliveNeighbors += checkVerticalNeighbors(shiftToTopNeighbors - 1)
            }
            if i % 49 != 0 {
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
    
    func checkVerticalNeighbors(_ index: Int) -> Int {
        var i = index
        var countOfAliveNeighbors = 0
        
        for _ in 1...3 {
            if i >= 0 && i < Constants.cellsCount {
                if cells[i].backgroundColor == .black {
                    countOfAliveNeighbors += 1
                }
            }
            i += 50
        }
        
        return countOfAliveNeighbors
    }
    func checkTopOrBottomNeighbors(_ index: Int) -> Int {
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
    @objc func startButtonPressed() {
        
        if !isStarted {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
                self.updateGeneration()
            })
            startButton.setTitle("Stop", for: .normal)
            startButton.configuration?.background.backgroundColor = .systemRed
        } else {
            self.timer.invalidate()

            startButton.setTitle("Start", for: .normal)
            startButton.configuration?.background.backgroundColor = .systemBlue
            print("game stoped")
        }
        isStarted.toggle()
    }
    // MARK: - Restart Button
    @objc func restartButtonPressed() {
        currentGeneration = 0
        clearField()
        self.timer.invalidate()
        placeRandomly(150)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
            self.updateGeneration()
        })
        startButton.setTitle("Stop", for: .normal)
        startButton.configuration?.background.backgroundColor = .systemRed
        isStarted = true
    }
    
}


// MARK: - Views Manager
extension ViewController {
    func setupViews() {
        field.translatesAutoresizingMaskIntoConstraints = false
        controlPanel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(controlPanel)
        controlPanel.addSubview(startButton)
        controlPanel.addSubview(restartButton)
        view.addSubview(field)
        
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            controlPanel.topAnchor.constraint(equalTo: view.topAnchor),
            controlPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlPanel.heightAnchor.constraint(equalToConstant: 150),
            
            startButton.centerXAnchor.constraint(equalTo: controlPanel.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: field.topAnchor, constant: -20),
            
            restartButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor),
            restartButton.trailingAnchor.constraint(equalTo: field.trailingAnchor, constant: -20),
            
            field.topAnchor.constraint(equalTo: controlPanel.bottomAnchor),
            field.widthAnchor.constraint(equalToConstant: Constants.screenWidth),
            field.heightAnchor.constraint(equalToConstant: Constants.screenWidth),
            
        ])
    }
    
    func configureAppearance() {
        field.backgroundColor = .systemRed
        view.backgroundColor = .systemCyan
    }
}
