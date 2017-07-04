//
//  MessageDetailController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 16/06/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import SVProgressHUD
import AlamofireImage
import Alamofire

class MessageDetailController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet var Message_detail_tableview: UITableView!
    @IBOutlet var Chat_txt: UITextField!
    var traine_id:String=""
    var client_id:String=""
    var IsClient:Bool = false
    
    var arrmessageList = [[String:AnyObject]]() 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.Chat_txt.attributedPlaceholder = NSAttributedString(string: "Type here",
                     
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.black])
        if self.IsClient==false{
        self.FetchMessageList()
        }
        else{
        self.FetchMessageListByClient()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateViewMoving(up: true, moveValue: 250.0)
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
         self.animateViewMoving(up: false, moveValue: 250.0)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrmessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CommentCell! = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        cell.Profile_image.layoutIfNeeded()
        cell.Profile_image.layer.borderWidth = 1.0
        cell.Profile_image.layer.masksToBounds = true
        cell.Profile_image.layer.borderColor = UIColor.black.cgColor
        cell.Profile_image.layer.cornerRadius = cell.Profile_image.frame.size.width/2
        cell.Profile_image.clipsToBounds = true
        
        cell.Profile_image.CircleImageView(BorderColour: UIColor.gray, Radious: 1.0)
        
        cell.message_lbl.text=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "message") as? String
        cell.time_lbl.text=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "time_diff") as? String
        let send_by=((self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "send_by") as? String)!
        let url:String?
        if send_by=="client"{
       url=((self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "client_photo") as? String)!
            cell.Name_lbl.text=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "client_name") as? String
        }
        else{
         url=((self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "trainer_photo") as? String)!
            cell.Name_lbl.text=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "trainer_name") as? String
        }
        
        
        cell.selectionStyle = .none
        Alamofire.request(url!).responseImage { response in
            //debugPrint(response)
            
            
            // debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                cell.Profile_image.image=image
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // MARK:- Web service class calling+++++++++++++++++++++++++++*****************************
    
    
    
    func FetchMessageList()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let param=["trainer_id": self.traine_id as AnyObject,"client_id": self.client_id as AnyObject]
        let url=Constants.Base_url+"trainerMessageThread"
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Sign Up= ",response)
                        SVProgressHUD.dismiss()
                        if( response.result.value as AnyObject).value(forKey: "status") as? NSNumber==0{
                            SVProgressHUD.dismiss()
                            self.arrmessageList=(response.result.value as AnyObject).value(forKey: "messages") as! [[String:AnyObject]]
                            self.Message_detail_tableview.reloadData()
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
    
    func FetchMessageListByClient()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let param=["trainer_id": self.traine_id as AnyObject,"client_id": self.client_id as AnyObject]
        let url=Constants.Client_url+"clientMessageThread"
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Sign Up= ",response)
                        SVProgressHUD.dismiss()
                        if( response.result.value as AnyObject).value(forKey: "status") as? NSNumber==0{
                            SVProgressHUD.dismiss()
                            self.arrmessageList=(response.result.value as AnyObject).value(forKey: "messages") as! [[String:AnyObject]]
                            self.Message_detail_tableview.reloadData()
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

    
    func SendToReply(ReplyDict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let url=Constants.Client_url+"sendMessage"
        Alamofire.request(url, method: .post, parameters: ReplyDict, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Sign Up= ",response)
                        SVProgressHUD.dismiss()
                        if( response.result.value as AnyObject).value(forKey: "status") as? NSNumber==0{
                            SVProgressHUD.dismiss()
                           /* let date = NSDate()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd/MM/yyyy"
                            let result = formatter.string(from: date as Date)
                            // *** create calendar object ***
                            var calendar = NSCalendar.current
                            
                            // *** Get components using current Local & Timezone ***
                            print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date))
                            
                            // *** define calendar components to use as well Timezone to UTC ***
                            let unitFlags = Set<Calendar.Component>([.hour, .year, .minute])
                            calendar.timeZone = TimeZone(identifier: "UTC")!
                            
                            // *** Get All components from date ***
                            let components = calendar.dateComponents(unitFlags, from: date as Date)
                            print("All Components : \(components)")
                            
                            // *** Get Individual components from date ***
                            let hour = calendar.component(.hour, from: date as Date)
                            let minutes = calendar.component(.minute, from: date as Date)
                            let seconds = calendar.component(.second, from: date as Date)
                            print("\(hour):\(minutes):\(seconds)")
                            let date_time:String = result + " at " + String(hour) + ":" + String(minutes) + ":" + String(seconds)*/
                            
                            var param=self.arrmessageList[0] as [String:AnyObject]
                            
                            param["message"]=self.Chat_txt.text as AnyObject?
                            param["time_diff"]="just a seconds ago" as AnyObject?
                            if self.IsClient==true{
                            param["send_by"] = "client" as AnyObject?
                            }
                            else{
                             param["send_by"] = "trainer" as AnyObject?
                            }
                            print("param",param)
                            self.arrmessageList.append(param)
                            self.Message_detail_tableview.reloadData()
                            self.scrollToBottom()
                            self.Chat_txt.text="";
                            
                        }
                            
                        else{
                            
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        SVProgressHUD.dismiss()
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

    
    func scrollToBottom(){
        DispatchQueue.global(qos: .background).async {
            let indexPath = IndexPath(row: self.arrmessageList.count-1, section: 0)
            self.Message_detail_tableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    @IBAction func DidTAbBackBtn(_ sender: Any) {
      self.navigationController!.popViewController(animated: true)
    }

    @IBAction func DidTabMessagesend(_ sender: Any) {
        self.view.endEditing(true)
        let trimmedString = Chat_txt.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedString == ""
        {
        self.presentAlertWithTitle(title: "Alert", message: "type your message")
        
        }
        
        else{
            if self.IsClient==true {
                let param=["trainer_id":self.traine_id,"client_id":self.client_id,"send_by":"client","message":trimmedString]
                self.SendToReply(ReplyDict: param)
            }
            else{
                let param=["trainer_id":self.traine_id,"client_id":self.client_id,"send_by":"trainer","message":trimmedString]
                self.SendToReply(ReplyDict: param)
            }
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
