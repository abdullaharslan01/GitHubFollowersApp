//
//  GFTitleLabel.swift
//  GHFollowersApp
//
//  Created by abdullah on 5.05.2024.
//

import UIKit

class GFTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    init(textAligment: NSTextAlignment, fontsize: CGFloat) {
        super.init(frame: .zero)
        
        self.textAlignment = textAligment
        self.font = UIFont.systemFont(ofSize: fontsize, weight: .bold)
        
        configure()

    }
    
    
  private  func configure() {
      textColor                 = .label
      adjustsFontSizeToFitWidth = true
      minimumScaleFactor        = 0.90
      
      // if it doesn't fit ...
      lineBreakMode             = .byTruncatingTail
      
      translatesAutoresizingMaskIntoConstraints = false
    }
    
}
