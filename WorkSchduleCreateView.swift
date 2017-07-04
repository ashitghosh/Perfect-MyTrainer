//
//  WorkSchduleCreateView.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 07/04/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
class WorkSchduleCreateView: UIViewController,HADropDownDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var No_schdule_lbl: UILabel!
    @IBOutlet var StarTime_border_lbl: UILabel!
    @IBOutlet var Endtime_border_lbl: UILabel!
    @IBOutlet var Day_border_lbl: UILabel!
    @IBOutlet var WorkSchduleTableview: UITableView!
    @IBOutlet var StartTime_select_lbl: UILabel!
    @IBOutlet var starttime_dropdown_image: UIImageView!
    @IBOutlet var Endtime_dropdown_image: UIImageView!
    @IBOutlet var Endtime_select_lbl: UILabel!
    @IBOutlet var Day_dropdown_image: UIImageView!
    @IBOutlet var Day_select_lbl: UILabel!
    @IBOutlet var EndTimeDropDown: HADropDown!
    @IBOutlet var StartTime_Dropdown: HADropDown!
    @IBOutlet var DayDropDown: HADropDown!
    var WorkSchduleDict:[String:AnyObject] = [:]
    var arrWorkSchdule = [[String:AnyObject]]()
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            if self.arrWorkSchdule.isEmpty==true{
            self.WorkSchduleTableview.isHidden=true
                self.No_schdule_lbl.isHidden=false
            }
            else{
                self.WorkSchduleTableview.isHidden=false
                self.No_schdule_lbl.isHidden=true
            }
            
            DayDropDown.delegate=self
            StartTime_Dropdown.delegate=self
            EndTimeDropDown.delegate=self
