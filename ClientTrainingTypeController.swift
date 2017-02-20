//
//  ClientTrainingTypeController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 16/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class ClientTrainingTypeController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    @IBOutlet var Search_background_view: UIView!
    @IBOutlet var search_btn: UIButton!
    @IBOutlet var SearchView_dropdown: UIView!
    @IBOutlet var Search_here: UIView!
    @IBOutlet var Skill_tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Search_background_view.isHidden=true;
        Skill_tableview.isHidden=true;
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TrainingTypeCell! = tableView.dequeueReusableCell(withIdentifier: "TypeCell") as! TrainingTypeCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
