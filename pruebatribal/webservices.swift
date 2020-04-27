//
//  webservices.swift
//  pruebatribal
//
//  Created by Antonio Torres on 24/04/20.
//  Copyright © 2020 Antonio Torres. All rights reserved.
//

import UIKit

class webservices: NSObject {
    
    override init() {
        
    }
    
    public func callphotos(page:NSInteger, result: @escaping (NSMutableArray) -> ()) {
        
        let url = URL(string:"https://api.unsplash.com/photos?client_id=tPMEDwhhMVTk0W6NiMvdHhAb1zmRUNd_MVQLcrGzBPQ&page=\(page)")
        
        self.taskservice(url: url!) { (respuesta) in
            result(respuesta as! NSMutableArray)
        }
        
    }
    
    public func photoinfo(idphoto:String, result: @escaping (NSMutableDictionary) -> ()){
        
        let url = URL(string: "https://api.unsplash.com/photos/\(idphoto)?client_id=tPMEDwhhMVTk0W6NiMvdHhAb1zmRUNd_MVQLcrGzBPQ")
        
        self.taskservice(url: url!) { (respuesta) in
            result(respuesta as! NSMutableDictionary)
        }
        
    }
    
    public func userinfo(iduser:String, result: @escaping (NSMutableDictionary) -> ()){
        
        let url = URL(string: "https://api.unsplash.com/users/\(iduser)?client_id=tPMEDwhhMVTk0W6NiMvdHhAb1zmRUNd_MVQLcrGzBPQ")
        
        self.taskservice(url: url!) { (respuesta) in
            result(respuesta as! NSMutableDictionary)
        }
        
        
    }
    
    public func usercollections(iduser:String, result: @escaping (NSMutableArray) -> ()){
        
        let url = URL(string: "https://api.unsplash.com/users/\(iduser)/collections?client_id=tPMEDwhhMVTk0W6NiMvdHhAb1zmRUNd_MVQLcrGzBPQ")
        
        self.taskservice(url: url!) { (respuesta) in
            result(respuesta as! NSMutableArray)
        }
        
    }
    
    
    public func taskservice(url:URL, result: @escaping (Any) -> ()) {
        

        
        let task = URLSession.shared.dataTask(with: url){(datos,respuesta, error ) in
            if error != nil {
                print(error!)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    result(json)
                }catch{
                     
                }
            }
            
        }
        
        task.resume()
    }
 

}
