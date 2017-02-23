//
//  ClientAboutController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 15/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import QuartzCore
class ClientAboutController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,FloatRatingViewDelegate {
fileprivate let reuseIdentifier = "Customcell"
//fileprivate let reuseIdentifier = "Customcell"
    @IBOutlet var video_collectionview: UICollectionView!
    @IBOutlet var Certificate_tableview: UITableView!
    @IBOutlet var Galaery_collection: UICollectionView!
    @IBOutlet var Client_scorllview: UIScrollView!
    @IBOutlet var Profile_imageview: UIImageView!
    @IBOutlet var Book_now_lbl: UILabel!
    @IBOutlet var About_lbl: UILabel!
    @IBOutlet var timeline_lbl: UILabel!
    @IBOutlet var Rating_view: FloatRatingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ReadyViewCustomize()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ReadyViewCustomize(){
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
        self.Rating_view.rating = 2.5
        self.Rating_view.editable = true
        self.Rating_view.halfRatings = true
        self.Rating_view.floatRatings = false
        
    }
    
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        Client_scorllview.contentSize = CGSize(width: 320   , height: 1000)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CertificateCell! = tableView.dequeueReusableCell(withIdentifier: "CertificateCell") as! CertificateCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
      
        if collectionView==video_collectionview {
            return 12
        }
        else{
         return 12;
        }
       
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView==video_collectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videocell", for: indexPath) as! VideoCell
            cell.layer.cornerRadius=10
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gallerycell", for: indexPath)as! GalleryCell
            cell.layer.cornerRadius=10
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
        About_lbl.isHidden=false
        timeline_lbl.isHidden=true
    }
    
    @IBAction func DidTAbTimelineBtn(_ sender: Any) {
        About_lbl.isHidden=true
        timeline_lbl.isHidden=false
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
