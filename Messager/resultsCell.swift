//
//  resultsCell.swift
//  Messager
//
//  Created by Mario  on 11/30/15.
//  Copyright © 2015 BBG. All rights reserved.
//

import UIKit

class resultsCell: UITableViewCell {
    
    
    @IBOutlet weak var profileimg: UIImageView!
    
    @IBOutlet weak var profileNameLbl: UILabel!
    
    @IBOutlet weak var usernameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let theWidth = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, theWidth, 120)
        
        profileimg.center = CGPointMake(60, 60)
        profileimg.layer.cornerRadius = profileimg.frame.size.width/2
        profileimg.clipsToBounds = true
        profileNameLbl.center = CGPointMake(230, 55)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
