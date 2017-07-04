//
//  TrainerScheduleListView.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 09/05/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
class TrainerScheduleListView: UIViewController,UITableViewDelegate,UITableViewDataSource,HADropDownDelegate {

    @IBOutlet var Schdule_table_view: UITableView!
    var  ArrSchduleList = [[String:AnyObject]]()
    
    var Selectedtag:NSInteger=0
    @IBOutlet var Booking_dropdown_backview: UIView!
    @IBOutlet var Schdule_confirm_backview: UIView!
    @IBOutlet var Cencel_btn: UIButton!
    @IBOutlet var Submit_btn: UIButton!
    @IBOutlet var End_time_drop_down: HADropDown!
    @IBOutlet var Start_time_dropdown: HADropDown!
    @IBOutlet var Chat_txt: UITextView!
    
    @IBOutlet var Message_back_view: UIView!
    @IBOutlet var Msg_submit_btn: UIButton!
    var Confirm:[String:Any] = [:]
    
    @IBOutlet var Msg_cancel_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
        self.Message_back_view.ViewRoundCorner(Roundview: self.Message_back_view, radious: 15.0)
        self.Msg_cancel_btn.ButtonRoundCorner(radious: 8.0)
        self.Msg_submit_btn.ButtonRoundCorner(radious: 8.0)
        self.Chat_txt.text = "Write your message"
        self.Chat_txt.layer.borderWidth=1.0
        self.Chat_txt.layer.borderColor=UIColor.black.cgColor
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.Schdule_confirm_backview.isHidden=true
        self.FetchSchduleList()
        self.Start_time_dropdown.delegate=self
        self.End_time_drop_down.delegate=self
        self.Booking_dropdown_backview.layer.cornerRadius=5.0
        self.Booking_dropdown_backview.clipsToBounds=true

    }
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView==self.Chat_txt{
        Chat_txt.text = ""
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView){
        if textView==self.Chat_txt{
        let triming = Chat_txt.text.trimmingCharacters(in: .whitespaces)
            if triming == ""{
            Chat_txt.text="Write your message"
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
        
        self.Chat_txt.inputAccessoryView = doneToolbar
    }
    func doneButtonAction() {
        self.Chat_txt.resignFirstResponder()
    }

    
    // MARK: - Table VIEW CELL BUTTON PRESS FUNCTIONALITY
    
    func ClickForConfirmButton(sender:UIButton)
    {
        Selectedtag=(sender as AnyObject).tag
        print(Selectedtag)
        if ((self.ArrSchduleList[self.Selectedtag] as AnyObject).value(forKey: "is_new") as! NSNumber)==1{
            //{"trainer_id":"12","client_id":"12","booking_id":"2", "date":"2017-05-21", "start_time":"06:00:00", "end_time":"10:00:00"}
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            Confirm  = ["trainer_id":User_id,"client_id":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "client_id") as! NSNumber),"booking_id":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "id") as! NSNumber),"date":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "session_date") as! String),"session_time":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "session_time") as! NSNumber) ] as [String : Any]
            print("Param=",Confirm)
            let Starttime:String=((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "slot_start_time") as! String)
            let Endtime:String=((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "slot_end_time") as! String)
            let arrstartTime=Starttime.components(separatedBy: ":")
            let arrEndTime=Endtime.components(separatedBy: ":")
            print(Starttime,Endtime)
            let Start=NSInteger(arrstartTime[0])
            let End=NSInteger(arrEndTime[0])
            print(Start!,End!)
            var arrdropdown = [String]()
            
            for  index in stride(from: Start!, to:  End!+1, by: 1){
                print("index",index)
                if index>=Start! || index<=End!{
                    if index>9{
                        let appendstring = String(index)
                        let finalString = appendstring + ":00:00"
                        let finalStringWithMin = appendstring + ":30:00"
                        arrdropdown.append(finalString)
                        arrdropdown.append(finalStringWithMin)
                    }
                    else{
                        let appendstring = String(index)
                        let finalString = "0" + appendstring + ":00:00"
                        let finalStringWithMin = "0" + appendstring + ":30:00"
                        arrdropdown.append(finalString)
                        arrdropdown.append(finalStringWithMin)
                    }
                    
                }
            }
         
            self.Start_time_dropdown.title=Starttime
             self.End_time_drop_down.title=Endtime
            self.Start_time_dropdown.items=arrdropdown
            self.End_time_drop_down.items=arrdropdown
            self.Schdule_confirm_backview.isHidden=false
            self.Message_back_view.isHidden=true
            self.Booking_dropdown_backview.isHidden=false
        }
        else{
            let param=["client_id":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "client_id") as! NSNumber),"booking_id":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "id") as! NSNumber),"session_time":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "session_time") as! NSNumber) ] as [String : Any]
            let vc = self.storyboard! .instantiateViewController(withIdentifier: "AddScheduleViewController") as! AddScheduleViewController
           vc.PassParameter=param
          self.navigationController?.pushViewController(vc, animated: true);
        }

       
    }
    
    
    func ClickForReschduleButton(sender:UIButton)
    {
         Selectedtag=(sender as AnyObject).tag
        print(Selectedtag)
        if ((self.ArrSchduleList[self.Selectedtag] as AnyObject).value(forKey: "is_new") as! NSNumber)==1{
            let param=["client_id":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "client_id") as! NSNumber),"booking_id":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "id") as! NSNumber),"session_time":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "session_time") as! NSNumber) ] as [String : Any]
            let vc = self.storyboard! .instantiateViewController(withIdentifier: "AddScheduleViewController") as! AddScheduleViewController
            vc.PassParameter=param
            
            self.navigationController?.pushViewController(vc, animated: true);
        }
        else{
            let vc = self.storyboard! .instantiateViewController(withIdentifier: "RescheduleViewController") as! RescheduleViewController
          //  vc.arrSchedule=((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "schedules")) as! [[String:AnyObject]]
            vc.Session_time=((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "session_time")) as! NSNumber
             vc.Booking_id=((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "id")) as! NSNumber
            self.navigationController?.pushViewController(vc, animated: true);
        }
        

        
    }
    
    func ClickForMessageButton(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        self.Chat_txt.text = "Write your message"
        self.Schdule_confirm_backview.isHidden=false
        self.Message_back_view.isHidden=false
        self.Booking_dropdown_backview.isHidden=true
        self.Confirm.removeAll()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
       self.Confirm["trainer_id"] = User_id
      self.Confirm["client_id"] = (ArrSchduleList[SelectedTag] as AnyObject).value(forKey: "client_id") as! NSNumber
        self.Confirm["send_by"] = "trainer"
        print("confirl dict",self.Confirm)
        
        
    }
    func labelMultiColor(getLabelName: UILabel,labelStr: String,Start_location:NSInteger,EndLocation:NSInteger) ->NSMutableAttributedString
    {
        let myString: String = labelStr
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSFontAttributeName:UIFont(name: "Georgia-Bold", size: 13.0)!])
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:12,length:8))
        getLabelName.attributedText = myMutableString
        return myMutableString
    }
    
