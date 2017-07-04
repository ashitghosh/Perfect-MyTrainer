//
//  TrainerCreateProfileTwo.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 09/03/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Photos
import AVKit
import DKImagePickerController
import Alamofire
import AlamofireImage
import SVProgressHUD
import AVFoundation
class TrainerCreateProfileTwo: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate {

    @IBOutlet var Facebook_imageview: UIImageView!
    @IBOutlet var instagram_imageview: UIImageView!
    @IBOutlet var Twitter_imageview: UIImageView!
    @IBOutlet var Upload_image_view: UIView!
    @IBOutlet var OkBtn: UIButton!
    @IBOutlet var wheelchair_access_switch: UISwitch!
    @IBOutlet var VideoCollectionView: UICollectionView!
    @IBOutlet var Image_collectionView: UICollectionView!
    @IBOutlet var Upload_video_plusBtn: UILabel!
    @IBOutlet var Upload_videoBtn: UIButton!
    @IBOutlet var Upload_image_btn: UIButton!
    @IBOutlet var Upload_image_plus_lbl: UILabel!
    @IBOutlet var About_txt_view: UITextView!
    @IBOutlet var Tagline_txtView: UITextView!
    var placeholderLabel : UILabel!
    var Imagedict:[String:AnyObject] = [:]
    var arrCollectionImages = [[String:AnyObject]] ()
    var arrCollectionVideo = [[String:AnyObject]] ()
    var arrUploadVideo = [[String:AnyObject]] ()
    var arrUploadCollectionVideo = [[String:AnyObject]] ()
    var fb_profile:String=""
     var twitter_profile:String=""
     var instagram_profile:String=""
    var arrVideo: [NSData] = []
    var arrImage: [NSData] = []
    var arrVideoUrl:[String] = []
    var Urlcount:NSInteger = 0
    var DkassetCount:NSInteger = 0
    var UploadImageData:NSData? = nil
    var UploadVideodata:NSData? = nil
    let cameraManager = CameraManager()
    var pickerController: DKImagePickerController!
    var assets: [DKAsset]?
    var IsVideo:Bool = false
    var uploadImage:UIImageView? = nil
    var Wheel_chair:String = "Y"
    var player:AVPlayer?
    var Upload:String=""
    
   
    // MARK: - @IBOutlets
    
    @IBOutlet var Camera_background_view: UIView!
    @IBOutlet var Camera_menu_view: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var flashModeButton: UIButton!
    
