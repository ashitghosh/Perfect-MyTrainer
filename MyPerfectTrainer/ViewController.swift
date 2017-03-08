//
//  ViewController.swift
//  MyPerfectTrainer
//
//  Created by Alok Das on 23/01/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    var user_type = "trainer"
    var messgae = ""

    @IBOutlet var client_btn: UIButton!
    @IBOutlet var lbl_forgot_password: UILabel!
    @IBOutlet var btn_login: UIButton!
    @IBOutlet var txt_email: UITextField!
    @IBOutlet var CreateAccount: UIButton!
    @IBOutlet var txt_password: UITextField!
    @IBOutlet var view_login_password: UIView!
    @IBOutlet var view_login_email: UIView!
    @IBOutlet var Trainer_select_view: UIView!
    @IBOutlet var Trainer_btn: UIButton!
     var LoginDict:[String:AnyObject] = [:]
    var FbDict:[String:AnyObject]=[:]
    var IsFacebook:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Trainer_select_view.isHidden=true
        self.labelMultiColor(getLabelName: lbl_forgot_password)
        self.ButtonCorner(getViewName: btn_login)
        self.ButtonCorner(getViewName: CreateAccount)
        self.ViewCorner(getViewName: view_login_email)
        self.ViewCorner(getViewName: view_login_password)
        self.textplaceholderColor(getTextName: txt_email, getplaceholderText: "Email")
        self.textplaceholderColor(getTextName: txt_password, getplaceholderText: "Password")
        // Do any additional setup after loading the view, typically from a nib.
       
       
    }
    func ViewCorner(getViewName: UIView)  {
        getViewName.layer.cornerRadius = 12;
        getViewName.layer.masksToBounds = true;
    }
    func ButtonCorner(getViewName: UIButton)  {
        getViewName.layer.cornerRadius = 12;
        getViewName.layer.masksToBounds = true;
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

   
    func labelMultiColor(getLabelName: UILabel)
    {
        let myString: String = "Forgot your password?"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSFontAttributeName:UIFont(name: "Georgia-Bold", size: 13.0)!])
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:12,length:8))
            getLabelName.attributedText = myMutableString
     }
    func textplaceholderColor(getTextName: UITextField, getplaceholderText: String){
     
        getTextName.attributedPlaceholder = NSAttributedString(string: getplaceholderText,
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var done:Bool=false
        if textField==txt_email{
            done=false
            txt_password.becomeFirstResponder()
        }
        
        if textField==txt_password{
            done=true
            txt_password.resignFirstResponder()
        }
        
        return done
    }

    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func ShowAlert( MessageName : NSString)  {
        let alertController = UIAlertController(title: title, message: MessageName as String, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    func CheckLogin () {
        if txt_email.text=="" {
            
            self.ShowAlert(MessageName: "Please write your Email")
        }
                else if !self.isValidEmail(testStr: txt_email.text! ){
            self.ShowAlert(MessageName: "Please write valid email")
            
        }
        else if txt_password.text==""{
            self.ShowAlert(MessageName: "Please write your password")
        }
        else{
              Trainer_select_view.isHidden=false
            IsFacebook=false
        }
    }
    
    func facebookLoginJson(jsonString : [String:AnyObject],Url:String){
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("details",jsonString)
   /*     var poststring:String=""
        
        if let json = try? JSONSerialization.data(withJSONObject: jsonString, options: []) {
             poststring = String(data: json, encoding: String.Encoding.utf8)!
             print(poststring)
            if  poststring == String(data: json, encoding: String.Encoding.utf8)! {
                // here `content` is the JSON dictionary containing the String
                print(poststring)
            }
        }
        var request = URLRequest(url: URL(string:"http://ogmaconceptions.com/demo/my_perfect_trainer/MyPerfectTrainerApp/facebookLogin")!)
        request.httpMethod = "POST"
        //let postString = "id=13&name=Jack"
        request.httpBody = poststring.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            
            let responseString = String(data: data, encoding: .utf8)
            
            let data1 = responseString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            do {
                let json = try JSONSerialization.jsonObject(with: data1!, options: []) as! [String: AnyObject]
                
                print(json);
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            print("responseString = \(responseString)")
            SVProgressHUD.dismiss()
        }
        task.resume()*/

      Alamofire.request(Url, method: .post, parameters: jsonString, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Login= ",response)
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0 {
                            let user_type:String=(response.result.value as AnyObject).value(forKey: "user_type") as! String
                            let user_id=(response.result.value as AnyObject).value(forKey: "user_id")
                            let userDefaults = Foundation.UserDefaults.standard
                            userDefaults.set( user_id ,  forKey: "user_id")
                            userDefaults.set( user_type ,  forKey: "user_type")
                            userDefaults.synchronize()
                            let value:String = userDefaults.string(forKey: "user_id")!
                            let usertype:String = userDefaults.string(forKey: "user_type")!
                            print("usertype = ",usertype  )
                            print("user_id = ",value  )
                            SVProgressHUD.dismiss()
                            
                            if user_type=="trainer"{
                                let vc = self.storyboard!.instantiateViewController(withIdentifier: "TrainerViewController") as! TrainerViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{
                                let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientHomeController") as! ClientHomeController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            
                        }
                        else{
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                    }
                }
        }
    }
    
    func LoginJsonCheck(jsonstring : [String:AnyObject], url : String) {
        print(jsonstring)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        
       /* Alamofire.request(url, method: .post, parameters: jsonstring, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Login= ",response)
                  //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                       
                     if (response.result.value as AnyObject).value(forKey: "is_error") as? NSNumber == 0 {
                            let user_type:String=(response.result.value as AnyObject).value(forKey: "user_type") as! String
                            let user_id=(response.result.value as AnyObject).value(forKey: "user_id") 
                            let userDefaults = Foundation.UserDefaults.standard
                            userDefaults.set( user_id ,  forKey: "user_id")
                            userDefaults.set( user_type ,  forKey: "user_type")
                            userDefaults.synchronize()
                            let value:String = userDefaults.string(forKey: "user_id")!
                            let usertype:String = userDefaults.string(forKey: "user_type")!
                            print("usertype = ",usertype  )
                            print("user_id = ",value  )
                            SVProgressHUD.dismiss()
                            
                            if user_type=="trainer"{
                                let vc = self.storyboard!.instantiateViewController(withIdentifier: "TrainerViewController") as! TrainerViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{
                                let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientHomeController") as! ClientHomeController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                           
                            
                        }
                        else{
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                    }
                }*/
              /*  //to get JSON return value
                     if let result = response.result.value {
                 let JSON = result as! NSDictionary
                 print("new result",JSON)
                 }
    }*/
    
}
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func didTapLogin(_ sender: Any) {
        
        self.CheckLogin()
    }
    
    @IBAction func DidTabTrainerBtn(_ sender: Any) {
        self.Trainer_btn.setBackgroundImage(UIImage(named :"Non_selected_image.png"), for: UIControlState.normal)
        self.Trainer_btn.setBackgroundImage(UIImage(named :"Selected_image.png"), for: UIControlState.normal)
        user_type="trainer"
        print(user_type)
        if IsFacebook {
           
            Trainer_select_view.isHidden=true
             print("FbDict",self.FbDict)
           let email: String = (self.FbDict["email"] as! String?)!
           let fbid: String = (self.FbDict["id"] as! String?)!
            let name: String = (self.FbDict["name"] as! String?)!
            let data = self.FbDict["picture"] as?[String:Any]
            let newdata = data!["data"] as? [String:Any]
            let picture:String = (newdata!["url"] as! String?)!
            print(picture)
            print(email)
            let profile_url:String="https://www.facebook.com/"+fbid
            print("fb details",self.FbDict)
            var Fbdetails:[String:AnyObject]=[:]
            print("fb details=",Fbdetails)
         Fbdetails = ["email" : email as AnyObject, "facebook_id" :fbid as AnyObject, "device_token" : "" as AnyObject ,"login_type" :"facebook"  as AnyObject,"name" :name as AnyObject,"fb_image" :picture as AnyObject,"fb_link" :profile_url as AnyObject,"user_type" :user_type as AnyObject ]
            print("Lattest details",Fbdetails)
self.facebookLoginJson(jsonString: Fbdetails, Url: "http://ogmaconceptions.com/demo/my_perfect_trainer/MyPerfectTrainerApp/facebookLogin")
        }
        else{
            LoginDict = ["email" : (txt_email.text)! as AnyObject, "password" : (txt_password.text)! as AnyObject, "device_token" : "" as AnyObject,"user_type" : "user_type" as AnyObject ]
            Trainer_select_view.isHidden=true
            self.LoginJsonCheck(jsonstring: LoginDict, url: "http://ogmaconceptions.com/demo/my_perfect_trainer/MyPerfectTrainerApp/login")
        }
        

    }
    
    @IBAction func DidTabClientBtn(_ sender: Any) {
        self.client_btn.setBackgroundImage(UIImage(named :"Selected_image.png"), for: UIControlState.normal)
        self.Trainer_btn.setBackgroundImage(UIImage(named :"Non_selected_image.png"), for: UIControlState.normal)
        user_type="client"
        print(user_type)
         Trainer_select_view.isHidden=true
        if IsFacebook {
            self.FbDict = ["user_type" : user_type as AnyObject ]
           print("FbDict",self.FbDict)
self.facebookLoginJson(jsonString: FbDict, Url: "http://ogmaconceptions.com/demo/my_perfect_trainer/MyPerfectTrainerApp/facebookLogin")        }
        else{
            LoginDict = ["email" : (txt_email.text)! as AnyObject, "password" : (txt_password.text)! as AnyObject, "device_token" : "" as AnyObject,"user_type" : "user_type" as AnyObject ]
            self.LoginJsonCheck(jsonstring: LoginDict, url: "http://ogmaconceptions.com/demo/my_perfect_trainer/MyPerfectTrainerApp/login")
        }



    }
   
    @IBAction func DidTabFacebookBtn(_ sender: Any) {
        
        let login: FBSDKLoginManager = FBSDKLoginManager()
        // Make login and request permissions
       login.logOut()
        login.logIn(withReadPermissions: ["email"], from: self, handler: {(result, error) -> Void in
           
            if error != nil {
                // Handle Error
           print(error!)
            } else if (result?.isCancelled)! {
                // If process is cancel
                NSLog("Cancelled")
            }
            else {
                // Parameters for Graph Request
                let parameters = ["fields": "email, name,picture,gender"]
                
                FBSDKGraphRequest(graphPath: "me", parameters: parameters).start {(connection, result, error) -> Void in
                    if error != nil {
                        NSLog(error.debugDescription)
                        return
                    }
                    
                    // Result
                   // print("Result: " ,result! )
               self.IsFacebook=true
                    self.FbDict=result! as! [String : AnyObject]
                    print("fb details",self.FbDict)
                    let email: String = (self.FbDict["email"] as! String?)!
                    print(email)
                    self.Trainer_select_view.isHidden=false
                    // Handle vars
                    
                   /*if let result = result as? [String:Any],
                        let email: String = result["email"] as! String?,
                        let fbId: String = result["id"] as! String?,
                     let name: String = result["name"] as! String?
                  
                    {
                        print("Email: \(email)")
                        print("fbID: \(fbId)")
                         print("fbID: \(name)")
                        print("fbID: \(name)")
                    }*/
                }
            }
        })
    }
    @IBAction func DidTabCreateAccountBtn(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

