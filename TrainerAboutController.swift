//
//  TrainerAboutController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 20/03/17.
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
class TrainerAboutController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,FloatRatingViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    var myLocations: [CLLocation] = []
    fileprivate let reuseIdentifier = "Customcell"
    //fileprivate let reuseIdentifier = "Customcell"
   
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
    @IBOutlet var Client_scorllview: UIScrollView!
    @IBOutlet var Rating_view: FloatRatingView!
    @IBOutlet var Profile_image: UIImageView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ReadyViewCustomize()
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.JsonForFetch()
       
               // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func ReadyViewCustomize(){
        self.Video_backgroundView.isHidden=true
        Profile_image.layoutIfNeeded()
        Profile_image.layer.borderWidth = 1
        Profile_image.layer.masksToBounds = true
        Profile_image.layer.borderColor = UIColor.white.cgColor
        Profile_image.layer.cornerRadius = Profile_image.frame.height/2
        Profile_image.clipsToBounds = true
               
        self.Rating_view.emptyImage = UIImage(named: "whitestar.png")
        self.Rating_view.fullImage = UIImage(named: "orengestar.png")
        // Optional params whitestar.png
        self.Rating_view.delegate = self
        self.Rating_view.contentMode = UIViewContentMode.scaleAspectFit
        self.Rating_view.maxRating = 5
        self.Rating_view.minRating = 1
        self.Rating_view.rating = 2.5
        self.Rating_view.editable = false
        self.Rating_view.halfRatings = true
        self.Rating_view.floatRatings = false
        self.Image_lbl.isHidden=true
        self.Video_lbl.isHidden=true
      
        
     //   self.ViewCoordinate()
    }
    
    func adjustContentSize(tv: UITextView){
        let deadSpace = tv.bounds.size.height - tv.contentSize.height
        let inset = max(0, deadSpace/2.0)
        tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right)
    }
    // MARK : View Coorditaion Function
    
    
        // Function MapView Delegate
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("user location",myLocations)
       
        manager.stopUpdatingLocation()
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
            Client_scorllview.contentSize = CGSize.init(width: self.view.frame.size.width, height: Client_scorllview.frame.size.height+300)
        }
        
    }
    
    
    // Json fetch++++++++++++++++++********************************
    
    func JsonForFetch()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        var poststring:String?
        
        let parameters = ["trainer_id": User_id,"latitude": currentLocation.coordinate.latitude,"longitude": currentLocation.coordinate.longitude] as [String : Any]
        
        print("params",parameters)
        
        let Url:String=Constants.Base_url+"trainerProfile"
        
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
                            
//                            self.Skill_textview.textAlignment = NSTextAlignment.center
//                            //self.liability_txt.textAlignment = NSTextAlignment.center
//                           // self.Wheel_chair_textview.textAlignment = NSTextAlignment.center
//                            self.About_txt.textAlignment = NSTextAlignment.center
//                            self.other_txt.textAlignment = NSTextAlignment.center
//                            self.adjustContentSize(tv: self.Skill_textview)
//                            //self.adjustContentSize(tv: self.liability_txt)
//                           // self.adjustContentSize(tv: self.Wheel_chair_textview)
//                            self.adjustContentSize(tv: self.About_txt)
//                            self.adjustContentSize(tv: self.other_txt)
//                            self.Skill_textview.layoutIfNeeded()
//                            self.liability_txt.layoutIfNeeded()
//                            self.Wheel_chair_textview.layoutIfNeeded()
//                            self.About_txt.layoutIfNeeded()
//                            self.other_txt.layoutIfNeeded()
                             let url:String=((response.result.value as AnyObject).value(forKey: "profile_image") as? String)!
                            Alamofire.request(url).responseImage { response in
                                debugPrint(response)
                                
                                
                                debugPrint(response.result)
                                
                                if let image = response.result.value {
                                    print("image downloaded: \(image)")
                                    self.Profile_image.image=image
                                }
                            }
                            self.arrCertificateSkill=(response.result.value as AnyObject).value(forKey: "Certificate") as! [[String:AnyObject]]
                            //self.arrSelectedSkill=(response.result.value as! String).value(forKey: "skill") as! String
                            print("certificateSkill",self.arrCertificateSkill)
                            self.Certificate_tableview.reloadData()
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
        return arrCertificateSkill.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       
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
            Video_backgroundView.isHidden=false
            self.SelectedImageview.isHidden=false
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
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
    }
    
    
    @IBAction func DidTabBookNowBtn(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "BookNowViewController") as! BookNowViewController
        self.navigationController?.pushViewController(vc, animated: true);
        
        
        /* let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientHomeController") as! ClientHomeController
         self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
   
    @IBAction func DidTabDrawerBtn(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
  
    
    
   
    @IBAction func DidTabCommentBtn(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    @IBAction func DidTabSchduleBtn(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    

    @IBAction func DidTabEditBtn(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TrainerCreateController") as! TrainerCreateController
        vc.TrainerEdit="yes"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func DidTabVideoCrossBtn(_ sender: Any) {
        self.Video_backgroundView.isHidden=true
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
