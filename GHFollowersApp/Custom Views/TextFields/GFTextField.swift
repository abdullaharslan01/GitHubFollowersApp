//
//  GFTextField.swift
//  GHFollowersApp
//
//  Created by abdullah on 5.05.2024.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        backgroundColor = .tertiarySystemBackground
        font = UIFont.preferredFont(forTextStyle: .title2)
        
        // minimum 12 olacak şekilde içeresine sığacak şekilde küçültme yapar.
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        autocorrectionType = .no
        placeholder = "Enter a username"
        
        
        keyboardType = .default
        
        returnKeyType = .go
        
    }
    
    
  
    
    
}
