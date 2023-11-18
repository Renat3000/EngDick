//
//  WordDetailsHeaderView.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 17.11.2023.
//

import UIKit

class WordDetailsHeaderView: UICollectionReusableView {

    weak var delegate: HeaderDelegate?
    let wordLabel = UILabel()
    let phoneticsLabel = UILabel()
    var isBookmarked: Bool = false
    var soundButtonIsPressed: Bool = false
    
    let starButton: UIButton = {
        let button = UIButton(type: .system)
        let starImage = UIImage(systemName: "star")
        button.setImage(starImage, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)

        return button
    }()
    
    let soundButton: UIButton = {
        let button = UIButton(type: .system)
        let headphonesImage = UIImage(systemName: "headphones.circle")
        button.setImage(headphonesImage, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapHeadphones), for: .touchUpInside)

        return button
    }()
    
      override init(frame: CGRect) {
          super.init(frame: frame)

          wordLabel.font = .systemFont(ofSize: 30)
          phoneticsLabel.font = .systemFont(ofSize: 20)
          wordLabel.textColor = .white
          phoneticsLabel.textColor = .systemGray
          
          let firstStack = UIStackView(arrangedSubviews: [
            wordLabel, phoneticsLabel, soundButton, starButton
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
    
    func setAudioButtonEnabled(_ isEnabled: Bool) {
        soundButton.isEnabled = isEnabled
        soundButton.tintColor = isEnabled ? .systemBlue : .gray
    }
    
    @objc private func didTapStar() {
        isBookmarked.toggle()
        
        if isBookmarked {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        delegate?.didTapStar()
    }
    
    @objc private func didTapHeadphones() {
        soundButtonIsPressed.toggle()
        if soundButtonIsPressed {
            soundButton.setImage(UIImage(systemName: "headphones.circle.fill"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "headphones.circle"), for: .normal)
        }
        delegate?.didTapHeadphones(soundButtonIsPressed: soundButtonIsPressed)
    }
}

protocol HeaderDelegate: AnyObject {
    func didTapStar()
    func didTapHeadphones(soundButtonIsPressed: Bool)
}
