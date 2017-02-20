//
//  ViewController.swift
//  MyPerfectTrainer
//
//  Created by Alok Das on 23/01/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lbl_forgot_password: UILabel!
    @IBOutlet var btn_login: UIButton!
    @IBOutlet var txt_email: UITextField!
    @IBOutlet var txt_password: UITextField!
    @IBOutlet var view_login_password: UIView!
    @IBOutlet var view_login_email: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelMultiColor(getLabelName: lbl_forgot_password)
        self.ButtonCorner(getViewName: btn_login)
        self.ViewCorner(getViewName: view_login_email)
        self.ViewCorner(getViewName: view_login_password)
        self.textplaceholderColor(getTextName: txt_email, getplaceholderText: "Email")
        self.textplaceholderColor(getTextName: txt_password, getplaceholderText: "Password")
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    func ViewCorner(getViewName: UIView)  {
        getViewName.layer.cornerRadius = 12;
        getViewName.layer.masksToBounds = true;
    }
    func ButtonCorner(getViewName: UIButton)  {
        getViewName.layer.cornerRadius = 12;
        getViewName.layer.masksToBounds = true;
    }
   
    func labelMultiColor(getLabelName: UILabel)
    {
        let myString: String = "Forgot your password?"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSFontAttributeName:UIFont(name: "Georgia-Bold", size: 13.0)!])
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:12,length:8))
            getLabelName.attributedText = myMutableString
     }
    func textplaceholderColor(getTextName: UITextField, getplaceholderText: String){
     
        getTextName.attributedPlaceholder = NSAttributedString(string: getplaceholderText,
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didTapLogin(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ClientHomeController") as! ClientHomeController
            self.navigationController?.pushViewController(vc, animated: true)
    }
}

