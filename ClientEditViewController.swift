//
//  ClientEditViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 19/04/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
class ClientEditViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var Password_view: UIView!
    @IBOutlet var Profile_imageview: UIImageView!
    @IBOutlet var Password_txt: UITextField!
    @IBOutlet var Email_txt: UITextField!
    @IBOutlet var Name_txt: UITextField!
    var login_type:String?=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Profile_imageview.layoutIfNeeded()
         self.Profile_imageview.CircleImageView(BorderColour: UIColor.white, Radious: 1.0)
        self.textplaceholderColor(getTextName: Email_txt, getplaceholderText: "Email")
        self.textplaceholderColor(getTextName: Password_txt, getplaceholderText: "Password")
        self.textplaceholderColor(getTextName: Name_txt, getplaceholderText: "Fullname")
        Email_txt.isEnabled=false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        self.JsonForFetchClientDetails()
    }
    
    func textplaceholderColor(getTextName: UITextField, getplaceholderText: String){
        
        getTextName.attributedPlaceholder = NSAttributedString(string: getplaceholderText,
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var done:Bool=true
        if textField==Name_txt{
            done=true
            Password_txt.becomeFirstResponder()
        }
        
        
        else if textField==Password_txt{
            textField.resignFirstResponder()
            done=true
        }
        
        return done
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField==Password_txt{
            self.animateViewMoving(up: true, moveValue: 150.0)
        }
    }
    
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        if textField==Password_txt{
            self.animateViewMoving(up: false, moveValue: 150.0)
        }    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func viewCorner(getViewName :UIView,GetBtnName : UIButton? = nil)   {
        getViewName.layer.cornerRadius=14.0;
        getViewName.layer.masksToBounds=true;
        
        if GetBtnName != nil{
            GetBtnName?.layer.cornerRadius=16.0;
            GetBtnName?.layer.masksToBounds=true;
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    
    //For image Picker Function controller++++++++++++++++++*************************************
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            Profile_imageview.contentMode = .scaleAspectFit
            Profile_imageview.image = pickedImage
            // self.CallingForImageUpload()
            self.uploadWithAlamofire()
//            if ProfileImageData == nil {
//                ProfileImageData = UIImageJPEGRepresentation(pickedImage, 1) as NSData?
//            }
            
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion:nil)
    }

    func JsonForFetchClientDetails()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        var poststring:String?
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        
        
        let parameters = ["client_id": User_id]
        let Url:String=Constants.Client_url+"clientProfileView"
        
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
                            
                           self.login_type=(response.result.value as AnyObject).value(forKey: "login_type") as? String
                            if self.login_type=="facebook"{
                            self.Password_view.isHidden=true
                            }
                            else{
                            self.Password_view.isHidden=false
                            }
                          self.Email_txt.text=(response.result.value as AnyObject).value(forKey: "email") as? String
                            self.Password_txt.text=(response.result.value as AnyObject).value(forKey: "password") as? String
                            self.Name_txt.text=(response.result.value as AnyObject).value(forKey: "name") as? String
                            
                            
                            let url:String=((response.result.value as AnyObject).value(forKey: "profile_image") as? String)!
                            Alamofire.request(url).responseImage { response in
                               // debugPrint(response)
                                
                                
                               // debugPrint(response.result)
                                
                                if let image = response.result.value {
                                    print("image downloaded: \(image)")
                                    
                                    self.Profile_imageview.image=image
                                }
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
    
    func uploadWithAlamofire() {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        // define parameters
        
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        
        let parameters = ["client_id": User_id]
        let Url:String=Constants.Client_url+"clientProfileImage"
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(self.Profile_imageview.image!, 1) {
                multipartFormData.append(imageData, withName: "photo", fileName: "file.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
        }, to:Url, method: .post, headers: ["Authorization": "auth_token"],
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                print("Upload success")
                upload.responseJSON { response in
                    print("Response",response.result.value!)
                    SVProgressHUD.dismiss()
                    if (response.result.value as AnyObject).value(forKey: "status")as! NSNumber==0{
                        let url:String=((response.result.value as AnyObject).value(forKey: "image") as? String)!
                        Alamofire.request(url).responseImage { response in
                            debugPrint(response)
                            
                            
                            debugPrint(response.result)
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                
                                self.Profile_imageview.image=image
                            }
                        }
                        
                    }
                    
                    let Message=(response.result.value as AnyObject).value(forKey: "message")
                    print(Message as! String)
                    //  self.presentAlertWithTitle(title: "Success", message: Message as! String)
                    
                }
                
                
            case .failure(let encodingError):
                print("error:\(encodingError)")
                SVProgressHUD.dismiss()
            }
        })
        
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func DidTabSubmitBtn(_ sender: Any) {
        if Name_txt.text==""{
        self.presentAlertWithTitle(title: "Alert", message: " write your name")
        }
       else if self.login_type=="normal"{

           if Password_txt.text==""{
                self.presentAlertWithTitle(title: "Alert", message: " write your password")
            }
        }
        
        else{
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show()
            var poststring:String?
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            
            
            let parameters = ["client_id": User_id,"name": Name_txt.text!  ,"password": Password_txt.text!,"email": Email_txt.text! ] as [String : Any]
            let Url:String=Constants.Client_url+"updateClientProfile"

            
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
    
    
    @IBAction func DidTabProfilePicUpload(_ sender: Any) {
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
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    @IBAction func DidTabBackBtn(_ sender: Any) {
        
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }

        
    }
}
