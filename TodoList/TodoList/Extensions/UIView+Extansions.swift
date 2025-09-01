//
//  UIView+Extansions.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import UIKit

extension UIView {
    func addConstrained(subview: UIView,
                        top: CGFloat? = 0,
                        left: CGFloat? = 0,
                        bottom: CGFloat? = 0,
                        right: CGFloat? = 0) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)

        if let top = top {
            subview.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        }
        if let left = left {
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: left).isActive = true
        }
        if let bottom = bottom {
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
        }
        if let right = right {
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: right).isActive = true
        }
    }
}
