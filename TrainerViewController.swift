//
//  TrainerViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 14/02/17.
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

class TrainerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Time_lbl: UILabel!
    @IBOutlet var about_lbl: UILabel!
    @IBOutlet var Profile_image: UIImageView!
    @IBOutlet var BookNow_lbl: UILabel!
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
        // Do any additional setup after loading the view.
    }
    
    func ReadyViewCustomize(){
        Time_lbl.isHidden=true
        Profile_image.layoutIfNeeded()
        Profile_image.layer.borderWidth = 1
        Profile_image.layer.masksToBounds = true
        Profile_image.layer.borderColor = UIColor.white.cgColor
        Profile_image.layer.cornerRadius = Profile_image.frame.height/2
        Profile_image.clipsToBounds = true
        BookNow_lbl.layoutIfNeeded()
        BookNow_lbl.layer.borderWidth = 1
        BookNow_lbl.layer.masksToBounds = true
        BookNow_lbl.layer.borderColor = UIColor.white.cgColor
        BookNow_lbl.layer.cornerRadius = BookNow_lbl.frame.width/2
        BookNow_lbl.clipsToBounds = true
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FeedCell! = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FeedCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    @IBAction func DidTabDrawerBtn(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBAction func AboutBtn(_ sender: Any) {
        about_lbl.isHidden=false
        Time_lbl.isHidden=true
    }
    @IBAction func TimeLinebtn(_ sender: Any) {
        about_lbl.isHidden=true
        Time_lbl.isHidden=false

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
