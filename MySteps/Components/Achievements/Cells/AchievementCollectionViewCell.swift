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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var achievementTitleLabel: UILabel!
    @IBOutlet weak var stepsCountLabel: UILabel!

    func update(viewModel: AchievementCellViewModel) {
        imageView.image = UIImage(named: viewModel.imageName)
        achievementTitleLabel.text = viewModel.title
        stepsCountLabel.text = viewModel.stepsCount
    }

    override func awakeFromNib() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2

        backgroundColor = Colors.Background.collectionViewCell
        imageView.backgroundColor = Colors.Background.imageView
        achievementTitleLabel.textColor = Colors.Foreground.white
        achievementTitleLabel.backgroundColor = Colors.Background.label
        stepsCountLabel.textColor = Colors.Foreground.grey
        stepsCountLabel.backgroundColor = Colors.Background.label

        achievementTitleLabel.font = Fonts.achievement
        stepsCountLabel.font = Fonts.achievementSteps
    }
}
