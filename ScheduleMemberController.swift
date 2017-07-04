//
//  ScheduleMemberController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 09/06/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
class ScheduleMemberController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var Header_lbl: UILabel!
    @IBOutlet var Total_member_lbl: UILabel!
    
    
    var arrMyMember:[String:Any] = [:]
    
    @IBOutlet var Memeber_tableview: UITableView!
    @IBOutlet var Book_lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("arr member",self.arrMyMember)
        let booking_type = (self.arrMyMember as AnyObject).value(forKey: "booking_type") as? String
        if booking_type == "group"{
         self.Header_lbl.text="Group"
        }
        if booking_type == "individual"{
            self.Header_lbl.text="Individual"
        }
        if booking_type == "tandem"{
            self.Header_lbl.text="Tandem"
        }
       
         self.Total_member_lbl.text="Total Member: " + String(describing: ((self.arrMyMember as AnyObject).value(forKey: "total_members")) as! NSNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidTabBackBtn(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (((self.arrMyMember as AnyObject).value(forKey: "members") as! NSArray).count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MemberCell! = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as! MemberCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.Name_lbl.text=(((((self.arrMyMember as AnyObject).value(forKey: "members") as! NSArray)[indexPath.row]) as AnyObject).value(forKey: "client_name")) as? String
        cell.Booking_type_lbl.isHidden=true
        //cell.Booking_type_lbl.text=(((((self.arrMyMember as AnyObject).value(forKey: "members") as! NSArray)[indexPath.row]) as AnyObject).value(forKey: "booking_type")) as? String
        let url:String=(((((self.arrMyMember as AnyObject).value(forKey: "members") as! NSArray)[indexPath.row]) as AnyObject).value(forKey: "client_photo")) as! String
        cell.Profile_image.CircleImageView(BorderColour: .black, Radious: 0.0)
        Alamofire.request(url).responseImage { response in
            // debugPrint(response)
            
            
            // debugPrint(response.result)
            
            if let image = response.result.value {
                // print("image downloaded: \(image)")
                cell.Profile_image.image=image
            }
        }

               return cell
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
