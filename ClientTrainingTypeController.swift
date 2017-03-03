//
//  ClientTrainingTypeController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 16/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class ClientTrainingTypeController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate {
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    @IBOutlet var Search_background_view: UIView!
    @IBOutlet var Place_select_btn: UIButton!
    @IBOutlet var search_btn: UIButton!
    @IBOutlet var SearchView_dropdown: UIView!
    @IBOutlet var Date_place_select_btn: UIButton!
    @IBOutlet var Search_here: UIView!
    @IBOutlet var Skill_tableview: UITableView!
    @IBOutlet var date_distence_select_btn: UIButton!
    @IBOutlet var Distence_select_btn: UIButton!
    var Newview: UIView! = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Search_background_view.isHidden=true;
        Skill_tableview.isHidden=true
      //  Skill_tableview.frame=CGRect.init(x: 0, y: 0, width: 0, height: 0);
        Skill_tableview.backgroundColor = UIColor.white
        Skill_tableview.layer.shadowColor = UIColor.darkGray.cgColor
        Skill_tableview.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        Skill_tableview.layer.shadowOpacity = 1.0
        Skill_tableview.layer.shadowRadius = 2
        
        Skill_tableview.layer.cornerRadius = 10
         Skill_tableview.layer.borderWidth = 1.0
        Skill_tableview.layer.borderColor=UIColor.gray.cgColor
        Skill_tableview.layer.masksToBounds = true
        
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==Skill_tableview{
 let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
            cell.textLabel?.text="Yoga"
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            return cell

        }
        else{
            let cell : TrainingTypeCell! = tableView.dequeueReusableCell(withIdentifier: "TypeCell") as! TrainingTypeCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView==Skill_tableview {
            Skill_tableview.isHidden=true
        }
    }
   
//Collectview method implement
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    
        return 12
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedCell", for: indexPath)as! SelectedSkillCell
        cell.contentView.layer.cornerRadius = 18.0
        cell.contentView.layer.borderWidth = 1.0
        
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.init(colorLiteralRed: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.9).cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        cell.contentView.layer.insertSublayer(gradient, at: 0)
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        cell.Cross_btn.layer.borderWidth = 1
        cell.Cross_btn.layer.masksToBounds = false
        cell.Cross_btn.layer.borderColor = UIColor.gray.cgColor
        cell.Cross_btn.layer.cornerRadius = cell.Cross_btn.frame.height/2
        cell.Cross_btn.clipsToBounds = true
        return cell
        
        
        
    }

    
    
    @IBAction func DidTabSerachBtn(_ sender: Any) {
        
        search_btn.isSelected  = !search_btn.isSelected;
        
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
        Date_place_select_btn.isSelected  = !Date_place_select_btn.isSelected
        
        if Date_place_select_btn.isSelected {
            print("Selected")
             Skill_tableview.isHidden=false
            Date_place_select_btn.isSelected=true
            Skill_tableview.frame=CGRect.init(x: Date_place_select_btn.frame.origin.x+10, y: Date_place_select_btn.frame.origin.y+Date_place_select_btn.frame.size.height, width: Date_place_select_btn.frame.size.width, height: 200)
            
        }
        else{
            print("Not Selected")
            Date_place_select_btn.isSelected=false
            Skill_tableview.frame=CGRect.init(x: Date_place_select_btn.frame.origin.x, y: Date_place_select_btn.frame.origin.y+Date_place_select_btn.frame.size.height, width: Date_place_select_btn.frame.size.width, height: 0)
        }

        
    }
    
    @IBAction func DidTabDateDistenceSelectBtn(_ sender: Any) {
        date_distence_select_btn.isSelected  = !date_distence_select_btn.isSelected
        
        if date_distence_select_btn.isSelected {
            print("Selected")
             Skill_tableview.isHidden=false
            date_distence_select_btn.isSelected=true
            Skill_tableview.frame=CGRect.init(x: date_distence_select_btn.frame.origin.x-10, y: date_distence_select_btn.frame.origin.y+date_distence_select_btn.frame.size.height, width: date_distence_select_btn.frame.size.width, height: 200)
            
        }
        else{
            print("Not Selected")
            date_distence_select_btn.isSelected=false
            Skill_tableview.frame=CGRect.init(x: date_distence_select_btn.frame.origin.x, y: date_distence_select_btn.frame.origin.y+date_distence_select_btn.frame.size.height, width: date_distence_select_btn.frame.size.width, height: 0)
        }

        
    }

    @IBAction func DidTabDraweBtn(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
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
