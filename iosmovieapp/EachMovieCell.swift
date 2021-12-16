//
//  EachMovieCell.swift
//  iosmovieapp
//
//  Created by Greg Garman on 12/15/21.
//

import UIKit


class EachMovieCell: UITableViewCell {
    
    
    @IBOutlet weak var ivMovieImage: UIImageView!
    
    @IBOutlet weak var lblMovieTitle: UILabel!
    
    @IBOutlet weak var lblMovieDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
