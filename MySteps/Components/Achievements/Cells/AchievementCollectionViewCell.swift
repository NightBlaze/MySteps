//
//  AchievementCollectionViewCell.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    static let size = CGSize(width: 116, height: 177)

    @IBOutlet weak var badgeView: AchievementBadgeView!
    
    func update(viewModel: AchievementBadgeViewModel) {
        badgeView.update(viewModel: viewModel)
    }
}