// MARK : HADROPDOWN DATASOURCE AND DELEGATE METHOD
    
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        
        
    }
    
    // MARK : Table VIEW DATASOURCE AND DELEGATE METHOD
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ArrSchduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SchedulelistCell! = tableView.dequeueReusableCell(withIdentifier: "SchedulelistCell") as! SchedulelistCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.Profile_image.CircleImageView(BorderColour: UIColor.black, Radious: 1.0)
        
        
        
        cell.name_lbl.text=(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "client") as AnyObject).value(forKey: "name") as! String)
        if ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "is_new") as! NSNumber)==1{
            cell.Reschedule_image.image=UIImage.init(named: "reschedule-icon.png")
            cell.Message_imageview.image=UIImage.init(named: "message-icon.png")
            
       cell.confirm_lbl.text="Confirm"
       cell.Reschdule_lbl.text="Reschedule"
            cell.Schdule_back_Ground_lbl.layer.borderWidth = 0.0
            cell.Schdule_back_Ground_lbl.layer.borderColor = UIColor.clear.cgColor
            cell.Schdule_back_Ground_lbl.backgroundColor=UIColor.init(colorLiteralRed: 55.0/255.0, green: 94.0/255, blue: 111.0/255.0, alpha: 1.0)
           cell.Session_date_time_lbl.textColor=UIColor.white
            cell.Paid_lbl.textColor=UIColor.init(colorLiteralRed: 220.0/255.0, green: 102.0/255, blue: 24.0/255.0, alpha: 1.0)
            cell.Session_time_lbl.textColor=UIColor.init(colorLiteralRed: 220.0/255.0, green: 102.0/255, blue: 24.0/255.0, alpha: 1.0)
            cell.Total_session_lbl.textColor=UIColor.init(colorLiteralRed: 220.0/255.0, green: 102.0/255, blue: 24.0/255.0, alpha: 1.0)
            cell.Session_type_lbl.textColor=UIColor.init(colorLiteralRed: 220.0/255.0, green: 102.0/255, blue: 24.0/255.0, alpha: 1.0)
            cell.Reschdule_lbl.textColor=UIColor.white
            cell.confirm_lbl.textColor=UIColor.white
            cell.Message_lbl.textColor=UIColor.white
            cell.name_lbl.textColor=UIColor.white
           // cell.Schdule_back_Ground_lbl.layer.borderWidth = 2.0
           // cell.Schdule_back_Ground_lbl.layer.borderColor = UIColor.init(colorLiteralRed: 55.0/255.0, green: 95.0/255, blue: 28.0/255.0, alpha: 1.0).cgColor
            // cell.Schdule_back_Ground_lbl.backgroundColor=UIColor.lightGray
            cell.Border_lbl.isHidden=true
            let session_txt1:String=((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "display_session_date") as! String)
            let session_txt:String="Session date: " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "display_session_date") as! String) + " at " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "display_start_time") as! String) + " to " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "display_end_time") as! String)
            let myString: String = session_txt
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 11)])
            
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 220.0/255.0, green: 102.0/255.0, blue: 24.0/255.0, alpha: 1.0), range: NSRange(location:14,length:session_txt1.characters.count))
            cell.Session_date_time_lbl.attributedText = myMutableString
            
            let paid_txt:String = "Total paid: $" + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "total_price") as! NSInteger))
            
            myMutableString = NSMutableAttributedString(string: paid_txt, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 11)])
            
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:0,length:12))
            
            cell.Paid_lbl.attributedText =  myMutableString
            
            let session_time:String =  "Session time: " +  String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "session_time") as! NSInteger))
            
            myMutableString = NSMutableAttributedString(string: session_time, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 11)])
            
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:0,length:13))
            
            cell.Session_time_lbl.attributedText = myMutableString
            let total_session:String = "Total session: " + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "remaining_session") as! NSInteger))
            
            myMutableString = NSMutableAttributedString(string: total_session, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 11)])
            
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:0,length:14))
            
            cell.Total_session_lbl.attributedText=myMutableString
            
            let Type:String = "Type: " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "booking_type") as! String)
            
            myMutableString = NSMutableAttributedString(string: Type, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 11)])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:0,length:5))
            cell.Session_type_lbl.attributedText=myMutableString
        }
        else{
        cell.confirm_lbl.text="Add schedule"
         cell.Reschdule_lbl.text="View"
            cell.Schdule_back_Ground_lbl.layer.borderWidth = 0.0
            cell.Schdule_back_Ground_lbl.layer.borderColor = UIColor.clear.cgColor
            cell.Schdule_back_Ground_lbl.backgroundColor=UIColor.white
            cell.Border_lbl.isHidden=false
             cell.Total_session_lbl.text = "Session left: " + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "remaining_session") as! NSInteger))
            cell.Reschedule_image.image=UIImage.init(named: "Schedule_list_reschedule.png")
            cell.Message_imageview.image=UIImage.init(named: "schdulelist_message.png")
            cell.Session_date_time_lbl.textColor=UIColor.black
            cell.Paid_lbl.textColor=UIColor.black
            cell.Session_time_lbl.textColor=UIColor.black
            cell.Total_session_lbl.textColor=UIColor.black
            cell.Session_type_lbl.textColor=UIColor.black
             cell.Reschdule_lbl.textColor=UIColor.black
             cell.confirm_lbl.textColor=UIColor.black
             cell.Message_lbl.textColor=UIColor.black
            cell.name_lbl.textColor=UIColor.black
            cell.Session_date_time_lbl.text="Session date: " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "display_session_date") as! String) + " at " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "display_start_time") as! String) + " to " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "display_end_time") as! String)
            
            cell.Paid_lbl.text = "Total paid: $" + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "total_price") as! NSInteger))
            
            cell.Session_time_lbl.text =  "Session time: " +  String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "session_time") as! NSInteger))
            
            cell.Total_session_lbl.text = "Total session: " + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "remaining_session") as! NSInteger))
             cell.Session_type_lbl.text = "Type: " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "booking_type") as! String)

        }
       
        cell.Confirm_btn.tag=indexPath.row
        cell.Confirm_btn.addTarget(self,action:#selector(ClickForConfirmButton(sender:)),
                                        for:.touchUpInside)
        cell.message_btn.tag=indexPath.row
        cell.message_btn.addTarget(self,action:#selector(ClickForMessageButton(sender:)),
                                   for:.touchUpInside)
        cell.Reschdule_btn.tag=indexPath.row
        cell.Reschdule_btn.addTarget(self,action:#selector(ClickForReschduleButton(sender:)),
                                   for:.touchUpInside)
        
       
          cell.Profile_image.image = UIImage.gif(name: "Waiting_image_gif")
        let url:String=(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "client") as AnyObject).value(forKey: "profile_image") as! String)
        
        Alamofire.request(url).responseImage { response in
           // debugPrint(response)
            
            
           // debugPrint(response.result)
            
            if let image = response.result.value {
               // print("image downloaded: \(image)")
                cell.Profile_image.image=image
            }
        }

        
               return cell
    }
    
  // MARK: - for Webservice
    
    func FetchSchduleList()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        let param=["trainer_id": User_id as AnyObject]
        let url=Constants.Base_url+"bookingScheduleByUser"
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
                            self.ArrSchduleList.removeAll()
                            self.ArrSchduleList=((response.result.value as AnyObject).value(forKey: "List") as AnyObject) as! [[String : AnyObject]]
                            self.Schdule_table_view.reloadData()
                            
                        }
                            
                        else{
                            
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                         SVProgressHUD.dismiss()
                    }
                }
                //to get JSON return value
                /*     if let result = response.result.value {
                 let JSON = result as! NSDictionary
                 print("new result",JSON)
                 }*/
                
        }
    }

    func ConfirmScheduleAdd(ConfirmDict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let url=Constants.Base_url+"addBookingSchedule"
        Alamofire.request(url, method: .post, parameters: ConfirmDict, encoding: JSONEncoding.default)
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
                            //self.ArrSchduleList[self.Selectedtag]=(response.result.value as AnyObject) as! [String : AnyObject]
                           // print("lattest schedule",self.ArrSchduleList)
                            
                           // self.Schdule_table_view.reloadData()
                            self.FetchSchduleList()
                           // self.FetchSchduleList()
                            
                        }
                            
                        else{
                            if( response.result.value as AnyObject).value(forKey: "status") as? NSNumber==1{
                            self.presentAlertWithTitle(title: "Alert", message:( response.result.value as AnyObject).value(forKey: "err_msg") as! String )
                            }
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

    func ConfirmMessageSend(MessageDict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let url=Constants.Client_url+"sendMessage"
        Alamofire.request(url, method: .post, parameters: MessageDict, encoding: JSONEncoding.default)
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
                            //self.ArrSchduleList[self.Selectedtag]=(response.result.value as AnyObject) as! [String : AnyObject]
                            
                            
                        }
                            
                        else{
                            if( response.result.value as AnyObject).value(forKey: "status") as? NSNumber==1{
                                self.presentAlertWithTitle(title: "Alert", message:( response.result.value as AnyObject).value(forKey: "err_msg") as! String )
                            }
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

    
    
    @IBAction func DidTabDrawerBtn(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }

    @IBAction func DidTabSubmitBtn(_ sender: Any) {
        self.Schdule_confirm_backview.isHidden=true
        var arrstart=self.Start_time_dropdown.title.components(separatedBy: ":")
        var arrEnd=self.End_time_drop_down.title.components(separatedBy: ":")
        
        let start = NSInteger(arrstart[0])
        let end = NSInteger(arrEnd[0])
         let schdule_time = (end!-start!)*60
        
        arrstart[1] = arrstart[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        arrEnd[1] = arrEnd[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let startMin = NSInteger(arrstart[1])
        let endMin = NSInteger(arrEnd[1])
        let schdule_time_min:NSInteger?
        if startMin!>endMin!{
            schdule_time_min = (startMin!-endMin!)
        }
        else{
            schdule_time_min = (endMin!-startMin!)
        }
        let final_time = schdule_time + schdule_time_min!
        print("Final min",final_time)

        let original_schdule_time=NSInteger(Confirm["session_time"] as! NSNumber)
        if final_time != original_schdule_time{
        self.presentAlertWithTitle(title: "Alert", message: "Schedule time should be same as session time")
        }
        else{
        Confirm["start_time"] = self.Start_time_dropdown.title
        Confirm["end_time"] = self.End_time_drop_down.title
            print("Final dict",self.Confirm)
            self.ConfirmScheduleAdd(ConfirmDict: Confirm)
            
        }
        
        
    }
    @IBAction func DidTabCancelBtn(_ sender: Any) {
         self.Schdule_confirm_backview.isHidden=true
    }
    @IBAction func DidTabMyScheduleBtn(_ sender: Any) {
        let vc=self.storyboard!.instantiateViewController(withIdentifier: "MySchduleController") as! MySchduleController
        vc.IsNotComeFromDrawer=true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    @IBAction func DidTabMessageSubmitBtn(_ sender: Any) {
        Chat_txt.text=Chat_txt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if Chat_txt.text == "" || Chat_txt.text == "Write your message"{
            self.presentAlertWithTitle(title: "Alert", message: "Write your message")
        }
        else{
        self.Schdule_confirm_backview.isHidden=true
            self.Confirm["message"] = self.Chat_txt.text
            self.ConfirmMessageSend(MessageDict: self.Confirm)
            
        }
        
    }
    
     @IBAction func DidTabMsgCancelBtn(_ sender: Any) {
        self.Schdule_confirm_backview.isHidden=true
        
     }
   /* // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
