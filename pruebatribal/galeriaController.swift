//
//  galeriaController.swift
//  pruebatribal
//
//  Created by Antonio Torres on 24/04/20.
//  Copyright © 2020 Antonio Torres. All rights reserved.
//

import UIKit
import CoreData

class galeriaController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, Favorites {
    

    @IBOutlet var collectionView: UICollectionView!
    var arrayPhotos = [[String:Any]]()
    let webservice = webservices()
    var numpage = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Galería"
        self.loadPhotos()
        
        // Do any additional setup after loading the view.
    }
    
    
    func loadPhotos(){
        
        webservice.callphotos(page: numpage, result: { (resultado) in
            print(resultado)
            self.arrayPhotos.append(contentsOf: resultado as! [[String:Any]])
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.numpage = self.numpage + 1
            }
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galeria", for: indexPath) as! galeriaCell
        
        let objusr = self.arrayPhotos[indexPath.row]
        let likesnum = objusr["likes"] as! NSNumber
        cell.likestxt.text = likesnum.stringValue
        
        let userobj = objusr["user"] as! [String:Any]
        cell.usuariotxt.text = userobj["name"] as? String
        
        let profileimages = userobj["profile_image"] as! [String:Any]
        let profilemedium = profileimages["medium"] as! String
        
        let dataimage = try? Data(contentsOf: URL(string: profilemedium)!)
        cell.imagenuser.image = UIImage(data:dataimage!)
        cell.imagenuser.layer.cornerRadius = 15
        
        let photourl = objusr["urls"] as! [String:Any]
        let fullurl = photourl["thumb"] as! String
        
        let datafull = try? Data(contentsOf: URL(string: fullurl)!)
        cell.image.image = UIImage(data: datafull!)
        
        cell.layer.cornerRadius = 10
        cell.numPhoto = indexPath.row
        cell.delegate = self;
        
        return cell
    }
    
    func selectphoto(num:NSInteger) {
        
        print("----- seleccionado:")
       
        
        let archivar = try? NSKeyedArchiver.archivedData(withRootObject: arrayPhotos[num], requiringSecureCoding: true);
        
        let str = archivar?.base64EncodedString()
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Favoritos", in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        managedObject.setValue(str, forKey: "informacion")
        do{
            try managedContext.save()
            
        }catch let error as NSError {
            print(error.userInfo)
        }
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentscroll = scrollView.contentOffset.y
        let maxscroll = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxscroll - currentscroll <= -40 {
            self.loadPhotos()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let objPic = arrayPhotos[indexPath.row]
        let idpic = objPic["id"] as! String
        
        let view = storyboard?.instantiateViewController(identifier: "infoPhoto") as! infoPhoto
        view.idphoto = idpic
        
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    
    func selectuser(num:NSInteger) {
        
        let objPic = arrayPhotos[num]
        let userobj = objPic["user"] as! NSMutableDictionary
        
        let userid = userobj["username"] as! String
        
        let view = storyboard?.instantiateViewController(identifier: "infoUser") as! infoUser
        view.idUser = userid
        
        self.navigationController?.pushViewController(view, animated: true)
        
        
        
    }
    


}

extension galeriaController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellwidth = (UIScreen.main.bounds.size.width - 40) / 2
        
        return CGSize(width: cellwidth, height: cellwidth)
    }
}
