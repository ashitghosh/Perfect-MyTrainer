//
//  BookNowViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 22/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class BookNowViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet var Total_pay_lbl: UILabel!
    @IBOutlet var Session_txt: UITextField!
    @IBOutlet var Tandem_select_imageview: UIImageView!
    @IBOutlet var Group_select_imageview: UIImageView!
    @IBOutlet var Individual_select_imageview: UIImageView!
    @IBOutlet var Package_list_Tableview: UITableView!
    @IBOutlet var Session_selectDropdown: UIView!
    @IBOutlet var About_btn: UIButton!
    @IBOutlet var Send_btn: UIButton!
    var arrSessionList = [[String:AnyObject]]()
     var arrGroup = [[String:AnyObject]]()
    var arrTandem = [[String:AnyObject]]()
    var arrIndividual = [[String:AnyObject]]()
    var PassParameter:[String:Any] = [:]
    var trainer_id:String?=""
    var trainer_name:String=""
    var Session_price:NSInteger = -1
    var booking_type:String=""
    var Price_per_session:String=""
    var Session_time:String=""
    var NumberOfSession:NSInteger=0
    
    @IBOutlet var session_count_lbl: UILabel!
    @IBOutlet var Next_btn: UIButton!
    @IBOutlet var BookNow_imagev: UIImageView!
    @IBOutlet var Total_pay_view: UIView!
    @IBOutlet var Session_book_view: UIView!
    @IBOutlet var Schdule_list_available: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("trainer_id=",self.trainer_id!);
        self.Individual_select_imageview.image=UIImage.init(named: "select-radio.png")
        self.Group_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
        self.Tandem_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
       // let param=["trainer_id": "11"] as [String : Any]
        print("PassParameter",self.PassParameter)
        let param=["trainer_id": self.trainer_id! as AnyObject] as [String : Any]
        self.FetchSessionSchdule(Dict: param as! [String : String])
        self.addDoneButtonOnKeyboard()
        self.Total_pay_view.isHidden=true
        self.Session_book_view.isHidden=true
        self.Next_btn.isHidden=true
        self.BookNow_imagev.isHidden=true

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Textfield Delegate method
    
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
        
       // self.Session_txt.inputAccessoryView = doneToolbar
    }
    func doneButtonAction() {
       // self.Session_txt.resignFirstResponder()
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

    
    func textFieldDidEndEditing(_ textField: UITextField) {
       // self.animateViewMoving(up: false, moveValue: 100.0)
        

        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
     // self.animateViewMoving(up: true, moveValue: 100.0)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
// MARK: - Table view delegate and datasource method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count=arrSessionList.count
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DiscountCell! = tableView.dequeueReusableCell(withIdentifier: "DiscountCell") as! DiscountCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
       
            
            
          cell.session_price.text="$ " + String(describing: ((arrSessionList[indexPath.row] as AnyObject).value(forKey: "price")) as! NSNumber)
        cell.Session_select_btn.isHidden=true
            cell.Session_count.text = String(describing: ((arrSessionList[indexPath.row] as AnyObject).value(forKey: "max_session")) as! NSNumber)  +  " Session"
            cell.Session_select_imageview.image=UIImage.init(named: "nonselect-radio.png");
            // cell.Seassion_status_lbl.text = String(describing: ((arrIndividualDiscount[indexPath.row] as AnyObject).value(forKey: "discount_status")) as! NSNumber)*/
        
            return cell
            
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DiscountCell
        cell.Session_select_imageview.image=UIImage.init(named: "select-radio.png");
        let selectedPrice:NSInteger=((arrSessionList[indexPath.row] as AnyObject).value(forKey: "price")) as! NSInteger
        self.NumberOfSession=((arrSessionList[indexPath.row] as AnyObject).value(forKey: "max_session")) as! NSInteger
        if Session_price != selectedPrice{
        Session_price=selectedPrice
            self.Price_per_session=String(describing: selectedPrice)
            self.session_count_lbl.text="Number of sessions: " + String(describing: self.NumberOfSession)
            self.Session_time=String(describing: ((arrSessionList[indexPath.row] as AnyObject).value(forKey: "session_time")) as! NSNumber)
            cell.Session_select_imageview.image=UIImage.init(named: "select-radio.png");
            if (Session_price>0){
                
              // let session:NSInteger = self
                print(self.NumberOfSession)
                let totalprice:NSInteger = self.NumberOfSession*(Session_price as NSInteger)
                print(totalprice)
                
                Total_pay_lbl.text="$ " + String(totalprice)
                
                
            }
            self.Total_pay_view.isHidden=false
            self.Session_book_view.isHidden=false
            self.Next_btn.isHidden=false
            self.BookNow_imagev.isHidden=false
        }
        else{
            self.Price_per_session=String(describing: selectedPrice)
            self.Session_time=String(describing: ((arrSessionList[indexPath.row] as AnyObject).value(forKey: "session_time")) as! NSNumber)
            Session_price = -5;
             cell.Session_select_imageview.image=UIImage.init(named: "nonselect-radio.png");
            Total_pay_lbl.text=""
            Price_per_session=""
            self.Total_pay_view.isHidden=true
            self.Session_book_view.isHidden=true
            self.Next_btn.isHidden=true
            self.BookNow_imagev.isHidden=true
        }
        print("selected price=",Session_price);
        print("selected price new=",self.Price_per_session);
        print("session time=",self.Session_time);
        let session_time_new:NSInteger=NSInteger(self.Session_time)!
        self.PassParameter["session_time"]=session_time_new
        
    }
        
    @IBAction func IndividualBtn(_ sender: Any) {
        //radio-unselect.png
        self.Total_pay_view.isHidden=true
        self.Session_book_view.isHidden=true
        self.Next_btn.isHidden=true
        self.BookNow_imagev.isHidden=true
         self.Individual_select_imageview.image=UIImage.init(named: "select-radio.png")
         self.Group_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
         self.Tandem_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
        if self.arrIndividual.isEmpty==false{
            self.arrSessionList.removeAll()
            self.arrSessionList.append(contentsOf: self.arrIndividual);
            self.Package_list_Tableview.reloadData()
            self.Schdule_list_available.isHidden=true
            self.Package_list_Tableview.isHidden=false
             self.booking_type="individual"
        }
        else{
            self.Session_book_view.isHidden=true
            self.Next_btn.isHidden=true
            self.BookNow_imagev.isHidden=true
            self.Total_pay_view.isHidden=true
            self.Package_list_Tableview.isHidden=true
            self.Schdule_list_available.isHidden=false
            self.Schdule_list_available.text="Individual Schedule Are not Available"
        }
        
    }

    @IBAction func GroupBtn(_ sender: Any) {
        self.Total_pay_view.isHidden=true
        self.Session_book_view.isHidden=true
        self.Next_btn.isHidden=true
        self.BookNow_imagev.isHidden=true
        self.Individual_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
        self.Group_select_imageview.image=UIImage.init(named: "select-radio.png")
        self.Tandem_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
        if self.arrGroup.isEmpty==false{
            self.arrSessionList.removeAll()
            self.arrSessionList.append(contentsOf: self.arrGroup);
            self.Package_list_Tableview.reloadData()
            self.Schdule_list_available.isHidden=true
          
            self.booking_type="group"
        }
        else{
            self.Session_book_view.isHidden=true
            self.Next_btn.isHidden=true
            self.BookNow_imagev.isHidden=true
            self.Total_pay_view.isHidden=true
            self.Package_list_Tableview.isHidden=true
            self.Schdule_list_available.isHidden=false
            self.Schdule_list_available.text="Group Schedule Are not Available"
        }
        
    }
   
    @IBAction func TandemBtn(_ sender: Any) {
        self.Total_pay_view.isHidden=true
        self.Session_book_view.isHidden=true
        self.Next_btn.isHidden=true
        self.BookNow_imagev.isHidden=true
        self.Individual_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
        self.Group_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
        self.Tandem_select_imageview.image=UIImage.init(named: "select-radio.png")
        if self.arrTandem.isEmpty==false{
            self.arrSessionList.removeAll()
            self.arrSessionList.append(contentsOf: self.arrTandem);
            self.Package_list_Tableview.reloadData()
            self.Schdule_list_available.isHidden=true
            self.Package_list_Tableview.isHidden=false
            self.booking_type="tandem"
        }
        else{
            self.Session_book_view.isHidden=true
            self.Next_btn.isHidden=true
            self.BookNow_imagev.isHidden=true
            self.Total_pay_view.isHidden=true
            self.Package_list_Tableview.isHidden=true
            self.Package_list_Tableview.isHidden=true
            self.Schdule_list_available.isHidden=false
            self.Schdule_list_available.text="Tandem Schedule Are not Available"
        }
        
    }
    @IBAction func BookNowNextBtn(_ sender: Any) {
        
        
        if booking_type==""{
        self.presentAlertWithTitle(title: "Alert", message: "Select your booking type")
        }
       
        else{
            let param = ["booking_type":booking_type,"no_of_session":self.NumberOfSession,"price_per_session":Price_per_session,"session_time":Session_time] as [String:Any]
            print("Param",param) 
            let vc = self.storyboard! .instantiateViewController(withIdentifier: "BookNowNextView") as! BookNowNextView
            vc.trainer_id=self.trainer_id!
            vc.PassParameter=self.PassParameter
            vc.PaymentDict=param
            vc.Trainer_name = self.trainer_name
            self.navigationController?.pushViewController(vc, animated: true);

        }
        
        
    }
    
    
   //MARK: - Webservice Method For the class
    
    func FetchSessionSchdule(Dict:[String:String])  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let url=Constants.Client_url+"booknowStep1"
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
                            if let val = (response.result.value as AnyObject).value(forKey: "individual") {
                                // now val is not nil and the Optional has been unwrapped, so use it
                                print("key=",val)
                                self.arrIndividual=val as! [[String : AnyObject]]
                               self.arrSessionList.append(contentsOf: self.arrIndividual)
                          
                            }
                            
                            
                            if let val = (response.result.value as AnyObject).value(forKey: "tandem") {
                                // now val is not nil and the Optional has been unwrapped, so use it
                                print("key=",val)
                                self.arrTandem=val as! [[String : AnyObject]]
                            }
                            
                            if let val = (response.result.value as AnyObject).value(forKey: "group") {
                                // now val is not nil and the Optional has been unwrapped, so use it
                                print("key=",val)
                                self.arrGroup=val as! [[String : AnyObject]]
                            }
                            
                            if self.arrIndividual.isEmpty==true && self.arrGroup.isEmpty==true && self.arrTandem.isEmpty==true{
                                self.Session_book_view.isHidden=true
                                self.Next_btn.isHidden=true
                                self.BookNow_imagev.isHidden=true
                                self.Total_pay_view.isHidden=true
                                self.Package_list_Tableview.isHidden=true
                                self.Schdule_list_available.isHidden=false
                                self.Schdule_list_available.text="No Schedule Are not Available"
                            }
                            
                       else  if self.arrIndividual.isEmpty==false{
                                self.arrSessionList.removeAll()
                                self.arrSessionList.append(contentsOf: self.arrIndividual);
                                self.Individual_select_imageview.image=UIImage.init(named: "select-radio.png")
                                self.Group_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
                                self.Tandem_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
                                self.Schdule_list_available.isHidden=true
                                self.Package_list_Tableview.isHidden=false
                                self.Package_list_Tableview.reloadData()
                                self.booking_type="individual"
                            }
                            else if self.arrTandem.isEmpty==false{
                                self.arrSessionList.removeAll()
                                self.arrSessionList.append(contentsOf: self.arrTandem);
                                self.Individual_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
                                self.Group_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
                                self.Tandem_select_imageview.image=UIImage.init(named: "select-radio.png")
                                self.Schdule_list_available.isHidden=true
                                self.Package_list_Tableview.isHidden=false
                                self.Package_list_Tableview.reloadData()
                                self.booking_type="tandem"
                            
                            }
                            else if self.arrGroup.isEmpty==false{
                                self.arrSessionList.removeAll()
                                self.arrSessionList.append(contentsOf: self.arrGroup);
                                self.Individual_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
                                self.Group_select_imageview.image=UIImage.init(named: "select-radio.png")
                                self.Tandem_select_imageview.image=UIImage.init(named: "nonselect-radio.png")
                                self.Schdule_list_available.isHidden=true
                                self.Package_list_Tableview.isHidden=false
                                self.Package_list_Tableview.reloadData()
                                self.booking_type="group"
                                
                            
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

    
    /*
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func DidTabBackBtn(_ sender: Any) {
self.navigationController! .popViewController(animated: true)
    }
    @IBAction func DidTabSessionSelectBtn(_ sender: Any) {
    }
}
