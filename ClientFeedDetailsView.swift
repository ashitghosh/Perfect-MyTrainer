//
//  ClientFeedDetailsView.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 14/04/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AlamofireImage
import AVFoundation
import MediaPlayer
import MobilePlayer
import QuickLook
class ClientFeedDetailsView: UIViewController {
    
    
    @IBOutlet var Like_count_lbl: UILabel!
    
    var PostDetails:[String:AnyObject] = [:]
    var Feed_id:String = ""
    var Feed_File:String = ""
    var Feed_Type:String = ""
    @IBOutlet var date_lbl: UILabel!
    @IBOutlet var Name_lbl: UILabel!
    @IBOutlet var description_txtview: UITextView!
    @IBOutlet var title_lbl: UILabel!
    @IBOutlet var ImageBackground_view: UIView!
    @IBOutlet var comments_count_lbl: UILabel!
    @IBOutlet var Details_imageview: UIImageView!
    @IBOutlet var Like_lbl: UILabel!
    @IBOutlet var Post_Image_view: UIImageView!
    @IBOutlet var Profile_image: UIImageView!
    @IBOutlet var Created_date_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Post details",PostDetails)
        
       // Feed_id=(((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "feed_id") as? String)!
        self.ImageBackground_view.isHidden=true
        // self.JsonForFetchForFeedDetail()
        comments_count_lbl.layoutIfNeeded()
        comments_count_lbl.layer.cornerRadius =
            comments_count_lbl.frame.size.height / 2
        comments_count_lbl.layer.borderWidth = 1.0
        comments_count_lbl.layer.backgroundColor = UIColor.clear.cgColor
        comments_count_lbl.layer.borderColor = UIColor.black.cgColor
        comments_count_lbl.layer.masksToBounds = true
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.JsonForFetchForFeedDetail()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidTabCommentBtn(_ sender: Any) {
        let vc=self.storyboard! .instantiateViewController(withIdentifier: "ClientFeedCommentsView") as! ClientFeedCommentsView
        vc.FeedId=Feed_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func DidTabBackBtn(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    @IBAction func DetailsImageviewHideBtn(_ sender: Any) {
        self.ImageBackground_view.isHidden=true
    }
    
    @IBAction func DidTabImageShowBtn(_ sender: Any) {
      //  let file_type=((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "file_type") as? String
       // let url:String?
        //url = (((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "feed_file") as? String)!
        if self.Feed_Type=="image"{
            self.ImageBackground_view.isHidden=false
            Alamofire.request(self.Feed_File).responseImage { response in
                // debugPrint(response)
                
                
                //debugPrint(response.result)
                
                if let image = response.result.value {
                    self.Details_imageview.contentMode = .scaleAspectFit
                    self.Details_imageview.image=image
                }
                
            }
            
        }
        else{
            
            let Video_url = NSURL(string: self.Feed_File)
            let playerVC = MobilePlayerViewController(contentURL: Video_url as! URL)
            playerVC.title = "Video"
            playerVC.activityItems = [Video_url as! URL] // Check the documentation for more information.
            presentMoviePlayerViewControllerAnimated(playerVC)
            
        }
        
    }
    
    func JsonForLike(feed_id:String)  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        var poststring:String?
        
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        let parameters = ["feed_id": feed_id,"client_id":User_id]
        let Url:String=Constants.Base_url+"likeFeed"
        
        if let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            poststring = String(data: json, encoding: String.Encoding.utf8)!
            // print(poststring)
            if  poststring == String(data: json, encoding: String.Encoding.utf8)! {
                // here `content` is the JSON dictionary containing the String
                print(poststring as AnyObject)
            }
        }
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        Alamofire.request(Url, method:.post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Fetch= ",response)
                        SVProgressHUD.dismiss()
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0  {
                            SVProgressHUD.dismiss()
                            let message=(response.result.value as AnyObject).value(forKey: "message") as? String
                            
                            if message=="Like successfull"{
                            self.Like_lbl.text="Unlike"
                            }
                            else{
                            self.Like_lbl.text="Like"
                            }
                            self.JsonForFetchForFeedDetail()
                        }
                            
                        else{
                            
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.dismiss()
                    }
                }
        }
        
    }

    
    func JsonForFetchForFeedDetail()  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        let parameters = ["feed_id": Feed_id,"client_id":User_id]
        let Url:String=Constants.Client_url+"trainerFeedDetail"
        var poststring:String?
        
        if let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            poststring = String(data: json, encoding: String.Encoding.utf8)!
            // print(poststring)
            if  poststring == String(data: json, encoding: String.Encoding.utf8)! {
                // here `content` is the JSON dictionary containing the String
                print(poststring as AnyObject)
            }
        }
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        Alamofire.request(Url, method:.post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Fetch= ",response)
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0  {
                            SVProgressHUD.dismiss()
                            
                            self.description_txtview.text=(response.result.value as AnyObject).value(forKey: "feed_description") as? String
                            print(self.description_txtview.text)
                            self.Profile_image.layoutIfNeeded()
                            let  Islike=(response.result.value as AnyObject).value(forKey: "is_like") as? NSNumber
                            if Islike==0 {
                               self.Like_lbl.text="Like"
                            }
                            else{
                                self.Like_lbl .text="Unlike"
                                
                            }
                            self.Profile_image.CircleImageView(BorderColour: UIColor.black, Radious: 1.0)
                            self.title_lbl.text=(response.result.value as AnyObject).value(forKey: "feed_title") as? String
                            self.Name_lbl.text=(response.result.value as AnyObject).value(forKey: "name") as? String
                            self.Like_count_lbl.text=(response.result.value as AnyObject).value(forKey: "total_likes") as? String
                            self.date_lbl.text=(response.result.value as AnyObject).value(forKey: "created") as? String
                            self.comments_count_lbl.text=(response.result.value as AnyObject).value(forKey: "total_comment") as? String
                           // self.Like_lbl.text=(response.result.value as AnyObject).value(forKey: "total_likes") as? String
                             self.Feed_Type=((response.result.value as AnyObject).value(forKey: "file_type") as? String)!
                            
                            let Profile_url:String = ((response.result.value as AnyObject).value(forKey: "trainer_images") as? String)!
                            Alamofire.request(Profile_url).responseImage { response in
                                // debugPrint(response)
                                
                                
                                //debugPrint(response.result)
                                
                                if let image = response.result.value {
                                    self.Profile_image.image=image
                                    
                                }
                                
                            }
                            
                            if self.Feed_Type=="video"{
                                self.Feed_File = "http://ogmaconceptions.com/demo/my_perfect_trainer/img/video.jpeg"
                            }
                            else{
                                self.Feed_File = ((response.result.value as AnyObject).value(forKey: "feed_file") as? String)!
                            }
                            //  let url:String = ((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "feed_file") as! String
                            
                            Alamofire.request(self.Feed_File).responseImage { response in
                                // debugPrint(response)
                                
                                
                                //debugPrint(response.result)
                                
                                if let image = response.result.value {
                                    self.Post_Image_view.image=image
                                    
                                }
                                
                            }
                            
                            
                        }
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 1  {
                            SVProgressHUD.dismiss()
                            
                            
                        }
                        else{
                            
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.dismiss()
                    }
                }
        }
        
}

    @IBAction func DidTabLikeBtn(_ sender: Any) {
        self.JsonForLike(feed_id: Feed_id)
    }
}
