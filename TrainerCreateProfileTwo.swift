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
class TrainerCreateProfileTwo: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

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
    
    var arrVideo: [NSData] = []
    var arrImage: [NSData] = []
    var UploadImageData:NSData? = nil
    var UploadVideodata:NSData? = nil
    let cameraManager = CameraManager()
    var pickerController: DKImagePickerController!
    var assets: [DKAsset]?
    var IsVideo:Bool = false
    var uploadImage:UIImageView? = nil
    
    
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
        OkBtn.CircleBtn(BorderColour: UIColor.clear, Radious: 0.0)
         cameraButton.CircleBtn(BorderColour: UIColor.clear, Radious: 0.0)
        Upload_image_btn.BtnRoundCorner(radious: 5.0, colour: UIColor.white)
        Upload_videoBtn.BtnRoundCorner(radious: 5.0, colour: UIColor.white)
        Upload_image_plus_lbl.Circlelabel(BorderColour: UIColor.clear, Radious: 0.0)
        Upload_video_plusBtn.Circlelabel(BorderColour: UIColor.clear, Radious: 0.0)
        self.addDoneButtonOnKeyboard()
        self.Camera_background_view.isHidden=true

        
        
    }
    
    func showImagePicker() {
        
        //	 pickerController.assetType = .allPhotos
        let pickerController = DKImagePickerController()
       // pickerController.maxSelectableCount=5
        if IsVideo==true{
         pickerController.assetType = .allVideos
        }
        else{
         pickerController.assetType = .allPhotos
        }
       
     
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            self.assets = assets
        
            
            let asset = self.assets?[0]
            asset?.fetchImageDataForAsset(true, completeBlock: {UploadImageData ,info in
              self.arrImage.append((UploadImageData as AnyObject) as! NSData)
            })
           
           
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
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
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
    
    
    // For collection View+++++++++++++++++++++++++++++***********************++++++++++++++++++++++++++
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
       return 12
        
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCell", for: indexPath) as! UploadImageCell
        cell.layer.cornerRadius=10
        return cell
    
    }
    
    
    //For image Picker Function controller++++++++++++++++++*************************************
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
       if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            // self.CallingForImageUpload()
          //  self.uploadWithAlamofire()
            if UploadImageData == nil {
                UploadImageData = UIImageJPEGRepresentation(pickedImage, 1) as NSData?
              
            }
            
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion:nil)
    }

    
    
    @IBAction func DidTabUploadVideoButton(_ sender: UIButton) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Recording", style: .default)
        { void in
           
            self.CameraPermission()
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Video From Gallery", style: .default)
        { void in
        self.IsVideo=true
            self.showImagePicker()
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)

        
    }
    
   
    @IBAction func DidTabUploadImageBtn(_ sender: Any) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Camera", style: .default)
        { void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Gallery", style: .default)
        { void in
            self.IsVideo=false
            self.showImagePicker()
            
         
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)

        
    }
    @IBAction func DidTabTwitterConnectBtn(_ sender: Any) {
    }
    @IBAction func DidTabFacebookConnectBtn(_ sender: Any) {
    }
    @IBAction func DidTabInstragramBtn(_ sender: Any) {
    }
    
    @IBAction func DidTabCameraCancelBtn(_ sender: Any) {
        self.Camera_background_view.isHidden=true
        cameraManager.stopCaptureSession()
    }
    @IBAction func DidTabOkBtn(_ sender: Any) {
      
    }
    
    @IBAction func DidTabRecordBtn(_ sender: Any) {
        cameraButton.isSelected = !cameraButton.isSelected
        cameraButton.setTitle(" ", for: UIControlState.selected)
        cameraButton.backgroundColor = cameraButton.isSelected ? UIColor.red : UIColor.green
        if cameraButton.isSelected {
            cameraManager.startRecordingVideo()
        } else {
            cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
              print("video url",videoURL as AnyObject)
                if let errorOccured = error {
                    self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
                }
            })
      
    }

    }

    @IBAction func DidTabChangeCameraBtn(_ sender: Any) {
    }
    
    @IBAction func DidTabFlashBtn(_ sender: Any) {
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switch (cameraManager.cameraDevice) {
        case .front:
            flashModeButton.setTitle("Front", for: UIControlState())
        case .back:
            flashModeButton.setTitle("Back", for: UIControlState())
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
