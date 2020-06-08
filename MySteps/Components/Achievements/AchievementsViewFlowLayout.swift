//
//  AchievementsViewFlowLayout.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 08.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

// from https://littlebitesofcocoa.com/306-customizing-collection-view-cell-insertion-animations
final class AchievementsViewFlowLayout: UICollectionViewFlowLayout {
    private var indexPaths: [IndexPath] = []

    override init() {
        super.init()

        sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        itemSize = AchievementCollectionViewCell.size
        scrollDirection = .horizontal
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        indexPaths.removeAll()

        updateItems.forEach { updateItem in
            if let indexPath = updateItem.indexPathAfterUpdate,
                updateItem.updateAction == .insert {
              indexPaths.append(indexPath)
            }
        }
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        indexPaths.removeAll()
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes()
        attributes.alpha = 0
        attributes.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        return attributes
    }
}
