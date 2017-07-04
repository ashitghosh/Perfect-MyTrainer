//
//  ClientHomeController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 30/01/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AlamofireImage
import MapKit
import CoreLocation

class ClientHomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Notification_lbl: UILabel!
    @IBOutlet var TandemBtn: UIButton!
    @IBOutlet var Small_group_btn: UIButton!
    @IBOutlet var Classes_btn: UIButton!
    @IBOutlet var Training_type_two_view: UIView!
    @IBOutlet var personal_training_btn: UIButton!
    @IBOutlet var Training_type_view: UIView!
    @IBOutlet var Training_type_backview: UIView!
    @IBOutlet var Dropdown_backview: UIView!
    @IBOutlet var Fitness_type_dropdownBtn: UILabel!
    @IBOutlet var Feed_tableview: UITableView!
    var arrFeed = [[String:AnyObject]]()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    var drop: UIDropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        Training_type_backview.isHidden=true;
     // Small_group_btn.setBottomBorder()
      Classes_btn.setBottomBorder()
      personal_training_btn.setBottomBorder()
        self.TandemBtn.setBottomBorder()
      Training_type_view.ViewRoundCorner(Roundview: Training_type_view, radious: 15.0)
        Training_type_two_view.ViewRoundCorner(Roundview: Training_type_two_view, radious: 10.0)
         self.Feed_tableview.register(UINib(nibName: "FeedCellTwo", bundle: nil), forCellReuseIdentifier: "FeedCellTwo")
         self.Feed_tableview.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        self.Notification_lbl.Circlelabel(BorderColour: .clear, Radious: 1.0)
        // Do any additional setup after loading the view.
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("just check")
        //let cell : FeedCell! = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FeedCell
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
        
        cell.profile_linkBtn.tag=indexPath.row
        
        cell.profile_linkBtn.addTarget(self,action:#selector(ProfileLinkAction(sender:)),
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
        
        cell.Profile_link_btn.tag=indexPath.row
        
        cell.Profile_link_btn.addTarget(self,action:#selector(ProfileLinkAction(sender:)),
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
               // let url:String = "http://gulpoli.in/images/0000006.jpeg"
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let file_type = (arrFeed[indexPath.row] as AnyObject).value(forKey: "file_type") as! String
        if file_type=="none"{
        return 278
        }
        else{
        return 447
        }

   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc=self.storyboard!.instantiateViewController(withIdentifier: "ClientAboutController") as! ClientAboutController
//        self.navigationController?.pushViewController(vc, animated: true)
       /* let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientHomeController") as! ClientHomeController
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
       Training_type_backview.isHidden=true;
        self.JsonForFetchForFeed()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // Show the navigation bar on other view controllers
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    

    @IBAction func DidTabCellDetailsBtn(_ sender: Any) {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let feed_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "feed_id") as! String
        let vc = self.storyboard? .instantiateViewController(withIdentifier: "ClientFeedDetailsView") as! ClientFeedDetailsView
        vc.Feed_id=feed_id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func DidTabCellOneDetailsBtn(_ sender: Any) {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let feed_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "feed_id") as! String
        let vc = self.storyboard? .instantiateViewController(withIdentifier: "ClientFeedDetailsView") as! ClientFeedDetailsView
        vc.Feed_id=feed_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func JsonForFetchForFeed()  {
        
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
     //http://gulpoli.in/myapi/api/LogIn/PostLogin
        let parameters = ["latitude": latitudeText,"longitude": longitudeText,"client_id": User_id]
       // let parameters = ["email": "test@gmail.com","pwd": "password"]
        let Url:String=Constants.Client_url+"trainerFeedListByClient"
       // let Url:String="http://gulpoli.in/myapi/api/LogIn/PostLogin"
        
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
                    print( "Json  return for Fetch= ",response)
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
                            self.Feed_tableview.reloadData()
                            let noti_num:NSInteger = NSInteger((response.result.value as AnyObject).value(forKey: "total_unread_notification") as! NSNumber)
                            if noti_num>0{
                            self.Notification_lbl.isHidden=false
                            }
                            else{
                            self.Notification_lbl.isHidden=true
                            }
                            self.Notification_lbl.text=String(describing: ((response.result.value as AnyObject).value(forKey: "total_unread_notification") as! NSNumber))
                           
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
    
    
    func JsonForLike(feed_id:String,trainer_id:String)  {
        
       // SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        //SVProgressHUD.show()
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
                          //  self.JsonForFetchForFeed()
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


    

    @IBAction func DidTabDrawerBtn(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
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
    @IBAction func DidTabTrainingTypeViewHideBtn(_ sender: Any) {
        
        Training_type_backview.isHidden=true;
    }
    @IBAction func DidTabTrainingTypeBtn(_ sender: Any) {
        Training_type_backview.isHidden=false;
    }
    @IBAction func DidTabPersonalTraining(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "ClientTrainingTypeController") as! ClientTrainingTypeController
         vc.TrainingType="Personal Training"
        vc.Search_training_type="individual"
        self.navigationController?.pushViewController(vc, animated: true);
    }

    @IBAction func DidTabClassesBtn(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "ClientTrainingTypeController") as! ClientTrainingTypeController
        vc.TrainingType="Small Group"
         vc.Search_training_type="group"
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    @IBAction func DidTabSmallGrouBtn(_ sender: Any) {
        
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "ClientTrainingTypeController") as! ClientTrainingTypeController
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    
    @IBAction func DidTabTandemBtn(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "ClientTrainingTypeController") as! ClientTrainingTypeController
        vc.TrainingType="Tandem"
        vc.Search_training_type="tandem"
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    
    @IBAction func DidTabCommentsCellBtn(_ sender: Any) {
        
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let feed_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "feed_id") as! String
        let vc = self.storyboard? .instantiateViewController(withIdentifier: "ClientFeedDetailsView") as! ClientFeedDetailsView
        vc.Feed_id=feed_id
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func DidTabCellOneCommentsBtn(_ sender: Any) {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let feed_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "feed_id") as! String
        let vc = self.storyboard? .instantiateViewController(withIdentifier: "ClientFeedCommentsView") as! ClientFeedCommentsView
        vc.FeedId=feed_id
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    func ProfileLinkAction(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let Trainer_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "trainer_id") as! String
        let vc = self.storyboard? .instantiateViewController(withIdentifier: "TrainerDetailsByClient") as! TrainerDetailsByClient
        vc.Trainer_id=Trainer_id
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
         let Is_like=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "is_like") as! NSNumber
        let Total_like=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "total_likes") as! String
        var MyNumber = 0
       
        if let myInteger = Int(Total_like) {
             MyNumber = Int(NSNumber(value:myInteger))
        }      // let Trainer_id=(self.arrFeed[SelectedTag] as AnyObject).value(forKey: "trainer_id") as! String
       self.JsonForLike(feed_id: feed_id, trainer_id: "")
        if self.arrFeed[SelectedTag] is [String:AnyObject] {
            var copyItem = (self.arrFeed[SelectedTag] as [String:AnyObject])
            if Is_like==0 {
              copyItem["is_like"] = 1 as AnyObject?
                MyNumber+=1
                 let myString = String(MyNumber)
            copyItem["total_likes"] = myString as AnyObject?
            }
            else{
                 copyItem["is_like"] = 0 as AnyObject?
                MyNumber-=1
                let myString = String(MyNumber)
                 copyItem["total_likes"] = myString as AnyObject?
                
            }
           
            self.arrFeed[SelectedTag] = (copyItem as AnyObject) as! [String : AnyObject]
        }
        print(self.arrFeed)
        self.Feed_tableview.reloadData()
        
        
        
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
    
    @IBAction func DidTabNotificationBtn(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientNotificationController") as! ClientNotificationController
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

