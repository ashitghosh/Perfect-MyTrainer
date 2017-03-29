//
//  TrainerMyPostController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 24/03/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AlamofireImage
class TrainerMyPostController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var arrMyPost = [[String:AnyObject]]()
    
    @IBOutlet var NoFeedListAvailable: UILabel!
    @IBOutlet var MyFeedTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.MyFeedTable.isHidden=false
        self.NoFeedListAvailable.isHidden=true
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.JsonForFetchForMyPost()

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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

    
    func JsonForFetchForMyPost()  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        var poststring:String?
        
        let parameters = ["trainer_id": User_id]
        let Url:String=Constants.Base_url+"trainerFeed"
        
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
                            self.MyFeedTable.isHidden=false
                            self.NoFeedListAvailable.isHidden=true
                           self.arrMyPost=(response.result.value as AnyObject).value(forKey: "TrainerFeed") as! [[String:AnyObject]]
                            self.MyFeedTable.reloadData()
                          //  self.arrCollectionVideo=(response.result.value as AnyObject).value(forKey: "TrainerVideo") as! [[String:AnyObject]]
                        }
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 1  {
                            SVProgressHUD.dismiss()
                            self.MyFeedTable.isHidden=true
                            self.NoFeedListAvailable.isHidden=false
                            self.NoFeedListAvailable.text=(response.result.value as AnyObject).value(forKey: "message") as? String
                            
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

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyPostCell! = tableView.dequeueReusableCell(withIdentifier: "MyPostCell") as! MyPostCell
        cell.selectionStyle = .none
        cell.Comment_count_lbl.layer.cornerRadius = cell.Comment_count_lbl.frame.size.height / 2
        cell.Comment_count_lbl.layer.borderWidth = 1.0
        cell.Comment_count_lbl.layer.backgroundColor = UIColor.clear.cgColor
        cell.Comment_count_lbl.layer.borderColor = UIColor.black.cgColor
        cell.Comment_count_lbl.layer.masksToBounds = true
        cell.title_lbl.text=(arrMyPost[indexPath.row] as AnyObject).value(forKey: "feed_title") as? String
        cell.description_lbl.text=(arrMyPost[indexPath.row] as AnyObject).value(forKey: "feed_description") as? String
        cell.like_count_lbl.text=(arrMyPost[indexPath.row] as AnyObject).value(forKey: "total_likes") as? String
        cell.Comment_count_lbl.text=(arrMyPost[indexPath.row] as AnyObject).value(forKey: "total_comment") as? String
        cell.Date_lbl.text=(arrMyPost[indexPath.row] as AnyObject).value(forKey: "created") as? String
        cell.Delete_btn.tag=indexPath.row

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    @IBAction func DidTabCreateFeed(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TrainerCreateFeedController") as! TrainerCreateFeedController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func DidTabDrawerBtn(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBAction func didTabDeleteBtn(_ sender: Any) {
        let selectedIndex:NSInteger=(sender as AnyObject).tag
        print(selectedIndex)
        self.arrMyPost.remove(at: selectedIndex)
        self.MyFeedTable.reloadData()
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
