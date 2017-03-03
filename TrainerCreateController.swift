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
class TrainerCreateController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet var skill_collectionview: UICollectionView!
    var arrskill = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    // self.CallFetchStates()
        self.JsonForSkill()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
