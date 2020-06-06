//
//  UITableViewCell+Creation.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class func registerClass(for tableView: UITableView?) {
        tableView?.register(self, forCellReuseIdentifier: reuseIdentifier())
    }

    class func registerNib(for tableView: UITableView?) {
        tableView?.register(nib(), forCellReuseIdentifier: reuseIdentifier())
    }

    class func dequeue(for tableView: UITableView,
                       indexPath: IndexPath) -> Self {
        return dequeCell(for: tableView, indexPath: indexPath)
    }
}

// MARK: - Private

private extension UITableViewCell {
    class func reuseIdentifier() -> String { nameOfClass() }

    class func nib() -> UINib? {
        UINib(nibName: nameOfClass(), bundle: nil)
    }

    class func dequeCell<T: UITableViewCell>(for tableView: UITableView,
                                             indexPath: IndexPath) -> T {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier(), for: indexPath) as! T
    }
}
