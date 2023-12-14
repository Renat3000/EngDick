//
//  SetsController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 24.11.2023.
//

import UIKit

class SetsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        
        let stackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            view.distribution = .fill
            view.alignment = .fill
            view.spacing = 8.0
            
            return view
        }()

        let playButton: UIButton = {
            let button = UIButton(type: .system)
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
            let playImage = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
            button.setImage(playImage, for: .normal)
            button.tintColor = .systemGray
            button.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)

            return button
        }()
        
        let noteLabel: UILabel = {
            let label = UILabel()
            
            label.numberOfLines = 3
            label.textColor = .white
            label.backgroundColor = .systemGray4
            label.font = .systemFont(ofSize: 24)
            label.textAlignment = .center
            return label
        }()
        
        stackView.addArrangedSubview(noteLabel)
        stackView.addArrangedSubview(playButton)
        view.addSubview(stackView)

        // Pinning to the sides of view
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        // Padding and spacing
        stackView.isLayoutMarginsRelativeArrangement = true
    
        noteLabel.text = "Practice Active Learning with the spaced repetition method! Learn words that were saved to Favorites"
    }

    
    @objc private func didTapPlay() {

        let cardVC = CardViewController()
        self.present(cardVC, animated: true)
    }

}
