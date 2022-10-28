//
//  Constants.swift
//  Conway-s-Game-of-Life-on-iOS
//
//  Created by Dreik on 10/20/22.
//

import UIKit

struct Constants {
    static let fieldWidth = 50
    static let fieldHeight = 50
    static let cellsCount = fieldWidth * fieldHeight
    static let startCellsAmount = 200
    static let leftDistanceToView: CGFloat = 10
    static let rightDistanceToView: CGFloat = 10
    static let galleryMinimumLineSpacing: CGFloat = 0
    
    static let screenWidth = UIScreen.main.bounds.width
    static let fieldViewWidth = screenWidth - leftDistanceToView - rightDistanceToView
    static let fieldCellWidth = fieldViewWidth / CGFloat(fieldWidth)
    static let halfOfCellWidth = fieldCellWidth / 2
    
    static let leftBoundry = halfOfCellWidth
    static let rightBoundry = fieldViewWidth - leftBoundry
}
