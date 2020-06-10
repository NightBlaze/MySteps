//
//  UserAvatarTableViewCell.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

// Here we can use VIP module
// but because the cell is very simple use just View
class UserAvatarTableViewCell: UITableViewCell {
    static let height: CGFloat = 220

    @IBOutlet weak var avatarImageView: UIImageView!

    private var avatarImageName: String? {
        didSet {
            if oldValue != avatarImageName,
                let avatarImageName = avatarImageName {
                avatarImageView.image = UIImage.roundedImage(named: avatarImageName)
            }
        }
    }
    private var userReader: IUserProviderReader? {
        didSet {
            userReader?.loggedInUser{ [weak self] result in
                if case .success(let user) = result {
                    self?.avatarImageName = user.avatar
                }
            }
        }
    }

    func resolveDependencies(userReader: IUserProviderReader) {
        self.userReader = userReader
    }

    override func awakeFromNib() {
        backgroundColor = Colors.Background.tableViewCell
        avatarImageView.backgroundColor = Colors.Background.imageView
    }
}
