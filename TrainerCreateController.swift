//
//  TrainerCreateController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 24/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
class TrainerCreateController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var ProfileBtn: UIButton!
    @IBOutlet var GroupImageview: UIImageView!
    @IBOutlet var Tandem_selectBtn: UIImageView!
    @IBOutlet var Invidual_selectBtn: UIImageView!
    @IBOutlet var Switch_btn: UISwitch!
    @IBOutlet var Instuite_name: UITextField!
    @IBOutlet var CertificateName_txt: UITextField!
    @IBOutlet var CertificateBtn: UIButton!
    @IBOutlet var Additional_skill_btn: UIButton!
    @IBOutlet var profile_image: UIImageView!
    @IBOutlet var Training_type_view: UIView!
    @IBOutlet var Certificate_tableview: UITableView!
    @IBOutlet var CertificateView: UIView!
    @IBOutlet var Additional_Skill_view: UIView!
       @IBOutlet var Additional_skill_text: UITextField!
    @IBOutlet var Back_btn: UIButton!
    @IBOutlet var skill_collectionview: UICollectionView!
    @IBOutlet var Back_image: UIImageView!
    @IBOutlet var Skill_table: UITableView!
    var SKillTableHeight:CGSize = CGSize.init(width: 0, height: 0)
    var CertificateTableHeight:CGSize = CGSize.init(width: 0, height: 0)
    var AdditonalskillDict = [String:String]()
    var CertificateDict = [String:String]()
    var arrskill = [[String:AnyObject]]()
    var ArradditionalSkill = [[String:AnyObject]]()
    var arrCertificateSkill = [[String:AnyObject]]()
    var arrnewSelectedskill = [[String:AnyObject]]()
    var arrSelectedSkill = [String]()
    var Training_type:String = ""
    var Liability_insurence:String = ""
     var CreateDict:[String:AnyObject]=[:]
    var ProfileImageData : NSData?
    var picked_image:UIImage?=nil
    var traine_profile_id:String="0"
    var TrainerEdit:String=""
    @IBOutlet var create_scorllview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.appearance().tintColor = UIColor.white
        self.ViewReCoordination()
          self.JsonForFetch()
        // Do any additional setup after loading the view.
        Skill_table.isHidden=true
        Liability_insurence="Y"
        profile_image.CircleImageView(BorderColour: UIColor.white, Radious: 1.0)
        Additional_skill_btn.CircleBtn(BorderColour: UIColor.white, Radious: 1.0)
         CertificateBtn.CircleBtn(BorderColour: UIColor.white, Radious: 1.0)
        ProfileBtn.CircleBtn(BorderColour: UIColor.white, Radious: 1.0)
        Additional_skill_text.attributedPlaceholder = NSAttributedString(string: "Type Your Skill",
                                                                attributes: [NSForegroundColorAttributeName: UIColor.white])
        CertificateName_txt.attributedPlaceholder = NSAttributedString(string: "Certificate Name",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.white])
        Instuite_name.attributedPlaceholder = NSAttributedString(string: "Institute Name",
                                                                        attributes: [NSForegroundColorAttributeName: UIColor.white])
        print("Trainer Edit=",self.TrainerEdit)
        if self.TrainerEdit=="yes"{
        Back_btn.isHidden=false
            Back_image.isHidden=false
        }
        else{
            Back_btn.isHidden=true
            Back_image.isHidden=true
        }
    /*    let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.skill_collectionview.collectionViewLayout = layout*/

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    func textplaceholderColor(TextColour: UIColor, getplaceholderText: String, GetTextfield:UITextField){
        
        GetTextfield.attributedPlaceholder = NSAttributedString(string: getplaceholderText,
                                                                attributes: [NSForegroundColorAttributeName: TextColour.cgColor])
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        create_scorllview.layoutIfNeeded()
}
    
    func ViewReCoordination()  {
        var Size:CGSize=CGSize.init(width: 0, height: 0)
          var skill_table:CGSize=CGSize.init(width: 0, height: 0)
        var Certificate_table:CGSize=CGSize.init(width: 0, height: 0)
        if arrCertificateSkill.isEmpty&&ArradditionalSkill.isEmpty==true {
            Skill_table.isHidden=true
            Certificate_tableview.isHidden=true
             CertificateView.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height+15, width: CertificateView.frame.size.width, height: CertificateView.frame.size.height)
             Training_type_view.frame=CGRect.init(x: CertificateView.frame.origin.x, y: CertificateView.frame.origin.y+CertificateView.frame.size.height+15, width: Training_type_view.frame.size.width, height: Training_type_view.frame.size.height)
            Size.height=(Additional_Skill_view.frame.size.height+CertificateView.frame.size.height+Training_type_view.frame.size.height+80.0)
            print("Height",Size.height)
        }
        else{
            if arrCertificateSkill.isEmpty==false && ArradditionalSkill.isEmpty==false {
                Skill_table.isHidden=false
             Certificate_tableview.isHidden=false
                if Skill_table.contentSize.height>111.0 {
                    skill_table.height=111.0
                  Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x+15, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Skill_table.frame.size.width, height: 111.0)
                }
                else{
                    
                Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x+15, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Skill_table.frame.size.width, height: Skill_table.contentSize.height)
                    skill_table.height=Skill_table.contentSize.height
                }
              
                CertificateView.frame=CGRect.init(x: 0, y: Skill_table.frame.origin.y+Skill_table.frame.size.height+15, width: CertificateView.frame.size.width, height: CertificateView.frame.size.height)
                if Certificate_tableview.contentSize.height>111.0 {
                    Certificate_table.height=111.0
                   Certificate_tableview.frame=CGRect.init(x:12, y: CertificateView.frame.origin.y+CertificateView.frame.size.height+5, width: Skill_table.frame.size.width, height: 111.0)
                }
                else{
                    Certificate_tableview.frame=CGRect.init(x:12, y: CertificateView.frame.origin.y+CertificateView.frame.size.height+5, width: Skill_table.frame.size.width, height: Certificate_tableview.contentSize.height)
             Certificate_table.height=Certificate_tableview.contentSize.height
                }
               
                 Training_type_view.frame=CGRect.init(x: 0, y: Certificate_tableview.frame.origin.y+Certificate_tableview.frame.size.height+15, width: Training_type_view.frame.size.width, height: Training_type_view.frame.size.height)
                 Size.height=(Additional_Skill_view.frame.size.height+CertificateView.frame.size.height+Training_type_view.frame.size.height+100.0+skill_table.height+Certificate_table.height)
                print("Height",Size.height)
            }
            else{
                if arrCertificateSkill.isEmpty==false {
                    Skill_table.isHidden=true
                    Certificate_tableview.isHidden=false
                    CertificateView.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height+15, width: CertificateView.frame.size.width, height: CertificateView.frame.size.height)
                    if Certificate_tableview.contentSize.height>111.0 {
                        Certificate_table.height=111.0
                        Certificate_tableview.frame=CGRect.init(x: CertificateView.frame.origin.x+15, y: CertificateView.frame.origin.y+CertificateView.frame.size.height, width: Certificate_tableview.frame.size.width, height: 111.0)
                    }
                    else{
                        Certificate_tableview.frame=CGRect.init(x: CertificateView.frame.origin.x+15, y: CertificateView.frame.origin.y+CertificateView.frame.size.height, width: Certificate_tableview.frame.size.width, height: Certificate_tableview.contentSize.height)
                          Certificate_table.height=Certificate_tableview.contentSize.height
                    }

                    Training_type_view.frame=CGRect.init(x: 0, y: Certificate_tableview.frame.origin.y+Certificate_tableview.frame.size.height+15, width: Training_type_view.frame.size.width, height: Training_type_view.frame.size.height)
                    Size.height=(Additional_Skill_view.frame.size.height+CertificateView.frame.size.height+Training_type_view.frame.size.height+100.0+Certificate_table.height)
                    
                }
                if ArradditionalSkill.isEmpty==false {
                    Skill_table.isHidden=false
                    Certificate_tableview.isHidden=true
                    if Skill_table.contentSize.height>111.0 {
                        skill_table.height=111.0
                        Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x+15, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Skill_table.frame.size.width, height: 111.0)
                    }
                    else{
                        Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x+15, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Skill_table.frame.size.width, height: Skill_table.contentSize.height)
                        skill_table.height=Skill_table.contentSize.height
                    }

                    CertificateView.frame=CGRect.init(x: 0, y: Skill_table.frame.origin.y+Skill_table.frame.size.height+15, width: CertificateView.frame.size.width, height: CertificateView.frame.size.height)
                    
                    Training_type_view.frame=CGRect.init(x: 0, y: CertificateView.frame.origin.y+CertificateView.frame.size.height+15, width: Training_type_view.frame.size.width, height: Training_type_view.frame.size.height)
                     Size.height=(Additional_Skill_view.frame.size.height+CertificateView.frame.size.height+Training_type_view.frame.size.height+100.0+skill_table.height)
                    print("Height=",Size.height)
                              }

            }
                   }
        
      if Skill_table.contentSize.height>111.0 || Certificate_tableview.contentSize.height>111.0{
         create_scorllview.contentSize = CGSize.init(width: self.view.frame.size.width, height:820.0)
         }
         else{
         create_scorllview.contentSize = CGSize.init(width: self.view.frame.size.width, height:700.0)
         }
      
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
     //  UITableView_Auto_Height();
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField==CertificateName_txt{
            self.animateViewMoving(up: true, moveValue: 150.0)
        }
        else if textField==Instuite_name{
            self.animateViewMoving(up: true, moveValue: 200.0)
        }
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField==CertificateName_txt{
            self.animateViewMoving(up: false, moveValue: 150.0)
        }
        else if textField==Instuite_name{
            self.animateViewMoving(up: false, moveValue: 200.0)
        }    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var IsDone:Bool=false
        if textField==Additional_skill_text {
             textField.resignFirstResponder()
            IsDone=true
        }
     else if textField==CertificateName_txt{
            Instuite_name.becomeFirstResponder()
            IsDone=false
        }
        else if textField==Instuite_name{
            Instuite_name.resignFirstResponder()
            IsDone=true
        }
       
        return IsDone
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
    
    
    //For image Picker Function controller++++++++++++++++++*************************************
     public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profile_image.contentMode = .scaleToFill
            profile_image.image = pickedImage
           // self.CallingForImageUpload()
            self.uploadWithAlamofire()
                        if ProfileImageData == nil {
                            ProfileImageData = UIImageJPEGRepresentation(pickedImage, 1) as NSData?
                        }
            
        }
        
        
        dismiss(animated: true, completion: nil)
    }
         func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
     dismiss(animated: true, completion:nil)
    }
    

    
    // For Tableview+++++++++++++++++++++++++++++++++++
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row == Skill_table.indexPathsForVisibleRows?.last?.row {
              print("\(tableView.contentSize.height)")
            Skill_table.isHidden=false
            SKillTableHeight.height=Certificate_tableview.contentSize.height
             print("\(SKillTableHeight.height)")
            //self.ViewReCoordination()
        }
        if indexPath.row == Certificate_tableview.indexPathsForVisibleRows?.last?.row {
            print("\(tableView.contentSize.height)")
            Skill_table.isHidden=false
            CertificateTableHeight.height=Certificate_tableview.contentSize.height
             print("\(CertificateTableHeight.height)")
          //  self.ViewReCoordination()
            
        }

    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==Skill_table {
            
            return ArradditionalSkill.count
            
        }
        else{
            
         return arrCertificateSkill.count
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView==Skill_table {
            let cell : AdditionalSkillCell! = tableView.dequeueReusableCell(withIdentifier: "AdditionalSkill") as! AdditionalSkillCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
           
            cell.CrossBtn.tag=indexPath.row
            cell.contentView.layer.cornerRadius = 8.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor;
            cell.contentView.layer.masksToBounds = true;
            cell.name_lbl.text=(ArradditionalSkill[indexPath.row] as AnyObject).value(forKey: "name") as? String
            
            return cell
        }
        else{
            let cell : AdditionalSkillCell! = tableView.dequeueReusableCell(withIdentifier: "CertificateSkill") as! AdditionalSkillCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.CertificateCross_Btn.tag=indexPath.row
            cell.contentView.layer.cornerRadius = 8.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor;
            cell.contentView.layer.masksToBounds = true;
            cell.name_lbl.text=(arrCertificateSkill[indexPath.row] as AnyObject).value(forKey: "certificate_name") as? String
            return cell
        }
      
    }
    
      
