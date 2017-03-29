//
//  TrainerCreateFeedController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 27/03/17.
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

class TrainerCreateFeedController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var Camera_background_view: UIView!
    @IBOutlet var Camera_menu_view: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet var CameraChangeBtn: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var flashModeButton: UIButton!
    let cameraManager = CameraManager()
    
    @IBOutlet var Description_Txtview: UITextView!
    @IBOutlet var title_text: UITextField!
    @IBOutlet var UploadImageOrVideo: UIImageView!
    @IBOutlet var Titile_TextView: UITextField!
    @IBOutlet var SendBtn: UIButton!
    var pickerController: DKImagePickerController!
    var Upload:String = ""
      var assets: [DKAsset]?
    var UploadImageData:NSData? = nil
    var UploadVideodata:NSData? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
SendBtn.ButtonRoundCorner(radious: 8.0)
        title_text.attributedPlaceholder = NSAttributedString(string: "Enter Title",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.Camera_background_view.isHidden=true
        self.addDoneButtonOnKeyboard()
       

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.Description_Txtview.inputAccessoryView = doneToolbar
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
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.stopCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
      return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView==Description_Txtview {
             self.animateViewMoving(up: true, moveValue: 150.0)
            if Description_Txtview.text=="Enter Description"{
                Description_Txtview.text=""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView==Description_Txtview {
            self.animateViewMoving(up: false, moveValue: 150.0)
            if Description_Txtview.text?.isEmpty==true{
                Description_Txtview.text="Enter Description"
            }
        }
       
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
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
        self.Description_Txtview.resignFirstResponder()
    }

    
    func showImagePicker() {
        
        //	 pickerController.assetType = .allPhotos
        
        let pickerController = DKImagePickerController()
         pickerController.maxSelectableCount=1
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
            let asset=self.assets?[0]
            print(assets)
            if (asset?.isVideo)! {
                asset?.fetchAVAssetWithCompleteBlock({(avAsset,info) in
                    let urlAsset = avAsset as? AVURLAsset
                    let video = try? Data(contentsOf: (urlAsset?.url)!)
                    self.UploadVideodata=video as NSData?
                    let url:String = "http://ogmaconceptions.com/demo/my_perfect_trainer/img/offwhite-video.png"
                    Alamofire.request(url).responseImage { response in
                        // debugPrint(response)
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.show()
                        
                        //debugPrint(response.result)
                        
                        if let image = response.result.value {
                            self.UploadImageOrVideo.image=image
                            SVProgressHUD.dismiss()
                            
                        }
                        
                    }

                    
                })
                
                
            }
            else{
                asset?.fetchImageDataForAsset(true, completeBlock: {Data ,info in
                    self.UploadImageData=Data as NSData?
                    self.UploadImageOrVideo.image=UIImage.init(data: self.UploadImageData as! Data)
                })
            }
            
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        self.present(pickerController, animated: true) {}
    }

    func uploadWithAlamofire() {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        // define parameters
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        var file_type:String=""
        if self.UploadImageData==nil && self.UploadVideodata==nil{
            file_type="none"
        }
        else{
         if self.UploadVideodata==nil{
            file_type="image"
            }
         else{
            file_type="video"
            }
        }
            

        
        let parameter = ["trainer_id": User_id ,"file_type": file_type ,"feed_title": title_text.text!,"feed_description": Description_Txtview.text!]
        print("parameter",parameter)
        let Url:String=Constants.Base_url+"createTrainerFeed"
        Alamofire.upload(multipartFormData: { multipartFormData in
            if self.UploadImageData==nil && self.UploadVideodata==nil{
                
            }
            else{
                if self.UploadVideodata==nil{
                    
                     let data:NSData = self.UploadImageData!
                    if let imageData = UIImageJPEGRepresentation(UIImage.init(data: data as Data)!, 1)
                    {
                        
                        let file_name : String="file.jpeg"
                        let Photo : String="feed_file"
                        print(Photo)
                        print(file_name)
                        multipartFormData.append(imageData, withName: Photo, fileName: file_name, mimeType: "image/jpeg")
                        print("New Image")
                    }
                    
                    
            }
                else{
                    var movieData:Data?
                    movieData=self.UploadVideodata as? Data
                    
                    let file_name : String="file.mp4"
                    let Photo : String="feed_file"
                    print(Photo)
                    print(file_name)
                    multipartFormData.append(movieData!, withName: Photo, fileName: file_name, mimeType: "video/mp4")
                    print("New video")

                }
            }
            
            for (key, value) in parameter {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
        },
                         to:Url, method: .post, headers: ["Authorization": "auth_token"],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                print("Upload success")
                                upload.responseJSON { response in
                                    print("Response",response.result.value!)
                                    SVProgressHUD.dismiss()
                                    
                                    
                                    if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0 {
                                        SVProgressHUD.dismiss()
                                      self.navigationController! .popViewController(animated: true)
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
    

    
    
    @IBAction func DidTabSendBtn(_ sender: Any) {
        view.endEditing(true)
        if title_text.text?.isEmpty==true{
        self.presentAlertWithTitle(title: "Alert", message: "Write your feed title")
        }
            
        else if Description_Txtview.text?.isEmpty==true || Description_Txtview.text == "Enter Description"{
            self.presentAlertWithTitle(title: "Alert", message: "Write your feed Description")
        }
        
        else{
            
        self.uploadWithAlamofire()

        }
    }

    @IBAction func DidTabUploadBtn(_ sender: Any) {
        view.endEditing(true)
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Recording", style: .default)
        { void in
            self.Upload="VideoRecording"
            self.CameraPermission()
            self.UploadImageData=nil
            self.UploadVideodata=nil
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let VideoGallery: UIAlertAction = UIAlertAction(title: "Video From Gallery", style: .default)
        { void in
            self.Upload="VideoFromGallery"
            self.showImagePicker()
            self.UploadImageData=nil
            self.UploadVideodata=nil
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let Camera: UIAlertAction = UIAlertAction(title: "Image From Camera", style: .default)
        { void in
            self.Upload="ImageFromCamera"
              self.showImagePicker()
            self.UploadImageData=nil
            self.UploadVideodata=nil
        }
        let Gallery: UIAlertAction = UIAlertAction(title: "Image From Gallery", style: .default)
        { void in
            self.Upload="ImageFromGallery"
            self.showImagePicker()
            self.UploadImageData=nil
            self.UploadVideodata=nil
        }
        actionSheetControllerIOS8.addAction(Camera)
        actionSheetControllerIOS8.addAction(VideoGallery)
        actionSheetControllerIOS8.addAction(Gallery)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func DidTabBackBtn(_ sender: Any) {
        self.view.endEditing(true)
self.navigationController! .popViewController(animated: true)
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
                            self.UploadVideodata=(data as AnyObject) as? NSData
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
    
   
    
    @IBAction func DidTabCameraCancelBtn(_ sender: Any) {
        self.Camera_background_view.isHidden=true
        cameraManager.stopCaptureSession()
    }
    @IBAction func DidTabChangeCameraBtn(_ sender: Any) {
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switch (cameraManager.cameraDevice) {
        case .front:
            CameraChangeBtn.setTitle("Front", for: UIControlState())
        case .back:
            CameraChangeBtn.setTitle("Back", for: UIControlState())
        }

    }
    
    
    @IBAction func DidTabFlashBtn(_ sender: Any) {
        
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
