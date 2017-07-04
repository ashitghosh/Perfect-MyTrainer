//
//  MessageViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 12/06/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var Reply_back_view: UIView!

    @IBOutlet var Reply_view: UIView!
    @IBOutlet var Reply_cancel_btn: UIButton!
    @IBOutlet var Reply_txt: UITextView!
    @IBOutlet var Reply_submit_btn: UIButton!
    var arrmessageList = [[String:AnyObject]]()
    var IsNotComeFromClient=false
   var select_tag:NSInteger=0
    
    @IBOutlet var No_message_available: UILabel!
    @IBOutlet var Messagelist_tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.Reply_view.ViewRoundCorner(Roundview: self.Reply_view, radious: 8.0)
        self.Reply_submit_btn.ButtonRoundCorner(radious: 5.0)
        self.Reply_cancel_btn.ButtonRoundCorner(radious: 5.0)
        self.Reply_back_view.isHidden=true
        self.addDoneButtonOnKeyboard()
        self.Reply_txt.text="Write your message"
        self.Reply_txt.layer.borderWidth=2.0
        self.Reply_txt.layer.borderColor=UIColor.black.cgColor
        self.Reply_txt.layer.cornerRadius=8.0
        self.Reply_txt.clipsToBounds=true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.FetchMessageList()
    }

    func textViewDidBeginEditing(_ textView: UITextView){
        if textView==self.Reply_txt{
            Reply_txt.text = ""
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView){
        if textView==self.Reply_txt{
            let triming = Reply_txt.text.trimmingCharacters(in: .whitespaces)
            if triming == ""{
                Reply_txt.text="Write your message"
            }
        }
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
        
        self.Reply_txt.inputAccessoryView = doneToolbar
    }
    func doneButtonAction() {
        self.Reply_txt.resignFirstResponder()
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.Reply_btn.tag=indexPath.row
        cell.View_btn.tag=indexPath.row
        cell.Reply_btn.addTarget(self,action:#selector(ClickForMessageReplyBtn(sender:)),
                                   for:.touchUpInside)
        cell.View_btn.addTarget(self,action:#selector(ClickForMessageViewBtn(sender:)),
                                 for:.touchUpInside)
        
          cell.Profile_image.CircleImageView(BorderColour: UIColor.gray, Radious: 1.0)
        
        cell.Name_lbl.text=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "user_name") as? String
        cell.message_lbl.text=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "message") as? String
        cell.time_lbl.text=(self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "time_diff") as? String
        let url:String=((self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "user_photo") as? String)!
        if( self.arrmessageList[indexPath.row] as AnyObject).value(forKey: "is_read") as? NSNumber==0{
        cell.message_lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        else{
        cell.message_lbl.font = UIFont.systemFont(ofSize: 13.0)
        }
        cell.selectionStyle = .none
        Alamofire.request(url).responseImage { response in
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
    func ClickForMessageReplyBtn(sender:UIButton)
    {
        self.select_tag=(sender as AnyObject).tag
        print(self.select_tag)
        self.Reply_txt.text="Write your message"
        self.Reply_back_view.isHidden=false
        
       /* let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        self.Confirm["trainer_id"] = User_id
        self.Confirm["client_id"] = (ArrSchduleList[SelectedTag] as AnyObject).value(forKey: "client_id") as! NSNumber
        self.Confirm["send_by"] = "trainer"*/
        
        
    }
    
    
    //MARK:- For Webservice calling*****************************++++++++++++++++++++++++++
    func FetchMessageList()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        var param:[String:Any]=[:]
        var url:String = ""
        if self.IsNotComeFromClient==true{
         param=["trainer_id": User_id as AnyObject]
            url=Constants.Base_url+"trainerMessageList"
        }
        else{
         param=["client_id": User_id as AnyObject]
        url=Constants.Client_url+"clientMessageList"
        }
        
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
                            self.Messagelist_tableview.isHidden=false
                            self.No_message_available.isHidden=true
                            self.Messagelist_tableview.reloadData()
                            
                        }
                            
                        else{
                            self.Messagelist_tableview.isHidden=true
                            self.No_message_available.isHidden=false
                            self.No_message_available.text="Inbox is empty"
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
                          self.FetchMessageList()
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


    
    func ClickForMessageViewBtn(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let trainer_id:String=String(describing: ((arrmessageList[SelectedTag] as AnyObject).value(forKey: "trainer_id"))as! NSNumber)
         let client_id:String=String(describing: ((arrmessageList[SelectedTag] as AnyObject).value(forKey: "client_id"))as! NSNumber)
        print("",trainer_id,client_id)
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MessageDetailController") as! MessageDetailController
        vc.client_id=client_id
        vc.traine_id=trainer_id
        if self.IsNotComeFromClient==true{
        vc.IsClient=false
        }
        else{
        vc.IsClient=true
        }
        self.navigationController!.pushViewController(vc, animated: true)
        
        
    }
    

    @IBAction func DidTabReplySubmitBtn(_ sender: Any) {
        
        self.Reply_txt.text=self.Reply_txt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if self.Reply_txt.text == "" || self.Reply_txt.text == "Write your message"{
            self.presentAlertWithTitle(title: "Alert", message: "Write your message")
        }
        else{
            self.Reply_back_view.isHidden=true
            if self.IsNotComeFromClient==true{
               
                let param=["trainer_id":(((self.arrmessageList[self.select_tag] as AnyObject).value(forKey: "trainer_id")) as! NSNumber),"client_id":(((self.arrmessageList[self.select_tag] as AnyObject).value(forKey: "client_id")) as! NSNumber), "send_by":"trainer","message":self.Reply_txt.text] as [String : Any]
                print("param",param)
                self.SendToReply(ReplyDict: param)
            }
                
            else{
                let param=["trainer_id":(((self.arrmessageList[self.select_tag] as AnyObject).value(forKey: "trainer_id")) as! NSNumber),"client_id":(((self.arrmessageList[self.select_tag] as AnyObject).value(forKey: "client_id")) as! NSNumber), "send_by":"client","message":self.Reply_txt.text] as [String : Any]
              
                print("param",param)
                self.SendToReply(ReplyDict: param)
            }
            
        }

        
        
    }
    
    @IBAction func DidTabReplyCancelBtn(_ sender: Any) {
        self.Reply_back_view.isHidden=true
    }

    @IBAction func DidTabReplyViewHideBtn(_ sender: Any) {
        self.Reply_back_view.isHidden=true
    }
    @IBAction func DidTabDrawerButton(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
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
