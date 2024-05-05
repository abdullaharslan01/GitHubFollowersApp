//
//  GFBodyLabel.swift
//  GHFollowersApp
//
//  Created by abdullah on 5.05.2024.
//

import UIKit

class GFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    init(textAligment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAligment
        configure()

    }
    
    
  private  func configure() {
      textColor                 = .secondaryLabel
      font                      = UIFont.preferredFont(forTextStyle: .body)
      adjustsFontSizeToFitWidth = true
      minimumScaleFactor        = 0.75
      
      // if it doesn't fit ...
      lineBreakMode             = .byWordWrapping
      translatesAutoresizingMaskIntoConstraints = false
    }

}
