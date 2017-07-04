//
//  BookNowNextView.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 04/05/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import CallKit
import SVProgressHUD
import AlamofireImage
import Alamofire
import Stripe

class BookNowNextView: UIViewController,FSCalendarDelegate,FSCalendarDataSource,HADropDownDelegate,STPAddCardViewControllerDelegate,UITextFieldDelegate,STPPaymentCardTextFieldDelegate {
    
    @IBOutlet var Booking_banner: UIImageView!
    @IBOutlet var trainer_profile_imgv: UIImageView!
   
    
    @IBOutlet var End_time_slot: HADropDown!
    @IBOutlet var Start_time_slot: HADropDown!
    @IBOutlet var Time_slot_dropdown: HADropDown!
    @IBOutlet var Time_select_backview: UIView!
    @IBOutlet var Session_price: UILabel!
    @IBOutlet var Total_session_lbl: UILabel!
    @IBOutlet var DropDown_BackView: UIView!
    @IBOutlet var DropDownView: HADropDown!
    @IBOutlet var PayNowBtn: UIButton!
    
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    var PassParameter:[String:Any] = [:]
    var availableDate=[NSInteger]()
     var availableDays=[[String:AnyObject]]()
    var availableTime=[String]()
    var month:String=""
    var year:String=""
    var select_date:String=""
    var SelectStartTime:String=""
    var SelectEndTime:String=""
    var token:String=""
    var first_session_date:String=""
    var PaymentDict:[String:Any]=[:]
    var Trainer_name:String=""
    @IBOutlet var Paynow_btn: UIButton!
    @IBOutlet var Name_lbl: UILabel!
    @IBOutlet var PayNowView: UIView!
    @IBOutlet var calender: FSCalendar!
    var trainer_id:String = ""
    
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
        UITextField.appearance().tintColor = UIColor.lightGray
             // Do any additional setup after loading the view.
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
         self.Booking_banner.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
         self.Booking_banner.contentMode = .scaleAspectFill // OR .scaleAspectFill
         self.Booking_banner.clipsToBounds = true
        self.trainer_profile_imgv.CircleImageView(BorderColour: UIColor.white, Radious: 1.0)
        print("PaymentDict",self.PaymentDict);
        if let name = self.PassParameter["trainer_name"] {
            self.Name_lbl.text=name as? String
        }
        if let url = self.PassParameter["profile_url"] {
            Alamofire.request((url as? String)!).responseImage { response in
                debugPrint(response)
                
                
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.trainer_profile_imgv.image=image
                }
            }

        }
      
      /*  if let price = self.PaymentDict["no_of_session"] {
            self.Total_session_lbl.text=(price as? String)! + " Session"
        }
        if let price = self.PaymentDict["price_per_session"] {
            self.Session_price.text="$ " + (price as? String)!
        }*/
     self.theme=0
        self.calender.allowsSelection=true
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let result = formatter.string(from: date)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        print("components",components)
        self.PayNowBtn.isHidden=true
   //   self.calender.setCurrentPage(<#T##currentPage: Date##Date#>, animated: <#T##Bool#>)
        
        
        
        
        
      let year=components.year
       
      let month=components.month
        let currentyear:String=String(year!)
        let currentmonth:String=String(month!)
        print(year!,month!)
        print(currentmonth,currentyear)
        print (result)
      //  print("color: \(year ?? "")")
        //input: {"trainer_id":"12","year":"2017","month":"05"}
        // let param=["trainer_id": self.trainer_id,"year":year as AnyObject,"year":month as AnyObject] as [String : Any]
        let param=["trainer_id": self.trainer_id,"year":currentyear,"month":currentmonth] as [String : Any]
        self.MonthAvailableDate(fetchDict: param as! [String : String])
        // let param=["trainer_id": self.trainer_id! as AnyObject] as [String : Any]
    //c    self.FetchSessionSchdule(Dict: param as! [String : String])
        self.calender.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.calender.select(self.formatter.date(from: result)!)
               let scopeGesture = UIPanGestureRecognizer(target: self.calender, action: #selector(self.calender.handleScopeGesture(_:)))
        self.calender.addGestureRecognizer(scopeGesture)
        self.PayNowBtn.ButtonRoundCorner(radious: 10)
        self.PayNowView.isHidden = true
        self.DropDown_BackView.UIViewRoundCorner(radious: 10, Colour: UIColor.black)
        DropDownView.delegate=self
        self.Time_slot_dropdown.delegate=self
        self.Start_time_slot.delegate=self
        self.End_time_slot.delegate=self
        self.Time_slot_dropdown.title="Select time slot"
        self.End_time_slot.title="End time"
        self.Start_time_slot.title="Start time"
        self.Time_select_backview.isHidden=true
        self.Time_slot_dropdown.UIViewRoundCorner(radious: 8.0, Colour: .black)
        self.Start_time_slot.UIViewRoundCorner(radious: 8.0, Colour: .black)
        self.End_time_slot.UIViewRoundCorner(radious: 8.0, Colour: .black)
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
    
    // MARK: STPPaymentCardTextFieldDelegate
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        print("Card number: \(textField.cardParams.number) Exp Month: \(textField.cardParams.expMonth) Exp Year: \(textField.cardParams.expYear) CVC: \(textField.cardParams.cvc)")
     //   self.buyButton.enabled = textField.isValid
    }
    
    func PaymentMethodCall(PaymentDict:[String:Any])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let url=Constants.Client_url+"booknowStep2"
        Alamofire.request(url, method: .post, parameters: PaymentDict, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Payment Method Call= ",response)
                        SVProgressHUD.dismiss()
                        if( response.result.value as AnyObject).value(forKey: "is_error") as? NSNumber==0{
                            SVProgressHUD.dismiss()
                            let vc = self.storyboard! .instantiateViewController(withIdentifier: "ClientMyScheduleController") as!ClientMyScheduleController
                            self.navigationController?.pushViewController(vc, animated: true);
                        }
                            
                        else{
                            if( response.result.value as AnyObject).value(forKey: "is_error") as? NSNumber==1{
                            self.presentAlertWithTitle(title: "Alert", message: ((response.result.value as AnyObject).value(forKey: "err_msg") as! String))
                            }
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
        return self.formatter.date(from: "2017/10/30")!
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
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
       let arrdate=self.formatter.string(from: calendar.currentPage).components(separatedBy: "/")
        self.PayNowView.isHidden = true
        
        
//        let currentyear:String=String(arrdate)
//        let currentmonth:String=String(month!)

        let param=["trainer_id": self.trainer_id,"year":arrdate[0],"month":arrdate[1]] as [String : Any]
        print(param)
        self.MonthAvailableDate(fetchDict: param as! [String : String])
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       //      self.calender.appearance.selectionColor=UIColor.black
         let day: Int! = self.gregorian.component(.day, from: date)
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        self.select_date=result
        print (result)

        
      if  self.availableDate.contains(day){
      //  self.calender.sele=false
        self.Time_select_backview.isHidden=false
        self.Time_slot_dropdown.isHidden=false
        self.Start_time_slot.isHidden=true
        self.End_time_slot.isHidden=true
        self.Time_slot_dropdown.title="Select Time slot"
        let index:Int = self.availableDate.index(of: day)!
        print(index as Int)
        let slot=((self.availableDays[index] as AnyObject).value(forKey: "slot")) as! [[String:AnyObject]]
       // print(slot)
       self.availableTime.removeAll()
        self.first_session_date=self.formatter.string(from: date)
        for count in stride(from: 0, to: slot.count, by: 1){
        let startTime=((slot[count] as AnyObject).value(forKey: "start_time")) as! String
            let endTime=((slot[count] as AnyObject).value(forKey: "end_time")) as! String
            
            
            let time = startTime + " to " +  endTime
           // print(time)
            self.availableTime.append(time)
        }
        print("available time",self.availableTime)
        self.Time_slot_dropdown.items=self.availableTime
       // self.PayNowView.isHidden = false
        
        }
      else{
        self.DropDownView.isCollapsed=true
        self.DropDownView.collapseTableView()
        self.PayNowView.isHidden = true
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
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        if dropDown==self.Time_slot_dropdown{
            let Time = availableTime[index].components(separatedBy: "to")
            let slot_start_time = Time[0]
            let slot_end_time = Time[1]
            print("select Start Time",slot_start_time)
            print("select End Time",slot_end_time)
            let arrstartTime=slot_start_time.components(separatedBy: ":")
            let arrEndTime=slot_end_time.components(separatedBy: ":")
            print(arrstartTime[0],arrEndTime[0])
            var newstart:String=arrstartTime[0]
            var newsend:String=arrEndTime[0]
            newsend = newsend.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            newstart = newstart.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
            self.Start_time_slot.items=arrdropdown
            self.End_time_slot.items=arrdropdown
            self.Start_time_slot.isHidden=false
            self.End_time_slot.isHidden=false
            self.Start_time_slot.title="Select start time"
            self.End_time_slot.title="Select end time"
            self.SelectEndTime=""
            self.SelectStartTime=""
            self.PayNowBtn.isHidden=false

            
        }
        if dropDown==self.Start_time_slot{
        self.SelectStartTime=self.Start_time_slot.title
        }
        if dropDown==self.End_time_slot{
         self.SelectEndTime=self.End_time_slot.title
        }
        
        
        
    }
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print("Block");
        print("StpToken",token);
        self.token=String(describing: token as STPToken)
        print("token=",self.token);
        
        self.dismiss(animated: true, completion: {
           // self.showReceiptPage()
            completion(nil)
        })
        if self.token==""{
        
        }
        else{
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            self.PaymentDict["client_id"]=User_id
            self.PaymentDict["slot_start_time"]=SelectStartTime
            self.PaymentDict["slot_end_time"]=SelectEndTime
            self.PaymentDict["first_session_date"]=first_session_date
            self.PaymentDict["trainer_id"]=self.trainer_id
            self.PaymentDict["trainer_id"]=self.trainer_id
            self.PaymentDict["token"]=self.token
            print(self.PaymentDict)
            self.PaymentMethodCall(PaymentDict: self.PaymentDict)
        }
    }
    
    @IBAction func DidTabPayNowBtn(_ sender: Any) {
        
    }
    @IBAction func PayNowBtn(_ sender: Any) {
        
        
        
        
        
        
        if SelectStartTime=="" && SelectEndTime=="" {
            self.presentAlertWithTitle(title: "Alert", message: "Select your Time")
        }
        else if self.SelectStartTime==self.SelectEndTime{
            self.presentAlertWithTitle(title: "Alert", message: "StartTime and Endtime can not be same")
        }
        else{
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "hh:mm:ss"
            let Start_time = self.Start_time_slot.title
            let End_time = self.End_time_slot.title
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
                self.Time_select_backview.isHidden=true
                //first_session_date
                let addCardViewController = STPAddCardViewController()
                addCardViewController.delegate = self
                // STPAddCardViewController must be shown inside a UINavigationController.
                let navigationController = UINavigationController(rootViewController: addCardViewController)
                self.present(navigationController, animated: true, completion: nil)
                
            }

        }
        

            
            
            
        
    }

    @IBAction func DidTabTimeSelectBtnHide(_ sender: Any) {
         self.Time_select_backview.isHidden=true
        
    }
    @IBAction func DidTabBackBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func DidTabViewSchedulebtn(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MySchduleController") as! MySchduleController
        vc.IsclientScheduleShow=true
        vc.IsNotComeFromDrawer=true
        vc.Traine_id=self.trainer_id
        vc.select_date=self.select_date
        vc.trainer_name=self.Trainer_name
        
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