    @IBOutlet weak var askForPermissionsButton: UIButton!
    @IBOutlet weak var askForPermissionsLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UITextField.appearance().tintColor = UIColor.white
        UITextView.appearance().tintColor = UIColor.white
        About_txt_view.text="Type Here"
        Tagline_txtView.text="Type Here"
                  cameraButton.CircleBtn(BorderColour: UIColor.clear, Radious: 0.0)
        Upload_image_btn.BtnRoundCorner(radious: 5.0, colour: UIColor.white)
        Upload_videoBtn.BtnRoundCorner(radious: 5.0, colour: UIColor.white)
        Upload_image_plus_lbl.Circlelabel(BorderColour: UIColor.clear, Radious: 0.0)
        Upload_video_plusBtn.Circlelabel(BorderColour: UIColor.clear, Radious: 0.0)
        self.addDoneButtonOnKeyboard()
        self.Camera_background_view.isHidden=true
         self.JsonForFetch()
     
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView==About_txt_view {
            if About_txt_view.text=="Type Here"{
             About_txt_view.text=""
            }
        }
        if textView==Tagline_txtView {
            if Tagline_txtView.text=="Type Here"{
                Tagline_txtView.text=""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView==About_txt_view {
            if About_txt_view.text.isEmpty==true{
            About_txt_view.text="Type Here"
            }
        }
        if textView==Tagline_txtView {
            if Tagline_txtView.text.isEmpty==true{
                Tagline_txtView.text="Type Here"
            }
        }
    }
  
    func showImagePicker() {
       
        //	 pickerController.assetType = .allPhotos
        
        let pickerController = DKImagePickerController()
       // pickerController.maxSelectableCount=5
        if Upload=="ImageFromCamera"{
        pickerController.sourceType = .camera
        }
        if Upload=="VideoFromGallery"{
         pickerController.assetType = .allVideos
        }
        if Upload=="ImageFromGallery"{
           pickerController.assetType = .allPhotos
        }
       
           pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            self.assets = assets
            print(assets)
         
           for  index in stride(from: 0, to:  (self.assets?.count)!, by: 1){
             let asset = self.assets![index]
           
        // signUpDict = ["name" : (FullName_txt.text)! as AnyObject, "password" : (Password_txt.text)! as AnyObject,"email":Email_txt.text as AnyObject,"user_type":user_type as AnyObject, "device_token" : "" as AnyObject ]
            
                if asset.isVideo {
                    self.Imagedict = ["sample" : "upload" as AnyObject, "trainer_video" : asset as AnyObject]
                    self.arrCollectionVideo.append(self.Imagedict)

           }
                    
                    
                else{
                    
                    self.Imagedict = ["sample" : "upload" as AnyObject, "trainer_images" : asset as AnyObject]
                    self.arrCollectionImages.append(self.Imagedict)
           }
            
            }
            if self.arrCollectionVideo.isEmpty==true{
                self.VideoCollectionView.isHidden=true
            }
            else{
                self.VideoCollectionView.isHidden=false
                self.VideoCollectionView.reloadData()
            }
            if self.arrCollectionImages.isEmpty==true{
                self.Image_collectionView.isHidden=true
            }
            else{
                self.Image_collectionView.isHidden=false
                self.Image_collectionView.reloadData()
            }

           print(" images",self.arrCollectionImages)
           print("Video",self.arrCollectionVideo)
            
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        self.present(pickerController, animated: true) {}
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.Tagline_txtView.inputAccessoryView = doneToolbar
        self.About_txt_view.inputAccessoryView = doneToolbar
    }
    
    
    
    
    func CameraPermission()  {
        cameraManager.askUserForCameraPermission({ permissionGranted in
                        if permissionGranted {
                            self.Camera_background_view.isHidden=false
                self.addCameraToView()
            }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        cameraManager.stopCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    // MARK: - ViewController
    
    fileprivate func addCameraToView()
    {
        
        _ = cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.videoWithMic)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }

    
    func doneButtonAction() {
        self.Tagline_txtView.resignFirstResponder()
        self.About_txt_view.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func JsonForSocialUrl(Url:String,social_type:String)  {
        if verifyUrl(urlString: Url)==false {
           self.presentAlertWithTitle(title: "Alert", message: "Write a valid url")
        }
        else{
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show()
            var poststring:String?
            
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
           
            
            let parameters = ["trainer_id": User_id,"account_type":social_type,"link":Url]
            let Url:String=Constants.Base_url+"insertSocialLink"
            
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
                                /*   facebook-hover.png,facebook_connect.png
                                 instragram_connect.png,instragram-hover.png
                                 twitter_connect.png,twitter_hover.png*/
                                if social_type=="facebook"{
                                self.Facebook_imageview.image=UIImage.init(named: "facebook-hover.png")
                                }
                                if social_type=="twitter"{
                                    self.Twitter_imageview.image=UIImage.init(named: "twitter_connect.png")
                                }
                                if social_type=="instagram"{
                                    self.instagram_imageview.image=UIImage.init(named: "instragram-hover.png")
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
    }
    
    
    func JsonForFetch()  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        var poststring:String?
        
        let parameters = ["trainer_id": User_id]
        print("new parameter",parameters)
        let Url:String=Constants.Base_url+"getTrainerInfoStep2"
        
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
                        print( "Json  return for Login= ",response)
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0 {
                            SVProgressHUD.dismiss()
                          
                            if (response.result.value as AnyObject).value(forKey: "about") as! String==""{
                            self.About_txt_view.text="Type Here"
                            }
                            else{
                            self.About_txt_view.text=(response.result.value as AnyObject).value(forKey: "about") as! String
                            }
                            if (response.result.value as AnyObject).value(forKey: "tagline") as! String==""{
                                self.Tagline_txtView.text="Type Here"
                            }
                            else{
                                self.Tagline_txtView.text=(response.result.value as AnyObject).value(forKey: "tagline") as! String
                            }
                            self.arrCollectionImages=(response.result.value as AnyObject).value(forKey: "trainer_images") as! [[String:AnyObject]]
                              self.arrCollectionVideo=(response.result.value as AnyObject).value(forKey: "trainer_videos") as! [[String:AnyObject]]
                            if self.arrCollectionVideo.isEmpty==true{
                                self.VideoCollectionView.isHidden=true
                            }
                            else{
                             self.VideoCollectionView.isHidden=false
                                self.VideoCollectionView.reloadData()
                            }
                            if self.arrCollectionImages.isEmpty==true{
                                self.Image_collectionView.isHidden=true
                            }
                            else{
                                self.Image_collectionView.isHidden=false
                                self.Image_collectionView.reloadData()
                            }
                            
                            self.Wheel_chair=(response.result.value as AnyObject).value(forKey: "iswheelchair") as! String
                            if self.Wheel_chair=="N"{
                             self.wheelchair_access_switch.setOn(false, animated: true)
                                
                            }
                            else{
                              self.wheelchair_access_switch.setOn(true, animated: true)
                            }
                            
                         /*   facebook-hover.png,facebook_connect.png
                            instragram_connect.png,instragram-hover.png
                            twitter_connect.png,twitter_hover.png*/
                            self.fb_profile=((response.result.value as AnyObject).value(forKey: "fb_profile_link") as? String)!
                            if self.fb_profile==""{
                            self.Facebook_imageview.image=UIImage.init(named: "facebook_connect.png")
                            }
                            else{
                             self.Facebook_imageview.image=UIImage.init(named: "facebook-hover.png")
                            }
                            
                             self.twitter_profile=((response.result.value as AnyObject).value(forKey: "twitter_profile_link") as? String)!
                            if self.twitter_profile==""{
                                self.Twitter_imageview.image=UIImage.init(named: "twitter_hover.png")
                            }
                            else{
                                self.Twitter_imageview.image=UIImage.init(named: "twitter_connect.png")
                            }
                             self.instagram_profile=((response.result.value as AnyObject).value(forKey: "instagram_profile_link") as? String)!
                            if self.instagram_profile==""{
                                self.instagram_imageview.image=UIImage.init(named: "instragram_connect.png")
                            }
                            else{
                                self.instagram_imageview.image=UIImage.init(named: "instragram-hover.png")
                            }

                            
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
    
    
    func DeleteImageAndVideo(imageOrvideo:String,id:NSNumber,url:String)  {
       
            
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show()
            var poststring:String?
            
       
            
            let parameters = [imageOrvideo: id]
            let Url:String=Constants.Base_url+url
            
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
                        print("Status = ",response.result.value as AnyObject);
                        
                        switch(status){
                        case 200:
                            print( "Json  return for Fetch= ",response)
                            SVProgressHUD.dismiss()
                            //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                            
                            if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0  {
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
    
    
    func convertDkassetToAvasset(count:NSInteger){
        let asset:DKAsset = ((self.arrUploadVideo[count] as AnyObject).value(forKey: "trainer_video") as AnyObject) as! DKAsset
         
         asset.fetchAVAssetWithCompleteBlock({(avAsset,info) in
         
            
         print("avAsset",avAsset!)
         let asset = avAsset as! AVURLAsset
         //   let url = NSURL(string: asset.url.absoluteString)
         print("Absoulute url", asset.url.absoluteString)
         print("Reletive url", asset.url.relativePath)
         //let catPictureURL = URL(string: asset.url.absoluteString)!
         self.arrVideoUrl.append(asset.url.absoluteString)
         print("arr video url",self.arrVideoUrl);
         self.DkassetCount = self.DkassetCount+1
            let urlAsset = avAsset as? AVURLAsset
            let video = try? Data(contentsOf: (urlAsset?.url)!)
            self.arrVideo.append((video as AnyObject) as! NSData)
            print("dk asset count =",self.DkassetCount)
            if self.DkassetCount<self.arrUploadVideo.count{
            self.convertDkassetToAvasset(count: self.DkassetCount)
            }
            else{
         
              //  self.videoDownload(count: 0)
                print("count=",self.arrVideo.count)
                self.UploadNew()
                
            }
         
         
         })
    }
    
    func UploadNew() {
        let userDefaults = Foundation.UserDefaults.standard
         let User_id:String = userDefaults.string(forKey: "user_id")!
         let photo_count = String(self.arrImage.count)
         let video_count = String(self.arrVideo.count)
         print(photo_count,video_count)
         
         // let parameters = ["trainer_id": "7" ,"trainer_info_id": "3","tagline": "new tagline","about": "now about","iswheelchair": Wheel_chair,"photo_count": photo_count,"video_count": video_count]
         let parameters = ["trainer_id": User_id ,"tagline": Tagline_txtView.text!,"about": About_txt_view.text!,"iswheelchair": Wheel_chair,"photo_count": photo_count,"video_count": video_count]
         print("parameter",parameters)
         let Url:String=Constants.Base_url+"createTrainerInfoStep2"
         Alamofire.upload(multipartFormData: { multipartFormData in
         if self.arrImage.isEmpty==true && self.arrVideo.isEmpty==true{
         
         }
         else{
         if self.arrImage.isEmpty==false{
         
         for  index in stride(from: 0, to:  (self.arrImage.count), by: 1){
         
         let data:NSData = self.arrImage[index]
         
         // let asset = self.assets![index]
         // self.uploadImage?.image=UIImage.init(data: data as Data)
         if let imageData = UIImageJPEGRepresentation(UIImage.init(data: data as Data)!, 1) {
         
         let file_name : String="file"+String(index+1)+".jpeg"
         let Photo : String="photo_"+String(index+1)
         print(Photo)
         print(file_name)
         multipartFormData.append(imageData, withName: Photo, fileName: file_name, mimeType: "image/jpeg")
         print("New Image")
         
         
         //  multipartFormData.append(ImageData, withName: "photo", fileName:"file.jpeg" , mimeType: "image/jpeg")
         }
         }
         }
         if self.arrVideo.isEmpty==false{
         for  index in stride(from: 0, to:  (self.arrVideo.count), by: 1){
         
         let data:Data = self.arrVideo[index] as Data
         // let asset = self.assets![index]
         // self.uploadImage?.image=UIImage.init(data: data as Data)
         var movieData:Data?
         movieData=data as Data
         
         let file_name : String="file"+String(index+1)+".mp4"
         let Photo : String="video_"+String(index+1)
         print(Photo)
         print(file_name)
         multipartFormData.append(movieData!, withName: Photo, fileName: file_name, mimeType: "video/mp4")
         print("New video")
         }
         }
         
         }
         
         for (key, value) in parameters {
         multipartFormData.append((value.data(using: .utf8))!, withName: key)
         }
         },
         to:Url, method: .post, headers: ["Authorization": "auth_token"],
         encodingCompletion: { encodingResult in
         switch encodingResult {
         case .success(let upload, _, _):
         
         print("Upload success")
         upload.responseJSON { response in
         
         print("Response",response.result.value as AnyObject)
         
         SVProgressHUD.dismiss()
         
         
         if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0 {
         SVProgressHUD.dismiss()
         self.arrCollectionVideo.removeAll()
         self.arrCollectionImages.removeAll()
         self.arrVideo.removeAll()
         self.arrImage.removeAll()
         let vc = self.storyboard!.instantiateViewController(withIdentifier: "TrainerAboutController") as! TrainerAboutController
         self.navigationController?.pushViewController(vc, animated: true)
         }
         else{
         SVProgressHUD.dismiss()
         }
         }
         
         
         case .failure(let encodingError):
         print("error:\(encodingError)")
         SVProgressHUD.dismiss()
         }
         })
  
    }
    
    func videoDownload(count:NSInteger){
        let catPictureURL = URL(string: self.arrVideoUrl[count])!
        
        let session = URLSession(configuration: .default)
        
         // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
         let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
         // The download has finished.
         if let e = error {
         print("Error downloading cat picture: \(e)")
            self.videoDownload(count: self.Urlcount)
         }
         else {
         //self.arrVideo.append((data as AnyObject) as! NSData)
         print("data",data!);
         let sourceNSData = data! as NSData
         self.arrVideo.append(sourceNSData)
            if self.Urlcount<self.arrVideoUrl.count{
            self.Urlcount=self.Urlcount+1
             print("url count=",self.Urlcount)
                self.videoDownload(count: self.Urlcount)
            }
            else{
                print("arrvideo count=",self.arrVideo.count)
            SVProgressHUD.dismiss()
            }
         //print("data",sourceNSData)
         // No errors found.
         // It would be weird if we didn't have a response, so check for that too.
         
         }
         }
        
         downloadPicTask.resume()
        
        

    }


    func uploadWithAlamofire() {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        self.arrVideo.removeAll()
        self.arrUploadVideo.removeAll()
        self.arrImage.removeAll()
        // define parameters
        for  index in stride(from: 0, to:  (self.arrCollectionVideo.count), by: 1){
            let sample = (self.arrCollectionVideo[index] as AnyObject).value(forKey: "sample") as! String
            print(sample)
            if sample=="upload"{
                self.arrUploadVideo.append(self.arrCollectionVideo[index])
                print("Upload video file",self.arrUploadVideo)
               

            }
        }
       
        
        for  index in stride(from: 0, to:  (self.arrCollectionImages.count), by: 1){
            let sample = (self.arrCollectionImages[index] as AnyObject).value(forKey: "sample") as! String
            print(sample)
            if sample=="upload"{
                let asset:DKAsset = ((self.arrCollectionImages[index] as AnyObject).value(forKey: "trainer_images") as AnyObject) as! DKAsset
                asset.fetchImageDataForAsset(true, completeBlock: {Data ,info in
                    self.arrImage.append((Data as AnyObject) as! NSData)
                   
                })
            }
            
        }
        
        
        if self.arrUploadVideo.isEmpty==false{
        self.convertDkassetToAvasset(count: 0)
        }
        else{
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            let photo_count = String(self.arrImage.count)
            let video_count = String(self.arrVideo.count)
            print(photo_count,video_count)
            
            // let parameters = ["trainer_id": "7" ,"trainer_info_id": "3","tagline": "new tagline","about": "now about","iswheelchair": Wheel_chair,"photo_count": photo_count,"video_count": video_count]
            let parameters = ["trainer_id": User_id ,"tagline": Tagline_txtView.text!,"about": About_txt_view.text!,"iswheelchair": Wheel_chair,"photo_count": photo_count,"video_count": video_count]
            print("parameter",parameters)
            let Url:String=Constants.Base_url+"createTrainerInfoStep2"
            Alamofire.upload(multipartFormData: { multipartFormData in
                if self.arrImage.isEmpty==true && self.arrVideo.isEmpty==true{
                    
                }
                else{
                    if self.arrImage.isEmpty==false{
                        
                        for  index in stride(from: 0, to:  (self.arrImage.count), by: 1){
                            
                            let data:NSData = self.arrImage[index]
                            
                            // let asset = self.assets![index]
                            // self.uploadImage?.image=UIImage.init(data: data as Data)
                            if let imageData = UIImageJPEGRepresentation(UIImage.init(data: data as Data)!, 1) {
                                
                                let file_name : String="file"+String(index+1)+".jpeg"
                                let Photo : String="photo_"+String(index+1)
                                print(Photo)
                                print(file_name)
                                multipartFormData.append(imageData, withName: Photo, fileName: file_name, mimeType: "image/jpeg")
                                print("New Image")
                                
                                
                                //  multipartFormData.append(ImageData, withName: "photo", fileName:"file.jpeg" , mimeType: "image/jpeg")
                            }
                        }
                    }
                    if self.arrVideo.isEmpty==false{
                        for  index in stride(from: 0, to:  (self.arrVideo.count), by: 1){
                            
                            let data:Data = self.arrVideo[index] as Data
                            // let asset = self.assets![index]
                            // self.uploadImage?.image=UIImage.init(data: data as Data)
                            var movieData:Data?
                            movieData=data as Data
                            
                            let file_name : String="file"+String(index+1)+".mp4"
                            let Photo : String="video_"+String(index+1)
                            print(Photo)
                            print(file_name)
                            multipartFormData.append(movieData!, withName: Photo, fileName: file_name, mimeType: "video/mp4")
                            print("New video")
                        }
                    }
                    
                }
                
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
            },
                             to:Url, method: .post, headers: ["Authorization": "auth_token"],
                             encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    
                                    print("Upload success")
                                    upload.responseJSON { response in
                                        
                                        print("Response",response.result.value as AnyObject)
                                        
                                        SVProgressHUD.dismiss()
                                        
                                        
                                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0 {
                                            SVProgressHUD.dismiss()
                                            self.arrCollectionVideo.removeAll()
                                            self.arrCollectionImages.removeAll()
                                            self.arrVideo.removeAll()
                                            self.arrImage.removeAll()
                                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "TrainerAboutController") as! TrainerAboutController
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        else{
                                            SVProgressHUD.dismiss()
                                        }
                                    }
                                    
                                    
                                case .failure(let encodingError):
                                    print("error:\(encodingError)")
                                    SVProgressHUD.dismiss()
                                }
            })

        }
        
        
    }

    
    
    // For collection View+++++++++++++++++++++++++++++***********************++++++++++++++++++++++++++
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if collectionView==Image_collectionView{
        return arrCollectionImages.count
        }
        else{
         return arrCollectionVideo.count
        }
      
        
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCell", for: indexPath) as! UploadImageCell
        cell.layer.cornerRadius=10
        if collectionView==VideoCollectionView{
            let Id:String = ((self.arrCollectionVideo[indexPath.row] as AnyObject).value(forKey: "sample") as? String)!
            cell.Video_DeleteBtn.tag=indexPath.row
            if Id == "upload"{
                 let url:String = "http://ogmaconceptions.com/demo/my_perfect_trainer/img/video.jpeg"
                Alamofire.request(url).responseImage { response in
                   // debugPrint(response)
                    
                    
                    //debugPrint(response.result)
                    
                    if let image = response.result.value {
                        cell.VideoImage.image=image
                        
                    }
                    
                }

                
            }
            else{
                
                
                    let url:String = ((self.arrCollectionVideo[indexPath.row] as AnyObject).value(forKey: "video_image") as? String)!
                    print("video image",url)
                    Alamofire.request(url).responseImage { response in
                       // debugPrint(response)
                        
                        
                        //debugPrint(response.result)
                        
                        if let image = response.result.value {
                            cell.VideoImage.image=image
                            
                    }

                }
               
            }
           
        }
        else{
            cell.DeleteBtn.tag=indexPath.row
            
            let Id:String = ((self.arrCollectionImages[indexPath.row] as AnyObject).value(forKey: "sample") as? String)!
            
            if Id == "upload"{
                let Assest:DKAsset = (self.arrCollectionImages[indexPath.row] as AnyObject).value(forKey: "trainer_images") as! DKAsset
                let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                Assest.fetchImageWithSize(layout.itemSize.toPixel(), completeBlock: { image, info in
                    cell.Upload_image.image=image
                })
                
                
            }
            else{
                let url:String = ((self.arrCollectionImages[indexPath.row] as AnyObject).value(forKey: "name") as? String)!
                print("Upload image",url)
                Alamofire.request(url).responseImage { response in
                   // debugPrint(response)
                    // debugPrint(response.result)
                    
                    if let image = response.result.value {
                        cell.Upload_image.image=image
                        
                    }
                }
                

            }
            
                    }
        return cell
    
    }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView==VideoCollectionView{
        
                   }
    }
    
    //For image Picker Function controller++++++++++++++++++*************************************
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
       if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        print(pickedImage)
     UploadImageData = UIImageJPEGRepresentation(pickedImage, 1) as NSData?
        self.arrImage.append((UploadImageData as AnyObject) as! NSData)
        print(self.arrImage.count)
        
        }
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion:nil)
    }

    
    
    @IBAction func DidTabUploadVideoButton(_ sender: UIButton) {
        self.view.endEditing(true)
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Recording", style: .default)
        { void in
           self.Upload="VideoRecording"
            self.CameraPermission()
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Video From Gallery", style: .default)
        { void in
         self.Upload="VideoFromGallery"
            self.showImagePicker()
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)

        
    }
    
   
    @IBAction func DidTabUploadImageBtn(_ sender: Any) {
        self.view.endEditing(true)
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Camera", style: .default)
        { void in
            self.Upload="ImageFromCamera"
             self.showImagePicker()
           
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Gallery", style: .default)
        { void in
            
            self.Upload="ImageFromGallery"
            self.showImagePicker()
         
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)

        
    }
    @IBAction func DidTabWheelChairSwitchBtn(_ sender: Any) {
        self.view.endEditing(true)
        if ((sender as AnyObject).isOn == true){
            Wheel_chair="Y"
        }
        else{
            Wheel_chair="N"
        }
    }
    @IBAction func DidTabTwitterConnectBtn(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func DidTabFacebookConnectBtn(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func DidTabInstragramBtn(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func DidTabCameraCancelBtn(_ sender: Any) {
        self.view.endEditing(true)
        self.Camera_background_view.isHidden=true
        cameraManager.stopCaptureSession()
    }
    @IBAction func DidTabOkBtn(_ sender: Any) {
        self.view.endEditing(true)
        if Tagline_txtView.text=="" || Tagline_txtView.text=="Type Here" {
        self.presentAlertWithTitle(title: "Alert", message: "Write your tagline")
        }
        else if About_txt_view.text=="" || About_txt_view.text=="Type Here" {
            self.presentAlertWithTitle(title: "Alert", message: "Write about you")

        }
       
        else{
         self.uploadWithAlamofire()
        }
    
       
    }
    
   
    
    
    
    @IBAction func DidTabRecordBtn(_ sender: Any) {
        self.view.endEditing(true)
        cameraButton.isSelected = !cameraButton.isSelected
        cameraButton.setTitle(" ", for: UIControlState.selected)
        cameraButton.backgroundColor = cameraButton.isSelected ? UIColor.red : UIColor.green
        if cameraButton.isSelected {
            cameraManager.startRecordingVideo()
        } else {
            
            
                      cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
              print("video url",videoURL as AnyObject)
           //     self.arrVideo.append(videoURL!)
         //       let catPictureURL = URL(string: "http://i.imgur.com/w5rkSIj.jpg")!
                        let session = URLSession(configuration: .default)
                        
                     
                        
                        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
                        let downloadPicTask = session.dataTask(with: videoURL!) { (data, response, error) in
                            // The download has finished.
                            
                            if let e = error {
                                print("Error downloading cat picture: \(e)")
                            } else {
                                // No errors found.
                                // It would be weird if we didn't have a response, so check for that too.
                                if let res = response as? HTTPURLResponse {
                                    print("Downloaded cat picture with response code \(res.statusCode)")
                                   // let asset:DKAsset=data as!DKAsset
                                  //  print(asset)
                                 // self.arrVideo.append((data as AnyObject) as! NSData)
                                   
                                } else {
                                    print("Couldn't get response code for some reason")
                                }
                            }
                        }
                        
                        downloadPicTask.resume()
                
                if let errorOccured = error {
                    self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
                }
            })
      
    }

    }

    @IBAction func DidTabChangeCameraBtn(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func DidTabFlashBtn(_ sender: Any) {
        self.view.endEditing(true)
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switch (cameraManager.cameraDevice) {
        case .front:
            flashModeButton.setTitle("Front", for: UIControlState())
        case .back:
            flashModeButton.setTitle("Back", for: UIControlState())
        }

    }
    
    @IBAction func DidTabBackBtn(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController! .popViewController(animated: true)
    }
    
    @IBAction func DidTabVideoDeleteBtn(_ sender: Any) {
        let selectedIndex:NSInteger=(sender as AnyObject).tag
        print(selectedIndex)
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure want to delete", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
            print((self.arrCollectionImages[selectedIndex] as AnyObject))
            let sample = (self.arrCollectionVideo[selectedIndex] as AnyObject).value(forKey: "sample") as! String
            print(sample)
            if sample=="upload"{
                self.arrCollectionVideo.remove(at: selectedIndex)
                self.VideoCollectionView.reloadData()
            }
            else{
                let Id = (self.arrCollectionVideo[selectedIndex] as AnyObject).value(forKey: "id") as! NSNumber
                self.arrCollectionVideo.remove(at: selectedIndex)
                self.VideoCollectionView.reloadData()
              // self.DeleteImageAndVideo(imageOrvideo: "trainer_video_id", id: Id)
                self.DeleteImageAndVideo(imageOrvideo: "trainer_video_id", id: Id, url: "deleteTrainerVideo")
            }

        }
        let NoAction = UIAlertAction(title: "No", style: .default) {
            (action: UIAlertAction) in print("Youve pressed No Button")
        }
        alertController.addAction(OKAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func DidTabImageDeleteBtn(_ sender: Any) {
        let selectedIndex:NSInteger=(sender as AnyObject).tag
        print(selectedIndex)
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure want to delete", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
            print((self.arrCollectionImages[selectedIndex] as AnyObject))
            let sample = (self.arrCollectionImages[selectedIndex] as AnyObject).value(forKey: "sample") as! String
            print(sample)
            if sample=="upload"{
            self.arrCollectionImages.remove(at: selectedIndex)
                self.Image_collectionView.reloadData()
             }
            else{
                let Id = (self.arrCollectionImages[selectedIndex] as AnyObject).value(forKey: "id") as! NSNumber
                self.arrCollectionImages.remove(at: selectedIndex)
                self.Image_collectionView.reloadData()
                //self.DeleteImageAndVideo(imageOrvideo: "trainer_image_id", id: Id)
                self.DeleteImageAndVideo(imageOrvideo: "trainer_image_id", id: Id, url: "deleteTrainerImages")
            }
        }
        let NoAction = UIAlertAction(title: "No", style: .default) {
            (action: UIAlertAction) in print("Youve pressed No Button")
        }
        alertController.addAction(OKAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func DidTabFaceBookSocialBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Your Link", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            print(firstTextField.text!)
            self.JsonForSocialUrl(Url: firstTextField.text!, social_type: "facebook")
            
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.fb_profile=firstTextField.text!
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Facebook Profile Link"
                  textField.text=self.fb_profile
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func DidTabSocialInstargramBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Your Link", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            print(firstTextField.text!)
            self.JsonForSocialUrl(Url: firstTextField.text!, social_type: "instagram")
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.instagram_profile=firstTextField.text!
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter instagram Profile Link"
            textField.text=self.instagram_profile
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    @IBAction func DidTabSocialTwitterBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Your Link", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            print(firstTextField.text!)
            self.JsonForSocialUrl(Url: firstTextField.text!, social_type: "twitter")
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.twitter_profile=firstTextField.text!
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Twitter Profile Link"
            textField.text=self.twitter_profile
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
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
