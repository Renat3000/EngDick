//
//  Extension.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

extension UIView {
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
}

func makeButtonForSets(withText text: String) -> UIButton {
    let button = UIButton(type: .system)
    
    button.setTitle(text, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 10
    button.titleLabel?.textColor = .black
    button.tintColor = .black
    button.backgroundColor = .white
    
    return button
}

func makeLabel() -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 2
    label.textColor = .white
    label.backgroundColor = .systemGray4
    label.font = .systemFont(ofSize: 24)
    label.textAlignment = .center
    return label
}

func  makeStackView() -> UIStackView {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.distribution = .fill
    view.alignment = .fill
    view.spacing = 8.0
    
    return view
}
