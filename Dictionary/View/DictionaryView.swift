//
//  DictionaryView.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class DictionaryView: UIView {
    
    let searchBar = UISearchBar()
    let testTextLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
//        backgroundColor = .black
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
