//
//  UserBarView.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IUserBarView: UIView {
    func resolveDependencies(userProvider: IUserProviderReader)
}

/// UserBaseView uses to show user's name.
/// This class can be implemented like VIP module
/// but because it's very simple I use only View
final class UserBarView: BaseNibView {
    @IBOutlet weak var nameLabel: UILabel!

    private var userProvider: IUserProviderReader?
    private var viewModel: UserBarViewModel? {
        didSet {
            nameLabel.text = viewModel?.fullName
        }
    }

    override func hostViewControllerViewDidLoad() {
        super.hostViewControllerViewDidLoad()

        userProvider?.loggedInUser { [weak self] result in
            if case .success(let user) = result {
                self?.viewModel = UserBarViewModel(dao: user)
            }
        }
    }
}

// MARK: - IUserBarView

extension UserBarView: IUserBarView {
    func resolveDependencies(userProvider: IUserProviderReader) {
        self.userProvider = userProvider
    }
}
