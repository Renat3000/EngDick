//
//  DictionaryView.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class DictionaryView: UICollectionView {
    
    let searchBar = UISearchBar()
    let testTextLabel = UILabel()
    
    init() {
            let layout = UICollectionViewFlowLayout()
//            layout.scrollDirection = .vertical
            super.init(frame: CGRect.zero, collectionViewLayout: layout)
        setupViews()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing. An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//
//    }
    
    func setupViews(){
        searchBar.placeholder = "Search any words here"
        searchBar.tintColor = .systemRed
        searchBar.searchTextField.borderStyle = .line
        testTextLabel.numberOfLines = 0
        testTextLabel.text = "pi pi po po pu pu pa pa"
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.addArrangedSubview(searchBar)
        mainStack.addArrangedSubview(testTextLabel)
        
        addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
}
