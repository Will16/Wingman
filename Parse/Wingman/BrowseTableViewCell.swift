//
//  BrowseTableViewCell.swift
//  Wingman
//
//  Created by William McDuff on 2015-03-05.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class BrowseTableViewCell: UITableViewCell {

    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    

//    @IBOutlet weak var seekingLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var clubOrBarLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
   
        springScaleFrom(genderLabel, 200, 200, 0.5, 0.5)
        
        springScaleFrom(usernameLabel, 200, 200, 0.5, 0.5)
        springScaleFrom(clubOrBarLabel, 200, 200, 0.5, 0.5)
        springScaleFrom(timeLabel, 200, 200, 0.5, 0.5)
        
        springScaleFrom(userImage, -100, 200, 0.5, 0.5)
  
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
