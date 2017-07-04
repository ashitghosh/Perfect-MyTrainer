//
//  AddScheduleViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 30/05/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import CallKit
import SVProgressHUD
import AlamofireImage
import Alamofire

class AddScheduleViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,HADropDownDelegate {
    
    @IBOutlet var End_time_dropdown: HADropDown!
    @IBOutlet var Slot_time_dropdown: HADropDown!
    
    @IBOutlet var Start_time_dropdown: HADropDown!
    
    @IBOutlet var Schedule_lbl: UILabel!
    @IBOutlet var End_time_backview: UIView!
    @IBOutlet var Start_time_backview: UIView!
    @IBOutlet var Time_slot_BackView: UIView!
     @IBOutlet var calender: FSCalendar!
    var PassParameter:[String:Any] = [:]
    var availableDate=[NSInteger]()
    var availableDays=[[String:AnyObject]]()
    var availableTime=[String]()
    var month:String=""
    var year:String=""
    var SelectStartTime:String=""
    var SelectEndTime:String=""
    var first_session_date:String=""
    var PaymentDict:[String:Any]=[:]
    var Isview:Bool=false
    
    
    @IBOutlet var Add_schedule_btn: UIButton!
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
    
    fileprivate var datesWithCat = ["2017/05/05","2017/05/06","2017/05/09","2017/05/11","2017/05/14","2017/05/17","2017/05/15","2017/05/18"]
    
