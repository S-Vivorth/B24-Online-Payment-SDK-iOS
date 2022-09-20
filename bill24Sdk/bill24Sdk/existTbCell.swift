//
//  existTbCell.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/10/21.
//

import UIKit

class existTbCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
//        setSelected(false, animated: true)
    }

    @IBOutlet weak var exBankImg: UIImageView!
    @IBOutlet weak var exBankName: UILabel!
    @IBOutlet weak var exBankNumber: UILabel!
    @IBOutlet weak var exCheckBox: UIImageView!
    @IBOutlet weak var exCellView: UIView!
    var image:UIImage!
    var exselectedBgColor:UIColor!
    var exselectedCheckboxTintColor: UIColor!
    var exselectedBankNameTextColor: UIColor!
    var exselectedFeeTextColor: UIColor!
    var exunselectedBankNameColor: UIColor!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        exBankImg.layer.cornerRadius = 5
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(selected==false ){
            exCheckBox.image = UIImage(named: "defaultcheckbox", in: Bundle(for: type(of: self)),compatibleWith: nil)
            exCheckBox.tintColor = UIColor.gray.withAlphaComponent(0.5)
            exCellView.backgroundColor = .clear
            exBankName.textColor = exunselectedBankNameColor
            exBankNumber.textColor = exunselectedBankNameColor
        }
        else{
            exCellView.backgroundColor = exselectedBgColor
            exCheckBox.image = image
            exCheckBox.tintColor = exselectedCheckboxTintColor
            exBankName.textColor = exselectedBankNameTextColor
            exBankNumber.textColor = exselectedFeeTextColor
        }


        
        
        // Configure the view for the selected state
    }
    
}
