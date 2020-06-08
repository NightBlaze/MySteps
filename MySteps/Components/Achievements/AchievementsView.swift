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

protocol IAchievementsViewUpdater: UIView {
    func updateViewModels(_ viewModels: [AchievementCellViewModel])
}

final class AchievementsView: BaseNibView {
    @IBOutlet weak var achievementsTitleLabel: UILabel!
    @IBOutlet weak var achievementsCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private let collectionViewLayout = AchievementsViewFlowLayout()
    private var interactor: IAchievementsViewInteractor?

    private var viewModels: [AchievementCellViewModel]? {
        didSet {
            updateUI()
        }
    }

    override func initialize(useAutoLayout: Bool = true,
                             bundle: Bundle? = .main) {
        super.initialize(useAutoLayout: useAutoLayout, bundle: bundle)

        let presenter = AchievementsViewPresenter()
        presenter.resolveDependencies(view: self)
        interactor = AchievementsViewInteractor(presenter: presenter)

        // TODO: localize
        achievementsTitleLabel.text = "Achievements"

        AchievementCollectionViewCell.registerNib(for: collectionView)

        collectionView.setCollectionViewLayout(collectionViewLayout, animated: false)
        collectionView.dataSource = self
    }
}

// MARK: - IAchievementsView

extension AchievementsView: IAchievementsView {
    func resolveDependencies(stepsReader: IStepsProviderReader) {
        interactor?.resolveDependencies(stepsReader: stepsReader)
        interactor?.loadData()
    }
}

// MARK: - IAchievementsViewUpdater

extension AchievementsView: IAchievementsViewUpdater {
    func updateViewModels(_ viewModels: [AchievementCellViewModel]) {
        self.viewModels = viewModels
    }
}

// MARK: - Private

private extension AchievementsView {
    func updateUI() {
        // TODO: localize
        achievementsCountLabel.text = "\(viewModels?.count ?? 0)"

        let viewModelsCount = viewModels?.count ?? 0
        let indexPaths = (0..<viewModelsCount).map { IndexPath(item: $0, section: 0) }
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: indexPaths)
        })
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
