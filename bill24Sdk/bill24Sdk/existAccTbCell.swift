//
//  existAccTbCell.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/10/21.
//

import UIKit

public class existAccTbCell: UITableViewCell {

    @IBOutlet weak var exBankImg: UIImageView!
    @IBOutlet weak var exBankName: UILabel!
    @IBOutlet weak var exBankNo: UILabel!
    @IBOutlet weak var exCheckBox: UIImageView!
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
