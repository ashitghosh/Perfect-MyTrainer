//
//  ClientInvoiceController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 03/07/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import AlamofireImage

class ClientInvoiceController: UIViewController,UITableViewDelegate,UITableViewDataSource {
var  ArrSchduleList = [[String:AnyObject]]()
    @IBOutlet var Invoice_tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       self.FetchInvoiceList()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Table VIEW DATASOURCE AND DELEGATE METHOD
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ArrSchduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SchedulelistCell! = tableView.dequeueReusableCell(withIdentifier: "SchedulelistCell") as! SchedulelistCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.Profile_image.CircleImageView(BorderColour: UIColor.black, Radious: 1.0)
        cell.name_lbl.text=(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "trainer") as AnyObject).value(forKey: "name") as! String)
        cell.Session_date_time_lbl.text="Booking Id: " + String(describing: ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "id") as! NSNumber)) + " Invoice Id: " + String(describing: ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "invoice_id") as! String))
        //cell.Session_date_time_lbl.text="Booking Id: " + String(describing: ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "id") as! NSNumber))
        
        cell.Paid_lbl.text = "Total paid: $" + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "total_price") as! NSInteger))
        
        cell.Session_time_lbl.text =  "Session time: " +  String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "session_time") as! NSInteger))
        
        cell.Total_session_lbl.text = "Total session: " + String(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "no_of_session") as! NSInteger))
        cell.Session_type_lbl.text = "Type: " + ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "booking_type") as! String)
        
       cell.Invoice_date_lbl.text =  ((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "date") as! String)
    cell.Profile_image.image = UIImage.gif(name: "Waiting_image_gif")
    let url:String=(((self.ArrSchduleList[indexPath.row] as AnyObject).value(forKey: "trainer") as AnyObject).value(forKey: "profile_image") as! String)
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }



    func FetchInvoiceList()  {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let userDefaults = Foundation.UserDefaults.standard
        let User_id:String = userDefaults.string(forKey: "user_id")!
        let param=["client_id": User_id as AnyObject]
        let url=Constants.Client_url+"clientInvoiceList"
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get status code
                if let status = response.response?.statusCode {
                    print("Status = ",status);
                    switch(status){
                    case 200:
                        print( "Json  return for Sign Up= ",response)
                        SVProgressHUD.dismiss()
                        if( response.result.value as AnyObject).value(forKey: "status") as? NSNumber==0{
                            SVProgressHUD.dismiss()
                            self.ArrSchduleList.removeAll()
                            self.ArrSchduleList=((response.result.value as AnyObject).value(forKey: "List") as AnyObject) as! [[String : AnyObject]]
                            self.Invoice_tableview.reloadData()
                            
                        }
                            
                        else{
                            
                            SVProgressHUD.dismiss()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.dismiss()
                    }
                }
                //to get JSON return value
                /*     if let result = response.result.value {
                 let JSON = result as! NSDictionary
                 print("new result",JSON)
                 }*/
                
        }
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
