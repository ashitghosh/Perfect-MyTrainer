//
//  CommentViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 17/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AlamofireImage

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet var Comment_view: UIView!
    @IBOutlet var MyFeedTableView: UITableView!
    @IBOutlet var NoCommentsAvailable: UILabel!
    @IBOutlet var Comment_txt: UITextField!
    var FeedId:String = ""
    
       var arrMyComments = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Feed_id=",self.FeedId)
        Comment_view.ViewRoundCorner(Roundview: Comment_view, radious: 8.0)
self.JsonForFetchForMyComments()
        // Do any additional setup after loading the view.
        
    }
    func PostComments()  {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        var poststring:String?
        
        let parameters = ["trainer_id": User_id,"comment": Comment_txt.text!,"feed_id": self.FeedId] as [String : Any]
        let Url:String=Constants.Base_url+"createTrainerComment"
        
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
                        self.Comment_txt.text=""
                             if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 0  {
                         SVProgressHUD.dismiss()
                         self.MyFeedTableView.isHidden=false
                         self.NoCommentsAvailable.isHidden=true
                                self.arrMyComments.append((response.result.value as AnyObject) as! [String : AnyObject])
                                print(self.arrMyComments)
                                self.MyFeedTableView.reloadData()
                       //  self.arrMyComments=(response.result.value as AnyObject).value(forKey: "trainerFeedComment") as! [[String:AnyObject]]
                        // self.MyFeedTableView.reloadData()
                         //  self.arrCollectionVideo=(response.result.value as AnyObject).value(forKey: "TrainerVideo") as! [[String:AnyObject]]
                         }
                         if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 1  {
                         SVProgressHUD.dismiss()
                         self.MyFeedTableView.isHidden=true
                         self.NoCommentsAvailable.isHidden=false
                         self.NoCommentsAvailable.text=(response.result.value as AnyObject).value(forKey: "message") as? String
                         
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
    
    func JsonForFetchForMyComments()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        var poststring:String?
        
        let parameters = ["feed_id": self.FeedId]as [String : Any]
        let Url:String=Constants.Base_url+"trainerFeedCommentList"
        
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
                            self.MyFeedTableView.isHidden=false
                            self.NoCommentsAvailable.isHidden=true
                            self.arrMyComments=(response.result.value as AnyObject).value(forKey: "trainerFeedComment") as! [[String:AnyObject]]
                            self.MyFeedTableView.reloadData()
                            //  self.arrCollectionVideo=(response.result.value as AnyObject).value(forKey: "TrainerVideo") as! [[String:AnyObject]]
                        }
                        if (response.result.value as AnyObject).value(forKey: "status") as? NSNumber == 1  {
                            SVProgressHUD.dismiss()
                            self.MyFeedTableView.isHidden=true
                            self.NoCommentsAvailable.isHidden=false
                            self.NoCommentsAvailable.text=(response.result.value as AnyObject).value(forKey: "message") as? String
                            
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


    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CommentCell! = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        cell.Profile_image.layoutIfNeeded()
        cell.Profile_image.layer.borderWidth = 1.0
        cell.Profile_image.layer.masksToBounds = true
        cell.Profile_image.layer.borderColor = UIColor.black.cgColor
        cell.Profile_image.layer.cornerRadius = cell.Profile_image.frame.size.width/2
        cell.Profile_image.clipsToBounds = true
      //  cell.Profile_image.CircleImageView(BorderColour: UIColor.gray, Radious: 1.0)
        cell.Name_lbl.text=(arrMyComments[indexPath.row] as AnyObject).value(forKey: "name") as? String
         cell.message_lbl.text=(arrMyComments[indexPath.row] as AnyObject).value(forKey: "comment") as? String
         cell.time_lbl.text=(arrMyComments[indexPath.row] as AnyObject).value(forKey: "created") as? String
        let url:String=((arrMyComments[indexPath.row] as AnyObject).value(forKey: "profile_image") as? String)!
        cell.selectionStyle = .none
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            
            
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                cell.Profile_image.image=image
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func DidTabMessgaePostBtn(_ sender: Any) {
        self.view.endEditing(true)
        let myString = Comment_txt.text
        let Comments:String = (myString?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
        print("Comments",Comments)
        if Comments.isEmpty==true{
        self.presentAlertWithTitle(title: "alert", message: "Type Your Message")
        }
        else{
        self.PostComments()
        }
    }
    @IBAction func DidTabBackBtn(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    
    @IBAction func DidTabDeleteBtn(_ sender: Any) {
        
    }
}
