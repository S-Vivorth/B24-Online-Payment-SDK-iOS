//
//  MyCollectionViewCell.swift
//  bill24SdkSampleApp
//
//  Created by San Vivorth on 12/10/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: Bundle(path: "bill24.bill24SdkSampleApp"))
    }
//    var model = []

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView:UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    public func configure(with model:Model){
        self.label.text = model.imageString
        self.label.contentMode = .scaleAspectFit
    }
}
