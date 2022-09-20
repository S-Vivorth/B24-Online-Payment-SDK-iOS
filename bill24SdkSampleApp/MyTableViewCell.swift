//
//  MyTableViewCell.swift
//  bill24SdkSampleApp
//
//  Created by San Vivorth on 12/10/21.
//

import UIKit

class MyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        print("modelll: \(models[indexPath.row])")
        cell.configure(with: models[indexPath.row])
        return cell
    }
    static func nib() ->UINib{
        return UINib(nibName: "MyTableViewCell", bundle: Bundle(path: "bill24.bill24SdkSampleApp"))
    }
    func configure(with models:[Model]){
        self.models = models
        collectionView.reloadData()
    }
    @IBOutlet weak var collectionView:UICollectionView!
    var models = [Model]()
    override func awakeFromNib() {
        
        super.awakeFromNib()
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: "MyCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
