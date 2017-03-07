//
//  TrainerCreateController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 24/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class TrainerCreateController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
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
    @IBOutlet var skill_collectionview: UICollectionView!
    @IBOutlet var Skill_table: UITableView!
    var SKillTableHeight:CGSize = CGSize.init(width: 0, height: 0)
    var CertificateTableHeight:CGSize = CGSize.init(width: 0, height: 0)
    var arrskill = [[String:AnyObject]]()
    var ArradditionalSkill = [String]()
     var arrCertificateSkill = [String]()
    var Training_type:String = ""
    var Liability_insurence:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ViewReCoordination()
        // Do any additional setup after loading the view.
    // self.CallFetchStates()
        
        self.JsonForSkill()
        Skill_table.isHidden=true
        Liability_insurence="yes"
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textplaceholderColor(TextColour: UIColor, getplaceholderText: String, GetTextfield:UITextField){
        
        GetTextfield.attributedPlaceholder = NSAttributedString(string: getplaceholderText,
                                                                attributes: [NSForegroundColorAttributeName: TextColour.cgColor])
    }
    
    func ViewReCoordination()  {
        
        if arrCertificateSkill.isEmpty&&ArradditionalSkill.isEmpty==true {
            Skill_table.isHidden=true
            Certificate_tableview.isHidden=true
             CertificateView.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height+5, width: CertificateView.frame.size.width, height: CertificateView.frame.size.height)
             Training_type_view.frame=CGRect.init(x: CertificateView.frame.origin.x, y: CertificateView.frame.origin.y+CertificateView.frame.size.height+5, width: Training_type_view.frame.size.width, height: Training_type_view.frame.size.height)
        }
        else{
            if arrCertificateSkill.isEmpty==false && ArradditionalSkill.isEmpty==false {
                Skill_table.isHidden=false
             Certificate_tableview.isHidden=false
                if Skill_table.contentSize.height>111.0 {
                  Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Additional_Skill_view.frame.size.width, height: 111.0)
                }
                else{
                Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Additional_Skill_view.frame.size.width, height: Skill_table.contentSize.height)
                }
              
                CertificateView.frame=CGRect.init(x: Skill_table.frame.origin.x, y: Skill_table.frame.origin.y+Skill_table.frame.size.height+5, width: CertificateView.frame.size.width, height: CertificateView.frame.size.height)
                if Certificate_tableview.contentSize.height>111.0 {
                   Certificate_tableview.frame=CGRect.init(x: CertificateView.frame.origin.x, y: CertificateView.frame.origin.y+CertificateView.frame.size.height, width: CertificateView.frame.size.width, height: 111.0)
                }
                else{
                    Certificate_tableview.frame=CGRect.init(x: CertificateView.frame.origin.x, y: CertificateView.frame.origin.y+CertificateView.frame.size.height, width: CertificateView.frame.size.width, height: Certificate_tableview.contentSize.height)
                }
               
                 Training_type_view.frame=CGRect.init(x: Certificate_tableview.frame.origin.x, y: Certificate_tableview.frame.origin.y+Certificate_tableview.frame.size.height+5, width: Training_type_view.frame.size.width, height: Training_type_view.frame.size.height)
                
            }
            else{
                if arrCertificateSkill.isEmpty==false {
                    Skill_table.isHidden=true
                    Certificate_tableview.isHidden=false
                    CertificateView.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height+5, width: CertificateView.frame.size.width, height: CertificateView.frame.size.height)
                    if Certificate_tableview.contentSize.height>111.0 {
                        Certificate_tableview.frame=CGRect.init(x: CertificateView.frame.origin.x, y: CertificateView.frame.origin.y+CertificateView.frame.size.height, width: CertificateView.frame.size.width, height: 111.0)
                    }
                    else{
                        Certificate_tableview.frame=CGRect.init(x: CertificateView.frame.origin.x, y: CertificateView.frame.origin.y+CertificateView.frame.size.height, width: CertificateView.frame.size.width, height: Certificate_tableview.contentSize.height)
                    }

                    Training_type_view.frame=CGRect.init(x: Certificate_tableview.frame.origin.x, y: Certificate_tableview.frame.origin.y+Certificate_tableview.frame.size.height+5, width: Training_type_view.frame.size.width, height: Training_type_view.frame.size.height)
                }
                if ArradditionalSkill.isEmpty==false {
                    Skill_table.isHidden=false
                    Certificate_tableview.isHidden=true
                    if Skill_table.contentSize.height>111.0 {
                        Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Additional_Skill_view.frame.size.width, height: 111.0)
                    }
                    else{
                        Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Additional_Skill_view.frame.size.width, height: Skill_table.contentSize.height)
                    }

                    CertificateView.frame=CGRect.init(x: Skill_table.frame.origin.x, y: Skill_table.frame.origin.y+Skill_table.frame.size.height+5, width: CertificateView.frame.size.width, height: CertificateView.frame.size.height)
                    
                    Training_type_view.frame=CGRect.init(x: CertificateView.frame.origin.x, y: CertificateView.frame.origin.y+CertificateView.frame.size.height+5, width: Training_type_view.frame.size.width, height: Training_type_view.frame.size.height)
                }

            }
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
            cell.CrossBtn.layoutIfNeeded()
              cell.CrossBtn.CircleBtn(BorderColour: UIColor.white, Radious: 1.0)
            cell.contentView.layer.cornerRadius = 8.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor;
            cell.contentView.layer.masksToBounds = true;
            cell.name_lbl.text=(ArradditionalSkill[indexPath.row] as AnyObject) as? String
            
            return cell
        }
        else{
            let cell : AdditionalSkillCell! = tableView.dequeueReusableCell(withIdentifier: "CertificateSkill") as! AdditionalSkillCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.CrossBtn.layoutIfNeeded()
            cell.CrossBtn.CircleBtn(BorderColour: UIColor.white, Radious: 1.0)
            cell.contentView.layer.cornerRadius = 8.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor;
            cell.contentView.layer.masksToBounds = true;
            cell.name_lbl.text=(arrCertificateSkill[indexPath.row] as AnyObject) as? String
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
        cell.Skill_name_lbl.text=(arrskill[indexPath.row] as AnyObject).value(forKey: "skill_name") as? String
        cell.Skill_selected_image.image = UIImage.init(named: "radio-unselect.png")
        return cell
        
    }

    
    
    
  // WebService Calling++++++++++++++++++++++++++++++++++++
    
    func JsonForSkill () {
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
    
    @IBAction func DidTabAdditionalSkillBtn(_ sender: Any) {
        if (Additional_skill_text.text?.characters.count)! > 0 {
            let arrayobject:String=Additional_skill_text.text!
            ArradditionalSkill.append(arrayobject)
            print("arr certificate ",arrCertificateSkill)
            //   self.UITableView_Auto_Height()
            Skill_table .reloadData()
            self.ViewReCoordination()

        }
        else{
          presentAlertWithTitle(title: "Alert", message: "Write your Additional skill")
        }

    }

    @IBAction func DidTabCrossBtn(_ sender: Any) {
        
    }
    
    @IBAction func DidTabCertificateCellBtn(_ sender: Any) {
       
        if (Additional_skill_text.text?.characters.count)!  > 0 && (Additional_skill_text.text?.characters.count)! > 0 {
            
            let arrayobject:String=self.CertificateName_txt.text!+","+self.Instuite_name.text!
            ArradditionalSkill.append(arrayobject)
            print("AdditionalSkill",ArradditionalSkill)
            //   self.UITableView_Auto_Height()
            Skill_table .reloadData()
            self.ViewReCoordination()
        }
        else{
            if (CertificateName_txt.text?.characters.count)!   == 0  {
                
                 presentAlertWithTitle(title: "Alert", message: "Write your Certificate")
                
            }
            else if (Instuite_name.text?.characters.count)!   == 0{
                
             presentAlertWithTitle(title: "Alert", message: "write your Institute Name")
                
            }
           
        }

        
    }
    
    @IBAction func DidTabInsurenceBtn(_ sender: Any) {
    }
    @IBAction func DidTabGroupBtn(_ sender: Any) {
        Training_type="group"
        GroupImageview.image=UIImage.init(named: "radio-select.png")
         Tandem_selectBtn.image=UIImage.init(named: "radio-unselect.png")
         Invidual_selectBtn.image=UIImage.init(named: "radio-unselect.png")
        
    }
    @IBAction func DidTabIndividualBtn(_ sender: Any) {
         Training_type="individual"
        GroupImageview.image=UIImage.init(named: "radio-unselect.png")
        Tandem_selectBtn.image=UIImage.init(named: "radio-unselect.png")
        Invidual_selectBtn.image=UIImage.init(named: "radio-select.png")

        
    }
    @IBAction func DidTabTandemBtn(_ sender: Any) {
        Training_type="tandem"
        GroupImageview.image=UIImage.init(named: "radio-unselect.png")
        Tandem_selectBtn.image=UIImage.init(named: "radio-select.png")
        Invidual_selectBtn.image=UIImage.init(named: "radio-unselect.png")

    }
    
    @IBAction func DidTabRightArrowBtn(_ sender: Any) {
        if ((sender as AnyObject).isOn == true){
            Liability_insurence="yes"
        }
        else{
             Liability_insurence="off" 
        }
    }
    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
