//
//  infoPhoto.swift
//  pruebatribal
//
//  Created by Antonio Torres on 25/04/20.
//  Copyright © 2020 Antonio Torres. All rights reserved.
//

import UIKit

class infoPhoto: UIViewController {
    
    @IBOutlet var imageTop: UIImageView!
    
    @IBOutlet var autorlbl: UILabel!
    @IBOutlet var likelbl: UILabel!
    @IBOutlet var downlbl: UILabel!
    @IBOutlet var sizelbl: UILabel!
    @IBOutlet var descriptlbl: UILabel!
    @IBOutlet var locationlbl: UILabel!
    
    @IBOutlet var btnDownload: UIButton!
    var idphoto:String = ""
    var downloadLink:String = ""
    var idUser:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let infophoto = webservices()
        
        self.btnDownload.layer.cornerRadius = 10
        
        infophoto.photoinfo(idphoto: idphoto) { (result) in
            print("------PHOTO")
            print(result)
            
            let urlobj = result["urls"] as! NSMutableDictionary
            let urlimg = urlobj["small"] as! String
            let dataimg = try? Data(contentsOf: URL(string: urlimg)!)
            let widthpic = result["width"] as! NSNumber
            let heightpic = result["height"] as! NSNumber
            let downloads = result["downloads"] as! NSNumber
            let likes = result["likes"] as! NSNumber
            let descripphoto = result["alt_description"] as! String
            
            let usrobj = result["user"] as! NSMutableDictionary
            let nameusr = usrobj["name"] as! String
            self.idUser = usrobj["username"] as! String
            
            let locaobj = result["location"] as! NSMutableDictionary
            let city = locaobj["city"] as? String
            let contry = locaobj["country"] as? String
            
            let linksobj = result["links"] as! NSMutableDictionary
            self.downloadLink = linksobj["download"] as! String
            
            DispatchQueue.main.async {
                self.imageTop.image = UIImage(data: dataimg!)
                self.descriptlbl.text = descripphoto
                self.sizelbl.text = "\(widthpic.stringValue) X \(heightpic.stringValue) px"
                self.downlbl.text = "\(downloads.stringValue)"
                self.likelbl.text = "\(likes.stringValue)"
                self.autorlbl.text = nameusr
                
                if city == nil {
                    self.locationlbl.text = "Ubicación no especificada"
                }else{
                    self.locationlbl.text = "\(String(city!).capitalized), \(String(contry!).capitalized)"
                }
                
            }
            
            
            
            
        }
    }
    
    @IBAction func downloadbtn(_ sender: UIButton) {
        let urldown = URL(string: downloadLink)!
        UIApplication.shared.open(urldown)
        
    }
    
    @IBAction func showUser(_ sender: Any) {
        
        let view = storyboard?.instantiateViewController(identifier: "infoUser") as! infoUser
        view.idUser = self.idUser
        
        self.navigationController?.pushViewController(view, animated: true)
        
        
        
    }
}