    let lunarCalendar = NSCalendar(calendarIdentifier: .indian)!
    let lunarChars = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","二一","二二","二三","二四","二五","二六","二七","二八","二九","三十"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.Isview==true{
        self.Schedule_lbl.text="Reschedule"
        }
        else{
        self.Schedule_lbl.text="Schedule list"
        }
        self.theme=0
        self.calender.allowsSelection=true
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let result = formatter.string(from: date)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        print("components",components)
        //   self.calender.setCurrentPage(<#T##currentPage: Date##Date#>, animated: <#T##Bool#>)

        let year=components.year
        
        let month=components.month
        let currentyear:String=String(year!)
        let currentmonth:String=String(month!)
        print(year!,month!)
        print(currentmonth,currentyear)
        print (result)
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
         let param=["trainer_id": User_id,"year":currentyear,"month":currentmonth] as [String : Any]
       // let param=["trainer_id": "14","year":currentyear,"month":currentmonth] as [String : Any]
        self.MonthAvailableDate(fetchDict: param as! [String : String])
        self.calender.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.calender.select(self.formatter.date(from: result)!)
        let scopeGesture = UIPanGestureRecognizer(target: self.calender, action: #selector(self.calender.handleScopeGesture(_:)))
        self.calender.addGestureRecognizer(scopeGesture)
        self.Time_slot_BackView.isHidden=true
        self.Start_time_backview.isHidden=true
        self.End_time_backview.isHidden=true
        self.Add_schedule_btn.isHidden=true
        self.Slot_time_dropdown.delegate=self
        self.Start_time_dropdown.delegate=self
        self.End_time_dropdown.delegate=self
       self.Slot_time_dropdown.title="Select slot Time"
        self.Start_time_dropdown.title="Select start Time"
        self.End_time_dropdown.title="Select end Time"
       print("PassParameter",self.PassParameter)

    }
    
    func DropdownClose(){
    self.Slot_time_dropdown.isCollapsed=true
    self.Slot_time_dropdown.collapseTableView()
        self.Start_time_dropdown.isCollapsed=true
        self.Start_time_dropdown.collapseTableView()
        self.End_time_dropdown.isCollapsed=true
        self.End_time_dropdown.collapseTableView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.DropdownClose()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        let day: Int! = self.gregorian.component(.day, from: date)
        let Today=String(day)
        
        return self.gregorian.isDateInToday(date) ? Today : nil
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard self.lunar else {
            return nil
        }
        let day = self.lunarCalendar.component(.day, from: date)
        
        return self.lunarChars[day-1]
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2030/12/31")!
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let day: Int! = self.gregorian.component(.day, from: date)
        let year: Int! = self.gregorian.component(.year, from: date)
        let Month: Int! = self.gregorian.component(.month, from: date)
     let Jsonmonth=NSInteger(self.month)
        let Jsonyear=NSInteger(self.year)
        if Jsonmonth==Month && Jsonyear==year{
           if self.availableDate.contains(day){
                print("contain");
                self.calender.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
                return 1
                
            }
            else{
                return 0
                
            }
        }
        else{
            return 0
        }
        
        
        
        
        
        
        
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let day: Int! = self.gregorian.component(.day, from: date)
        return [13,24].contains(day) ? UIImage(named: "icon_cat") : nil
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.Time_slot_BackView.isHidden=true
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
       let arrdate=self.formatter.string(from: calendar.currentPage).components(separatedBy: "/")
       
        
        
        //        let currentyear:String=String(arrdate)
        //        let currentmonth:String=String(month!)
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        
        let param=["trainer_id": User_id,"year":arrdate[0],"month":arrdate[1]] as [String : Any]
        print(param)
        self.MonthAvailableDate(fetchDict: param as! [String : String])
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //      self.calender.appearance.selectionColor=UIColor.black
        let day: Int! = self.gregorian.component(.day, from: date)
        
        if  self.availableDate.contains(day){
            //  self.calender.sele=false
           self.Time_slot_BackView.isHidden=false
            let index:Int = self.availableDate.index(of: day)!
            print(index as Int)
            let slot=((self.availableDays[index] as AnyObject).value(forKey: "slot")) as! [[String:AnyObject]]
            // print(slot)
            self.availableTime.removeAll()
            self.first_session_date=self.formatter.string(from: date)
            for count in stride(from: 0, to: slot.count, by: 1){
                let startTime=((slot[count] as AnyObject).value(forKey: "start_time")) as! String
                let endTime=((slot[count] as AnyObject).value(forKey: "end_time")) as! String
                
                
                let time:String = startTime + " to " +  endTime
                // print(time)
                self.availableTime.append(time)
            }
            print("available time",self.availableTime)
            self.Slot_time_dropdown.items=self.availableTime
            let arrdate=self.formatter.string(from: date).components(separatedBy: "/")
            let date:String=arrdate[0] + "-" + arrdate[1] + "-" + arrdate[2]
            self.PassParameter["date"]=date
            
        }
        else{
             self.Time_slot_BackView.isHidden=true
            self.Start_time_backview.isHidden=true
            self.End_time_backview.isHidden=true
            let alertController = UIAlertController(title: "Alert", message: "Trainer does not available this day", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                (action: UIAlertAction) in print("Youve pressed OK Button")
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        print("calendar did select date \(self.formatter.string(from: date))")
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    // MARK:- Dropdown delegate method
    
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        if dropDown==self.Slot_time_dropdown{
        let arrtime_slot=self.Slot_time_dropdown.title.components(separatedBy: "to")
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
            self.End_time_dropdown.title="Select end time"
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
            self.End_time_dropdown.items=arrdropdown
            self.Start_time_backview.isHidden=false
            self.End_time_backview.isHidden=false
            self.Add_schedule_btn.isHidden=false
            
        }
       
    }
    func didShow(dropDown: HADropDown) {
        if  dropDown==self.Slot_time_dropdown {
            
            self.Start_time_dropdown.isCollapsed=true
            self.Start_time_dropdown.collapseTableView()
            self.End_time_dropdown.isCollapsed=true
            self.End_time_dropdown.collapseTableView()
  
        }
        if  dropDown==self.Start_time_dropdown {
            self.Slot_time_dropdown.isCollapsed=true
            self.Slot_time_dropdown.collapseTableView()
            
            self.End_time_dropdown.isCollapsed=true
            self.End_time_dropdown.collapseTableView()
            
        }
        if  dropDown==self.End_time_dropdown {
            self.Slot_time_dropdown.isCollapsed=true
            self.Slot_time_dropdown.collapseTableView()
            self.Start_time_dropdown.isCollapsed=true
            self.Start_time_dropdown.collapseTableView()
            
            
        }
    }
    
    // MARK:- Webservice class calling
    
    func MonthAvailableDate(fetchDict:[String:String])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("FetchDict",fetchDict);
        let url=Constants.Client_url+"TrainerAvailableByMonth"
        Alamofire.request(url, method: .post, parameters: fetchDict, encoding: JSONEncoding.default)
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
                            self.availableDate.removeAll()
                            self.availableDays.removeAll()
                            self.month=((response.result.value as AnyObject).value(forKey: "month")) as! String
                            self.year=((response.result.value as AnyObject).value(forKey: "year")) as! String
                            
                            
                            self.availableDays=((response.result.value as AnyObject).value(forKey: "available_days")) as! [[String:AnyObject]]
                            for index in stride(from: 0, to: self.availableDays.count, by: 1){
                                var arrdate=((self.availableDays[index] as AnyObject).value(forKey: "date") as AnyObject).components(separatedBy: "-")
                                // print(arrdate[2]);
                                let date=NSInteger(arrdate[2]);
                                //  print(date!)
                                self.availableDate.append(date!)
                                
                            }
                            print("date",self.availableDate)
                            self.calender.reloadData()
                            
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
    func Addschedule(AddscheduleDict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("FetchDict",AddscheduleDict);
        let url=Constants.Base_url+"addBookingSchedule"
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
                            self.navigationController!.popViewController(animated: true)
                        }
                            
                        else{
                            self.presentAlertWithTitle(title: "Alert", message: (response.result.value as AnyObject).value(forKey: "err_msg") as! String)
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

    func Reschedule(AddscheduleDict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print("FetchDict",AddscheduleDict);
        let url=Constants.Base_url+"bookingReschedule"
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
                            self.navigationController!.popViewController(animated: true)
                        }
                            
                        else{
                           self.presentAlertWithTitle(title: "Alert", message: (response.result.value as AnyObject).value(forKey: "err_msg") as! String)
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
    


    
    
    @IBAction func DidTabBackBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        self.DropdownClose()
    }
   
    @IBAction func DidTabAddScheduleBtn(_ sender: Any) {
        self.DropdownClose()
        
        if self.Start_time_dropdown.title=="" || self.Start_time_dropdown.title=="Select start time"{
    self.presentAlertWithTitle(title: "alert", message: "Select your start time")
        }
        else if self.End_time_dropdown.title=="" || self.End_time_dropdown.title=="Select end time"{
        
        }
        else{
            let dateFormatter = DateFormatter()
            
             dateFormatter.dateFormat = "hh:mm:ss"
            let Start_time = self.Start_time_dropdown.title
            let End_time = self.End_time_dropdown.title
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
            let original_schdule_time=NSInteger(self.PassParameter["session_time"] as! NSNumber)
            // self.presentAlertWithTitle(title: "Alert", message: "Schedule time should be same as session time")
            
            if Start_minutes>End_minutes{
             self.presentAlertWithTitle(title: "alert", message: "Select A proper time")
            }
            else if Original_diff != original_schdule_time{
            self.presentAlertWithTitle(title: "Alert", message: "Schedule time should be same as session time")
            }
            else{
                let userDefaults = Foundation.UserDefaults.standard
                let User_id:String = userDefaults.string(forKey: "user_id")!
                self.PassParameter["start_time"] = self.Start_time_dropdown.title
                self.PassParameter["end_time"] = self.End_time_dropdown.title
                self.PassParameter["trainer_id"] = User_id
                print("Final dict",self.PassParameter)
                if self.Isview==true{
                    self.Reschedule(AddscheduleDict: self.PassParameter)
                }
                else{
                    self.Addschedule(AddscheduleDict: self.PassParameter)
                }
                //self.ConfirmScheduleAdd(ConfirmDict: Confirm)
                
                
            }

        }
        
       
    }

    @IBAction func DidTabMyScheduleBtn(_ sender: Any) {
        self.DropdownClose()
        let vc=self.storyboard!.instantiateViewController(withIdentifier: "MySchduleController")as! MySchduleController
        vc.IsNotComeFromDrawer=true
        self.navigationController!.pushViewController(vc, animated: true)
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
