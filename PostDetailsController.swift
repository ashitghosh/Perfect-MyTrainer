//
//  PostDetailsController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 29/03/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AlamofireImage
class PostDetailsController: UIViewController {
    var PostDetails:[String:AnyObject] = [:]
    var Feed_id:NSNumber = 0.0
    @IBOutlet var date_lbl: UILabel!
    @IBOutlet var description_txtview: UITextView!
    @IBOutlet var title_lbl: UILabel!
    @IBOutlet var comments_count_lbl: UILabel!
    @IBOutlet var Like_lbl: UILabel!
    @IBOutlet var Post_Image_view: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Post details",PostDetails)
        
        Feed_id=(((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "feed_id") as? NSNumber)!
        description_txtview.text=((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "feed_description") as? String
         title_lbl.text=((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "feed_title") as? String
        Like_lbl.text=((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "total_likes") as? String
         comments_count_lbl.text=((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "total_comment") as? String
         date_lbl.text=((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "created") as? String
        let file_type=((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "file_type") as? String
        let url:String?
        if file_type=="video"{
             url = "http://ogmaconceptions.com/demo/my_perfect_trainer/img/video.jpeg"
        }
        else{
             url = (((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "feed_file") as? String)!
        }
      //  let url:String = ((PostDetails as AnyObject).value(forKey: "detail") as AnyObject).value(forKey: "feed_file") as! String
        
        Alamofire.request(url!).responseImage { response in
            // debugPrint(response)
            
            
            //debugPrint(response.result)
            
            if let image = response.result.value {
                self.Post_Image_view.image=image
                
            }
            
        }

        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidTabCommentBtn(_ sender: Any) {
       let vc=self.storyboard! .instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        vc.FeedId=Feed_id
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func DidTabBackBtn(_ sender: Any) {
    self.navigationController! .popViewController(animated: true) 
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
