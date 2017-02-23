//
//  ClientHomeController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 30/01/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class ClientHomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Small_group_btn: UIButton!
    @IBOutlet var Classes_btn: UIButton!
    @IBOutlet var Training_type_two_view: UIView!
    @IBOutlet var personal_training_btn: UIButton!
    @IBOutlet var Training_type_view: UIView!
    @IBOutlet var Training_type_backview: UIView!
    @IBOutlet var Dropdown_backview: UIView!
    @IBOutlet var Fitness_type_dropdownBtn: UILabel!
    @IBOutlet var Feed_tableview: UITableView!
    var drop: UIDropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        Training_type_backview.isHidden=true;
      Small_group_btn.setBottomBorder()
      Classes_btn.setBottomBorder()
      personal_training_btn.setBottomBorder()
      Training_type_view.ViewRoundCorner(Roundview: Training_type_view, radious: 15.0)
        Training_type_two_view.ViewRoundCorner(Roundview: Training_type_two_view, radious: 10.0)
        // Do any additional setup after loading the view.
    }
    
    
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FeedCell! = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FeedCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc=self.storyboard!.instantiateViewController(withIdentifier: "ClientAboutController") as! ClientAboutController
        self.navigationController?.pushViewController(vc, animated: true)
       /* let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientHomeController") as! ClientHomeController
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // Show the navigation bar on other view controllers
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func DidTabDrawerBtn(_ sender: Any) {
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
    @IBAction func DidTabTrainingTypeViewHideBtn(_ sender: Any) {
        
        Training_type_backview.isHidden=true;
    }
    @IBAction func DidTabTrainingTypeBtn(_ sender: Any) {
        Training_type_backview.isHidden=false;
    }
    @IBAction func DidTabPersonalTraining(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "ClientTrainingTypeController") as! ClientTrainingTypeController
        self.navigationController?.pushViewController(vc, animated: true);
    }

    @IBAction func DidTabClassesBtn(_ sender: Any) {
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "ClientTrainingTypeController") as! ClientTrainingTypeController
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    @IBAction func DidTabSmallGrouBtn(_ sender: Any) {
        
        let vc = self.storyboard! .instantiateViewController(withIdentifier: "ClientTrainingTypeController") as! ClientTrainingTypeController
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
}

