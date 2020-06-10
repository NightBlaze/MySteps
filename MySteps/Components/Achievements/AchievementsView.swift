//
//  AchievementsView.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IAchievementsView: UIView {
    func resolveDependencies(stepsReader: IStepsProviderReader,
                             animator: IAchievementAnimator)
}

protocol IAchievementsViewUpdater: UIView {
    func showAchievements(viewModels: [AchievementBadgeViewModel])
    func showNoAchievement(viewModel: AchievementBadgeViewModel)
}

final class AchievementsView: BaseNibView {
    @IBOutlet weak var achievementsTitleLabel: UILabel!
    @IBOutlet weak var achievementsCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noAchievementsBadgeView: AchievementBadgeView!
    
    private var interactor: IAchievementsViewInteractor?
    private var animator: IAchievementAnimator?

    private var viewModels: [AchievementBadgeViewModel]?
    private var tempViewModels: [AchievementBadgeViewModel]?
    private var needToAnimate = true

    override func initialize(useAutoLayout: Bool = true,
                             bundle: Bundle? = .main) {
        super.initialize(useAutoLayout: useAutoLayout, bundle: bundle)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)

        backgroundColor = Colors.Background.view
        achievementsTitleLabel.textColor = Colors.Foreground.white
        achievementsTitleLabel.backgroundColor = Colors.Background.label
        achievementsCountLabel.textColor = Colors.Foreground.blue
        achievementsCountLabel.backgroundColor = Colors.Background.label
        collectionView.backgroundColor = Colors.Background.collectionViewCell
        achievementsTitleLabel.font = Fonts.achievementsTitle
        achievementsCountLabel.font = Fonts.achievementsCount

        let presenter = AchievementsViewPresenter()
        presenter.resolveDependencies(view: self)
        interactor = AchievementsViewInteractor(presenter: presenter)

        achievementsTitleLabel.text = "achievements_view.achievements_title".localized

        AchievementCollectionViewCell.registerNib(for: collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - IAchievementsView

extension AchievementsView: IAchievementsView {
    func resolveDependencies(stepsReader: IStepsProviderReader,
                             animator: IAchievementAnimator) {
        self.animator = animator
        interactor?.resolveDependencies(stepsReader: stepsReader)
        interactor?.loadData()
    }
}

// MARK: - IAchievementsViewUpdater

extension AchievementsView: IAchievementsViewUpdater {
    func showAchievements(viewModels: [AchievementBadgeViewModel]) {
        updateNoAchievementsBadgeVisibility(visible: false)
        self.viewModels = viewModels
        updateAchievementsCountLabel()
        collectionView.reloadSections(IndexSet(integer: 0))
    }

    func showNoAchievement(viewModel: AchievementBadgeViewModel) {
        updateNoAchievementsBadgeVisibility(visible: true)
        viewModels = nil
        updateAchievementsCountLabel()
        noAchievementsBadgeView.update(viewModel: viewModel)
    }
}

// MARK: - Private

private extension AchievementsView {
    func updateAchievementsCountLabel() {
        let count = viewModels?.count ?? 0
        achievementsCountLabel.text = "\(count.localized)"
    }

    func updateNoAchievementsBadgeVisibility(visible: Bool) {
        noAchievementsBadgeView.isHidden = !visible
        collectionView.isHidden = !noAchievementsBadgeView.isHidden
    }

    @objc func applicationWillEnterForeground(notification: NSNotification) {
        tempViewModels = viewModels
        viewModels = nil
        collectionView.reloadData()
    }

    @objc func applicationDidBecomeActive(notification: NSNotification) {
        guard tempViewModels != nil else { return }

        viewModels = tempViewModels
        tempViewModels = nil
        needToAnimate = true
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.needToAnimate = false
        }
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

// MARK: - UICollectionViewDelegate

extension AchievementsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if needToAnimate {
            animator?.animate(view: cell, indexPath: indexPath)

            // We need show animation only once
            // and do not animate while scrolling
            // On the screen there are max 3 cells
            // so we disable animation after 3 animations
            // or after all cells appears (if we have not 3 cells)
            let totalAchievements = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            if indexPath.row >= totalAchievements || indexPath.row >= 2 {
                needToAnimate = false
            }
        }
    }
}
