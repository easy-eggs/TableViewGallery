//
//  ImageCell.swift
//  TableViewGallery
//
//  Created by mrbesford on 10/19/18.
//  Copyright © 2018 mrbesford. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet  var _image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
  
    
    func configure(for url: String) {

        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let placeholder = UIImage(named: "noimage")

        _image.af_setImage( withURL: URL(string: url)!, placeholderImage: placeholder, filter: nil, imageTransition: .crossDissolve(0.2), completion : { response in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
        })
        

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _image.af_cancelImageRequest()
        _image.image = nil
    }

}
