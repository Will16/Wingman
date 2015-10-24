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
        
   
        springScaleFrom(genderLabel, x: 200, y: 200, scaleX: 0.5, scaleY: 0.5)
        
        springScaleFrom(usernameLabel, x: 200, y: 200, scaleX: 0.5, scaleY: 0.5)
        springScaleFrom(clubOrBarLabel, x: 200, y: 200, scaleX: 0.5, scaleY: 0.5)
        springScaleFrom(timeLabel, x: 200, y: 200, scaleX: 0.5, scaleY: 0.5)
        
        springScaleFrom(userImage, x: -100, y: 200, scaleX: 0.5, scaleY: 0.5)
  
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
