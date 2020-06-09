//
//  BaseNibView.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

class BaseNibView: UIView {
    @IBOutlet weak var containerView: UIView?

    private var nibName: String { nameOfClass() }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initialize()
    }

    func initialize(useAutoLayout: Bool = true,
                    bundle: Bundle? = .main) {
        translatesAutoresizingMaskIntoConstraints = !useAutoLayout

        // load the view hierarchy to get proper outlets
        let nib = UINib(nibName: nibName, bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)

        if let containerView = containerView {
            addSubview(containerView)

            containerView.translatesAutoresizingMaskIntoConstraints = !useAutoLayout

            if useAutoLayout {
                containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
                containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
                containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
                containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            }

            containerView.backgroundColor = backgroundColor
            containerView.isOpaque = true
        }
    }

    func hostViewControllerViewDidLoad() {
        
    }
}

// MARK: - Overrides

extension BaseNibView {
    override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            containerView?.backgroundColor = newValue
            super.backgroundColor = newValue
        }
    }

    override var isOpaque: Bool {
        get {
            return super.isOpaque
        }
        set {
            containerView?.isOpaque = newValue
            super.isOpaque = newValue
        }
    }

    override func addSubview(_ view: UIView) {
        // Need to check that view != containerView
        // to not add containerView to containerView
        if let containerView = containerView, view != containerView {
            containerView.addSubview(view)
        } else {
            super.addSubview(view)
        }
    }
}
