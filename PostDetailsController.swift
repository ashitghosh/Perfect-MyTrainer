//
//  PostDetailsController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 29/03/17.
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
class PostDetailsController: UIViewController {
    var PostDetails:[String:AnyObject] = [:]
    var Feed_id:String = ""
    var FeedFile:String?
    var FeedFileType:String?
    
    @IBOutlet var date_lbl: UILabel!
    @IBOutlet var description_txtview: UITextView!
    @IBOutlet var title_lbl: UILabel!
    @IBOutlet var ImageBackground_view: UIView!
    @IBOutlet var comments_count_lbl: UILabel!
    @IBOutlet var Details_imageview: UIImageView!
    @IBOutlet var Like_lbl: UILabel!
    @IBOutlet var Post_Image_view: UIImageView!
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
       let vc=self.storyboard! .instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
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
       
        if self.FeedFileType=="image"{
        self.ImageBackground_view.isHidden=false
            Alamofire.request(self.FeedFile!).responseImage { response in
                // debugPrint(response)
                
                
                //debugPrint(response.result)
                
                if let image = response.result.value {
                self.Details_imageview.contentMode = .scaleAspectFit
                    self.Details_imageview.image=image
                }
                
            }
 
        }
        else{
           
            let Video_url = NSURL(string: self.FeedFile!)
            let playerVC = MobilePlayerViewController(contentURL: Video_url as! URL)
            playerVC.title = "Video"
            playerVC.activityItems = [Video_url as! URL] // Check the documentation for more information.
            presentMoviePlayerViewControllerAnimated(playerVC)

        }
        
    }
    
    func JsonForFetchForFeedDetail()  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()

        
        let parameters = ["feed_id": Feed_id]
        let Url:String=Constants.Base_url+"trainerFeedDetail"
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
                            self.title_lbl.text=(response.result.value as AnyObject).value(forKey: "feed_title") as? String
                            self.Like_lbl.text=(response.result.value as AnyObject).value(forKey: "total_comment") as? String
                            self.date_lbl.text=(response.result.value as AnyObject).value(forKey: "created") as? String
                            self.comments_count_lbl.text=(response.result.value as AnyObject).value(forKey: "total_comment") as? String
                            self.Like_lbl.text=(response.result.value as AnyObject).value(forKey: "total_likes") as? String
                            self.FeedFileType=(response.result.value as AnyObject).value(forKey: "file_type") as? String
                            
                            if self.FeedFileType=="video"{
                                self.FeedFile = "http://ogmaconceptions.com/demo/my_perfect_trainer/img/video.jpeg"
                            }
                            else{
                                self.FeedFile = ((response.result.value as AnyObject).value(forKey: "feed_file") as? String)!
                            }
                            //  let url:String = ((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "feed_file") as! String
                            
                            Alamofire.request(self.FeedFile!).responseImage { response in
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
