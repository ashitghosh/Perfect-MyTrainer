//
//  ClientTrainingTypeController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 16/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import SVProgressHUD
import AlamofireImage
import MapKit
import CoreLocation
import Alamofire

class ClientTrainingTypeController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,HADropDownDelegate {
    @IBOutlet var Location_imageview: UIImageView!
    @IBOutlet var Nearest_selected_image: UIImageView!
    
    @IBOutlet var Training_type_lbl: UILabel!
    @IBOutlet var Skill_collection_view: UICollectionView!
    @IBOutlet var Distence_arrow_image: UIImageView!
    @IBOutlet var Address_txt: UITextView!
    @IBOutlet var Skill_search_btn: UITextField!
    @IBOutlet var Place_txt: UITextField!
    @IBOutlet var Time_arrow_image: UIImageView!
    @IBOutlet var Select_time: HADropDown!
    @IBOutlet var Select_Distence: HADropDown!
    @IBOutlet var Date_picker: UIDatePicker!
    @IBOutlet var DatePickerBackView: UIView!
    @IBOutlet var top_rated_selected_image: UIImageView!
    @IBOutlet var Serach_top_rated_image: UIImageView!
    @IBOutlet var No_trainer_lbl: UILabel!
    
    @IBOutlet var Search_submit_Btn: UIButton!
    @IBOutlet var Search_nearest_imageView: UIImageView!
    @IBOutlet var Date_txt: UITextField!
    @IBOutlet var nearest_btn: UIButton!
    @IBOutlet var Top_rated_btn: UIButton!
    @IBOutlet var Headsheet_Tableview: UITableView!
    var arrTrainerHeadsheet = [[String:AnyObject]]()
    var arrSearchSkill = [[String:AnyObject]]()
    var arrShowSearchSkill = [[String:AnyObject]]()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    var Search_TopAndNear:String = "distance"
    var Distens:String = "5"
    var Date:String = ""
    var Time:String = ""
    var arrskill = [[String:AnyObject]]()
    var arrSelectedSkill = [String]()
    var TrainingType:String = ""
    var Search_training_type:String = ""
    @IBOutlet var Search_background_view: UIView!
    @IBOutlet var Place_select_btn: UIButton!
    @IBOutlet var search_btn: UIButton!
    @IBOutlet var SearchView_dropdown: UIView!
    @IBOutlet var Date_place_select_btn: UIButton!
    @IBOutlet var Search_here: UIView!
    @IBOutlet var Skill_tableview: UITableView!
    @IBOutlet var Distence_select_btn: UIButton!
    var Newview: UIView! = UIView()
    
   // @IBOutlet var Search_btn: UIButton!
    @IBOutlet var Time_select_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Search_background_view.isHidden=true;
        Skill_tableview.isHidden=true
      //  Skill_tableview.frame=CGRect.init(x: 0, y: 0, width: 0, height: 0);
        // self.top_rated_selected_image.image=UIImage.init(named: "nonselect-radio.png")
        // self.Nearest_selected_image.image=UIImage.init(named: "nonselect-radio.png")
       // self.top_rated_selected_image.isHidden=false
       // self.Nearest_selected_image.isHidden=false
        self.Location_imageview.isHidden=true
        self.DatePickerBackView.isHidden=true
        self.Nearest_selected_image.image=UIImage.init(named: "select-radio.png")
        self.top_rated_selected_image.image=UIImage.init(named: "nonselect-radio.png")
        Select_time.delegate=self
        Select_Distence.delegate=self
        Select_time.font=UIFont.systemFont(ofSize: 12.0)
        Select_Distence.font=UIFont.systemFont(ofSize: 12.0)
        Select_time.titleColor=UIColor.black
        Select_Distence.titleColor=UIColor.black
        Select_Distence.layer.borderColor=UIColor.clear.cgColor
        Select_time.layer.borderColor=UIColor.clear.cgColor
        Select_time.items=["Select time","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:01","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00"]
        Select_Distence.items=["Select Distance","5 miles","10 miles","15 miles","20 miles","25 miles","30 miles","40 miles","45 miles","50 miles"]
        Select_Distence.title="Select Distance"
        Select_time.title="Select time"
        self.Search_submit_Btn.ButtonRoundCorner(radious: 8.0)
        self.DidTabSearchSubmitBtn(sender:self)
        self.addDoneButtonOnKeyboard()
        self.Training_type_lbl.text=self.TrainingType
        self.textplaceholderColor(getTextName: Date_txt, getplaceholderText: "Date")
        self.textplaceholderColor(getTextName: Place_txt, getplaceholderText: "City")

