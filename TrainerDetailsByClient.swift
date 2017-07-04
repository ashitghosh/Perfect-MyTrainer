//
//  TrainerDetailsByClient.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 21/04/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
import MapKit
import CoreLocation
import AVFoundation
import MediaPlayer
import MobilePlayer
import Toast_Swift

class TrainerDetailsByClient: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,FloatRatingViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate{
   
    @IBOutlet var TimelineView: UIView!
    @IBOutlet var Client_scorllview: UIScrollView!
    @IBOutlet var Profile_imageview: UIImageView!
    @IBOutlet var Book_now_lbl: UILabel!
    @IBOutlet var About_lbl: UILabel!
    @IBOutlet var timeline_lbl: UILabel!
    @IBOutlet var Other_skill_view: UIView!
    @IBOutlet var About_view: UIView!
    @IBOutlet var Social_Connection_View: UIView!
    @IBOutlet var Certificate_view: UIView!
    @IBOutlet var Liability_view: UIView!
    @IBOutlet var Wheelchair_view: UIView!
    @IBOutlet var Skills_BackView: UIView!
    @IBOutlet var VideoAndImage_gallery_Backview: UIView!
    @IBOutlet var video_collectionview: UICollectionView!
    @IBOutlet var Certificate_tableview: UITableView!
    @IBOutlet var Galaery_collection: UICollectionView!
    @IBOutlet var Rating_view: FloatRatingView!
    var passDict:[String:Any]=[:]
    var arrFeed = [[String:AnyObject]]()

    @IBOutlet var Avg_rating_llb: UILabel!
    @IBOutlet var About_txt: UITextView!
    
    @IBOutlet var liability_txt: UITextView!
    @IBOutlet var Wheel_chair_textview: UITextView!
    @IBOutlet var Skill_textview: UITextView!
    
    @IBOutlet var other_txt: UITextView!
    var arrCollectionImages = [[String:AnyObject]] ()
    var arrCollectionVideo = [[String:AnyObject]] ()
    var arrCertificateSkill = [[String:AnyObject]]()
    var avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    let invisibleButton = UIButton()
    @IBOutlet var SelectedImageview: UIImageView!
    @IBOutlet var Video_frame_view: UIView!
    @IBOutlet var Video_backgroundView: UIView!
    @IBOutlet var Video_lbl: UILabel!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    @IBOutlet var Image_lbl: UILabel!
    @IBOutlet var Taglbl: UILabel!
    @IBOutlet var Name_lbl: UILabel!
    @IBOutlet var Certificate_lbl: UILabel!
    @IBOutlet var wheel_chair_lbl: UILabel!
    @IBOutlet var liablity_insurence: UILabel!
    @IBOutlet var No_timeline_lbl: UILabel!
    var Trainer_id:String = ""
    var fb_profile:String=""
    var twitter_profile:String=""
    var instagram_profile:String=""
     var trainer_name:String=""

