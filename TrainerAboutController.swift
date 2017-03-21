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
class TrainerAboutController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,FloatRatingViewDelegate,UITextFieldDelegate{
    fileprivate let reuseIdentifier = "Customcell"
    //fileprivate let reuseIdentifier = "Customcell"
    @IBOutlet var video_collectionview: UICollectionView!
    @IBOutlet var Certificate_tableview: UITableView!
    @IBOutlet var Galaery_collection: UICollectionView!
    @IBOutlet var Client_scorllview: UIScrollView!
    @IBOutlet var Rating_view: FloatRatingView!
    @IBOutlet var Profile_image: UIImageView!
    var arrCollectionImages = [[String:AnyObject]] ()
    var arrCollectionVideo = [[String:AnyObject]] ()
    var arrCertificateSkill = [[String:AnyObject]]()

    @IBOutlet var Name_lbl: UILabel!
    @IBOutlet var Certificate_lbl: UILabel!
    @IBOutlet var wheel_chair_lbl: UILabel!
    @IBOutlet var liablity_insurence: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ReadyViewCustomize()
      self.JsonForFetch()


        // Do any additional setup after loading the view.
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
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Client_scorllview.contentOffset.x>0 {
            Client_scorllview.contentOffset.x = 0
        }
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        Client_scorllview.layoutIfNeeded()
        if self.view.frame.size.width==320 {
            Client_scorllview.contentSize = CGSize.init(width: self.view.frame.size.width, height: Client_scorllview.frame.size.height+150)
        }
        else{
            Client_scorllview.contentSize = CGSize.init(width: self.view.frame.size.width, height: Client_scorllview.frame.size.height+100)
        }
        
    }
    
    
    // Json fetch++++++++++++++++++********************************
    
    func JsonForFetch()  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        var poststring:String?
        
        let parameters = ["trainer_id": User_id]
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
                                self.video_collectionview.reloadData()
                            }
                            
                            if self.arrCollectionImages.isEmpty==false{
                                self.Galaery_collection.reloadData()
                            }
                           
                            
                            let liability_insurance:String=((response.result.value as AnyObject).value(forKey: "liability_insurance") as? String)!
                            if liability_insurance=="Y"{
                               self.liablity_insurence.text="Yes"
                            }
                            else{
                                self.liablity_insurence.text="No"
                            }
                            let WheelChair:String=((response.result.value as AnyObject).value(forKey: "iswheelchair") as? String)!
                            
                            if WheelChair=="Y"{
                                self.wheel_chair_lbl.text="Yes"
                            }
                                
                            else{
                                self.wheel_chair_lbl.text="No"
                            }
                            
                             let Name:String=((response.result.value as AnyObject).value(forKey: "name") as? String)!
                            self.Name_lbl.text=Name
                            
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
    
    @IBAction func DidiTabDrawerBtn(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
        
        
    }
    
    
    
    @IBAction func DidTabNotificationBtn(_ sender: Any) {
    }
    
    @IBAction func DidTabAboutBtn(_ sender: Any) {
        
    }
    
    @IBAction func DidTAbTimelineBtn(_ sender: Any) {
        
    }
    @IBAction func DidTabCommentBtn(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    @IBAction func DidTabSchduleBtn(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        self.navigationController?.pushViewController(vc, animated: true);
        
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