DayDropDown.items=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            DayDropDown.font=UIFont.systemFont(ofSize: 12.0)
             StartTime_Dropdown.font=UIFont.systemFont(ofSize: 12.0)
             EndTimeDropDown.font=UIFont.systemFont(ofSize: 12.0)
     DayDropDown.titleColor=UIColor.white
     StartTime_Dropdown.titleColor=UIColor.white
     EndTimeDropDown.titleColor=UIColor.white
         StartTime_Dropdown.items=["5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00"]
            EndTimeDropDown.items=["5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00"]
            DayDropDown.title=""
            StartTime_Dropdown.title=""
            EndTimeDropDown.title=""
            self.FetchWorkSchdule()
            
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
          self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
   
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        if dropDown==DayDropDown{
            
            Day_select_lbl.isHidden=true
            Day_dropdown_image.isHidden=true
            Day_border_lbl.isHidden=true
           
        
        }
        if dropDown==StartTime_Dropdown{
            starttime_dropdown_image.isHidden=true
            StartTime_select_lbl.isHidden=true
            StarTime_border_lbl.isHidden=true
            
        }

        if dropDown==EndTimeDropDown{
            Endtime_select_lbl.isHidden=true
            Endtime_dropdown_image.isHidden=true
            Endtime_border_lbl.isHidden=true
            
        }

    }

    @IBAction func DidTabAddWorkSchdule(_ sender: Any) {
        if DayDropDown.title==""{
        self.presentAlertWithTitle(title: "Select Your Day", message: "Alert")
        }
       else if StartTime_Dropdown.title==""{
            self.presentAlertWithTitle(title: "Select Your Start Time", message: "Alert")
        }
        else if EndTimeDropDown.title==""{
            self.presentAlertWithTitle(title: "Select Your End Time", message: "Alert")
        }
            
            
        else{
            
            var Stattime = StartTime_Dropdown.title.components(separatedBy: ":")
            
            let CompareStattime = Stattime[0] // First
            
           var EndTime = EndTimeDropDown.title.components(separatedBy: ":")
            
            let CompareEndTime = EndTime[0] // First
            let myStartime = Int(CompareStattime)
            let myEndtime = Int(CompareEndTime)
            
            if myStartime!>myEndtime!{
            self.presentAlertWithTitle(title: "Select A Valid Schdule Time", message: "Alert")
            }
                
            else{
                let userDefaults = Foundation.UserDefaults.standard
                let User_id:String = userDefaults.string(forKey: "user_id")!
                WorkSchduleDict=["trainer_id": User_id as AnyObject,"day": DayDropDown.title as AnyObject,"start_time": StartTime_Dropdown.title as AnyObject,"end_time": EndTimeDropDown.title as AnyObject]
                print(WorkSchduleDict)
                let url=Constants.Base_url+"insertTrainerWorkSchedule"
                print(url)
                //self.arrWorkSchdule.append(WorkSchduleDict)
                self.CreateWorkSchdule(jsonstring: WorkSchduleDict, url: url)
                WorkSchduleTableview.reloadData()
                Day_select_lbl.isHidden=false
                Day_dropdown_image.isHidden=false
                Day_border_lbl.isHidden=false
                starttime_dropdown_image.isHidden=false
                StartTime_select_lbl.isHidden=false
                StarTime_border_lbl.isHidden=false
                Endtime_select_lbl.isHidden=false
                Endtime_dropdown_image.isHidden=false
                Endtime_border_lbl.isHidden=false
                DayDropDown.title=""
                StartTime_Dropdown.title=""
                EndTimeDropDown.title=""

            
            }
            
        }
        
        
    }
    func CreateWorkSchdule(jsonstring : [String:AnyObject],url:String)  {
        
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
                            self.arrWorkSchdule.removeAll()
                            self.arrWorkSchdule=((response.result.value as AnyObject).value(forKey: "TrainerWorkSchedules")) as! [[String:AnyObject]]
                            print(self.arrWorkSchdule)
                            
                            if self.arrWorkSchdule.isEmpty==true{
                                self.WorkSchduleTableview.isHidden=true
                                self.No_schdule_lbl.isHidden=false
                            }
                            else{
                                self.WorkSchduleTableview.reloadData()
                                self.WorkSchduleTableview.isHidden=false
                                self.No_schdule_lbl.isHidden=true
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
    
    func FetchWorkSchdule()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
         let param=["trainer_id": User_id as AnyObject]
        let url=Constants.Base_url+"trainerWorkScheduleList"
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
                            self.arrWorkSchdule=((response.result.value as AnyObject).value(forKey: "TrainerWorkSchedules")) as! [[String:AnyObject]]
                            print(self.arrWorkSchdule)
                           
                            if self.arrWorkSchdule.isEmpty==true{
                                self.WorkSchduleTableview.isHidden=true
                                self.No_schdule_lbl.isHidden=false
                            }
                            else{
                                 self.WorkSchduleTableview.reloadData()
                                self.WorkSchduleTableview.isHidden=false
                                self.No_schdule_lbl.isHidden=true
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

    
    func DeleteWorkSchdule(Work_schdule_id:NSInteger)  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
       // let userDefaults = Foundation.UserDefaults.standard
        //let User_id:String = userDefaults.string(forKey: "user_id")!
        let param=["trainer_work_schedules_id": Work_schdule_id as AnyObject]
        let url=Constants.Base_url+"deleteTrainerWorkSchedules"

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
                           
                            
                            if self.arrWorkSchdule.isEmpty==true{
                                self.WorkSchduleTableview.isHidden=true
                                self.No_schdule_lbl.isHidden=false
                            }
                            else{
                                self.WorkSchduleTableview.reloadData()
                                self.WorkSchduleTableview.isHidden=false
                                self.No_schdule_lbl.isHidden=true
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
                //to get JSON return value
                /*     if let result = response.result.value {
                 let JSON = result as! NSDictionary
                 print("new result",JSON)
                 }*/
                
        }
    }

    
   
    
    
   // Mark : TableView delegate++++++++++++++++++++++++++++++++++++++++++++++++
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrWorkSchdule.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : WorkSchduleCell! = tableView.dequeueReusableCell(withIdentifier: "WorkSchduleCell") as! WorkSchduleCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        view.layoutIfNeeded()
        
        cell.Day_lbl.text=(arrWorkSchdule[indexPath.row] as AnyObject).value(forKey: "day") as? String
        cell.Startime_lbl.text=(arrWorkSchdule[indexPath.row] as AnyObject).value(forKey: "start_time") as? String
        cell.Endtime_lbl.text=(arrWorkSchdule[indexPath.row] as AnyObject).value(forKey: "end_time") as? String
        cell.DeleteBtn.tag=indexPath.row
        return cell
        
    }

    
    @IBAction func DIdTabWorkSchduleDeleteBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure want to delete", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
            let selectedIndex:NSInteger=(sender as AnyObject).tag
            print(selectedIndex)
            let Work_schdule_id:NSInteger = ((self.arrWorkSchdule[selectedIndex] as AnyObject).value(forKey: "trainer_work_schedules_id") as? NSInteger)!
            print("Work_schdule_id",Work_schdule_id)
            self.DeleteWorkSchdule(Work_schdule_id: Work_schdule_id)
            self.arrWorkSchdule.remove(at: selectedIndex)
        }
        let NoAction = UIAlertAction(title: "No", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
        
        
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
import UIKit
class UIMarginLabel: UILabel {
    class InsetLabel: UILabel {
        let topInset = CGFloat(0)
        let bottomInset = CGFloat(0)
        let leftInset = CGFloat(20)
        let rightInset = CGFloat(20)
        
        override func drawText(in rect: CGRect) {
            let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        }
        
        override public var intrinsicContentSize: CGSize {
            var intrinsicSuperViewContentSize = super.intrinsicContentSize
            intrinsicSuperViewContentSize.height += topInset + bottomInset
            intrinsicSuperViewContentSize.width += leftInset + rightInset
            return intrinsicSuperViewContentSize
        }
}
}
