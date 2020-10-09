//
//  CustomOrderDetailsCell.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 10/4/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit

class CustomOrderDetailsCell: UITableViewCell {
    
    @IBOutlet weak var prod_name:UILabel!
    @IBOutlet weak var ordrPrice:UILabel!
    @IBOutlet weak var prod_quantity:UILabel!
    @IBOutlet weak var prod_image:UIImageView!
    
        
    override func draw(_ rect: CGRect) {
        
        prod_image.layer.cornerRadius = prod_image.frame.width/2
//        prod_image.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        prod_image.layer.borderWidth = 4
        prod_image.layer.shadowOpacity = 0.5
        
        if let view = self.viewWithTag(120){
            
            view.layer.cornerRadius = 8
            view.layer.shadowPath = view.createRectangle()
        }
        
    }
    
    func configureCell(with ordr:orderProducts_Details){
    
        prod_name.text = ordr.prod_name!
        prod_quantity.text = String(ordr.prod_quantity!)
        ordrPrice.text = ordr.prod_price!
        changeCellImage(with: ordr.prod_image!)
//         self.userImageView.image = image.resized_Image(withBounds: self.userImageView.frame.size)
    }
    
    func changeCellImage( with itemImageStr: String) {
        
           let url = URL.init(string: itemImageStr)
           self.prod_image.af_setImage(withURL: url!, placeholderImage: UIImage.init(named: ""), filter: nil,  imageTransition:UIImageView.ImageTransition.crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
       }
    
    
}