// For collection view+++++++++++++++++++++++++++++
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
   return arrskill.count
    }

    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCell", for: indexPath)as! SkillCell
        cell.layer.cornerRadius=10
        let SelectedId:NSInteger=(arrskill[indexPath.row] as AnyObject).value(forKey: "skill_id") as! NSInteger
        let  Id:String = String(SelectedId)
        if arrSelectedSkill.contains(Id){
        cell.Skill_selected_image.image = UIImage.init(named: "radio-select.png")
        }
        else{
          cell.Skill_selected_image.image = UIImage.init(named: "radio-unselect.png")
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
            selectedCell?.Skill_selected_image.image=UIImage.init(named: "radio-unselect.png")
            arrSelectedSkill.Delete(object: Id)
        }
        else{
        arrSelectedSkill.append(Id)
            selectedCell?.Skill_selected_image.image=UIImage.init(named: "radio-select.png")
        }
        print("",arrSelectedSkill)
    }

    
    
    
  // WebService Calling++++++++++++++++++++++++++++++++++++
    
    func JsonForFetch()  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        var poststring:String?
        
        let parameters = ["trainer_id": User_id]
        let Url:String=Constants.Base_url+"getTrainerInfoStep1"

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
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0  {
                            SVProgressHUD.dismiss()
                            
                            self.arrnewSelectedskill=(response.result.value as AnyObject).value(forKey: "skill") as! [[String:AnyObject]]
                           // print((self.arrnewSelectedskill[0] as AnyObject).value(forKey: "id") as! String)
                          //  print("seletced Arr",self.arrnewSelectedskill)
                            for  index in stride(from: 0, to:  (self.arrnewSelectedskill.count), by: 1){
                                let selectedId:String = (self.arrnewSelectedskill[index] as AnyObject).value(forKey: "id") as! String
                                self.arrSelectedSkill.append(selectedId)
                            }
                            print("Selected Skill list",self.arrSelectedSkill)
                            
                            self.JsonForSkill()
                            
                              let liability_insurance:String=((response.result.value as AnyObject).value(forKey: "liability_insurance") as? String)!
                            if liability_insurance=="Y"{
                            self.Switch_btn.setOn(true, animated: true)
                            }
                            else{
                            self.Switch_btn.setOn(false, animated: false)
                            }
                              let url:String=((response.result.value as AnyObject).value(forKey: "profile_image") as? String)!
                            Alamofire.request(url).responseImage { response in
                                debugPrint(response)
                                
                              
                                debugPrint(response.result)
                                
                                if let image = response.result.value {
                                    print("image downloaded: \(image)")
                                    self.profile_image.image=image
                                }
                            }
                            let trainer_type:String=((response.result.value as AnyObject).value(forKey: "trainer_type") as? String)!
                           
                           
                            if trainer_type=="individual"{
                            self.Invidual_selectBtn.image=UIImage.init(named: "radio-select.png")
                                self.Training_type="individual"
                            }
                            if trainer_type=="tandem"{
                               self.Tandem_selectBtn.image=UIImage.init(named: "radio-select.png")
                                self.Training_type="tandem"
                            }
                            if trainer_type=="group"{
                                self.GroupImageview.image=UIImage.init(named: "radio-select.png")
                                self.Training_type="group"
                            }
                            
                            self.arrCertificateSkill=(response.result.value as AnyObject).value(forKey: "certificate") as! [[String:AnyObject]]
                             //self.arrSelectedSkill=(response.result.value as! String).value(forKey: "skill") as! String
                            self.ArradditionalSkill=(response.result.value as AnyObject).value(forKey: "trainerOtherSkill") as! [[String:AnyObject]]
                            print("certificateSkill",self.arrCertificateSkill)
                             print("arr selected skill",self.arrSelectedSkill)
                             print("Additional skill",self.ArradditionalSkill)
                            self.Certificate_tableview.reloadData()
                            self.Skill_table.reloadData()
                            self.ViewReCoordination()
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
    
    func CreateFunctionCheck()  {
         self.view.endEditing(true)
        if arrSelectedSkill.isEmpty==true {
            presentAlertWithTitle(title: "alert", message: "Select your Skill")
        }
        else if ArradditionalSkill.isEmpty==true{
            presentAlertWithTitle(title: "alert", message: "Select your Additional Skill")
        }
        else if arrCertificateSkill.isEmpty==true{
            presentAlertWithTitle(title: "alert", message: "Select your Certificate")
        }
        else if Training_type == ""{
            presentAlertWithTitle(title: "alert", message: "Select your Training Type")
        }
        else{
            // Fbdetails = ["email" : email as AnyObject, "facebook_id" :fbid as AnyObject, "device_token" : "" as AnyObject ,"login_type" :"facebook"  as AnyObject,"name" :name as AnyObject,"fb_image" :picture as AnyObject,"fb_link" :profile_url as AnyObject,"user_type" :user_type as AnyObject ]
            let userDefaults = Foundation.UserDefaults.standard
            let User_id:String = userDefaults.string(forKey: "user_id")!
            
            CreateDict = ["skill" : arrSelectedSkill as AnyObject,"additionalSkill" : ArradditionalSkill as AnyObject,"certificate" : arrCertificateSkill as AnyObject,"liability_insurance" : Liability_insurence as AnyObject,"trainer_type" : Training_type as AnyObject,"trainer_id" : User_id as AnyObject ]
            let URL:String = Constants.Base_url+"createTrainerInfoStep1"
            self.CreateTrainerJson(jsonString: CreateDict, url: URL)
        }
        
        
    }
    func CreateTrainerJson(jsonString:[String:AnyObject],url:String)  {
        print(jsonString)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        var poststring:String=""
        
        if let json = try? JSONSerialization.data(withJSONObject: jsonString, options: []) {
            poststring = String(data: json, encoding: String.Encoding.utf8)!
            // print(poststring)
            if  poststring == String(data: json, encoding: String.Encoding.utf8)! {
                // here `content` is the JSON dictionary containing the String
                print(poststring)
            }
        }
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        Alamofire.request(url, method:.post, parameters: jsonString, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Login= ",response)
                        //      let isError:String=(response.result.value as AnyObject).value(forKey: "is_error" ) as! String
                        
                        
                        
                        
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0 {
                            
                        /*    self.arrnewSelectedskill=(response.result.value as AnyObject).value(forKey: "skill") as! [[String:AnyObject]]
                            // print((self.arrnewSelectedskill[0] as AnyObject).value(forKey: "id") as! String)
                            //  print("seletced Arr",self.arrnewSelectedskill)
                            for  index in stride(from: 0, to:  (self.arrnewSelectedskill.count), by: 1){
                                let selectedId:String = (self.arrnewSelectedskill[index] as AnyObject).value(forKey: "id") as! String
                                self.arrSelectedSkill.append(selectedId)
                            }
                            print("Selected Skill list",self.arrSelectedSkill)
                            
                          
                            
                            let liability_insurance:String=((response.result.value as AnyObject).value(forKey: "liability_insurance") as? String)!
                            if liability_insurance=="Y"{
                                self.Switch_btn.setOn(true, animated: true)
                            }
                            else{
                                self.Switch_btn.setOn(false, animated: false)
                            }
                            let trainer_type:String=((response.result.value as AnyObject).value(forKey: "trainer_type") as? String)!
                            if trainer_type=="individual"{
                                self.Invidual_selectBtn.image=UIImage.init(named: "radio-select.png")
                                self.Training_type="individual"
                            }
                            if trainer_type=="tandem"{
                                self.Tandem_selectBtn.image=UIImage.init(named: "radio-select.png")
                                self.Training_type="tandem"
                            }
                            if trainer_type=="group"{
                                self.GroupImageview.image=UIImage.init(named: "radio-select.png")
                                self.Training_type="group"
                            }
                            
                            self.arrCertificateSkill=(response.result.value as AnyObject).value(forKey: "certificate") as! [[String:AnyObject]]
                            //self.arrSelectedSkill=(response.result.value as! String).value(forKey: "skill") as! String
                            self.ArradditionalSkill=(response.result.value as AnyObject).value(forKey: "trainerOtherSkill") as! [[String:AnyObject]]
                            print("certificateSkill",self.arrCertificateSkill)
                            print("arr selected skill",self.arrSelectedSkill)
                            print("Additional skill",self.ArradditionalSkill)
                            self.Certificate_tableview.reloadData()
                            self.Skill_table.reloadData()
                            self.ViewReCoordination()*/
                          
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "TrainerCreateProfileTwo") as! TrainerCreateProfileTwo
                            self.navigationController?.pushViewController(vc, animated: true)
                            SVProgressHUD.dismiss()
                            
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
                            self.skill_collectionview.reloadData()
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
    
    func uploadWithAlamofire() {
     
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        // define parameters
        
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
       
                let parameters = ["trainer_id": User_id]
         let Url:String=Constants.Base_url+"trainerProfileImage"
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(self.profile_image.image!, 1) {
                multipartFormData.append(imageData, withName: "photo", fileName: "file.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
        }, to:Url, method: .post, headers: ["Authorization": "auth_token"],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                       
                        print("Upload success")
                        upload.responseJSON { response in
                            print("Response",response.result.value!)
                             SVProgressHUD.dismiss()
                            if (response.result.value as AnyObject).value(forKey: "status")as! NSNumber==0{
                                let url:String=((response.result.value as AnyObject).value(forKey: "image") as? String)!
                                Alamofire.request(url).responseImage { response in
                                    debugPrint(response)
                                    
                                    
                                    debugPrint(response.result)
                                    
                                    if let image = response.result.value {
                                        print("image downloaded: \(image)")
                                        
                                        self.profile_image.image=image
                                    }
                                }

                            }
                           
                            let Message=(response.result.value as AnyObject).value(forKey: "message")
                            print(Message as! String)
                         //  self.presentAlertWithTitle(title: "Success", message: Message as! String)
                            
                        }
                        

                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                         SVProgressHUD.dismiss()
                    }
        })
       
    }
    
    @IBAction func DidTabAdditionalSkillBtn(_ sender: Any) {
        self.view.endEditing(true)
        let myString2 = Additional_skill_text.text
        let Additinal_skill = myString2?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (Additinal_skill?.characters.count)! > 0 {
            let arrayobject:[String:String]=["name":(Additinal_skill)!,"id":""]
            ArradditionalSkill.append(arrayobject as [String : AnyObject])
            print("arr certificate ",arrCertificateSkill)
            //   self.UITableView_Auto_Height()
            Skill_table .reloadData()
            self.ViewReCoordination()
         Additional_skill_text.text=""
        }
        else{
          presentAlertWithTitle(title: "Alert", message: "Write your Additional skill")
        }

    }

    @IBAction func DidTabCrossBtn(_ sender: Any) {
        let SelectedIndex:NSInteger = (sender as AnyObject).tag
        print(SelectedIndex)
        ArradditionalSkill.remove(at: SelectedIndex)
        Skill_table.reloadData()
        if Skill_table.contentSize.height<111.0 {
            self.ViewReCoordination()
        }
    }
    
    @IBAction func DidTabCertificateCellBtn(_ sender: Any) {
        self.view.endEditing(true)
        let myString = CertificateName_txt.text
        let myString2 = Instuite_name.text
        let certificate = myString?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
         let Institute = myString2?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (certificate?.characters.count)!  > 0 && (Institute?.characters.count)! > 0 {
            
            let arrayobject:[String:String]=["certificate_name":(certificate)!+","+(Institute)!,"id":""]
           
            
            self.arrCertificateSkill.append(arrayobject as [String : AnyObject])
            print("AdditionalSkill",arrCertificateSkill)
            //   self.UITableView_Auto_Height()
            Certificate_tableview .reloadData()
            self.ViewReCoordination()
            CertificateName_txt.text = ""
            Instuite_name.text = ""
        }
        else{
            if (certificate?.characters.count)!   == 0  {
                
                 presentAlertWithTitle(title: "Alert", message: "Write your Certificate")
                
            }
            else if (Institute?.characters.count)!   == 0{
                
             presentAlertWithTitle(title: "Alert", message: "write your Institute Name")
                
            }
           
        }

        
    }
    
    @IBAction func DidTabInsurenceBtn(_ sender: Any) {
         self.view.endEditing(true)
        if ((sender as AnyObject).isOn == true){
            Liability_insurence="Y"
        }
        else{
            Liability_insurence="N"
        }
    
    }
    @IBAction func DidTabGroupBtn(_ sender: Any) {
        
        self.view.endEditing(true)
        Training_type="group"
        GroupImageview.image=UIImage.init(named: "radio-select.png")
         Tandem_selectBtn.image=UIImage.init(named: "radio-unselect.png")
         Invidual_selectBtn.image=UIImage.init(named: "radio-unselect.png")
        
    }
    @IBAction func DidTabIndividualBtn(_ sender: Any) {
         self.view.endEditing(true)
         Training_type="individual"
        GroupImageview.image=UIImage.init(named: "radio-unselect.png")
        Tandem_selectBtn.image=UIImage.init(named: "radio-unselect.png")
        Invidual_selectBtn.image=UIImage.init(named: "radio-select.png")

        
    }
    @IBAction func DidTabTandemBtn(_ sender: Any) {
         self.view.endEditing(true)
        Training_type="tandem"
        GroupImageview.image=UIImage.init(named: "radio-unselect.png")
        Tandem_selectBtn.image=UIImage.init(named: "radio-select.png")
        Invidual_selectBtn.image=UIImage.init(named: "radio-unselect.png")

    }
    
    @IBAction func DidTabRightArrowBtn(_ sender: Any) {
        self.CreateFunctionCheck()
        
        }
 
    @IBAction func DidTabCertificateCrossBtn(_ sender: Any) {
        let SelectedIndex:NSInteger = (sender as AnyObject).tag
        print(SelectedIndex)
        arrCertificateSkill.remove(at: SelectedIndex)
        Certificate_tableview.reloadData()
        if Certificate_tableview.contentSize.height<111.0 {
            self.ViewReCoordination()
        }

    }
    @IBAction func DidTabProfileImageSelect(_ sender: Any) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Camera", style: .default)
        { void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Gallery", style: .default)
        { void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    @IBAction func DidTabBackBtn(_ sender: Any) {
       self.navigationController! .popViewController(animated: true) 
    }
    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
