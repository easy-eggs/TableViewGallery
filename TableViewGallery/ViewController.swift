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


struct dataObject {
    
    var imageUrl: String = ""
    
    init(imageURL: String) {
        self.imageUrl = imageURL
    }
}


class ViewController: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var tableView: UITableView!

    var dataList:[dataObject] = []
    
    //API
    let client_id: String = "67d693d0a037578f6cfb5f293b30ea755088356f35cc92f3b065093e61086a6c"
    //Random photos per request
    let count: Int = 6
    let apiURL = "https://api.unsplash.com/photos/random"

    //Pagination
    let maxJsonList = 29 // local json file

    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImagesFromJson(offset: count)
        //loadImagesFromLocalJson()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

    // MARK: - Paginations and UIScrollViewDelegate
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 12.0 {
            
            loadImagesFromJson(offset: 6)
            print("Data list size: \(dataList.count)")
        }
    }
    
   // MARK: - Load data

    //Load images links from local json file (for test)
    func loadImagesFromLocalJson(offset: Int) {
        
        let url = Bundle.main.url(forResource: "dataJson", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSON(data: jsonData)
            
            for i in 0 ..< offset {
                
                if let imageUrl = json[i]["urls"]["small"].string {
                    
                    let data_obj = dataObject(imageURL: imageUrl)
                    self.dataList.append(data_obj)
                }
            }
        }
        catch {
            print(error)
      
        }
    }
    
     //Load images links from server API
    func loadImagesFromJson(offset: Int) {
        
        if Connectivity.isConnectedToInternet() {

            Alamofire.request(URL(string: apiURL)!, method: .get, parameters:["client_id": self.client_id, "count": String(count)]).validate().responseJSON { (response) in
                
                let swiftyJson = JSON(response.result.value!)
                print(swiftyJson)
                for i in 0 ..< offset {
                    
                    if let imageUrl = swiftyJson[i]["urls"]["small"].string {
                        
                        let data_obj = dataObject(imageURL: imageUrl)
                        self.dataList.append(data_obj)
                    }
                }
                DispatchQueue.main.async {
                    self.refreshTable()
                }
            }
            
        } else {            
            print("no internet")
            let alert = UIAlertController(title: "Error", message: "No internet connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

// MARK: - Extensions

extension ViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath as IndexPath) as! ImageCell
    
        let item = dataList[indexPath.row].imageUrl
        
        cell.configure(for: item)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dataList.count)
        return dataList.count
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


