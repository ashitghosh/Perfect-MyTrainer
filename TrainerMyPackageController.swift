//
//  TrainerMyPackageController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 26/04/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class TrainerMyPackageController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HADropDownDelegate {
    @IBOutlet var Disscount_session_time: HADropDown!

    @IBOutlet var Add_packe_title: UILabel!
    @IBOutlet var Session_time_background_view: UIView!
    @IBOutlet var My_package_scorllView: UIScrollView!
    @IBOutlet var Tandem_discount_tableview: UITableView!
    @IBOutlet var Group_discount_tableview: UITableView!
    @IBOutlet var Individual_discount_tableview: UITableView!
    @IBOutlet var Tandem_DiscountView: UIView!
    @IBOutlet var GroupDiscount_view: UIView!
    @IBOutlet var Individual_discount_view: UIView!
    var arrIndividualDiscount = [[String:AnyObject]] ()
    @IBOutlet var Discount_pop_View: UIView!
    var arrGroupDiscount = [[String:AnyObject]] ()
    var arrTandemDiscount = [[String:AnyObject]]()
    var arrTrainingType = [String]()
    var EditDict=[[String:AnyObject]]()
    var IsEDit:Bool = false
    
    @IBOutlet var Add_disscount_price_txt: UITextField!
    @IBOutlet var AddDisscount_switchBtn: UISwitch!
    @IBOutlet var Discount_dropdown: HADropDown!
    @IBOutlet var Session_dropdown: HADropDown!
    @IBOutlet var DiscountBackView: UIView!
    @IBOutlet var Discount_dropdown_backView: UIView!
    @IBOutlet var Session_txt: UITextField!
    
    @IBOutlet var Discount_saveBtn: UIButton!
    @IBOutlet var Price_BackView: UIView!
    @IBOutlet var Discount_type_dropdownBackView: UIView!
    var Discount_type:String = ""
    var Discount_Staus = "1"
    var IndiviDual_Session_length = ""
    var Group_Session_length = ""
    var Tandem_Session_length = ""
    var Discount_session_time_length = ""
    
    
        override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ViewCoordinateAccordingtocontent()
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
          let  dict=["trainer_id":User_id]
            self.FetchPackageList(dict: dict)
            
       // self.view.addSubview(self.My_package_scorllView)
           
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITextField.appearance().tintColor = UIColor.lightGray
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if My_package_scorllView.contentOffset.x>0 {
            My_package_scorllView.contentOffset.x = 0
        }
    }
    override func viewWillLayoutSubviews(){
       // super.viewWillLayoutSubviews()
        My_package_scorllView.layoutIfNeeded()
        
      if self.view.frame.size.width==320 {
            My_package_scorllView.contentSize = CGSize.init(width: self.view.frame.size.width, height: My_package_scorllView.frame.size.height+150)
        }
        else{
            My_package_scorllView.contentSize = CGSize.init(width: self.view.frame.size.width, height: My_package_scorllView.frame.size.height+100)
        }
        
    }
    
    func ReadyView()  {
        Discount_dropdown.delegate=self
        self.Disscount_session_time.delegate=self
        Discount_dropdown.font=UIFont.systemFont(ofSize: 12)
        self.Disscount_session_time.font=UIFont.systemFont(ofSize: 12)
        
//        if arrGroupDiscount.isEmpty==false{
//            Group_session_length_dropdown.tableFrame.origin.y=GroupSession_view.frame.size.height+Individual_session_view.frame.size.height+Individual_discount_view.frame.size.height
//            Group_session_length_dropdown.tableFrame.origin.x=GroupSession_view.frame.origin.x+30
//        }
//        else{
//            Group_session_length_dropdown.tableFrame.origin.y=GroupSession_view.frame.size.height+Individual_session_view.frame.size.height
//            Group_session_length_dropdown.tableFrame.origin.x=GroupSession_view.frame.origin.x+30
//        }
//        if arrTandemDiscount.isEmpty==false{
//            
//        }
//        else{
//            Tandem_session_length.tableFrame.size.height=200
//            Tandem_session_length.tableFrame.origin.y=TandemSession_View.frame.size.height+GroupSession_view.frame.size.height+Individual_session_view.frame.size.height
//            Tandem_session_length.tableFrame.origin.x=TandemSession_View.frame.origin.x+30
//        }
        
        //Discount_dropdown.items=["Individual","Group","Tandem"]
        Disscount_session_time.items=[ "30 min","60 min"]
        self.addDoneButtonOnKeyboard()
        self.DiscountBackView.isHidden=true
        self.Discount_pop_View.UIViewRoundCorner(radious: 10.0, Colour: UIColor.clear)
       // self.Discount_dropdown.UIViewRoundCorner(radious: 5.0, Colour: UIColor.gray)
        self.Discount_dropdown_backView.UIViewRoundCorner(radious: 5.0, Colour: UIColor.gray)
         self.Session_time_background_view.UIViewRoundCorner(radious: 5.0, Colour: UIColor.gray)
         self.Price_BackView.UIViewRoundCorner(radious: 5.0, Colour: UIColor.gray)
        self.Discount_type_dropdownBackView.UIViewRoundCorner(radious: 5.0, Colour: UIColor.gray)
        self.Discount_saveBtn.ButtonRoundCorner(radious: 5.0)
        //self.My_package_scorllView.addSubview(Individual_Session_length)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count=0
        if tableView==Individual_discount_tableview {
            count=self.arrIndividualDiscount.count
        }
        else if tableView==self.Group_discount_tableview{
        count=self.arrGroupDiscount.count
        }
        else if tableView==self.Tandem_discount_tableview{
            count=self.arrTandemDiscount.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DiscountCell! = tableView.dequeueReusableCell(withIdentifier: "DiscountCell") as! DiscountCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        if tableView==Individual_discount_tableview {
           
            
        cell.session_price.text="$" + String(describing: ((arrIndividualDiscount[indexPath.row] as AnyObject).value(forKey: "price")) as! NSNumber)
            cell.Session_count.text = String(describing: ((arrIndividualDiscount[indexPath.row] as AnyObject).value(forKey: "max_session")) as! NSNumber)  +  " Session"
       // cell.Seassion_status_lbl.text = String(describing: ((arrIndividualDiscount[indexPath.row] as AnyObject).value(forKey: "discount_status")) as! NSNumber)
            let discount_status:String=((arrIndividualDiscount[indexPath.row] as AnyObject).value(forKey: "discount_status")) as! String

            if  discount_status=="0"{
             cell.Seassion_status_lbl.text="Inactive"
            }
            else{
            cell.Seassion_status_lbl.text="Active"
            }
        cell.Session_edit_btn.tag=indexPath.row
        cell.Session_Delete_btn.tag=indexPath.row
            cell.Session_edit_btn.addTarget(self,action:#selector(ClickForIndividualEdit(sender:)),
                                        for:.touchUpInside)
            cell.Session_Delete_btn.addTarget(self,action:#selector(ClickForIndividualDelete(sender:)),
                                           for:.touchUpInside)
            
        }
        if tableView==Group_discount_tableview {
            
            let discount_status:String=((arrGroupDiscount[indexPath.row] as AnyObject).value(forKey: "discount_status")) as! String
            
            if  discount_status=="0"{
                cell.Seassion_status_lbl.text="Inactive"
            }
            else{
                cell.Seassion_status_lbl.text="Active"
            }
           // let price = Double(((arrGroupDiscount[indexPath.row] as AnyObject).value(forKey: "price")) as! NSNumber)
           // let price_txt=String(describing: price)
           // cell.session_price.text="$" + price_txt
            cell.session_price.text="$" + String(describing: ((arrGroupDiscount[indexPath.row] as AnyObject).value(forKey: "price")) as! NSNumber)
            cell.Session_count.text = String(describing: ((arrGroupDiscount[indexPath.row] as AnyObject).value(forKey: "max_session")) as! NSNumber)  +  " Session"
           // cell.Seassion_status_lbl.text = String(describing: ((arrGroupDiscount[indexPath.row] as AnyObject).value(forKey: "discount_status")) as! NSNumber)
            cell.Session_edit_btn.tag=indexPath.row
            cell.Session_Delete_btn.tag=indexPath.row
            
            cell.Session_edit_btn.addTarget(self,action:#selector(ClickForGroupEdit(sender:)),
                                            for:.touchUpInside)
            cell.Session_Delete_btn.addTarget(self,action:#selector(ClickForGroupDelete(sender:)),
                                              for:.touchUpInside)
            
        }
        if tableView==Tandem_discount_tableview {
             let discount_status:String=((arrTandemDiscount[indexPath.row] as AnyObject).value(forKey: "discount_status")) as! String
            
            if  discount_status=="0"{
                cell.Seassion_status_lbl.text="Inactive"
            }
            else{
                cell.Seassion_status_lbl.text="Active"
            }
            cell.session_price.text="$" + String(describing: ((arrTandemDiscount[indexPath.row] as AnyObject).value(forKey: "price")) as! NSNumber)
            cell.Session_count.text = String(describing: ((arrTandemDiscount[indexPath.row] as AnyObject).value(forKey: "max_session")) as! NSNumber)  +  " Session"
           // cell.Seassion_status_lbl.text = String(describing: ((arrTandemDiscount[indexPath.row] as AnyObject).value(forKey: "discount_status")) as! NSNumber)
            cell.Session_edit_btn.tag=indexPath.row
            cell.Session_Delete_btn.tag=indexPath.row
            cell.Session_edit_btn.addTarget(self,action:#selector(ClickForTandemEdit(sender:)),
                                            for:.touchUpInside)
            cell.Session_Delete_btn.addTarget(self,action:#selector(ClickForTandemDelete(sender:)),
                                              for:.touchUpInside)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
  func ViewCoordinateAccordingtocontent()  {
        
        if arrTrainingType.isEmpty==false{
             var Size:CGSize=CGSize.init(width: 0, height: 0)
            var  NewYAxis:NSInteger = 5
            
           // var NewYAxis:NSInteger=5
            if arrTrainingType.contains("individual")&&arrTrainingType.contains("group")&&arrTrainingType.contains("tandem"){
                if arrTrainingType.contains("individual") {
                    if arrIndividualDiscount.isEmpty==false{
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                    self.Individual_discount_view.isHidden=false
                        self.Individual_discount_view.frame=CGRect.init(x: 0, y: Size.height  , width: self.Individual_discount_view.frame.size.width, height: Individual_discount_view.frame.size.height)
                         print(Size.height)
                        NewYAxis+=NSInteger(5+Individual_discount_view.frame.size.height)
                        print("height=",NewYAxis)
                    }
                    else{
                        self.Individual_discount_view.isHidden=true
                    }
               
            }
                
                if arrTrainingType.contains("group") {

                    if arrGroupDiscount.isEmpty==false{
                        self.GroupDiscount_view.isHidden=false
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.GroupDiscount_view.frame=CGRect.init(x: 0, y: Size.height  , width: self.GroupDiscount_view.frame.size.width, height: GroupDiscount_view.frame.size.height)
                        NewYAxis+=NSInteger(self.GroupDiscount_view.frame.size.height+5)
                        print("height=",NewYAxis)
                    }
                    else{
                     self.GroupDiscount_view.isHidden=true
                    }
                }
                
                if arrTrainingType.contains("tandem") {
                        if arrTandemDiscount.isEmpty==false{
                        self.Tandem_DiscountView.isHidden=false
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.Tandem_DiscountView.frame=CGRect.init(x: 0, y: Size.height  , width: self.Tandem_DiscountView.frame.size.width, height: Tandem_DiscountView.frame.size.height)
                        NewYAxis+=NSInteger(self.Tandem_DiscountView.frame.size.height+5)
                        print("height=",NewYAxis)
                    }
                    else{
                    self.Tandem_DiscountView.isHidden=true
                    }
                }
        }
            else if arrTrainingType.contains("individual")&&arrTrainingType.contains("group"){
                self.Tandem_DiscountView.isHidden=true
               
                    if arrIndividualDiscount.isEmpty==false{
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.Individual_discount_view.isHidden=false
                        self.Individual_discount_view.frame=CGRect.init(x: 0, y: Size.height  , width: self.Individual_discount_view.frame.size.width, height: Individual_discount_view.frame.size.height)
                        NewYAxis+=NSInteger(5+Individual_discount_view.frame.size.height)
                        print("height=",NewYAxis)
                    }
                    else{
                        self.Individual_discount_view.isHidden=true
                    }
                    
               
                
                if arrTrainingType.contains("group") {
                    if arrGroupDiscount.isEmpty==false{
                        self.GroupDiscount_view.isHidden=false
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.GroupDiscount_view.frame=CGRect.init(x: 0, y: Size.height  , width: self.GroupDiscount_view.frame.size.width, height: GroupDiscount_view.frame.size.height)
                        NewYAxis+=NSInteger(self.GroupDiscount_view.frame.size.height+5)
                        print("height=",NewYAxis)
                    }
                    else{
                        self.GroupDiscount_view.isHidden=true
                    }
                }

            }
    
            else if arrTrainingType.contains("individual")&&arrTrainingType.contains("tandem"){
                self.GroupDiscount_view.isHidden=true
                    if arrTrainingType.contains("individual") {
                    
                    if arrIndividualDiscount.isEmpty==false{
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.Individual_discount_view.isHidden=false
                        self.Individual_discount_view.frame=CGRect.init(x: 0, y: Size.height  , width: self.Individual_discount_view.frame.size.width, height: Individual_discount_view.frame.size.height)
                        print(Size.height)
                        NewYAxis+=NSInteger(5+Individual_discount_view.frame.size.height)
                        print("height=",NewYAxis)
                    }
                    else{
                        self.Individual_discount_view.isHidden=true
                    }
                    
                }
                if arrTrainingType.contains("tandem") {
                   
                    if arrTandemDiscount.isEmpty==false{
                        self.Tandem_DiscountView.isHidden=false
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.Tandem_DiscountView.frame=CGRect.init(x: 0, y: Size.height  , width: self.Tandem_DiscountView.frame.size.width, height: Tandem_DiscountView.frame.size.height)
                        NewYAxis+=NSInteger(self.Tandem_DiscountView.frame.size.height+5)
                        print("height=",NewYAxis)
                    }
                    else{
                        self.Tandem_DiscountView.isHidden=true
                    }
                }
            }
            else if arrTrainingType.contains("group")&&arrTrainingType.contains("tandem"){
               
                self.Individual_discount_view.isHidden=true
                
                    if arrGroupDiscount.isEmpty==false{
                        self.GroupDiscount_view.isHidden=false
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.GroupDiscount_view.frame=CGRect.init(x: 0, y: Size.height  , width: self.GroupDiscount_view.frame.size.width, height: GroupDiscount_view.frame.size.height)
                        NewYAxis+=NSInteger(self.GroupDiscount_view.frame.size.height+5)
                        print("height=",NewYAxis)
                    }
                    else{
                        self.GroupDiscount_view.isHidden=true
                    }
            
            
                if arrTrainingType.contains("tandem") {
                        if arrTandemDiscount.isEmpty==false{
                        self.Tandem_DiscountView.isHidden=false
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.Tandem_DiscountView.frame=CGRect.init(x: 0, y: Size.height  , width: self.Tandem_DiscountView.frame.size.width, height: Tandem_DiscountView.frame.size.height)
                        NewYAxis+=NSInteger(self.Tandem_DiscountView.frame.size.height+5)
                        print("height=",NewYAxis)
                    }
                    else{
                        self.Tandem_DiscountView.isHidden=true
                    }
                }

            }
            else{
                if arrTrainingType.contains("individual") {
                   
                    self.GroupDiscount_view.isHidden=true
                    self.Tandem_DiscountView.isHidden=true
                        if arrIndividualDiscount.isEmpty==false{
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.Individual_discount_view.isHidden=false
                        self.Individual_discount_view.frame=CGRect.init(x: 0, y: Size.height  , width: self.Individual_discount_view.frame.size.width, height: Individual_discount_view.frame.size.height)
                        print(Size.height)
                        NewYAxis+=NSInteger(5+Individual_discount_view.frame.size.height)
                        Size.height=CGFloat(NewYAxis)
                        

                        print("height=",NewYAxis)
                    }
                    else{
                        self.Individual_discount_view.isHidden=true
                    }
                    
                }
              else  if arrTrainingType.contains("group") {
                    self.Individual_discount_view.isHidden=true
                    self.Tandem_DiscountView.isHidden=true

                    
                    if arrGroupDiscount.isEmpty==false{
                        self.GroupDiscount_view.isHidden=false
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.GroupDiscount_view.frame=CGRect.init(x: 0, y: Size.height  , width: self.GroupDiscount_view.frame.size.width, height: GroupDiscount_view.frame.size.height)
                        NewYAxis+=NSInteger(self.GroupDiscount_view.frame.size.height+5)
                        print("height=",NewYAxis)
                        Size.height=CGFloat(NewYAxis)
                        
                    }
                    else{
                        self.GroupDiscount_view.isHidden=true
                    }
                }
              else  if arrTrainingType.contains("tandem") {
                    self.GroupDiscount_view.isHidden=true
                    self.Individual_discount_view.isHidden=true

 
                    if arrTandemDiscount.isEmpty==false{
                        self.Tandem_DiscountView.isHidden=false
                        Size.height=0
                        Size.height=CGFloat(NewYAxis)
                        self.Tandem_DiscountView.frame=CGRect.init(x: 0, y: Size.height  , width: self.Tandem_DiscountView.frame.size.width, height: Tandem_DiscountView.frame.size.height)
                        NewYAxis+=NSInteger(self.Tandem_DiscountView.frame.size.height+5)
                        print("height=",NewYAxis)
                        
                    }
                    else{
                        self.Tandem_DiscountView.isHidden=true
                    }
                }
            }
            Size.height=0
            Size.height=CGFloat(NewYAxis)
            // My_package_scorllView.contentSize = CGSize.init(width: self.view.frame.size.width, height: Size.height+300)
            
        }
        else{
        
        }
         self.ReadyView()

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
       
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     textField.resignFirstResponder()
       return true
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
        
        self.Add_disscount_price_txt.inputAccessoryView = doneToolbar
        self.Session_txt.inputAccessoryView = doneToolbar
        
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
    func doneButtonAction() {
        self.Add_disscount_price_txt.resignFirstResponder()
        self.Session_txt.resignFirstResponder()
       
    }
    
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        if dropDown==Discount_dropdown {
            if Discount_dropdown.title=="tandem"{
            Discount_type="tandem"
            
            }
         else  if Discount_dropdown.title=="group"{
                Discount_type="group"
                
            }
            else  if Discount_dropdown.title=="individual"{
                Discount_type="individual"
                
            }
            
        }
        if dropDown==Disscount_session_time{
            Discount_session_time_length=""
            if Disscount_session_time.title=="30 min"{
                Discount_session_time_length="30"
            }
            else if Disscount_session_time.title=="60 min"{
                Discount_session_time_length="60"
            }
                       print("session length",Discount_session_time_length)
            
        }

        
    }
    
    func didShow(dropDown: HADropDown) {
        self.view.endEditing(true)
        
        if dropDown==Disscount_session_time{
            Discount_dropdown.isCollapsed=true
            Discount_dropdown.collapseTableView()
            
        }
        if dropDown==Discount_dropdown{
            Disscount_session_time.isCollapsed=true
            Disscount_session_time.collapseTableView()
            
        }
        
    }

// Mark: Almofire Method 
    
    func SavePackage(dict:[String:String])  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let url=Constants.Base_url+"insertTrainerDiscoutPackage"
        Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default)
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
                            let count=0
                            let user_type=(((((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as! NSArray )[count]) as AnyObject).value(forKey: "user_type")) as! String
                            print("user_type",user_type)
                            if user_type=="individual"{
                                self.arrIndividualDiscount.removeAll()
                                self.arrIndividualDiscount=((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as AnyObject) as! [[String : AnyObject]]
                                self.Individual_discount_tableview.reloadData()
                            }
                            if user_type=="group"{
                                self.arrGroupDiscount.removeAll()
                                self.arrGroupDiscount=((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as AnyObject) as! [[String : AnyObject]]
                                print("group array",self.arrGroupDiscount)
                                self.Group_discount_tableview.reloadData()
                                
                            }
                            if user_type=="tandem"{
                                self.arrTandemDiscount.removeAll()
                                self.arrTandemDiscount=((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as AnyObject) as! [[String : AnyObject]]
                                self.Tandem_discount_tableview.reloadData()
                            }
                            self.ViewCoordinateAccordingtocontent()
                        
                        }
                        else{
                            
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                    }
                }

        }
    }
    func FetchPackageList(dict:[String:String])  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        print(dict)
        let url=Constants.Base_url+"showTrainerPackage"
        Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    print( "Json  return for Sign Up= ",response)
                    switch(status){
                    case 200:
                        print( "Json  return for Sign Up= ",response)
                        SVProgressHUD.dismiss()
                        if( response.result.value as AnyObject).value(forKey: "status") as? NSNumber==0{
                            SVProgressHUD.dismiss()
                          self.arrTrainingType=(response.result.value as AnyObject).value(forKey: "UserType") as! [String]
                            self.Discount_dropdown.items=(response.result.value as AnyObject).value(forKey: "UserType") as! [String]
                           self.Discount_dropdown.reloadInputViews()
                            
                            if self.arrTrainingType.contains("individual"){
                                self.arrIndividualDiscount=((response.result.value as AnyObject).value(forKey: "individual"))as! [[String:AnyObject]]
                                 print("Array discount",self.arrIndividualDiscount)
                                if self.arrIndividualDiscount.isEmpty==false{
                                  self.Individual_discount_tableview.reloadData()
                                }
                               // let max_session_count:NSInteger=NSInteger(max_session! as NSNumber)
                               
                                
                            }
                            
                            if self.arrTrainingType.contains("tandem"){
                                self.arrTandemDiscount=((response.result.value as AnyObject).value(forKey: "tandem"))as! [[String:AnyObject]]
                                print("Array discount",self.arrTandemDiscount)
                                if self.arrTandemDiscount.isEmpty==false{
                                 self.Tandem_discount_tableview.reloadData()
                                }
                                
                                // let max_session_count:NSInteger=NSInteger(max_session! as NSNumber)
                                
                            }
                                if self.arrTrainingType.contains("group"){
                                    self.arrGroupDiscount=((response.result.value as AnyObject).value(forKey: "group"))as! [[String:AnyObject]]
                                    print("Array discount",self.arrGroupDiscount)
                                    if self.arrGroupDiscount.isEmpty==false{
                                      self.Group_discount_tableview.reloadData()
                                    }
                                    
                                   
                            }
                            
                            self.ViewCoordinateAccordingtocontent()
                        }
                            
                        else{
                            
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.dismiss()
                    }
                }
                
        }
    }

    
    
    
    
    func SaveDiscountPackage(dict:[String:String])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let url=Constants.Base_url+"insertTrainerDiscoutPackage"
        Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default)
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
                           /// let user_tyoe=((((response.result.value as AnyObject).value(forKey: "DiscountPackage") as AnyObject)[0] as AnyObject).value(forKey: "user_type")) as! String
                            let count=0
                            let user_type=(((((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as! NSArray )[count]) as AnyObject).value(forKey: "user_type")) as! String
                            print("user_type",user_type)
                            if user_type=="individual"{
                                self.arrIndividualDiscount.removeAll()
                            self.arrIndividualDiscount=((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as AnyObject) as! [[String : AnyObject]]
                                self.Individual_discount_tableview.reloadData()
                            }
                            if user_type=="group"{
                                 self.arrGroupDiscount.removeAll()
                                self.arrGroupDiscount=((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as AnyObject) as! [[String : AnyObject]]
                                print("group array",self.arrGroupDiscount)
                                self.Group_discount_tableview.reloadData()
                                
                            }
                            if user_type=="tandem"{
                                 self.arrTandemDiscount.removeAll()
                                self.arrTandemDiscount=((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as AnyObject) as! [[String : AnyObject]]
                                self.Tandem_discount_tableview.reloadData()
                            }
                            self.ViewCoordinateAccordingtocontent()
                        }
                            
                        else{
                            
                            SVProgressHUD.dismiss()
                            let alert_msg=((response.result.value as AnyObject).value(forKey: "message")) as? String
                            self.presentAlertWithTitle(title: "Alert", message: alert_msg!)
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
    
    func EditDiscountPackage(dict:[[String:AnyObject]])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        if Session_txt.text?.characters.count==0{
            self.presentAlertWithTitle(title: "Alert", message: "Write Your Session")
        }
        else if Add_disscount_price_txt.text?.characters.count==0{
            self.presentAlertWithTitle(title: "Alert", message: "Write Your Price")
        }
            
            
        else{
            let Package_id=(self.EditDict[0] as AnyObject).value(forKey: "package_id") as! NSNumber
            self.DiscountBackView.isHidden=true
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            let  DiscountDict=["max_session":Session_txt.text!,"price":Add_disscount_price_txt.text!,"user_type":Discount_type,"status":Discount_Staus,"trainer_id":User_id,"package_id":Package_id,"session_time":Discount_session_time_length] as [String : Any]
            print(DiscountDict)
            
            let url=Constants.Base_url+"updateTrainerDiscoutPackage"
            Alamofire.request(url, method: .post, parameters: DiscountDict, encoding: JSONEncoding.default)
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
                                /// let user_tyoe=((((response.result.value as AnyObject).value(forKey: "DiscountPackage") as AnyObject)[0] as AnyObject).value(forKey: "user_type")) as! String
                                let count=0
                                let user_type=(((((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as! NSArray )[count]) as AnyObject).value(forKey: "user_type")) as! String
                                print("user_type",user_type)
                                if user_type=="individual"{
                                    self.arrIndividualDiscount.removeAll()
                                    self.arrIndividualDiscount=((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as AnyObject) as! [[String : AnyObject]]
                                    self.Individual_discount_tableview.reloadData()
                                }
                                if user_type=="group"{
                                    self.arrGroupDiscount.removeAll()
                                    self.arrGroupDiscount=((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as AnyObject) as! [[String : AnyObject]]
                                    print("group array",self.arrGroupDiscount)
                                    self.Group_discount_tableview.reloadData()
                                    
                                }
                                if user_type=="tandem"{
                                    self.arrTandemDiscount.removeAll()
                                    self.arrTandemDiscount=((response.result.value as AnyObject).value(forKey:"DiscountPackage" ) as AnyObject) as! [[String : AnyObject]]
                                    self.Tandem_discount_tableview.reloadData()
                                }
                                self.ViewCoordinateAccordingtocontent()
                            }
                                
                            else{
                                
                                SVProgressHUD.dismiss()
                                let alert_msg=((response.result.value as AnyObject).value(forKey: "message")) as? String
                                self.presentAlertWithTitle(title: "Alert", message: alert_msg!)
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

        
        
    }
    
    func DeleteDiscountPackage(Dict:[String:String]){
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
     //   let userDefaults = Foundation.UserDefaults.standard
     //   let User_id:String = userDefaults.string(forKey: "user_id")!
     //   let param=["trainer_id": User_id as AnyObject]
        let url=Constants.Base_url+"deleteDiscountPackage"
        Alamofire.request(url, method: .post, parameters: Dict, encoding: JSONEncoding.default)
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



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidTabAddDiscountBtn(_ sender: Any) {
        self.Add_packe_title.text="Add Package";
         self.DiscountBackView.isHidden=false
        IsEDit=false
    }

    @IBAction func DidTabDrawerBtn(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBAction func DidTabAddDiscountSaveBtn(_ sender: Any) {
        self.Session_dropdown.isCollapsed=true
        self.Session_dropdown.collapseTableView()
        self.Discount_dropdown.isCollapsed=true
        self.Discount_dropdown.collapseTableView()
        if IsEDit==true{
        self.EditDiscountPackage(dict: self.EditDict)
        }
        else{
            if Session_txt.text?.characters.count==0{
                self.presentAlertWithTitle(title: "Alert", message: "Write Your Session")
            }
            else if Add_disscount_price_txt.text?.characters.count==0{
                self.presentAlertWithTitle(title: "Alert", message: "Write Your Price")
            }
            else if Discount_type==""{
                self.presentAlertWithTitle(title: "Alert", message: "Select Discount Type")
            }
            else if Discount_Staus==""{
                self.presentAlertWithTitle(title: "Alert", message: "Select Package Status")
            }
            else if Discount_session_time_length==""{
                self.presentAlertWithTitle(title: "Alert", message: "Select Session Time")
            }
            else{
                self.DiscountBackView.isHidden=true
                let userDefaults = Foundation.UserDefaults.standard
                let User_id:String = userDefaults.string(forKey: "user_id")!
                let  DiscountDict=["max_session":Session_txt.text!,"price":Add_disscount_price_txt.text!,"user_type":Discount_type,"status":Discount_Staus,"trainer_id":User_id,"session_time":Discount_session_time_length]
                print(DiscountDict)
                
                self.SaveDiscountPackage(dict: DiscountDict)
                
            }

        }
        
    }
    @IBAction func AddDiscountPopUpDismissBtn(_ sender: Any) {
        
         self.DiscountBackView.isHidden=true
        self.view.endEditing(true);
        self.Session_dropdown.isCollapsed=true
        self.Session_dropdown.collapseTableView()
        self.Discount_dropdown.isCollapsed=true
        self.Discount_dropdown.collapseTableView()
    }
    
    @IBAction func DisCouViewViewHideBtn(_ sender: Any) {
         self.DiscountBackView.isHidden=true
        self.Session_dropdown.isCollapsed=true
        self.Session_dropdown.collapseTableView()
        self.Discount_dropdown.isCollapsed=true
        self.Discount_dropdown.collapseTableView()
        
    }
    @IBAction func DidTabAddDiscountSwitchBtn(_ sender: Any) {
        self.Session_dropdown.isCollapsed=true
        self.Session_dropdown.collapseTableView()
        self.Discount_dropdown.isCollapsed=true
        self.Discount_dropdown.collapseTableView()
        if self.AddDisscount_switchBtn.isOn{
        self.Discount_Staus="1"
        }
        else{
        self.Discount_Staus="0"
        }
    }
    
    
    func ClickForIndividualEdit(sender:UIButton)
    {
        self.Add_packe_title.text="Edit Package";
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        IsEDit=true
        self.DiscountBackView.isHidden=false
        self.EditDict.removeAll()
        self.EditDict.append((self.arrIndividualDiscount[SelectedTag] as AnyObject) as! [String : AnyObject])
        print("dict",self.EditDict)
        self.Session_txt.text=String(describing: ((arrIndividualDiscount[SelectedTag] as AnyObject).value(forKey: "max_session")) as! NSNumber)
        self.Add_disscount_price_txt.text=String(describing: ((arrIndividualDiscount[SelectedTag] as AnyObject).value(forKey: "price")) as! NSNumber)
        self.Discount_dropdown.title=((arrIndividualDiscount[SelectedTag] as AnyObject).value(forKey: "user_type"))as! String
        Discount_type=((arrIndividualDiscount[SelectedTag] as AnyObject).value(forKey: "user_type"))as! String
        self.Disscount_session_time.title=String(describing: ((arrIndividualDiscount[SelectedTag] as AnyObject).value(forKey: "session_time"))as! NSNumber)
        Discount_session_time_length=String(describing: ((arrIndividualDiscount[SelectedTag] as AnyObject).value(forKey: "session_time"))as! NSNumber)
        let discountstatus:String=String(describing: ((arrIndividualDiscount[SelectedTag] as AnyObject).value(forKey: "discount_status"))as! String)
        print("discount status=",discountstatus);
        if  discountstatus=="1"{
            // cell.Seassion_status_lbl.text="Inactive"
            self.Discount_Staus="1"
            self.AddDisscount_switchBtn.setOn(true, animated: true)
            
        }
        else{
            self.Discount_Staus="0"
            self.AddDisscount_switchBtn.setOn(false, animated: true)
        }
        print(self.Session_txt.text!,self.Add_disscount_price_txt.text!)
        
    
    }
    
 func ClickForGroupEdit(sender:UIButton)
    
{
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        IsEDit=true
    self.Add_packe_title.text="Edit Package";
        self.DiscountBackView.isHidden=false
    self.DiscountBackView.isHidden=false
    self.EditDict.removeAll()
    self.EditDict.append((self.arrGroupDiscount[SelectedTag] as AnyObject) as! [String : AnyObject])
    print("dict",self.EditDict)
    self.Session_txt.text=String(describing: ((arrGroupDiscount[SelectedTag] as AnyObject).value(forKey: "price")) as! NSNumber)
    self.Add_disscount_price_txt.text=String(describing: ((arrGroupDiscount[SelectedTag] as AnyObject).value(forKey: "price")) as! NSNumber)
    self.Discount_dropdown.title=((arrGroupDiscount[SelectedTag] as AnyObject).value(forKey: "user_type"))as! String
    Discount_type=((arrGroupDiscount[SelectedTag] as AnyObject).value(forKey: "user_type"))as! String
    
    Discount_session_time_length=String(describing: ((arrGroupDiscount[SelectedTag] as AnyObject).value(forKey: "session_time"))as! NSNumber)
    Disscount_session_time.title=String(describing: ((arrGroupDiscount[SelectedTag] as AnyObject).value(forKey: "session_time"))as! NSNumber)
    let discountstatus:String=String(describing: ((arrGroupDiscount[SelectedTag] as AnyObject).value(forKey: "session_time"))as! NSNumber)
    print("discount status=",discountstatus);
    if  discountstatus=="1"{
        // cell.Seassion_status_lbl.text="Inactive"
        self.Discount_Staus="1"
        self.AddDisscount_switchBtn.setOn(true, animated: true)
    }
    else{
        self.AddDisscount_switchBtn.setOn(false, animated: true)
        self.Discount_Staus="0"
    }
    print(self.Session_txt.text!,self.Add_disscount_price_txt.text!)
    
    }
    
    func ClickForTandemEdit(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        IsEDit=true
        self.Add_packe_title.text="Edit Package";
        self.EditDict.removeAll()
        self.DiscountBackView.isHidden=false
        self.EditDict.append((self.arrTandemDiscount[SelectedTag] as AnyObject) as! [String : AnyObject])
        print("dict",self.EditDict)
        self.Session_txt.text=String(describing: ((arrTandemDiscount[SelectedTag] as AnyObject).value(forKey: "price")) as! NSNumber)
        self.Add_disscount_price_txt.text=String(describing: ((arrTandemDiscount[SelectedTag] as AnyObject).value(forKey: "price")) as! NSNumber)
        self.Discount_dropdown.title=((arrTandemDiscount[SelectedTag] as AnyObject).value(forKey: "user_type"))as! String
        Discount_type=((arrTandemDiscount[SelectedTag] as AnyObject).value(forKey: "user_type"))as! String
        
        Discount_session_time_length=String(describing: ((arrTandemDiscount[SelectedTag] as AnyObject).value(forKey: "session_time"))as! NSNumber)
        Disscount_session_time.title=String(describing: ((arrTandemDiscount[SelectedTag] as AnyObject).value(forKey: "session_time"))as! NSNumber)
        let discountstatus:String=String(describing: ((arrTandemDiscount[SelectedTag] as AnyObject).value(forKey: "discount_status"))as! String)
        print("discount status=",discountstatus);
        if  discountstatus == "1"{
            // cell.Seassion_status_lbl.text="Inactive"
            self.Discount_Staus="1"
            self.AddDisscount_switchBtn.setOn(true, animated: true) 
        }
        else{
            self.AddDisscount_switchBtn.setOn(false, animated: true)
            self.Discount_Staus="0"
        }
        
    }
    func ClickForIndividualDelete(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!

        
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure want to delete", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Yes", style: .default) {
                (action: UIAlertAction) in print("Youve pressed OK Button")
                let Package_id=String(describing: ((self.arrIndividualDiscount[SelectedTag] as AnyObject).value(forKey: "package_id"))as! NSNumber)
                let discount=["package_id":Package_id,"trainer_id":User_id] as [String : Any]
                self.DeleteDiscountPackage(Dict: discount as! [String : String])
                self.arrIndividualDiscount.remove(at: SelectedTag)
                self.Individual_discount_tableview.reloadData()
                
            }
            let No = UIAlertAction(title: "No", style: .default) {
                (action: UIAlertAction) in print("Youve pressed No Button")
            }
            
            alertController.addAction(OKAction)
            alertController.addAction(No)
            self.present(alertController, animated: true, completion: nil)
        
       
        
    }
    func ClickForGroupDelete(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure want to delete", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
            let Package_id=String(describing: ((self.arrGroupDiscount[SelectedTag] as AnyObject).value(forKey: "package_id"))as! NSNumber)
            let discount=["package_id":Package_id,"trainer_id":User_id] as [String : Any]
            self.DeleteDiscountPackage(Dict: discount as! [String : String])
            self.arrGroupDiscount.remove(at: SelectedTag)
            self.Group_discount_tableview.reloadData()
            
        }
        let No = UIAlertAction(title: "No", style: .default) {
            (action: UIAlertAction) in print("Youve pressed No Button")
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(No)
        self.present(alertController, animated: true, completion: nil)

        
       
    
    }
    func ClickForTandemDelete(sender:UIButton)
    {
        let SelectedTag:NSInteger=(sender as AnyObject).tag
        print(SelectedTag)
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure want to delete", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
           let Package_id = String(describing: ((self.arrTandemDiscount[SelectedTag] as AnyObject).value(forKey: "package_id"))as! NSNumber)
            let discount=["package_id":Package_id,"trainer_id":User_id] as [String : Any]
            self.DeleteDiscountPackage(Dict: discount as! [String : String])
            self.arrTandemDiscount.remove(at: SelectedTag)
            self.Tandem_discount_tableview.reloadData()
            
        }
        let No = UIAlertAction(title: "No", style: .default) {
            (action: UIAlertAction) in print("Youve pressed No Button")
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(No)
        self.present(alertController, animated: true, completion: nil)
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
