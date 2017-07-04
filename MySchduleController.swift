//
//  MySchduleController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 08/05/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
class MySchduleController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource,HADropDownDelegate {
    
    @IBOutlet var My_schedule_image: UIImageView!
    
    @IBOutlet var New_blockSchedule_btn: UIButton!
    @IBOutlet var Block_schedule_btn: UIButton!
    @IBOutlet var Switch_btn: UISwitch!
    @IBOutlet var Schedule_availeability_lbl: UILabel!
    @IBOutlet var No_scheduleview: UIView!
    @IBOutlet var dayoff_switch: UISwitch!
    
    @IBOutlet var Block_schedule_view: UIView!
    var availableTime=[String]()
    
    @IBOutlet var calender: FSCalendar!
    @IBOutlet var Time_slot_dropdown: HADropDown!
    
    @IBOutlet var Submit_btn: UIButton!
    @IBOutlet var End_time_drop_down: HADropDown!
    @IBOutlet var Start_time_dropdown: HADropDown!
    @IBOutlet var Menu_imageview: UIImageView!
    @IBOutlet var Back_arrow_img: UIImageView!
    @IBOutlet var Date_titile_lbl: UILabel!
    @IBOutlet var Myschedule_table: UITableView!
    @IBOutlet var height_constant: NSLayoutConstraint!
    var IsclientScheduleShow=false
    var Traine_id:String=""
    var trainer_name:String=""
    var switch_off:String=""
    var select_date:String=""
    var select_time_slot=""
    var arrMyschedule = [[String:AnyObject]]()
    var IsNotComeFromDrawer=false
    var IsNoWork:Bool=false
    
    @IBOutlet var Header_title: UILabel!
    fileprivate var lunar: Bool = false {
        didSet {
            self.calender.reloadData()
        }
    }
    fileprivate var theme: Int = 0 {
        didSet {
            switch (theme) {
            case 0:
                self.calender.appearance.weekdayTextColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.calender.appearance.headerTitleColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.calender.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calender.appearance.selectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calender.appearance.headerDateFormat = "MMMM yyyy"
                self.calender.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
                self.calender.appearance.borderRadius = 1.0
                self.calender.appearance.headerMinimumDissolvedAlpha = 0.2
            case 1:
                self.calender.appearance.weekdayTextColor = UIColor.red
                self.calender.appearance.headerTitleColor = UIColor.darkGray
                self.calender.appearance.eventDefaultColor = UIColor.green
                self.calender.appearance.selectionColor = UIColor.blue
                self.calender.appearance.headerDateFormat = "yyyy-MM";
                self.calender.appearance.todayColor = UIColor.red
                self.calender.appearance.borderRadius = 1.0
                self.calender.appearance.headerMinimumDissolvedAlpha = 0.0
            case 2:
                self.calender.appearance.weekdayTextColor = UIColor.red
                self.calender.appearance.headerTitleColor = UIColor.red
                self.calender.appearance.eventDefaultColor = UIColor.green
                self.calender.appearance.selectionColor = UIColor.blue
                self.calender.appearance.subtitleFont = UIFont.systemFont(ofSize: 5.0)
                self.calender.appearance.headerDateFormat = "yyyy/MM"
                self.calender.appearance.todayColor = UIColor.orange
                self.calender.appearance.borderRadius = 0
                self.calender.appearance.headerMinimumDissolvedAlpha = 1.0
            default:
                break;
            }
        }
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    fileprivate let datesWithCat = ["2017/05/05","2017/05/06","2017/05/09","2017/05/11","2017/05/14","2017/05/17","2017/05/15","2017/05/18"]
    
    let lunarCalendar = NSCalendar(calendarIdentifier: .indian)!
    let lunarChars = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","二一","二二","二三","二四","二五","二六","二七","二八","二九","三十"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let date1 = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let result1 = formatter1.string(from:date1)
        print (result1)
        
       
        
        if IsclientScheduleShow==true{
            
        self.Date_titile_lbl.text=self.select_date
           self.Header_title.text=self.trainer_name + "'s Schedule"
        }
        else{
            
        self.Date_titile_lbl.text=result1
            self.select_date=result1
            
        }
        
        self.My_schedule_image.isHidden=true
        self.calender.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
      self.calender.scope = .week
        
        self.calender.select(self.formatter.date(from: result1)!)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
               print (result)
          let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        if self.IsclientScheduleShow==false{
            let param=["trainer_id":User_id, "date":result]
            self.Viewschedule(AddscheduleDict: param)
            self.Switch_btn.isHidden=true

        }
        else{
            let param=["trainer_id":self.Traine_id, "date":self.select_date]
            self.ViewscheduleByClient(AddscheduleDict: param)
            self.New_blockSchedule_btn.isHidden=false
            self.Block_schedule_btn.isHidden=false
            self.Block_schedule_btn.isHidden=true
            self.New_blockSchedule_btn.isHidden=true

        }
              self.No_scheduleview.isHidden=true
        if IsNotComeFromDrawer==true{
        self.Menu_imageview.isHidden=true
        self.Back_arrow_img.isHidden=false
           
        }
        else{
            self.Menu_imageview.isHidden=false
            self.Back_arrow_img.isHidden=true
        }
        self.Block_schedule_view.isHidden=true
        self.Time_slot_dropdown.delegate=self
        self.Start_time_dropdown.delegate=self
        self.Start_time_dropdown.delegate=self
        self.Time_slot_dropdown.title="Select time slot"
        self.Start_time_dropdown.title="Select start time"
        self.End_time_drop_down.title="Select end time"
        self.Block_schedule_btn.ButtonRoundCorner(radious: 5)
        self.New_blockSchedule_btn.ButtonRoundCorner(radious: 5.0)
        self.Submit_btn.ButtonRoundCorner(radious: 5.0)
        

        // Do any additional setup after loading the view.
    }
    
