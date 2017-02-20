//
//  ClientHomeController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 30/01/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class ClientHomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Dropdown_backview: UIView!
    @IBOutlet var Fitness_type_dropdownBtn: UILabel!
    @IBOutlet var Feed_tableview: UITableView!
    var drop: UIDropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

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

}
