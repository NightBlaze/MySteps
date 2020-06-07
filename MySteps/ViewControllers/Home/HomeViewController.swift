//
//  HomeViewController.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IHomeViewController: UIViewController {
    
}

final class HomeViewController: UIViewController {
    private enum CellType: Int, CaseIterable {
        case userAvatar, chart, achievements

        static func fromIndexPath(_ indexPath: IndexPath) -> Self? {
            return CellType(rawValue: indexPath.row)
        }

        func cellClass() -> UITableViewCell.Type {
            switch self {
            case .userAvatar:
                return UserAvatarTableViewCell.self as UITableViewCell.Type
            case .chart:
                return ChartTableViewCell.self as UITableViewCell.Type
            case .achievements:
                return AchievementsTableViewCell.self as UITableViewCell.Type
            }
        }

        func cellHeight() -> CGFloat {
            switch self {
            case .userAvatar:
                return UserAvatarTableViewCell.height
            case .chart:
                return ChartTableViewCell.height
            case .achievements:
                return AchievementsTableViewCell.height
            }
        }
    }

    @IBOutlet weak var userBarView: UserBarView!
    @IBOutlet weak var tableView: UITableView!
    
    private let interactor: IHomeInteractor
    private let userProvider: IUserProviderReader
    private let stepsReader: IStepsProviderReader
    
    init(interactor: IHomeInteractor,
         userProvider: IUserProviderReader,
         stepsReader: IStepsProviderReader) {
        self.interactor = interactor
        self.userProvider = userProvider
        self.stepsReader = stepsReader
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        AchievementsTableViewCell.registerNib(for: tableView)
        ChartTableViewCell.registerNib(for: tableView)
        UserAvatarTableViewCell.registerNib(for: tableView)

        userBarView.resolveDependencies(userProvider: userProvider)
        userBarView.hostViewControllerViewDidLoad()
    }
}

// MARK: - IHomeViewController

extension HomeViewController: IHomeViewController {
}

// MARK: - Private

private extension HomeViewController {
    func dequeueCellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = CellType.fromIndexPath(indexPath) else {
            return UITableViewCell()
        }

        let cellClass = cellType.cellClass()
        let cell = cellClass.dequeue(for: tableView, indexPath: indexPath)
        return cell
    }

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cellType = CellType.fromIndexPath(indexPath) else { return }

        switch cellType {
            case .userAvatar:
                if let cell = cell as? UserAvatarTableViewCell {
                    cell.resolveDependencies(userReader: userProvider)
                }
            case .chart:
                if let cell = cell as? ChartTableViewCell {
                    cell.resolveDependencies(stepsReader: stepsReader)
                }
            case .achievements:
                if let cell = cell as? AchievementsTableViewCell {
                    cell.resolveDependencies(stepsReader: stepsReader)
                }
                break
        }
    }
}

// MARK: - IBAction

private extension HomeViewController {
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCellForRowAt(indexPath: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = CellType.fromIndexPath(indexPath) else {
            return 0
        }

        return cellType.cellHeight()
    }
}
