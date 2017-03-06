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
    
  
    @IBOutlet var Certificate_tableview: UITableView!
    @IBOutlet var CertificateView: UIView!
    @IBOutlet var Additional_Skill_view: UIView!
    @IBOutlet var Additional_skill_btn: UIButton!
    @IBOutlet var Additional_skill_text: UITextField!
    @IBOutlet var skill_collectionview: UICollectionView!
    @IBOutlet var Skill_table: UITableView!
    var arrskill = [[String:AnyObject]]()
    var ArradditionalSkill = [String]()
     var arrCertificateSkill = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    // self.CallFetchStates()
        
        self.JsonForSkill()
        Skill_table.isHidden=true
        Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x-10, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Additional_Skill_view.frame.size.width/2, height: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ViewReCoordination()  {
        if arrCertificateSkill.isEmpty&&ArradditionalSkill.isEmpty==true {
             CertificateView.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Additional_Skill_view.frame.size.width, height: Additional_Skill_view.frame.size.height)
        }
    }
    
    func UITableView_Auto_Height()
    {
        if(self.Skill_table.contentSize.height < self.Skill_table.frame.height){
            var frame: CGRect = self.Skill_table.frame;
            frame.size.height = self.Skill_table.contentSize.height;
            self.Skill_table.frame = frame;
        }
    }
    override func viewDidAppear(_ animated: Bool) {
     //  UITableView_Auto_Height();
    }
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // For Tableview+++++++++++++++++++++++++++++++++++
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row == Skill_table.indexPathsForVisibleRows?.last?.row {
            print("\(tableView.contentSize.height)")
            Skill_table.isHidden=false
            Skill_table.frame=CGRect.init(x: Additional_Skill_view.frame.origin.x, y: Additional_Skill_view.frame.origin.y+Additional_Skill_view.frame.size.height, width: Additional_Skill_view.frame.size.width, height: Skill_table.contentSize.height)
            
        }
        if indexPath.row == Certificate_tableview.indexPathsForVisibleRows?.last?.row {
            print("\(tableView.contentSize.height)")
            Skill_table.isHidden=false
            Certificate_tableview.frame=CGRect.init(x: CertificateView.frame.origin.x, y: CertificateView.frame.origin.y+CertificateView.frame.size.height, width: CertificateView.frame.size.width, height: Certificate_tableview.contentSize.height)
            
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
            let cell : AdditionalSkillCell! = tableView.dequeueReusableCell(withIdentifier: "AdditionaleSkill") as! AdditionalSkillCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.name_lbl.text=(ArradditionalSkill[indexPath.row] as AnyObject) as? String
            return cell
        }
        else{
            let cell : AdditionalSkillCell! = tableView.dequeueReusableCell(withIdentifier: "CertificateSkill") as! AdditionalSkillCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.name_lbl.text=(ArradditionalSkill[indexPath.row] as AnyObject) as? String
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
        let arrayobject:String=Additional_skill_text.text!
   ArradditionalSkill.append(arrayobject)
        print("new array",ArradditionalSkill)
     //   self.UITableView_Auto_Height()
        Skill_table .reloadData()
        

    }

    @IBAction func DidTabCrossBtn(_ sender: Any) {
        
    }
    
    @IBAction func DidTabCertificateCellBtn(_ sender: Any) {
        let arrayobject:String=Additional_skill_text.text!
        ArradditionalSkill.append(arrayobject)
        print("new array",ArradditionalSkill)
        //   self.UITableView_Auto_Height()
        Skill_table .reloadData()
 
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
