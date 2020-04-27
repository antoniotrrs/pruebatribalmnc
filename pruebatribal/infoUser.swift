//
//  infoUser.swift
//  pruebatribal
//
//  Created by Antonio Torres on 25/04/20.
//  Copyright © 2020 Antonio Torres. All rights reserved.
//

import UIKit

class infoUser: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet var imageuser: UIImageView!
    @IBOutlet var nameuser: UILabel!
    @IBOutlet var biouser: UILabel!
    @IBOutlet var btnPortfolio: UIButton!
    @IBOutlet var numPhotos: UILabel!
    @IBOutlet var numCollections: UILabel!
    @IBOutlet var numLikes: UILabel!
    @IBOutlet var locationlbl: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var idUser:String = ""
    var twLink:String = ""
    var igLink:String = ""
    var portLink:String = ""
    
    var arrayCollection = [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = idUser
        
        
        self.btnPortfolio.layer.cornerRadius = 10
        self.imageuser.layer.cornerRadius = 40
        
        let userinfo = webservices()
        userinfo.userinfo(iduser: idUser) { (resultado) in
            print("----USER")
            print(resultado)
            
            
            let objProfile = resultado["profile_image"] as! NSMutableDictionary
            let picurl = objProfile["large"] as! String
            let dataurl =  try? Data(contentsOf: URL(string: picurl)!)
            
            let nameUsr = resultado["name"] as! String
            let bioUser = resultado["bio"] as! String
            
            let objLinks = resultado["links"] as! NSMutableDictionary
            self.portLink = objLinks["portfolio"] as! String
            
            let numphoto = resultado["total_photos"] as! NSNumber
            let numColl = resultado["total_collections"] as! NSNumber
            let numLik = resultado["total_likes"] as! NSNumber
            
            var location:String
            let locc = resultado["location"] as? String
            if locc == nil {
                location = "Ubicación no especificada"
            }else{
                location = locc!
            }
            
            
            let igg = resultado["instagram_username"] as? String
            if igg == nil {
                self.igLink = ""
            }else{
                self.igLink = igg!
            }
            
            
           let twlink = resultado["twitter_username"] as? String
            if twlink == nil {
                self.twLink = ""
            }else{
                self.twLink = twlink!
            }
            
            
            DispatchQueue.main.async {
                
                self.imageuser.image = UIImage(data: dataurl!)
                self.nameuser.text = nameUsr
                self.biouser.text = bioUser
                self.numPhotos.text = numphoto.stringValue
                self.numCollections.text = numColl.stringValue
                self.numLikes.text = numLik.stringValue
                self.locationlbl.text = location.capitalized
            }
            
            
        }
        
        
        userinfo.usercollections(iduser: idUser) { (resultado) in
            
            print("---COLLECTIONS")
            print(resultado)
            
            DispatchQueue.main.async {
                 self.arrayCollection = resultado as! [[String : Any]]
                           self.collectionView.reloadData()
            }
           
            
            
        }
        
    }
    
    @IBAction func portfolioClick(_ sender: Any) {
        
        let urlpot = URL(string: portLink)!
        UIApplication.shared.open(urlpot)
        
    }
    
    @IBAction func twitterClick(_ sender: Any) {
        
        let urltw = URL(string: "https://www.twitter.com/\(twLink)")!
        UIApplication.shared.open(urltw)
        
    }
    
    @IBAction func instaClick(_ sender: Any) {
        
        let urlig = URL(string: "https://www.instagram.com/\(igLink)")!
        UIApplication.shared.open(urlig)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! collectionCell
        
        let objColl = arrayCollection[indexPath.row]
        let coverobj = objColl["cover_photo"] as! NSMutableDictionary
        let urlobj = coverobj["urls"] as! NSMutableDictionary
        let urlimg = urlobj["regular"] as! String
        
        let title = objColl["title"] as! String
        
        let dataimg = try? Data(contentsOf: URL(string: urlimg)!)
        
        cell.coverimage.image = UIImage(data: dataimg!)
        cell.titleColl.text = title.uppercased()
        
        cell.layer.cornerRadius = 20
        
        return cell
        
    }
}

extension infoUser: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: 200, height: 128)
    }
}
