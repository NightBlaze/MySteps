//
//  AchievementBadgeView.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 09.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IAchievementBadgeView {
    func update(viewModel: AchievementBadgeViewModel)
}

final class AchievementBadgeView: BaseNibView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var achievementTitleLabel: UILabel!
    @IBOutlet weak var stepsCountLabel: UILabel!

    override func initialize(useAutoLayout: Bool = true, bundle: Bundle? = .main) {
        super.initialize(useAutoLayout: useAutoLayout, bundle: bundle)

        backgroundColor = Colors.Background.view
        imageView.backgroundColor = Colors.Background.imageView
        achievementTitleLabel.textColor = Colors.Foreground.white
        achievementTitleLabel.backgroundColor = Colors.Background.label
        stepsCountLabel.textColor = Colors.Foreground.grey
        stepsCountLabel.backgroundColor = Colors.Background.label

        achievementTitleLabel.font = Fonts.achievement
        stepsCountLabel.font = Fonts.achievementSteps
    }
}

// MARK: - IAchievementBadgeView

extension AchievementBadgeView: IAchievementBadgeView {
    func update(viewModel: AchievementBadgeViewModel) {
        imageView.image = UIImage.roundedImage(named: viewModel.imageName)
        achievementTitleLabel.text = viewModel.title
        stepsCountLabel.text = viewModel.subtitle
    }
}
