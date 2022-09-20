//
//  tableViewCell.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/4/21.
//

import UIKit

class tableViewCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        cellView.backgroundColor = .darkGray
        
    }
    @IBOutlet weak var bankImage: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var checkBox: UIImageView!
    
    @IBOutlet weak var cellView: UIView!
    
    var image:UIImage!
    var selectedBgColor:UIColor!
    var selectedCheckboxTintColor: UIColor!
    var selectedBankNameTextColor: UIColor!
    var selectedFeeTextColor: UIColor!
    var unselectedBankNameColor: UIColor!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bankImage.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if(selected==false ){
            checkBox.image = UIImage(named: "defaultcheckbox", in: Bundle(for: type(of: self)),compatibleWith: nil)
        checkBox.tintColor = UIColor.gray.withAlphaComponent(0.5)
            cellView.backgroundColor = .clear
            bankName.textColor = unselectedBankNameColor
            totalPrice.textColor = unselectedBankNameColor
        }
        else {
            cellView.backgroundColor = selectedBgColor
            checkBox.image = image
            checkBox.tintColor = selectedCheckboxTintColor
            bankName.textColor = selectedBankNameTextColor
            totalPrice.textColor = selectedFeeTextColor
        }
        
//         Configure the view for the selected state
    }
    
    
}
