//
//  ViewController.swift
//  MyPerfectTrainer
//
//  Created by Alok Das on 23/01/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire

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
            
        }
    }
    
    func LoginJsonCheck(jsonstring : [String:AnyObject], url : String) {
        Alamofire.request(url, method: .post, parameters: jsonstring, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Login= ",response)
                        let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        print(" Is error =",(response.result.value as AnyObject).value(forKey: "is_error" ) as! String )
                        if isError=="0"{
                            let user_id=(response.result.value as AnyObject).value(forKey: "user_id")
                            let userDefaults = Foundation.UserDefaults.standard
                            userDefaults.set( user_id ,  forKey: "user_id")
                            userDefaults.synchronize()
                            let value:String = userDefaults.string(forKey: "user_id")!
                            print("user_id = ",value  )
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientHomeController") as! ClientHomeController
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                    default:
                        print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                /*     if let result = response.result.value {
                 let JSON = result as! NSDictionary
                 print("new result",JSON)
                 }*/
    }
        
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
        LoginDict = ["email" : (txt_email.text)! as AnyObject, "password" : (txt_password.text)! as AnyObject, "device_token" : "" as AnyObject,"user_type" : "user_type" as AnyObject ]
        Trainer_select_view.isHidden=false
        self.LoginJsonCheck(jsonstring: LoginDict, url: "http://10.1.1.11/findmytrainer/FindMyTrainerApp/login")

    }
    
    @IBAction func DidTabClientBtn(_ sender: Any) {
        self.client_btn.setBackgroundImage(UIImage(named :"Selected_image.png"), for: UIControlState.normal)
        self.Trainer_btn.setBackgroundImage(UIImage(named :"Non_selected_image.png"), for: UIControlState.normal)
        user_type="client"
        print(user_type)
        LoginDict = ["email" : (txt_email.text)! as AnyObject, "password" : (txt_password.text)! as AnyObject, "device_token" : "" as AnyObject,"user_type" : user_type as AnyObject ]
        Trainer_select_view.isHidden=false
        self.LoginJsonCheck(jsonstring: LoginDict, url: "http://10.1.1.11/findmytrainer/FindMyTrainerApp/login")


    }
    @IBAction func DidTabCreateAccountBtn(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

