//
//  SignUpViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 24/01/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class SignUpViewController: UIViewController ,UITextFieldDelegate{

    var user_type = "trainer"
    var messgae = ""
    var signUpDict:[String:AnyObject] = [:]
    
    
    @IBOutlet var signning_lbl: UILabel!
    @IBOutlet var ClientBtn: UIButton!
    @IBOutlet var CreateBtn: UIButton!
    @IBOutlet var Password_view: UIView!
    @IBOutlet var Email_view: UIView!
    @IBOutlet var Fullname_view: UIView!
    @IBOutlet var Password_txt: UITextField!
    @IBOutlet var Email_txt: UITextField!
    @IBOutlet var FullName_txt: UITextField!
    @IBOutlet var Trainer_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.Trainer_btn.setBackgroundImage(UIImage(named :"Selected_image.png"), for: UIControlState.normal)
       self.viewCorner(getViewName: Password_view, GetBtnName: (nil))
        self.viewCorner(getViewName: Email_view, GetBtnName: (nil))
        self.viewCorner(getViewName: Fullname_view, GetBtnName: self.CreateBtn)
        self.labelMultiColor(getLabelName:signning_lbl)
        self.textplaceholderColor(getTextName: Email_txt, getplaceholderText: "Email")
        self.textplaceholderColor(getTextName: Password_txt, getplaceholderText: "Password")
        self.textplaceholderColor(getTextName: FullName_txt, getplaceholderText: "Fullname")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
             view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var done:Bool=false
        if textField==FullName_txt{
            done=false
            Email_txt.becomeFirstResponder()
        }

        if textField==Email_txt{
            done=false
            Password_txt.becomeFirstResponder()
        }
        else if textField==Password_txt{
            textField.resignFirstResponder()
            done=true
        }
        
        return done
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField==Email_txt{
        self.animateViewMoving(up: true, moveValue: 150.0)
        }
        else if textField==Password_txt{
        self.animateViewMoving(up: true, moveValue: 200.0)
        }
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField==Email_txt{
            self.animateViewMoving(up: false, moveValue: 150.0)
        }
        else if textField==Password_txt{
            self.animateViewMoving(up: false, moveValue: 200.0)
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
    func CheckRegistration (){
        view.endEditing(true)

        if FullName_txt.text=="" {
            
            self.ShowAlert(MessageName: "Please write your name")
        }
        else if Email_txt.text==""{
            self.ShowAlert(MessageName: "Please write your email")

        }
        else if !self.isValidEmail(testStr: Email_txt.text! ){
            self.ShowAlert(MessageName: "Please write valid email")
            
        }
        else if Password_txt.text==""{
            self.ShowAlert(MessageName: "Please write your password")
    
        }
        else{
            signUpDict = ["name" : (FullName_txt.text)! as AnyObject, "password" : (Password_txt.text)! as AnyObject,"email":Email_txt.text as AnyObject,"user_type":user_type as AnyObject, "device_token" : "" as AnyObject ]
            
            
            /* signUpDict=["email":Email_txt.text as AnyObject,"password":Password_txt.text as AnyObject,"full_name":FullName_txt.text as AnyObject,"user_type":user_type as AnyObject]*/
            
            print("signup dict",signUpDict)
            self.SignUpJson(jsonstring: signUpDict, url: "http://ogmaconceptions.com/demo/my_perfect_trainer/MyPerfectTrainerApp/registration")
            
        /*    let poststring = ""
            if let json = try? JSONSerialization.data(withJSONObject: signUpDict, options: []) {
                if let postString = String(data: json, encoding: String.Encoding.utf8) {
                    // here `content` is the JSON dictionary containing the String
                    print(postString)
                }
            }
            var request = URLRequest(url: URL(string:"http://aggdirect.com/aggdirect/customer_login")!)
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
            }
            task.resume()*/
            
                    }
        
    }
    func SignUpJson(jsonstring : [String:AnyObject],url:String)  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
    
        Alamofire.request(url, method: .post, parameters: jsonstring, encoding: JSONEncoding.default)
            .responseJSON { response in
              
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Sign Up= ",response)
                        SVProgressHUD.dismiss()
                        if( response.result.value as AnyObject).value(forKey: "status") as? NSNumber==0{
                             let Is_profile:String=(response.result.value as AnyObject).value(forKey: "is_profile_complete") as! String
                            let user_type:String=(response.result.value as AnyObject).value(forKey: "user_type") as! String
                            let user_id=(response.result.value as AnyObject).value(forKey: "user_id") 
                            let userDefaults = Foundation.UserDefaults.standard
                            userDefaults.set( user_id ,  forKey: "user_id")
                             userDefaults.set( user_type ,  forKey: "user_type")
                            userDefaults.synchronize()
                            let value:String = userDefaults.string(forKey: "user_id")!
                            print("user_id = ",value  )
                            if user_type=="trainer"{
                                if Is_profile=="N"{
                                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "TrainerCreateController") as! TrainerCreateController
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else{
                                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "TrainerAboutController") as! TrainerAboutController
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                
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
                //to get JSON return value
           /*     if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print("new result",JSON)
                }*/
                
        }
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
    func labelMultiColor(getLabelName: UILabel)
    {
        let myString: String = "By signing up you agree to our Terms & condition and Privacy policy"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSFontAttributeName:UIFont(name: "Georgia-Bold", size: 13.0)!])
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:26,length:18))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:52,length:15))
        getLabelName.attributedText = myMutableString
    }
    func textplaceholderColor(getTextName: UITextField, getplaceholderText: String){
        
        getTextName.attributedPlaceholder = NSAttributedString(string: getplaceholderText,
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
    }

    
    @IBAction func DidTabCreateAccountBtn(_ sender: Any) {
       self.CheckRegistration()
    }
    @IBAction func DidTabClientBtn(_ sender: Any) {
        self.ClientBtn.setBackgroundImage(UIImage(named :"Selected_image.png"), for: UIControlState.normal)
        self.Trainer_btn.setBackgroundImage(UIImage(named :"Non_selected_image.png"), for: UIControlState.normal)
        user_type="client"
        print(user_type)
    }
    @IBAction func DidTabTrainerBtn(_ sender: Any) {
        self.ClientBtn.setBackgroundImage(UIImage(named :"Non_selected_image.png"), for: UIControlState.normal)
        self.Trainer_btn.setBackgroundImage(UIImage(named :"Selected_image.png"), for: UIControlState.normal)
       user_type="trainer"
        print(user_type)
    }
    
    @IBAction func DidTabBackBtn(_ sender: Any) {
self.navigationController! .popViewController(animated: true)
    
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
