//
//  favController.swift
//  pruebatribal
//
//  Created by Antonio Torres on 24/04/20.
//  Copyright © 2020 Antonio Torres. All rights reserved.
//

import UIKit
import CoreData

class favController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, Favorites {

    var arrayFavs:[NSManagedObject] = []
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleBackground: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Favoritos"
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favoritos")
        
        do {
            arrayFavs = try managedContext.fetch(fetchRequest)
            collectionView.reloadData()
        } catch let error as NSError {
            print(error.userInfo)
        }
        
        if arrayFavs.count == 0 {
            self.titleBackground.isHidden = false
            self.titleBackground.text = "Aún no has seleccionado fotos favoritas"
        }else{
            self.titleBackground.isHidden = true
            self.titleBackground.text = ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayFavs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoris", for: indexPath) as! galeriaCell
        
        let coredataObject = arrayFavs[indexPath.row]
        let dataInfo = coredataObject.value(forKey: "informacion") as! String
        
        
        let data = Data(base64Encoded: dataInfo, options: Data.Base64DecodingOptions(rawValue: 0))!

         print("----favs")
        
        let dictPhoto = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSDictionary
        
        let likesnum = dictPhoto?["likes"] as! NSNumber
        cell.likestxt.text = likesnum.stringValue
        
        let userobj = dictPhoto?["user"] as! [String:Any]
        cell.usuariotxt.text = userobj["name"] as? String
        
        let profileimages = userobj["profile_image"] as! [String:Any]
        let profilemedium = profileimages["medium"] as! String
        
        let dataimage = try? Data(contentsOf: URL(string: profilemedium)!)
        cell.imagenuser.image = UIImage(data:dataimage!)
        cell.imagenuser.layer.cornerRadius = 15
        
        let photourl = dictPhoto?["urls"] as! [String:Any]
        let fullurl = photourl["full"] as! String
        
        let datafull = try? Data(contentsOf: URL(string: fullurl)!)
        cell.image.image = UIImage(data: datafull!)
        
        cell.layer.cornerRadius = 10
        cell.numPhoto = indexPath.row
        cell.delegate = self;
        
        return cell
        
    }
    
    func selectphoto(num: NSInteger) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favoritos")
        
       let result = try! managedContext.fetch(fetchRequest)
        var i = 0;
        
        for object in result {
            if i == num {
                managedContext.delete(object)
            }
            i = i + 1
        }
        
        
        
        do {
            try managedContext.save()
            arrayFavs.remove(at: num)
            collectionView.reloadData()
        } catch let error as NSError {
            print(error.userInfo)
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     let coredataObject = arrayFavs[indexPath.row]
     let dataInfo = coredataObject.value(forKey: "informacion") as! String
     
     
     let data = Data(base64Encoded: dataInfo, options: Data.Base64DecodingOptions(rawValue: 0))!
     
     let dictPhoto = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSDictionary
     
     let idpicture = dictPhoto?["id"] as! String
        
        let view = storyboard?.instantiateViewController(identifier: "infoPhoto") as! infoPhoto
        view.idphoto = idpicture
        
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    
    func selectuser(num: NSInteger) {
        
        let coredataObject = arrayFavs[num]
        let dataInfo = coredataObject.value(forKey: "informacion") as! String
        
        
        let data = Data(base64Encoded: dataInfo, options: Data.Base64DecodingOptions(rawValue: 0))!
        
        let dictPhoto = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSDictionary
        
        let objUser = dictPhoto?["user"] as! NSMutableDictionary
        let iduser = objUser["username"] as! String
           
           let view = storyboard?.instantiateViewController(identifier: "infoUser") as! infoUser
           view.idUser = iduser
           
           self.navigationController?.pushViewController(view, animated: true)
    }

}
