//
//  checkOutButton.swift
//  bill24Sdk
//
//  Created by San Vivorth on 11/11/21.
//

import UIKit

public class checkOutButton: UIView {
    public var label: UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.text = "Checkout"
        label.textAlignment = .center
        label.textColor = .white
        label.center = center
        return label
    }
    public var label1: UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.text = "Checkout"
        label.textAlignment = .center
        label.textColor = .white
        label.center = center
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 55))
        addSubview(label1)
        addSubview(label)
        clipsToBounds = true
        layer.masksToBounds = false
        label.center = center
        backgroundColor = .systemRed
        layer.cornerRadius = 20
        self.configureView()
    }
    
    private func configureView(){
        let view = self.loadViewFromNib(nibname: "checkOut")
        view.frame = self.bounds
        addSubview(view)
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        label.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }

}
extension UIView{
    func loadViewFromNib(nibname:String) ->UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibname, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
