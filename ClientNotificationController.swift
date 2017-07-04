//
//  ClientNotificationController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 20/06/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
class ClientNotificationController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Message_detail_tableview: UITableView!
    @IBOutlet var Chat_txt: UITextField!
    var traine_id:String=""
    var client_id:String=""
    var IsClient:Bool = false
    
    @IBOutlet var No_notification_lbl: UILabel!
    var arrmessageList = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
       // self.FetchMessageList()
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
        
        cell.message_lbl.text=((self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "user_name") as? String)! + " " + ((self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "message") as? String)!
        cell.time_lbl.text=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "time_diff") as? String
        if( self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "is_read") as? NSNumber==0{
            cell.message_lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        else{
            cell.message_lbl.font = UIFont.systemFont(ofSize: 13.0)
        }
        let url:String?
        url=((self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "user_photo") as? String)!
        cell.Name_lbl.text=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "user_name") as? String
        
        
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
        let type:String=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "type") as! String
        if type=="message" {
            let trainer_id:String=String(describing: ((arrmessageList[indexPath.row] as AnyObject).value(forKey: "trainer_id"))as! NSNumber)
            let client_id:String=String(describing: ((arrmessageList[indexPath.row] as AnyObject).value(forKey: "client_id"))as! NSNumber)
            print("",trainer_id,client_id)
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "MessageDetailController") as! MessageDetailController
            vc.client_id=client_id
            vc.traine_id=trainer_id
            vc.IsClient = true
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else{
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientMyScheduleController") as! ClientMyScheduleController
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure want to delete", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
            if editingStyle == .delete {
                print("Deleted")
                let noti_id:String=String(describing: ((self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "id") as! NSNumber))
                print("",noti_id);
                let param = ["notification_id":noti_id]
                self.NotificationDelete(Notidict: param);
                self.arrmessageList.remove(at: indexPath.row)
                self.Message_detail_tableview.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
        let NoAction = UIAlertAction(title: "No", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK:- Web service class calling+++++++++++++++++++++++++++*****************************
    
    
    
    func FetchMessageList()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        let param=["client_id": User_id as AnyObject]
        let url=Constants.Client_url+"clientNotificationList"
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
                            self.arrmessageList=(response.result.value as AnyObject).value(forKey: "notification") as! [[String:AnyObject]]
                            self.Message_detail_tableview.reloadData()
                            self.No_notification_lbl.isHidden=true
                            self.Message_detail_tableview.isHidden=false
                        }
                            
                        else{
                            self.No_notification_lbl.isHidden=false
                            self.Message_detail_tableview.isHidden=true
                            self.No_notification_lbl.text="No notification are available"
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
    func NotificationDelete(Notidict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let url=Constants.Client_url+"deleteNotification"
        Alamofire.request(url, method: .post, parameters: Notidict, encoding: JSONEncoding.default)
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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.FetchMessageList()
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func DidTabDrawerBtn(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }

    }
}
