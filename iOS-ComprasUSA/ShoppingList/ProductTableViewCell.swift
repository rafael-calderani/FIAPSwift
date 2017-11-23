//
//  ProductTableViewCell.swift
//  Calderani
//
//  Created by Rafael dos Santos Calderani on 20/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var lbProduct: UILabel!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
