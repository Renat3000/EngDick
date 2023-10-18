//
//  DictionaryView.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class DictionaryView: UIView {
    
    let searchBar = {
      let bar = UISearchBar()

        bar.placeholder = "Search any words here"
        bar.tintColor = .systemRed
        bar.searchTextField.borderStyle = .line
//        bar.layer.borderWidth = 1
//        let whiteColor: UIColor = .white
//        bar.layer.borderColor = [[UIColor whiteColor] CGColor];

        return bar
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
//        backgroundColor = .black
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.addArrangedSubview(searchBar())
        
        addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
}