        self.No_trainer_lbl.isHidden=true
        self.Headsheet_Tableview.isHidden=false
        UITextField.appearance().tintColor = UIColor.lightGray
        

        
    }
    func doneButtonAction() {
        self.Address_txt.resignFirstResponder()
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
        
        self.Address_txt.inputAccessoryView = doneToolbar
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView==Address_txt {
            if Address_txt.text=="Enter Address"{
                Address_txt.text=""
            }
        }
        
    }
    
    private func textViewDidEndEditing(_ textView: UITextView) {
        if textView==Address_txt {
            if Address_txt.text.isEmpty==true{
                Address_txt.text="Enter Address"
            }
        }
        
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
       
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
   
    
    
    
    
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        if dropDown==Select_time{
            
         Time_arrow_image.isHidden=true
           Time_select_btn.setTitle("", for: UIControlState.normal)
            if self.Select_time.title=="Select time"{
            
            }
            else{
            self.Time=Select_time.title
            }
        
            
            
        }
        if dropDown==Select_Distence{
            Distence_arrow_image.isHidden=true
            Distence_select_btn.setTitle("", for: UIControlState.normal)
            if self.Select_time.title=="Select distance"{
                
            }
            else{
                self.Time=Select_time.title
                let arr=self.Select_Distence.title.components(separatedBy: " ")
                print("miles",arr[0])
                self.Distens=arr[0]
                print("distance",self.Distens)
            }

            
            
        }
        
        
    }
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
       // let  date = dateFormatter.string(from: sender.date)
       
        Date=dateFormatter.string(from: sender.date)
         print("Date=",Date)
        Date_txt.text=Date
        
    }
    
    
    
    
    
    func JsonForFetchForFeed()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        var poststring:String?
        var latitudeText:String=""
        var longitudeText:String=""
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            latitudeText = String(format: "%f", currentLocation.coordinate.latitude)
            longitudeText = String(format: "%f", currentLocation.coordinate.longitude)
        }
        
        print(latitudeText,longitudeText)
        
        let parameters = ["latitude": latitudeText,"longitude": longitudeText,"client_id": User_id]
        let Url:String=Constants.Client_url+"headsheetList"
        
        if let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            poststring = String(data: json, encoding: String.Encoding.utf8)!
            // print(poststring)
            if  poststring == String(data: json, encoding: String.Encoding.utf8)! {
                // here `content` is the JSON dictionary containing the String
                print(poststring as AnyObject)
            }
        }
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        Alamofire.request(Url, method:.post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Fetch= ",response)
                        SVProgressHUD.dismiss()
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0  {
                            SVProgressHUD.dismiss()
                            self.No_trainer_lbl.isHidden=true
                            self.Headsheet_Tableview.isHidden=false

                            self.arrTrainerHeadsheet=(response.result.value as AnyObject).value(forKey: "Trainer") as! [[String:AnyObject]]
                            print("feed list", self.arrTrainerHeadsheet)
                            self.Headsheet_Tableview.reloadData()
                        }
                            
                        else{
                            self.No_trainer_lbl.text="No trainer available"
                            self.No_trainer_lbl.isHidden=false
                            self.Headsheet_Tableview.isHidden=true
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.dismiss()
                    }
                }
        }
        
    }
    func JsonForFetchAsNearestOrTop(NearestOrTop:String)  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        var poststring:String?
        var latitudeText:String=""
        var longitudeText:String=""
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            latitudeText = String(format: "%f", currentLocation.coordinate.latitude)
            longitudeText = String(format: "%f", currentLocation.coordinate.longitude)
        }
        
        print(latitudeText,longitudeText)
        
        let parameters = ["latitude": latitudeText,"longitude": longitudeText,"client_id": User_id,"sort_by": NearestOrTop]
        let Url:String=Constants.Client_url+"searchHeadsheetSortby"
        
        if let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            poststring = String(data: json, encoding: String.Encoding.utf8)!
            // print(poststring)
            if  poststring == String(data: json, encoding: String.Encoding.utf8)! {
                // here `content` is the JSON dictionary containing the String
                print(poststring as AnyObject)
            }
        }
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        Alamofire.request(Url, method:.post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Fetch= ",response)
                        SVProgressHUD.dismiss()
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0  {
                            SVProgressHUD.dismiss()
                            //self.No_trainer_lbl.text="No trainer listed above search criteria"
                            self.No_trainer_lbl.isHidden=true
                            self.Headsheet_Tableview.isHidden=false
                            self.arrTrainerHeadsheet.removeAll()
                            self.arrTrainerHeadsheet=(response.result.value as AnyObject).value(forKey: "Trainer") as! [[String:AnyObject]]
                            print("feed list", self.arrTrainerHeadsheet)
                            self.Headsheet_Tableview.reloadData()
                        }
                            
                        else{
                            self.No_trainer_lbl.text="No trainer listed"
                            self.No_trainer_lbl.isHidden=false
                            self.Headsheet_Tableview.isHidden=true
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.dismiss()
                    }
                }
        }
        
    }

    
    func JsonForSearchskill(character:String)  {
        var postString:String?
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let parameters = ["character": character]
        let Url:String=Constants.Client_url+"headsheetSkills"
        
        if let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            postString = String(data: json, encoding: String.Encoding.utf8)!
            // print(poststring)
            if  postString == String(data: json, encoding: String.Encoding.utf8)! {
                // here `content` is the JSON dictionary containing the String
                print(postString as AnyObject)
            }
        }
        
        Alamofire.request(Url, method:.post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Fetch= ",response)
                        SVProgressHUD.dismiss()
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0  {
                            SVProgressHUD.dismiss()
                            self.arrSearchSkill.removeAll()
                           self.arrSearchSkill=(response.result.value as AnyObject).value(forKey: "Skill") as! [[String:AnyObject]]
                            print("feed list", self.arrSearchSkill)
                            if self.arrSearchSkill.isEmpty==false{
                                
                                self.Skill_tableview.isHidden=false
                                self.Skill_tableview.reloadData()
                            }
                            else{
                                self.Skill_tableview.isHidden=true
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
        }
        
    }
    
    func JsonForSkill () {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let url:String=Constants.Base_url+"skills"
        print(url)
        // let url = URL(string: Constants.Base_url+"skill")
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                //print( "Json  return for Login= ",response)
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        // print( "Json  return for Login= ",response)
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0 {
                            SVProgressHUD.dismiss()
                            self.arrskill=(response.result.value as AnyObject).value(forKey: "Skill") as! [[String:AnyObject]]
                            print("arr skills",self.arrskill)
                            self.Skill_collection_view.reloadData()
                            SVProgressHUD.dismiss()
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


    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==Skill_tableview{
        return arrSearchSkill.count
        }
            
        else{
        return arrTrainerHeadsheet.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==Skill_tableview{
     let cell : SearchSkillCell! = tableView.dequeueReusableCell(withIdentifier: "SearchSkillCell") as! SearchSkillCell
            //cell.textLabel?.text="Yoga"
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            cell.Skill_name_lbl.text=(arrSearchSkill[indexPath.row] as AnyObject).value(forKey: "name") as? String
            return cell

        }
        else{
            let cell : TrainingTypeCell! = tableView.dequeueReusableCell(withIdentifier: "TypeCell") as! TrainingTypeCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
           // cell.Profile_imageview.layoutIfNeeded()
            //cell.Profile_imageview.CircleImageView(BorderColour: UIColor.clear, Radious: 1.0)
            cell.Name_lbl.text=(self.arrTrainerHeadsheet[indexPath.row] as AnyObject).value(forKey: "name") as? String
            cell.Tagline_text.text=(self.arrTrainerHeadsheet[indexPath.row] as AnyObject).value(forKey: "about") as? String
           
            let url = (arrTrainerHeadsheet[indexPath.row] as AnyObject).value(forKey: "profile_image") as? String
            
            Alamofire.request(url!).responseImage { response in
                // debugPrint(response)
                
                
                // debugPrint(response.result)
                
                if let image = response.result.value {
                    // print("image downloaded: \(image)")
                    cell.Profile_imageview.image=image
                }
            }

            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView==Skill_tableview {
            self.arrShowSearchSkill.append((arrSearchSkill[indexPath.row] as AnyObject) as! [String : AnyObject])
            print("arr show search Skill",self.arrShowSearchSkill)
         //   self.Skill_collection_view.reloadData()
           // Skill_tableview.isHidden=true
        }
        
        if tableView==self.Headsheet_Tableview{
        let trainer_id=(self.arrTrainerHeadsheet[indexPath.row] as AnyObject).value(forKey: "trainer_id") as? String
            let vc = self.storyboard! .instantiateViewController(withIdentifier: "TrainerDetailsByClient") as! TrainerDetailsByClient
           vc.Trainer_id=trainer_id!
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
   
//Collectview method implement
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    
        return arrskill.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCell", for: indexPath)as! SkillCell
        cell.layer.cornerRadius=10
        let SelectedId:NSInteger=(arrskill[indexPath.row] as AnyObject).value(forKey: "skill_id") as! NSInteger
        let  Id:String = String(SelectedId)
        if arrSelectedSkill.contains(Id){
            cell.Skill_selected_image.image = UIImage.init(named: "select-radio.png")
        }
        else{
            cell.Skill_selected_image.image = UIImage.init(named: "nonselect-radio.png")
        }
        cell.Skill_name_lbl.text=(arrskill[indexPath.row] as AnyObject).value(forKey: "skill_name") as? String
        //cell.Skill_selected_image.image = UIImage.init(named: "radio-unselect.png")*/
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let selectedCell = collectionView.cellForItem(at: indexPath) as? SkillCell
        print("Details",arrskill[(indexPath as NSIndexPath).row])
        print("",(arrskill[indexPath.row] as AnyObject).value(forKey: "skill_id") as! NSNumber)
        
        let SelectedId:NSInteger=(arrskill[indexPath.row] as AnyObject).value(forKey: "skill_id") as! NSInteger
        let  Id:String = String(SelectedId)
        
        if arrSelectedSkill.contains(Id) {
            print("not available")
            selectedCell?.Skill_selected_image.image=UIImage.init(named: "nonselect-radio.png")
            arrSelectedSkill.Delete(object: Id)
        }
        else{
            arrSelectedSkill.append(Id)
            selectedCell?.Skill_selected_image.image=UIImage.init(named: "select-radio.png")
        }
        print("",arrSelectedSkill)
    }

    
    func textplaceholderColor(getTextName: UITextField, getplaceholderText: String){
        
//        getTextName.attributedPlaceholder = NSAttributedString(string: getplaceholderText,
//                                                               attributes: [NSForegroundColorAttributeName: UIColor.black])
        getTextName.attributedPlaceholder = NSAttributedString(string:getplaceholderText, attributes:[NSForegroundColorAttributeName: UIColor.black,NSFontAttributeName :UIFont(name: "Arial", size: 12)!])
    }

    
       
    @IBAction func DidTabDateResetBtn(_ sender: Any) {
        Date_txt.text=""
        self.textplaceholderColor(getTextName: Date_txt, getplaceholderText: "Date")
         DatePickerBackView.isHidden=true
        
    }

    @IBAction func DidTabMapBtn(_ sender: Any) {
    }
    
    @IBAction func DidTabListBtn(_ sender: Any) {
    }
    @IBAction func DidTabTopRatedBtn(_ sender: Any) {
         self.top_rated_selected_image.image=UIImage.init(named: "select-radio.png")
        self.Nearest_selected_image.image=UIImage.init(named: "nonselect-radio.png")
       // self.JsonForFetchAsNearestOrTop(NearestOrTop: "rating")
        self.Search_TopAndNear="rating"
        self.DidTabSearchSubmitBtn(sender:self)

    }
    
    @IBAction func DidTabNearestBtn(_ sender: Any) {
        self.Nearest_selected_image.image=UIImage.init(named: "select-radio.png")
        self.top_rated_selected_image.image=UIImage.init(named: "nonselect-radio.png")
       // self.JsonForFetchAsNearestOrTop(NearestOrTop: "distance")
        self.Search_TopAndNear="distance"
        self.DidTabSearchSubmitBtn(sender:self)


    }
    @IBAction func DidTabSerachBtn(_ sender: Any) {
        
        search_btn.isSelected  = !search_btn.isSelected;
        /*Address_txt.text=""
        Place_txt.text=""
        Distens=""
        Select_Distence.title=""
        Select_time.title=""
        self.arrShowSearchSkill.removeAll()
        self.Skill_collection_view.reloadData()
        self.Search_TopAndNear=""
        self.top_rated_selected_image.image=UIImage.init(named: "nonselect-radio.png")
        self.Nearest_selected_image.image=UIImage.init(named: "nonselect-radio.png")*/
        
        
        if search_btn.isSelected {
            print("Selected")
            search_btn.isSelected=true
            Search_background_view.isHidden=false;
        }
        else{
        print("Not Selected")
            search_btn.isSelected=false
            Search_background_view.isHidden=true;
        }
    }

    @IBAction func DidTabSkillDeleteBtn(_ sender: Any) {
        let selectedIndex:NSInteger = (sender as AnyObject).tag
        arrShowSearchSkill.remove(at: selectedIndex)
        self.Skill_collection_view.reloadData()
        
        
    }
   
    @IBAction func DidTabDistenceSelectBtn(_ sender: Any) {
        
        
        Distence_select_btn.isSelected  = !Distence_select_btn.isSelected
        
        if Distence_select_btn.isSelected {
            print("Selected")
             Skill_tableview.isHidden=false
            Distence_select_btn.isSelected=true
            Skill_tableview.frame=CGRect.init(x: Distence_select_btn.frame.origin.x-10, y: Distence_select_btn.frame.origin.y+Distence_select_btn.frame.size.height, width: Distence_select_btn.frame.size.width, height: 200)
            
        }
        else{
            print("Not Selected")
            Distence_select_btn.isSelected=false
            Skill_tableview.frame=CGRect.init(x: Distence_select_btn.frame.origin.x, y: Distence_select_btn.frame.origin.y+Distence_select_btn.frame.size.height, width: Distence_select_btn.frame.size.width, height: 0)
        }

        
    }
    
    @IBAction func DidTabPlaceSelecteBtn(_ sender: Any) {
        Place_select_btn.isSelected  = !Place_select_btn.isSelected
        
        if Place_select_btn.isSelected {
            print("Selected")
            Skill_tableview.isHidden=false
            Place_select_btn.isSelected=true
            Skill_tableview.frame=CGRect.init(x: Place_select_btn.frame.origin.x+10, y: Place_select_btn.frame.origin.y+Distence_select_btn.frame.size.height, width: Place_select_btn.frame.size.width, height: 200)
            
        }
        else{
            print("Not Selected")
            Place_select_btn.isSelected=false
            Skill_tableview.frame=CGRect.init(x: Place_select_btn.frame.origin.x, y: Place_select_btn.frame.origin.y+Place_select_btn.frame.size.height, width: Place_select_btn.frame.size.width, height: 0)
        }

        
    }
   
    @IBAction func DidTabDatePlaceSelectBtn(_ sender: Any) {
        DatePickerBackView.isHidden=false
        self.Date_picker.datePickerMode = .date
       // (sender as AnyObject).inputView = self.Date_picker
        self.Date_picker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @IBAction func DidTabDateDistenceSelectBtn(_ sender: Any) {
       
        
    }
    
    @IBAction func SearchTopRatedBtn(_ sender: Any) {
        self.Serach_top_rated_image.image=UIImage.init(named: "select-radio.png")
        self.Search_nearest_imageView.image=UIImage.init(named: "nonselect-radio.png")
        self.Search_TopAndNear="rating"
        
    }

    @IBAction func SearchNearestBtn(_ sender: Any) {
        self.Search_nearest_imageView.image=UIImage.init(named: "select-radio.png")
        self.Serach_top_rated_image.image=UIImage.init(named: "nonselect-radio.png")
        self.Search_TopAndNear="distance"
        
    }
    @IBAction func DidTabDraweBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true) 
      /*  if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }*/

    }
    @IBAction func DatePickerCancelBtn(_ sender: Any) {
        DatePickerBackView.isHidden=true
    }

    @IBAction func DatePickerDoneBtn(_ sender: Any) {
        DatePickerBackView.isHidden=true
    }
    
    @IBAction func DidTabSearchSubmitBtn(_ sender: Any) {
        let Address = self.Address_txt.text!.trimmingCharacters(in: .whitespaces)
        let Place = self.Place_txt.text!.trimmingCharacters(in: .whitespaces)
        if Address=="" && Place=="" && Date==""  && Time=="" && self.arrSelectedSkill.isEmpty==true && Search_TopAndNear=="" && Address=="Enter Address"{
            //{"address":"South City Mall, 375, 2nd Floor, Prince Anwar Shah Road, Jodhpur Park, Kolkata- 700068, West Bengal","distance":"5","skill":[{"id":"1","name":"gymnastic"},{"id":"2","name":"gymnastic2"}],"sort_by":"rating","client_id":"6"}';
            //Enter Address
            Search_background_view.isHidden=true;
            

        }
        else{
            
            Search_background_view.isHidden=true;
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show()
            var poststring:String?
            var latitudeText:String=""
            var longitudeText:String=""
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            
            locManager.requestWhenInUseAuthorization()
            
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                currentLocation = locManager.location
                print(currentLocation.coordinate.latitude)
                print(currentLocation.coordinate.longitude)
                latitudeText = String(format: "%f", currentLocation.coordinate.latitude)
                longitudeText = String(format: "%f", currentLocation.coordinate.longitude)
            }
            
            print(latitudeText,longitudeText)
            
            var parameters = ["latitude": latitudeText,"longitude": longitudeText,"client_id": User_id,"distance": self.Distens,"city": Place,"skill": self.arrSelectedSkill,"sort_by": Search_TopAndNear,"search_type": self.Search_training_type,"date": Date,"time": Time] as [String : Any]
            if Address=="Enter Address" {
               parameters["address"]=""
            }
            else{
            parameters["address"]=Address
            }
            let Url:String=Constants.Client_url+"searchHeadsheet"
            
            if let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                poststring = String(data: json, encoding: String.Encoding.utf8)!
                // print(poststring)
                if  poststring == String(data: json, encoding: String.Encoding.utf8)! {
                    // here `content` is the JSON dictionary containing the String
                    print(poststring as AnyObject)
                }
            }
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show()
            Alamofire.request(Url, method:.post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
                    //to get status code
                    if let status = response.response?.statusCode {
                        print("Status = ",status);
                        switch(status){
                        case 200:
                            print( "Json  return for Fetch= ",response)
                            SVProgressHUD.dismiss()
                            //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                            
                            if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0  {
                                SVProgressHUD.dismiss()
                                self.JsonForSkill()
                                if self.Search_TopAndNear=="rating"{
                                    self.top_rated_selected_image.image=UIImage.init(named: "select-radio.png")
                                    self.Nearest_selected_image.image=UIImage.init(named: "nonselect-radio.png")

                                }
                                if self.Search_TopAndNear=="distance"{
                                    self.Nearest_selected_image.image=UIImage.init(named: "select-radio.png")
                                    self.top_rated_selected_image.image=UIImage.init(named: "nonselect-radio.png")
  
                                }
                                self.No_trainer_lbl.isHidden=true
                                self.Headsheet_Tableview.isHidden=false

                            
                                self.arrTrainerHeadsheet.removeAll()
                                self.arrTrainerHeadsheet=(response.result.value as AnyObject).value(forKey: "Trainer") as! [[String:AnyObject]]
                                print("feed list", self.arrTrainerHeadsheet)
                                self.Headsheet_Tableview.reloadData()
                            }
                                
                            else{
                                if self.Search_TopAndNear=="rating"{
                                    self.top_rated_selected_image.image=UIImage.init(named: "select-radio.png")
                                    self.Nearest_selected_image.image=UIImage.init(named: "nonselect-radio.png")
                                    
                                }
                                if self.Search_TopAndNear=="distance"{
                                    self.Nearest_selected_image.image=UIImage.init(named: "select-radio.png")
                                    self.top_rated_selected_image.image=UIImage.init(named: "nonselect-radio.png")
                                    
                                }
                                self.No_trainer_lbl.text="No trainer listed above search criteria"
                                self.No_trainer_lbl.isHidden=false
                                self.Headsheet_Tableview.isHidden=true
                                
                                SVProgressHUD.dismiss()
                            }
                            
                        default:
                             self.JsonForSkill()
                            print("error with response status: \(status)")
                            SVProgressHUD.dismiss()
                        }
                    }
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

extension ClientTrainingTypeController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        return .zero
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 5.0
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 1.0
}
}
