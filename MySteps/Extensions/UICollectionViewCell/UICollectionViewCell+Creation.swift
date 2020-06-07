//
//  UICollectionViewCell+Creation.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    class func registerClass(for collectionView: UICollectionView?) {
        collectionView?.register(self, forCellWithReuseIdentifier: reuseIdentifier())
    }

    class func registerNib(for collectionView: UICollectionView?) {
        collectionView?.register(nib(), forCellWithReuseIdentifier: reuseIdentifier())
    }

    class func dequeue(for collectionView: UICollectionView,
                       indexPath: IndexPath) -> Self {
        return dequeCell(for: collectionView, indexPath: indexPath)
    }
}

// MARK: - Private

private extension UICollectionViewCell {
    class func reuseIdentifier() -> String { nameOfClass() }

    class func nib() -> UINib? {
        UINib(nibName: nameOfClass(), bundle: nil)
    }

    class func dequeCell<T: UICollectionViewCell>(for collectionView: UICollectionView,
                                                  indexPath: IndexPath) -> T {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier(), for: indexPath) as! T
    }
}
