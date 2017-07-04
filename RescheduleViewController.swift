//
//  RescheduleViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 30/05/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
class RescheduleViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var Client_name_lbl: UILabel!
    var arrSchedule=[[String:AnyObject]]()
    var Session_time:NSNumber = 0
    var Booking_id:NSNumber = 0
    @IBOutlet var Schedule_list_table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("schedule list",self.arrSchedule)
        print("Session_time",self.Session_time)
        
        self.Client_name_lbl.text="Schedule"
    }
    override func viewWillAppear(_ animated: Bool) {
        let param=["booking_id":self.Booking_id] as [String:Any]
        self.Reschedule(AddscheduleDict: param)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Table VIEW DATASOURCE AND DELEGATE METHOD
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RescheduleCell! = tableView.dequeueReusableCell(withIdentifier: "RescheduleCell") as! RescheduleCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.Date_lbl.text=((self.arrSchedule[indexPath.row] as AnyObject).value(forKey: "date") as? String)!
        cell.Day_lbl.text=((self.arrSchedule[indexPath.row] as AnyObject).value(forKey: "day") as? String)!
        cell.Time_lbl.text=((self.arrSchedule[indexPath.row] as AnyObject).value(forKey: "display_start_time") as? String)! + " to " +  ((self.arrSchedule[indexPath.row] as AnyObject).value(forKey: "display_end_time") as? String)!
        cell.Reschedule_btn.tag=indexPath.row
        cell.Reschedule_btn.addTarget(self,action:#selector(ClickForRescheduleBtn(sender:)),
                                   for:.touchUpInside)
        
        return cell
    }
    
    func ClickForRescheduleBtn(sender:UIButton)
    {
       let Selectedtag:NSInteger=(sender as AnyObject).tag
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "AddScheduleViewController") as! AddScheduleViewController
        vc.PassParameter["schedule_id"]=((self.arrSchedule[Selectedtag] as AnyObject).value(forKey: "schedule_id")) as! NSNumber
        vc.PassParameter["session_time"]=self.Session_time
        vc.Isview=true
        self.navigationController?.pushViewController(vc, animated: true);
        print(Selectedtag)

    }

    @IBAction func DidTabBackBtn(_ sender: Any) {
        
    self.navigationController!.popViewController(animated: true)
        
    }
    
    @IBAction func DidTabMyScheduleBtn(_ sender: Any) {
      let vc=self.storyboard!.instantiateViewController(withIdentifier: "MySchduleController") as! MySchduleController
        vc.IsNotComeFromDrawer=true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func Reschedule(AddscheduleDict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("FetchDict",AddscheduleDict);
        let url=Constants.Base_url+"bookingScheduleList"
        Alamofire.request(url, method: .post, parameters: AddscheduleDict, encoding: JSONEncoding.default)
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
                            self.arrSchedule=((response.result.value as AnyObject).value(forKey: "List")) as! [[String:AnyObject]]
                            self.Schedule_list_table.reloadData()
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
