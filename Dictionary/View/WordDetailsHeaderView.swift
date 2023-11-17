//
//  WordDetailsHeaderView.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 17.11.2023.
//

import UIKit

class WordDetailsHeaderView: UICollectionReusableView {
        
    let wordLabel = UILabel()
    let phoneticsLabel = UILabel()
    
    let starButton: UIButton = {
        let button = UIButton(type: .system)
        let starImage = UIImage(systemName: "star")
        button.setImage(starImage, for: .normal)
        button.tintColor = .systemBlue
//        button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)

        return button
    }()
    
    var soundButtonIsPressed: Bool = false
    let soundButton: UIButton = {
        let button = UIButton(type: .system)
        let headphonesImage = UIImage(systemName: "headphones.circle")
        button.setImage(headphonesImage, for: .normal)
        button.tintColor = .systemBlue
//        button.addTarget(self, action: #selector(didTapHeadphones), for: .touchUpInside)

        return button
    }()
    
      override init(frame: CGRect) {
          super.init(frame: frame)

          wordLabel.font = .systemFont(ofSize: 30)
          phoneticsLabel.font = .systemFont(ofSize: 20)
          wordLabel.textColor = .white
          phoneticsLabel.textColor = .systemGray
          
          let wordStack = UIStackView(arrangedSubviews: [
            wordLabel, phoneticsLabel
          ])
          wordStack.axis = .horizontal
          wordStack.translatesAutoresizingMaskIntoConstraints = false
          wordStack.alignment = .lastBaseline
          
          let firstStack = UIStackView(arrangedSubviews: [
            wordStack, soundButton, starButton
          ])
          
          firstStack.axis = .horizontal
          firstStack.distribution = .equalSpacing
          firstStack.translatesAutoresizingMaskIntoConstraints = false
          firstStack.alignment = .lastBaseline
          firstStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
          
          addSubview(firstStack)
          
          firstStack.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
          firstStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
          firstStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
          firstStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0).isActive = true

      }

      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
