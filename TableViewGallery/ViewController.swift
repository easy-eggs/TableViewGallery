//
//  ViewController.swift
//  TableViewGallery
//
//  Created by mrbesford on 10/19/18.
//  Copyright © 2018 mrbesford. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage


struct galleryObject {
    
    var imageUrl: String = ""
    
    init(imageURL: String) {
        self.imageUrl = imageURL
    }
}


class ViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!

    var imagesList:[UIImage] = []
    var galleryObjects:[galleryObject] = []
    var imageLoader: ImageCacheLoader = ImageCacheLoader()
    
    //Pagination
    var maxFotoPerScreen: Int = 6
    let maxJsonList = 29 // local json file
    let fromIndexParametr = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImages()

        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func loadImages() {
        
        let url = Bundle.main.url(forResource: "dataJson", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSON(data: jsonData)
            
            for i in 0 ..< maxFotoPerScreen {
                
                if let imageUrl = json[i]["urls"]["small"].string {
                    
                    let data_obj = galleryObject(imageURL: imageUrl)
                    self.galleryObjects.append(data_obj)
                }
            }
            
        }
        catch {
            print(error)
        }
    }

}




extension ViewController: UITableViewDelegate,UITableViewDataSource {


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath as IndexPath) as! ImageCell
        cell.backView.layer.cornerRadius = 8
        
        let item = galleryObjects[indexPath.row].imageUrl
        
        cell.configure(for: item)
    
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(galleryObjects.count)
        return galleryObjects.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func refreshTable(){
        
        if(self.tableView != nil){
            self.tableView.reloadData()
        }
    }
}

// MARK: - Extensions
extension UIImageView {
    
    public func loadImageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        
        if self.image == nil{
            self.image = PlaceHolderImage
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}


