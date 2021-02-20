//
//  ViewController.swift
//  Swift5Bokete1
//
//  Created by 山本宰 on 2021/02/11.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos


class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var odaiImageView: UIImageView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization{(status) in
            switch(status){
            case .authorized:break
            case .denied:break
            case .notDetermined:break
            case .restricted:break
            case .limited:
                print("1")
            @unknown default:
                print("1")
            }
        }
        getImages(keyword: "funny")
        
    }
    
    func getImages(keyword:String){
        //API Key 20237469-37efe531a38ef60da6ad63e71
        
        let url = "https://pixabay.com/api/?key=20237469-37efe531a38ef60da6ad63e71&q=\(keyword)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{
            (response) in
            
            switch response.result{
            case .success:
                let json:JSON = JSON(response.data as Any)
                var imageString = json["hits"][self.count]["webformatURL"].string
                
                if imageString == nil{
                    imageString = json["hits"][0]["webformatURL"].string
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed:nil)
                }else{
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed:nil)

                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func nextOdai(_ sender: Any){
        count += 1

        if searchTextField.text == ""{
            getImages(keyword: "funny")
        }
        else{
            getImages(keyword: searchTextField.text!)
        }
    }
    
    
    
    @IBAction func searchAction(_ sender: Any) {
        self.count = 0

        if searchTextField.text == ""{
            getImages(keyword: "funny")
        }
        else{
            getImages(keyword: searchTextField.text!)
        }

    }
    
    @IBAction func next(_ sender: Any) {
        performSegue(withIdentifier: "next", sender:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let shareVC = segue.destination as? ShareViewController
        shareVC?.commentString = commentTextView.text
        shareVC?.resultImage = odaiImageView.image!
    }
    
}

