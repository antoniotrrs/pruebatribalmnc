//
//  galeriaCell.swift
//  pruebatribal
//
//  Created by Antonio Torres on 24/04/20.
//  Copyright © 2020 Antonio Torres. All rights reserved.
//

import UIKit

protocol Favorites {
    func selectphoto(num:NSInteger)
    func selectuser(num:NSInteger)
    
}

class galeriaCell: UICollectionViewCell {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var favoriteStar: UIButton!
    @IBOutlet var usuariotxt: UILabel!
    @IBOutlet var imagenuser: UIImageView!
    @IBOutlet var likestxt: UILabel!
    
    var delegate:Favorites?
    var numPhoto:NSInteger?
    
    
    @IBAction func clickOnFavorite(_ sender: UIButton) {
        delegate?.selectphoto(num: numPhoto!)
    }
    
    @IBAction func selectUser(_ sender: Any) {
        delegate?.selectuser(num: numPhoto!)
    }
    
    
    
}