    @IBOutlet var Timeline_tablieview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ReadyViewCustomize()
        self.JsonForFetch()
    }
    func ReadyViewCustomize(){
        self.SelectedImageview.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        self.SelectedImageview.contentMode = .scaleAspectFit
        self.Timeline_tablieview.register(UINib(nibName: "FeedCellTwo", bundle: nil), forCellReuseIdentifier: "FeedCellTwo")
        self.Timeline_tablieview.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")

        self.TimelineView.isHidden=true
        self.Video_backgroundView.isHidden=true
        self.Client_scorllview.isHidden=false
        
        timeline_lbl.isHidden=true
        Profile_imageview.layoutIfNeeded()
        Profile_imageview.layer.borderWidth = 1
        Profile_imageview.layer.masksToBounds = true
        Profile_imageview.layer.borderColor = UIColor.white.cgColor
        Profile_imageview.layer.cornerRadius = Profile_imageview.frame.height/2
        Profile_imageview.clipsToBounds = true
        Book_now_lbl.layoutIfNeeded()
        Book_now_lbl.layer.borderWidth = 1
        Book_now_lbl.layer.masksToBounds = true
        Book_now_lbl.layer.borderColor = UIColor.white.cgColor
        Book_now_lbl.layer.cornerRadius = Book_now_lbl.frame.width/2
        Book_now_lbl.clipsToBounds = true
        
        self.Rating_view.emptyImage = UIImage(named: "whitestar.png")
        self.Rating_view.fullImage = UIImage(named: "orengestar.png")
        // Optional params whitestar.png
        self.Rating_view.delegate = self
        self.Rating_view.contentMode = UIViewContentMode.scaleAspectFit
        self.Rating_view.maxRating = 5
        self.Rating_view.minRating = 1
        
        self.Rating_view.editable = true
        self.Rating_view.halfRatings = true
        self.Rating_view.floatRatings = false
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Client_scorllview.contentOffset.x>0 {
            Client_scorllview.contentOffset.x = 0
        }
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        self.Skill_textview.layoutIfNeeded()
        Client_scorllview.layoutIfNeeded()
        if self.view.frame.size.width==320 {
            Client_scorllview.contentSize = CGSize.init(width: self.view.frame.size.width, height: Client_scorllview.frame.size.height+400)
        }
        else{
            Client_scorllview.contentSize = CGSize.init(width: self.view.frame.size.width, height: Client_scorllview.frame.size.height+450)
        }
        
    }
    
    
    // Json fetch++++++++++++++++++********************************
    
    func JsonForFetch()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        var latitudeText:String=""
        var longitudeText:String=""
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            latitudeText = String(format: "%f", currentLocation.coordinate.latitude)
            longitudeText = String(format: "%f", currentLocation.coordinate.longitude)
            
        }
        
      //  let userDefaults = Foundation.UserDefaults.standard
        //let User_id:String = userDefaults.string(forKey: "user_id")!
        var poststring:String?
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        
        let parameters = ["trainer_id": self.Trainer_id,"latitude": latitudeText,"longitude": longitudeText,"client_id":User_id]
        
        print("params",parameters)
        
        let Url:String=Constants.Client_url+"trainerProfile"
        
        if let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            poststring = String(data: json, encoding: String.Encoding.utf8)!
            // print(poststring)
            if  poststring == String(data: json, encoding: String.Encoding.utf8)! {
                // here `content` is the JSON dictionary containing the String
                print(poststring as AnyObject)
            }
        }
        
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
                            
                            self.arrCollectionImages=(response.result.value as AnyObject).value(forKey: "TrainerImage") as! [[String:AnyObject]]
                            self.arrCollectionVideo=(response.result.value as AnyObject).value(forKey: "TrainerVideo") as! [[String:AnyObject]]
                            if self.arrCollectionVideo.isEmpty==false{
                                self.video_collectionview.isHidden=false
                                self.Video_lbl.isHidden=true
                                self.video_collectionview.reloadData()
                                
                            }
                            else{
                                self.video_collectionview.isHidden=true
                                self.Video_lbl.isHidden=false
                            }
                            
                            if self.arrCollectionImages.isEmpty==false{
                                self.Galaery_collection.reloadData()
                                self.Galaery_collection.isHidden=false
                                self.Image_lbl.isHidden=true
                            }
                            else{
                                self.Galaery_collection.isHidden=true
                                self.Image_lbl.isHidden=false
                            }
                            
                            
                            let liability_insurance:String=((response.result.value as AnyObject).value(forKey: "liability_insurance") as? String)!
                            self.About_txt.text=((response.result.value as AnyObject).value(forKey: "about") as? String)!
                            self.other_txt.text=((response.result.value as AnyObject).value(forKey: "other_skill") as? String)!
                            self.Taglbl.text=((response.result.value as AnyObject).value(forKey: "tagline") as? String)!
                            self.trainer_name=((response.result.value as AnyObject).value(forKey: "name") as? String)!
                            if liability_insurance=="Y"{
                                self.liability_txt.text="Yes"
                            }
                            else{
                                self.liability_txt.text="No"
                            }
                            let WheelChair:String=((response.result.value as AnyObject).value(forKey: "iswheelchair") as? String)!
                            
                            if WheelChair=="Y"{
                                self.Wheel_chair_textview.text="Yes"
                            }
                                
                            else{
                                self.Wheel_chair_textview.text="No"
                            }
                            
                            let Name:String=((response.result.value as AnyObject).value(forKey: "name") as? String)!
                            let Certificate:String=((response.result.value as AnyObject).value(forKey: "skills") as? String)!
                            self.Skill_textview.text=Certificate
                            self.Name_lbl.text=Name
                            self.passDict=["trainer_name":((response.result.value as AnyObject).value(forKey: "name") as? String)!,"profile_url":((response.result.value as AnyObject).value(forKey: "profile_image") as? String)!]
                            print("PassDict=%@",self.passDict)
                            
                                                       let url:String=((response.result.value as AnyObject).value(forKey: "profile_image") as? String)!
                            Alamofire.request(url).responseImage { response in
                                debugPrint(response)
                                
                                
                                debugPrint(response.result)
                                
                                if let image = response.result.value {
                                    print("image downloaded: \(image)")
                                    self.Profile_imageview.image=image
                                }
                            }
                           
                            self.arrCertificateSkill=(response.result.value as AnyObject).value(forKey: "Certificate") as! [[String:AnyObject]]
                            //self.arrSelectedSkill=(response.result.value as! String).value(forKey: "skill") as! String
                            print("certificateSkill",self.arrCertificateSkill)
                            self.Certificate_tableview.reloadData()
                            self.fb_profile=((response.result.value as AnyObject).value(forKey: "fb_profile_link") as? String)!
                            
                            self.twitter_profile=((response.result.value as AnyObject).value(forKey: "twitter_profile_link") as? String)!
                            
                            self.instagram_profile=((response.result.value as AnyObject).value(forKey: "instagram_profile_link") as? String)!
                            self.Rating_view.rating = Float(((response.result.value as AnyObject).value(forKey: "rating") as? NSNumber)!)
                            self.Avg_rating_llb.text="Avg: " + ((response.result.value as AnyObject).value(forKey: "average_rating") as? String)!
                            

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
    
    func GivenRatingByUser(param:[String:Any])  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let url=Constants.Client_url+"giveRating"
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Sign Up= ",response)
                        SVProgressHUD.dismiss()
                        if( response.result.value as AnyObject).value(forKey: "status") as? NSNumber==0{
                            SVProgressHUD.dismiss()
                            
                        }
                            
                        else{
                            
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        SVProgressHUD.dismiss()
                        print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                /*     if let result = response.result.value {
                 let JSON = result as! NSDictionary
                 print("new result",JSON)
                 }*/
                
        }
   
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==Certificate_tableview{
            return arrCertificateSkill.count
        }
        else{
        return arrFeed.count
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if tableView==Timeline_tablieview {
            let file_type = (arrFeed[indexPath.row] as AnyObject).value(forKey: "file_type") as! String
            if file_type=="none"{
                return 278
            }
            else{
                return 447
            }
  
        }
        else{
        return 54
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==Certificate_tableview{
            let cell : CertificateCell! = tableView.dequeueReusableCell(withIdentifier: "CertificateCell") as! CertificateCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            let certificate_name:String = (self.arrCertificateSkill[indexPath.row] as AnyObject).value(forKey: "certificate_name") as! String
            var fullNameArr = certificate_name.components(separatedBy: ",")
            
            let Name = fullNameArr[0] // First
            let Insttitute_name = fullNameArr[1]
            cell.Name_lbl.text=Name as String
            cell.Insitute_name.text=Insttitute_name as String
            return cell
        }
        else{
            let file_type = (arrFeed[indexPath.row] as AnyObject).value(forKey: "file_type") as! String
            print(file_type)
            if file_type=="none"{
                let cell : FeedCell! = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none;
                cell.profle_image.layoutIfNeeded()
                cell.profle_image.CircleImageView(BorderColour: UIColor.black, Radious: 1.0)
                cell.comment_count_lbl.layoutIfNeeded()
                cell.comment_count_lbl.layer.borderWidth = 1
                cell.comment_count_lbl.layer.masksToBounds = true
                cell.comment_count_lbl.layer.borderColor = UIColor.black.cgColor
                cell.comment_count_lbl.layer.cornerRadius = cell.comment_count_lbl.frame.width/2
                cell.comment_count_lbl.clipsToBounds = true
                cell.Comments_btn.tag=indexPath.row
                cell.Comments_btn.addTarget(self,action:#selector(buttonClicked),
                                            for:.touchUpInside)
                cell.like_btn.tag=indexPath.row
                
                cell.like_btn.addTarget(self,action:#selector(ClientLikeBtn),
                                        for:.touchUpInside)
                
                cell.Detail_btn.tag=indexPath.row
                cell.Detail_btn.addTarget(self,action:#selector(buttonClickedDetails),
                                          for:.touchUpInside)
                let  Islike=(arrFeed[indexPath.row] as AnyObject).value(forKey: "is_like") as? NSNumber
                if Islike==0 {
                    cell.like_lbl.text="Like"
                }
                else{
                    cell.like_lbl.text="Unlike"
                    
                }
                cell.name_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "name") as? String
                cell.Date_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "feed_created") as? String
                cell.Description_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "feed_description") as? String
                cell.comment_count_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "total_comments") as? String
                cell.like_count_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "total_likes") as? String
                
                cell.selectionStyle = .none
                let url = (arrFeed[indexPath.row] as AnyObject).value(forKey: "profile_image") as? String
                
                Alamofire.request(url!).responseImage { response in
                    // debugPrint(response)
                    
                    
                    // debugPrint(response.result)
                    
                    if let image = response.result.value {
                        // print("image downloaded: \(image)")
                        cell.profle_image.image=image
                    }
                }
                return cell
            }
            else{
                let cell : FeedCellTwo! = tableView.dequeueReusableCell(withIdentifier: "FeedCellTwo") as! FeedCellTwo
                cell.selectionStyle = UITableViewCellSelectionStyle.none;
                cell.profle_image.layoutIfNeeded()
                cell.profle_image.CircleImageView(BorderColour: UIColor.black, Radious: 1.0)
                cell.comment_count_lbl.layoutIfNeeded()
                cell.comment_count_lbl.layer.borderWidth = 1
                cell.comment_count_lbl.layer.masksToBounds = true
                cell.comment_count_lbl.layer.borderColor = UIColor.black.cgColor
                cell.comment_count_lbl.layer.cornerRadius = cell.comment_count_lbl.frame.width/2
                cell.comment_count_lbl.clipsToBounds = true
                cell.Comments_btn.tag=indexPath.row
                cell.Comments_btn.addTarget(self,action:#selector(buttonClicked),
                                            for:.touchUpInside)
                cell.like_btn.tag=indexPath.row
                
                cell.like_btn.addTarget(self,action:#selector(ClientLikeBtn),
                                        for:.touchUpInside)
                
                cell.Details_btn.tag=indexPath.row
                
                let  Islike=(arrFeed[indexPath.row] as AnyObject).value(forKey: "is_like") as? NSNumber
                if Islike==0 {
                    cell.Like_lbl.text="Like"
                }
                else{
                    cell.Like_lbl.text="Unlike"
                    
                }
                cell.name_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "name") as? String
                cell.Date_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "feed_created") as? String
                cell.Description_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "feed_description") as? String
                cell.comment_count_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "total_comments") as? String
                cell.like_count_lbl.text=(arrFeed[indexPath.row] as AnyObject).value(forKey: "total_likes") as? String
                cell.Details_btn.addTarget(self,action:#selector(buttonClickedDetails),
                                           for:.touchUpInside)
                cell.selectionStyle = .none
                let url = (arrFeed[indexPath.row] as AnyObject).value(forKey: "profile_image") as? String
                
                Alamofire.request(url!).responseImage { response in
                    // debugPrint(response)
                    
                    
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        //print("image downloaded: \(image)")
                        cell.profle_image.image=image
                    }
                }
                
                //video_img.jpg
                //  cell.Feed_imageview.image=UIImage.init(named: "no-img400x500-1.jpg")
                cell.Feed_imageview.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
                cell.Feed_imageview.contentMode = .scaleAspectFill // OR .scaleAspectFill
                cell.Feed_imageview.clipsToBounds = true
                if file_type=="image"{
                    let url = (arrFeed[indexPath.row] as AnyObject).value(forKey: "feed_file") as? String
                    // let url:String = "http://ogmaconceptions.com/demo/my_perfect_trainer/profile_images/1492069041.jpeg"
                    Alamofire.request(url!).responseImage { response in
                        // debugPrint(response)
                        
                        
                        //debugPrint(response.result)
                        
                        if let image = response.result.value {
                            print("image downloaded: \(image)")
                            
                            cell.Feed_imageview.image=image
                        }
                    }
                }
                else{
                    let url = (arrFeed[indexPath.row] as AnyObject).value(forKey: "video_image") as? String
                    //let url:String = "http://ogmaconceptions.com/demo/my_perfect_trainer/profile_images/1492069041.jpeg"
                    Alamofire.request(url!).responseImage { response in
                        //  debugPrint(response)
                        
                        
                        // debugPrint(response.result)
                        
                        if let image = response.result.value {
                            print("image downloaded: \(image)")
                            cell.Feed_imageview.image=image
                            
                        }
                    }
                }
                
                
                return cell
            }

        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
    func buttonClicked(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let feed_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "feed_id") as! String
        let vc = self.storyboard? .instantiateViewController(withIdentifier: "ClientFeedCommentsView") as! ClientFeedCommentsView
        vc.FeedId=feed_id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func buttonClickedDetails(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let feed_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "feed_id") as! String
        let vc = self.storyboard? .instantiateViewController(withIdentifier: "ClientFeedDetailsView") as! ClientFeedDetailsView
        vc.Feed_id=feed_id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func ClientLikeBtn(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let feed_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "feed_id") as! String
        // let Trainer_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "trainer_id") as! String
        self.JsonForLike(feed_id: feed_id, trainer_id: "")
        
    }
    
    func CommentButtonClicked(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let feed_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "feed_id") as! String
        let vc = self.storyboard? .instantiateViewController(withIdentifier: "ClientFeedCommentsView") as! ClientFeedCommentsView
        vc.FeedId=feed_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func JsonForLike(feed_id:String,trainer_id:String)  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        var poststring:String?
        
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        let parameters = ["feed_id": feed_id,"trainer_id": trainer_id,"client_id":User_id]
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
                          self.JsonForFetchForTrainerFeed()
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
    
    func JsonForFetchForTrainerFeed()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        var poststring:String?
        var latitudeText:String=""
        var longitudeText:String=""
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            latitudeText = String(format: "%f", currentLocation.coordinate.latitude)
            longitudeText = String(format: "%f", currentLocation.coordinate.longitude)
        }
        
        print(latitudeText,longitudeText)
        
        let parameters = ["latitude": latitudeText,"longitude": longitudeText,"client_id": User_id,"trainer_id": Trainer_id]
        let Url:String=Constants.Client_url+"trainerOwnFeed"
        
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
                            self.arrFeed=(response.result.value as AnyObject).value(forKey: "TrainerFeed") as! [[String:AnyObject]]
                            print("feed list",self.arrFeed)
                            print(self.arrFeed.count)
                            self.Timeline_tablieview.reloadData()
                            self.No_timeline_lbl.isHidden=true
                            self.Timeline_tablieview.isHidden=false

                        }
                            
                        else{
                            self.No_timeline_lbl.isHidden=false
                            self.No_timeline_lbl.text="No FeedList Available"
                            self.Timeline_tablieview.isHidden=true
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.dismiss()
                    }
                }
        }
        
    }

    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if collectionView==video_collectionview {
            return arrCollectionVideo.count
        }
        else{
            return arrCollectionImages.count;
        }
        
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView==video_collectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
            cell.layer.cornerRadius=10
            let Url:String = ((self.arrCollectionVideo[indexPath.row] as AnyObject).value(forKey: "video_image") as? String)!
            Alamofire.request(Url).responseImage { response in
                //  debugPrint(response)
                //debugPrint(response.result)
                
                if let image = response.result.value {
                    cell.Video_ImageView.image=image
                    
                }
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gallerycell", for: indexPath)as! GalleryCell
            cell.layer.cornerRadius=10
            let Url:String = ((self.arrCollectionImages[indexPath.row] as AnyObject).value(forKey: "trainer_images") as? String)!
            
            Alamofire.request(Url).responseImage { response in
                //  debugPrint(response)
                //debugPrint(response.result)
                
                if let image = response.result.value {
                    cell.gallery_ImageView.image=image
                    
                }
            }
            
            return cell
        }
        
        
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView==video_collectionview {
            //   Video_backgroundView.isHidden=false
            //  self.SelectedImageview.isHidden=true
            let url:String = (self.arrCollectionVideo[indexPath.row] as AnyObject).value(forKey: "video") as! String
            let Video_url = NSURL(string: url)
            let playerVC = MobilePlayerViewController(contentURL: Video_url as! URL)
            playerVC.title = "Video"
            playerVC.activityItems = [Video_url as! URL] // Check the documentation for more information.
            presentMoviePlayerViewControllerAnimated(playerVC)
        }
        if collectionView==Galaery_collection {
            self.TimelineView.isHidden=true
            self.Video_backgroundView.isHidden=false
            self.Client_scorllview.isHidden=true

            Video_backgroundView.isHidden=false
            self.SelectedImageview.isHidden=false
            self.SelectedImageview.image = UIImage.gif(name: "new_loader")
            let url:String = (self.arrCollectionImages[indexPath.row] as AnyObject).value(forKey: "trainer_images") as! String
            Alamofire.request(url).responseImage { response in
                //  debugPrint(response)
                //debugPrint(response.result)
                
                if let image = response.result.value {
                    self.SelectedImageview.image=image
                    
                }
            }
            
        }
        
        
    }
    
    
    
    func invisibleButtonTapped(sender: UIButton) {
        let playerIsPlaying = avPlayer.rate > 0
        if playerIsPlaying {
            avPlayer.pause()
        } else {
            avPlayer.play()
        }
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        
        print("Float Rating",rating)
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        let param=["trainer_id":self.Trainer_id,"client_id":User_id,"rating":rating] as [String : Any]
        print("Param",param)
        self.GivenRatingByUser(param: param)
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
       print(" Did Update Float Rating",rating)
    }
    
    
    @IBAction func DidTabBookNowBtn(_ sender: Any) {
       let vc = self.storyboard! .instantiateViewController(withIdentifier: "BookNowViewController") as! BookNowViewController
        vc.trainer_id=self.Trainer_id
        vc.PassParameter=self.passDict
        vc.trainer_name=self.trainer_name
       self.navigationController?.pushViewController(vc, animated: true);
        
        
        /* let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientHomeController") as! ClientHomeController
         self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
    
   
    
    @IBAction func DidTabDrawerBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
      /*  if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }*/
        
        
    }
    
    @IBAction func DidTabTimelineBtn(_ sender: Any) {
        timeline_lbl.isHidden=false
         About_lbl.isHidden=true
        self.TimelineView.isHidden=false
        self.Video_backgroundView.isHidden=true
        self.Client_scorllview.isHidden=true
        self.JsonForFetchForTrainerFeed()

    }
    
    @IBAction func DidTabAboutBtn(_ sender: Any) {
        timeline_lbl.isHidden=true
        About_lbl.isHidden=false
        self.TimelineView.isHidden=true
        self.Video_backgroundView.isHidden=true
        self.Client_scorllview.isHidden=false
        self.Client_scorllview.scrollToTopNew()

    }
    

    @IBAction func DidTabImageHideview(_ sender: Any) {
        self.TimelineView.isHidden=true
        self.Video_backgroundView.isHidden=true
        self.Client_scorllview.isHidden=false

    }
    

    @IBAction func DidTabFacebookBtn(_ sender: Any) {
        if self.fb_profile==""{
         self.view.makeToast("Dont have any facebook profile", duration: 3.0, position: .bottom)
        }
        else{
            UIApplication.shared.open(URL(string: self.fb_profile)!, options: [:], completionHandler: nil)

        }
        
       
        
    }
    
    @IBAction func DidTabTwitterBtn(_ sender: Any) {
        if self.twitter_profile==""{
            self.view.makeToast("Dont have any twitter profile", duration: 3.0, position: .bottom)

        }
        else{
            UIApplication.shared.open(URL(string: self.twitter_profile)!, options: [:], completionHandler: nil)

        }
    }
    @IBAction func DidTabInstagramBtn(_ sender: Any) {
        if self.instagram_profile==""{
            self.view.makeToast("Dont have any instagram profile", duration: 3.0, position: .bottom)

        }
        else {
            UIApplication.shared.open(URL(string: self.instagram_profile)!, options: [:], completionHandler: nil)

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
