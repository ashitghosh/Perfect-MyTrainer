//
//  ClientMyScheduleController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 31/05/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SVProgressHUD
class ClientMyScheduleController: UIViewController,UITableViewDelegate,UITableViewDataSource,HADropDownDelegate {
    @IBOutlet var Schdule_table_view: UITableView!
    var  ArrSchduleList = [[String:AnyObject]]()
    
    var Selectedtag:NSInteger=0
    @IBOutlet var Booking_dropdown_backview: UIView!
    @IBOutlet var Schdule_confirm_backview: UIView!
    @IBOutlet var Cencel_btn: UIButton!
    @IBOutlet var Submit_btn: UIButton!
    @IBOutlet var End_time_drop_down: HADropDown!
    @IBOutlet var Start_time_dropdown: HADropDown!
    
    var Confirm:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func ClickForConfirmButton(sender:UIButton)
    {
        Selectedtag=(sender as AnyObject).tag
        print(Selectedtag)
        if ((self.ArrSchduleList[self.Selectedtag] as AnyObject).value(forKey: "is_new") as! NSNumber)==0{
            
//            let param=["client_id":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "client_id") as! NSNumber),"booking_id":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "id") as! NSNumber),"session_time":((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "session_time") as! NSNumber) ] as [String : Any]
            let vc = self.storyboard! .instantiateViewController(withIdentifier: "ClientSessionListController") as! ClientSessionListController
            vc.Booking_id=((self.ArrSchduleList[Selectedtag] as AnyObject).value(forKey: "id")) as! NSNumber
            
            self.navigationController?.pushViewController(vc, animated: true);
        }
        
        
        
        
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ArrSchduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SchedulelistCell! = tableView.dequeueReusableCell(withIdentifier: "SchedulelistCell") as! SchedulelistCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.Profile_image.CircleImageView(BorderColour: UIColor.black, Radious: 1.0)
        
        cell.Session_type_lbl.text = "Type: " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "booking_type") as! String)
        
        cell.name_lbl.text=(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "trainer") as AnyObject).value(forKey: "name") as! String)
        if ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "is_new") as! NSNumber)==1{
          //  cell.confirm_lbl.text="Confirm"
            cell.Reschdule_lbl.text="Not confirmed"
            cell.Schdule_back_Ground_lbl.layer.borderWidth = 2.0
            cell.Schdule_back_Ground_lbl.layer.borderColor = UIColor.init(colorLiteralRed: 55.0/255.0, green: 95.0/255, blue: 28.0/255.0, alpha: 1.0).cgColor
            // cell.Schdule_back_Ground_lbl.backgroundColor=UIColor.lightGray
            cell.Border_lbl.isHidden=true
            cell.Total_session_lbl.text = "Total session: " + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "remaining_session") as! NSInteger))
        }
        else{
           // cell.confirm_lbl.text="Add schedule"
            cell.Reschdule_lbl.text=" View"
            cell.Schdule_back_Ground_lbl.layer.borderWidth = 0.0
            cell.Schdule_back_Ground_lbl.layer.borderColor = UIColor.clear.cgColor
            cell.Schdule_back_Ground_lbl.backgroundColor=UIColor.white
            cell.Border_lbl.isHidden=false
            cell.Total_session_lbl.text = "Session left: " + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "remaining_session") as! NSInteger))
        }
        
        cell.Reschdule_btn.tag=indexPath.row
        cell.Reschdule_btn.addTarget(self,action:#selector(ClickForConfirmButton(sender:)),
                                     for:.touchUpInside)
      
        cell.Session_date_time_lbl.text = "Session date: " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "session_date") as! String) + " at " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "display_start_time") as! String) + " to " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "display_end_time") as! String)
        
        cell.Paid_lbl.text = "Total paid: $ " + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "total_price") as! NSInteger))
        
        cell.Session_time_lbl.text = "Session time: " + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "session_time") as! NSInteger))
        
        
        
        let url:String=(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "trainer") as AnyObject).value(forKey: "profile_image") as! String)
        
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
        let param=["client_id": User_id as AnyObject]
        let url=Constants.Client_url+"clientBookingList"
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
                            self.ArrSchduleList=((response.result.value as AnyObject).value(forKey: "List") as AnyObject) as! [[String : AnyObject]]
                            self.Schdule_table_view.reloadData()
                            
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
                            self.ArrSchduleList[self.Selectedtag]=(response.result.value as AnyObject) as! [String : AnyObject]
                            print("lattest schedule",self.ArrSchduleList)
                            self.Schdule_table_view.reloadData()
                            // self.FetchSchduleList()
                            
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



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidTabDrawerBtn(_ sender: Any) {
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
