//
//  photoCollectionViewCell.swift
//  apr1
//
//  Created by Benson on 2021/4/8.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var detailContentView: UIView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var title: UILabel!
    
    static let cellReuseID: String = "PhotoCollectionViewCellReuseID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
