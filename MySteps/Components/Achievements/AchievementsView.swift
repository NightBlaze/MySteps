//
//  AchievementsView.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IAchievementsView: UIView {
    func resolveDependencies(stepsReader: IStepsProviderReader)
}

final class AchievementsView: BaseNibView {
    @IBOutlet weak var achievementsTitleLabel: UILabel!
    @IBOutlet weak var achievementsCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private var stepsReader: IStepsProviderReader?
    private var viewModels: [AchievementViewModel]? {
        didSet {
            updateUI()
        }
    }

    override func initialize(useAutoLayout: Bool = true,
                             bundle: Bundle? = .main) {
        super.initialize(useAutoLayout: useAutoLayout, bundle: bundle)

        // TODO: localize
        achievementsTitleLabel.text = "Achievements"

        AchievementCollectionViewCell.registerNib(for: collectionView)

        collectionView.dataSource = self
    }
}

// MARK: - IAchievementsView

extension AchievementsView: IAchievementsView {
    func resolveDependencies(stepsReader: IStepsProviderReader) {
        self.stepsReader = stepsReader

        loadData()
    }
}

// MARK: - Private

private extension AchievementsView {
    func loadData() {
        stepsReader?.stepsForLastMonth() { [weak self] result in
            guard let self = self,
                case .success(let stepsResult) = result else { return }

            self.viewModels = self.createViewModels(daos: stepsResult.steps)
        }
    }

    func updateUI() {
        // TODO: localize
        achievementsCountLabel.text = "\(viewModels?.count ?? 0)"

        collectionView.reloadData()
    }
}

// MARK: - Presenter

private extension AchievementsView {
    func createViewModels(daos: [StepsDAO]) -> [AchievementViewModel] {
        var totalSteps = Int(daos.reduce(0) { $0 + $1.count })
        if totalSteps > 40000 {
            totalSteps = 40000
        }
        return checkStepsAndReturnAchievements(acc: [], steps: totalSteps, decreaseStep: 5000).reversed()
    }

    func checkStepsAndReturnAchievements(acc: [AchievementViewModel], steps: Int, decreaseStep: Int) -> [AchievementViewModel] {
        if steps < 10000 {
            return acc
        }

        let achievement = AchievementViewModel(steps: steps)
        var result = acc
        result.append(achievement)

        return checkStepsAndReturnAchievements(acc: result, steps: steps - decreaseStep, decreaseStep: decreaseStep)
    }
}

// MARK: - UICollectionViewDataSource

extension AchievementsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = AchievementCollectionViewCell.dequeue(for: collectionView, indexPath: indexPath)
        if let viewModel = viewModels?[indexPath.row] {
            cell.update(viewModel: viewModel)
        }
        return cell
    }
}