    func CloseDropDown(){
        self.Start_time_dropdown.isCollapsed=true
        self.Start_time_dropdown.collapseTableView()
        self.End_time_drop_down.isCollapsed=true
        self.End_time_drop_down.collapseTableView()
        self.Time_slot_dropdown.isCollapsed=true
        self.Time_slot_dropdown.collapseTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
      
        let newdate = self.select_date.components(separatedBy: "-")
        print("newdate",newdate[0]);
        if IsclientScheduleShow==true{
         return self.gregorian.isDateInToday(date) ? newdate[0] : nil
        }
        else{
          let day: Int! = self.gregorian.component(.day, from: date)
            let Today=String(day)
             return self.gregorian.isDateInToday(date) ? Today : nil
        }
        
        
       
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard self.lunar else {
            return nil
        }
        let day = self.lunarCalendar.component(.day, from: date)
        
        return self.lunarChars[day-1]
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2017/10/30")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // let day: Int! = self.gregorian.component(.day, from: date)
        
        return 0;
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let day: Int! = self.gregorian.component(.day, from: date)
        return [13,24].contains(day) ? UIImage(named: "icon_cat") : nil
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //      self.calender.appearance.selectionColor=UIColor.black
       // let day: Int! = self.gregorian.component(.day, from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        self.select_date=result
       print("result",result)
         self.Date_titile_lbl.text=result
        if IsclientScheduleShow==false{
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            let param=["trainer_id":User_id, "date":result]
            self.Viewschedule(AddscheduleDict: param)

        }
        else{
            
            let param=["trainer_id":self.Traine_id, "date":result]
            self.ViewscheduleByClient(AddscheduleDict: param)

        }
        
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.height_constant.constant = bounds.height
//        self.view.layoutIfNeeded()
//    }

    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrMyschedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MySchduleCell! = tableView.dequeueReusableCell(withIdentifier: "MySchduleCell") as! MySchduleCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.Schdule_image_lbl.CircleImageView(BorderColour: UIColor.lightGray, Radious: 1)
       cell.View_btn.BtnRoundCorner(radious: 5.0, colour:UIColor.init(colorLiteralRed: 115.0/255.0, green: 172.0/255.0, blue: 198.0/255.0, alpha: 0.8))
        cell.View_btn.tag=indexPath.row
        cell.View_btn.addTarget(self,action:#selector(ClickForViewButton(sender:)),
                                     for:.touchUpInside)
        if self.IsclientScheduleShow==false{
        cell.View_btn.isHidden=false
        }
        else{
        cell.View_btn.isHidden=true
        }
        cell.DayoffSwitch.tag=indexPath.row
        cell.DayoffSwitch.addTarget(self,action:#selector(ClickForSwicthOff(sender:)),
                                for:.touchUpInside)
        cell.schdule_type_lbl.text=((self.arrMyschedule[indexPath.row] as AnyObject).value(forKey: "booking_type"))as? String
       cell.DayoffSwitch.isHidden=true
//        if self.switch_off=="0"{
//        cell.DayoffSwitch.setOn(true, animated: true)
//        }
//        else{
//        cell.DayoffSwitch.setOn(false, animated: true)
//        }
        if cell.schdule_type_lbl.text=="individual"{
        cell.Schdule_image_lbl.image=UIImage.init(named: "My_schdule_individual.png")
        }
        if cell.schdule_type_lbl.text=="group"{
          //My_schdule_group.png
            cell.Schdule_image_lbl.image=UIImage.init(named: "My_schdule_group.png")
            
        }
        if cell.schdule_type_lbl.text=="tandem"{
           cell.Schdule_image_lbl.image=UIImage.init(named: "My_schdule_tandem.png")
        }
        if cell.schdule_type_lbl.text=="block"{
            //My_schdule_group.png
            cell.Schdule_image_lbl.image=UIImage.init(named: "block-icon.png")
            cell.View_btn.setTitle("Delete", for: UIControlState.normal)
            cell!.layer.borderColor = UIColor.red.cgColor  // set cell border color here
            cell!.layer.borderWidth = 1.0 // set border width here
        }
        else{
        cell.View_btn.setTitle("View", for: UIControlState.normal)
            cell!.layer.borderColor = UIColor.clear.cgColor  // set cell border color here
            cell!.layer.borderWidth = 1.0 // set border width here
        }
        
        cell.time_lbl.text=((self.arrMyschedule[indexPath.row] as AnyObject).value(forKey: "time_slot"))as? String
           return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
   // MARK:- DropDownDelegate Methods
    
    
    
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        if dropDown==self.Time_slot_dropdown{
            let arrtime_slot=self.Time_slot_dropdown.title.components(separatedBy: "to")
            let start_time:String = arrtime_slot[0]
            let end_time:String = arrtime_slot[1]
            let arrstartTime=start_time.components(separatedBy: ":")
            let arrEndTime=end_time.components(separatedBy: ":")
            print(arrstartTime[0],arrEndTime[0])
            var newstart:String=arrstartTime[0]
            var newsend:String=arrEndTime[0]
            newsend = newsend.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            newstart = newstart.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.Start_time_dropdown.title="Select start time"
            self.End_time_drop_down.title="Select end time"
            print("+",newsend,"+",newstart,"+")
            let Start:Int=(Int(newstart))!
            let End:Int=Int(newsend)!
            print(Start)
            print(End)
            //  print(End)
            
            var arrdropdown = [String]()
            
            for  index in stride(from: Start, to:  End+1, by: 1){
                print("index",index)
                if index>=Start || index<=End{
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
            
            self.Start_time_dropdown.items=arrdropdown
            self.End_time_drop_down.items=arrdropdown
            self.Start_time_dropdown.isHidden=false
            self.End_time_drop_down.isHidden=false

        }
        
    }
    func didShow(dropDown: HADropDown) {
        if dropDown==self.Time_slot_dropdown{
        self.Start_time_dropdown.isCollapsed=true
        self.Start_time_dropdown.collapseTableView()
        self.End_time_drop_down.isCollapsed=true
        self.End_time_drop_down.collapseTableView()
            
        }
        if dropDown==self.Start_time_dropdown{
            self.Time_slot_dropdown.isCollapsed=true
            self.Time_slot_dropdown.collapseTableView()
            self.End_time_drop_down.isCollapsed=true
            self.End_time_drop_down.collapseTableView()

        
        }
        if dropDown==self.End_time_drop_down{
            self.Start_time_dropdown.isCollapsed=true
            self.Start_time_dropdown.collapseTableView()
            self.Time_slot_dropdown.isCollapsed=true
            self.Time_slot_dropdown.collapseTableView()

        
        }
        
    }
    
    
    @IBAction func DidTabDrawerbtn(_ sender: Any) {
        if IsNotComeFromDrawer==true{
      self.navigationController! .popViewController(animated: true)
        }
        else{
            if let drawerController = navigationController?.parent as? KYDrawerController {
                drawerController.setDrawerState(.opened, animated: true)
            }

        }
        
        
    }
    
    func ClickForViewButton(sender:UIButton)
    {
        let Selectedtag:NSInteger=(sender as AnyObject).tag
        print(Selectedtag)
        let booking_type = ((self.arrMyschedule[Selectedtag] as AnyObject).value(forKey: "booking_type"))as? String
        
        if booking_type == "block"{
            let alertController = UIAlertController(title: "Alert", message: "Are you sure want to delete", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Yes", style: .default) {
                (action: UIAlertAction) in print("Youve pressed OK Button")
                let Schedule_id = String(describing: (((self.arrMyschedule[Selectedtag] as AnyObject).value(forKey: "schedule_id"))as! NSNumber))
                let param = ["schedule_id":Schedule_id]
                print("Parameter",Schedule_id)
                print("Parameter",param)
                self.ScheduleDelete(param: param)
                self.arrMyschedule.remove(at: Selectedtag)
                self.Myschedule_table.reloadData()
                
            }
            let NoAction = UIAlertAction(title: "No", style: .default) {
                (action: UIAlertAction) in print("Youve pressed OK Button")
            }
            alertController.addAction(OKAction)
            alertController.addAction(NoAction)
            self.present(alertController, animated: true, completion: nil)
            
        
        }
        else{
            let vc = self.storyboard! .instantiateViewController(withIdentifier: "ScheduleMemberController") as! ScheduleMemberController
            vc.arrMyMember = (self.arrMyschedule[Selectedtag] as AnyObject) as! [String:Any]
            self.navigationController?.pushViewController(vc, animated: true)

        }
            }
    func ClickForSwicthOff(sender:UIButton)
    {
        let Selectedtag=(sender as AnyObject).tag
        print(Selectedtag!)
    }
    func Viewschedule(AddscheduleDict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("FetchDict",AddscheduleDict);
        let url=Constants.Base_url+"bookingListByWeekly"
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
                            self.IsNoWork=false
                            self.switch_off=String(describing: ((response.result.value as AnyObject).value(forKey: "isoff")) as! NSNumber)
                            if self.switch_off=="0"{
                                self.Switch_btn.setOn(true, animated: true)
                                self.Switch_btn.isHidden=false
                                
                                self.Block_schedule_btn.isHidden=false
                                self.Block_schedule_view.isHidden=true
                                let slot=((response.result.value as AnyObject).value(forKey: "schedules")) as! [[String:AnyObject]]
                                // print(slot)
                                self.availableTime.removeAll()
                                for count in stride(from: 0, to: slot.count, by: 1){
                                    let startTime=((slot[count] as AnyObject).value(forKey: "start_time")) as! String
                                    let endTime=((slot[count] as AnyObject).value(forKey: "end_time")) as! String
                                    
                                    
                                    let time:String = startTime + " to " +  endTime
                                    // print(time)
                                    self.availableTime.append(time)
                                }
                                print("available time",self.availableTime)
                                self.Time_slot_dropdown.items=self.availableTime
                                self.Time_slot_dropdown.isHidden=false
                                self.Start_time_dropdown.isHidden=true
                                self.End_time_drop_down.isHidden=true
                               
                            }
                            if self.switch_off=="1"{
                                self.Switch_btn.setOn(false, animated: true)
                                self.Switch_btn.isHidden=false
                                self.Block_schedule_btn.isHidden=true
                            }
                            self.arrMyschedule=((response.result.value as AnyObject).value(forKey: "result")) as! [[String:AnyObject]]
                            self.Myschedule_table.reloadData()
                            self.No_scheduleview.isHidden=true
                            self.Myschedule_table.isHidden=false
                            self.Switch_btn.isHidden=false
                        }
                            
                        else{
                            self.IsNoWork=true
                            self.Block_schedule_btn.isHidden=true
                            
                            self.No_scheduleview.isHidden=false
                            self.Myschedule_table.isHidden=true
                            self.Switch_btn.isHidden=true
                            self.switch_off=String(describing: ((response.result.value as AnyObject).value(forKey: "isoff")) as! NSNumber)
                            
                            if self.switch_off=="0"{
                            self.dayoff_switch.setOn(true, animated: true)
                                self.dayoff_switch.isHidden=false
                                self.New_blockSchedule_btn.isHidden=false
                                let slot=((response.result.value as AnyObject).value(forKey: "schedules")) as! [[String:AnyObject]]
                                // print(slot)
                                self.availableTime.removeAll()
                                for count in stride(from: 0, to: slot.count, by: 1){
                                    let startTime=((slot[count] as AnyObject).value(forKey: "start_time")) as! String
                                    let endTime=((slot[count] as AnyObject).value(forKey: "end_time")) as! String
                                    
                                    
                                    let time:String = startTime + " to " +  endTime
                                    // print(time)
                                    self.availableTime.append(time)
                                }
                                print("available time",self.availableTime)
                                self.Time_slot_dropdown.items=self.availableTime
                                self.Time_slot_dropdown.isHidden=false
                                self.Start_time_dropdown.isHidden=true
                                self.End_time_drop_down.isHidden=true
                            }
                            if self.switch_off=="1"{
                                self.dayoff_switch.setOn(false, animated: true)
                                self.dayoff_switch.isHidden=false
                                self.New_blockSchedule_btn.isHidden=true
                            }
                            if self.switch_off=="2"{
                                self.dayoff_switch.isHidden=true
                                self.New_blockSchedule_btn.isHidden=true
                            }
                            SVProgressHUD.dismiss()
                            self.arrMyschedule.removeAll()
                            self.Myschedule_table.reloadData()
                            self.Schedule_availeability_lbl.text=((response.result.value as AnyObject).value(forKey: "message") as! String)
                            //self.presentAlertWithTitle(title: "Alert", message: (response.result.value as AnyObject).value(forKey: "message") as! String)
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
    func ScheduleDelete(param:[String:Any])  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
                let url=Constants.Base_url+"deleteSlot"
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
                            let userDefaults = Foundation.UserDefaults.standard
                            let User_id:String = userDefaults.string(forKey: "user_id")!
                            let param=["trainer_id":User_id, "date":self.select_date]
                            self.Viewschedule(AddscheduleDict: param)
                            
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
    
    func ViewscheduleByClient(AddscheduleDict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("FetchDict",AddscheduleDict);
        let url=Constants.Client_url+"trainerBookingListByWeekly"
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
                            self.arrMyschedule=((response.result.value as AnyObject).value(forKey: "result")) as! [[String:AnyObject]]
                            self.Myschedule_table.reloadData()
                            self.No_scheduleview.isHidden=true
                            self.Myschedule_table.isHidden=false
                            self.Switch_btn.isHidden=true
                        }
                            
                        else{
                            self.No_scheduleview.isHidden=false
                            self.Myschedule_table.isHidden=true
                            self.Switch_btn.isHidden=true
                            self.arrMyschedule.removeAll()
                            self.Myschedule_table.reloadData()
                            self.dayoff_switch.isHidden=true
                            self.Schedule_availeability_lbl.text=((response.result.value as AnyObject).value(forKey: "message") as! String)
                            //self.presentAlertWithTitle(title: "Alert", message: (response.result.value as AnyObject).value(forKey: "message") as! String)
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

    func SwitchOffCalling(Switchoffdict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("FetchDict",Switchoffdict);
        let url=Constants.Base_url+"switchDateOffOn"

        Alamofire.request(url, method: .post, parameters: Switchoffdict, encoding: JSONEncoding.default)
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
                            let switchoff = String(describing: ((response.result.value as AnyObject).value(forKey: "isoff")) as! NSNumber)
                            if switchoff=="1"{
                            self.New_blockSchedule_btn.isHidden=true
                                self.Block_schedule_btn.isHidden=true
                            }
                            if switchoff=="0"{
                                self.Block_schedule_btn.isHidden=false
                                self.New_blockSchedule_btn.isHidden=true
                            }
                           
                          // self.No_scheduleview.isHidden=false
                        }
                            
                        else{
                            
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
    func SwitchOffCallingNew(Switchoffdict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("FetchDict",Switchoffdict);
        let url=Constants.Base_url+"switchDateOffOn"
        
        Alamofire.request(url, method: .post, parameters: Switchoffdict, encoding: JSONEncoding.default)
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
                            let switchoff = String(describing: ((response.result.value as AnyObject).value(forKey: "isoff")) as! NSNumber)
                            if switchoff=="1"{
                                
                                self.New_blockSchedule_btn.isHidden=true
                                self.Block_schedule_btn.isHidden=true
                            }
                            if switchoff=="0"{
                                self.New_blockSchedule_btn.isHidden=false
                                self.Block_schedule_btn.isHidden=true
                                
                            }
                            
                            // self.No_scheduleview.isHidden=false
                        }
                            
                        else{
                            
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

    func BlockSchedule(BlockScheduledict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("FetchDict",BlockScheduledict);
        let url=Constants.Base_url+"blockDaySlot"
        
        Alamofire.request(url, method: .post, parameters: BlockScheduledict, encoding: JSONEncoding.default)
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
                            let userDefaults = Foundation.UserDefaults.standard
                            let User_id:String = userDefaults.string(forKey: "user_id")!
                            let param=["trainer_id":User_id, "date":self.select_date]
                            self.Viewschedule(AddscheduleDict: param)
                            self.Switch_btn.isHidden=true
                            self.Block_schedule_btn.isHidden=true
                            self.New_blockSchedule_btn.isHidden=true
                            
                            // self.No_scheduleview.isHidden=false
                        }
                            
                        else{
                            let message:String=(response.result.value as AnyObject).value(forKey: "err_msg") as! String
                           self.presentAlertWithTitle(title: "Alert", message: message);
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



    @IBAction func DidTabSwitchOfBtn(_ sender: Any) {
      if self.dayoff_switch.isOn{
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        let param=["trainer_id":User_id, "date":self.select_date]
        self.SwitchOffCallingNew(Switchoffdict: param as [String:Any])
        }
      else{
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        let param=["trainer_id":User_id, "date":self.select_date];
        self.SwitchOffCalling(Switchoffdict: param as [String:Any])
        }
    }
    
    @IBAction func ScheduleSwitchStatusBtn(_ sender: Any) {
        if self.Switch_btn.isOn{
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            let param=["trainer_id":User_id, "date":self.select_date]
            self.SwitchOffCalling(Switchoffdict: param as [String:Any])
        }
        else{
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            let param=["trainer_id":User_id, "date":self.select_date];
            self.SwitchOffCalling(Switchoffdict: param as [String:Any])
        }
    }
    @IBAction func DidTabBlockScheduleBtn(_ sender: Any) {
        self.Block_schedule_view.isHidden=false
    }
    
    @IBAction func DidTabNewBlockScheduleBtn(_ sender: Any) {
        self.Block_schedule_view.isHidden=false
        
    }
    @IBAction func DidTabBlockHideBtn(_ sender: Any) {
        self.Block_schedule_view.isHidden=true
        self.CloseDropDown()
    }
    @IBAction func DidTabSubmitBtn(_ sender: Any) {
        
        if self.Start_time_dropdown.title=="Select start time" || self.End_time_drop_down.title=="Select end time"{
            
        self.presentAlertWithTitle(title: "alert", message: "Select a proper time")
        }
        else{
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "hh:mm:ss"
            let Start_time = self.Start_time_dropdown.title
            let End_time = self.End_time_drop_down.title
            let start_new_time = dateFormatter.date(from: Start_time)
            let End_new_time = dateFormatter.date(from: End_time)
            let Start1970 = start_new_time?.timeIntervalSince1970
            print("",Start1970!);
            let Start_minutes = (Start1970! / 60)
            print("Start_minute=",Start_minutes);
            
            let End1970 = End_new_time?.timeIntervalSince1970
            print("",End1970!);
            let End_minutes = (End1970! / 60)
            print("End_minute",End_minutes);
            
            let diff = End_minutes - Start_minutes
            
            print("Diff=",diff);
            let myNumber = NSNumber(value:diff)
            let Original_diff:NSInteger = NSInteger(myNumber)
            print("Original_diff=",Original_diff)
            // self.presentAlertWithTitle(title: "Alert", message: "Schedule time should be same as session time")
            
            if Start_minutes>End_minutes{
                self.presentAlertWithTitle(title: "alert", message: "Select A proper time")
            }
            else if Original_diff < 30{
                self.presentAlertWithTitle(title: "Alert", message: "Schedule time should be same as session time")
            }
            else{
                self.CloseDropDown()
                let userDefaults = Foundation.UserDefaults.standard
                let User_id:String = userDefaults.string(forKey: "user_id")!
               let param=["start_time":self.Start_time_dropdown.title,"end_time":self.End_time_drop_down.title,"trainer_id":User_id,"date":self.select_date]
                self.BlockSchedule(BlockScheduledict: param)
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
