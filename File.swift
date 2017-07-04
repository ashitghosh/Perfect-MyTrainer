//
//  File.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 21/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit
extension UIButton{
    func setBottomBorder() {
 //       self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func ButtonRoundCorner(radious:Float)  {
       // self.layer.backgroundColor = .clear
        self.layer.cornerRadius = CGFloat(radious)
       self.layer.borderWidth = 1
       self.layer.borderColor = UIColor.clear.cgColor
    }
    func BtnRoundCorner(radious:Float,colour:UIColor)  {
        // self.layer.backgroundColor = .clear
        self.layer.cornerRadius = CGFloat(radious)
        self.layer.borderWidth = 1
        self.layer.borderColor = colour.cgColor
    }
    
    func CircleBtn(BorderColour:UIColor,Radious:CGFloat)  {
        self.layoutIfNeeded()
        self.layer.borderWidth = Radious
        self.layer.masksToBounds = true
        self.layer.borderColor = BorderColour.cgColor
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }

}


extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }


extension UIScrollView {
    func scrollToTopNew() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
extension UILabel{
    func Circlelabel(BorderColour:UIColor,Radious:CGFloat)  {
        self.layoutIfNeeded()
        self.layer.borderWidth = Radious
        self.layer.masksToBounds = true
        self.layer.borderColor = BorderColour.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    func LabelRoundCorner(radious:Float)  {
        // self.layer.backgroundColor = .clear
        self.layer.cornerRadius = CGFloat(radious)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
     



}
extension UITextField{
//    func textplaceholderColor(TextColour: UIColor, getplaceholderText: String, GetTextfield:UITextField){
//        
//        GetTextfield.attributedPlaceholder = NSAttributedString(string: getplaceholderText,
//                                                               attributes: [NSForegroundColorAttributeName: TextColour.cgColor])
//    }
}

extension DateComponentsFormatter {
    func difference(from fromDate: Date, to toDate: Date) -> String? {
        self.allowedUnits = [.year,.month,.weekOfMonth,.day]
        self.maximumUnitCount = 1
        self.unitsStyle = .full
        return self.string(from: fromDate, to: toDate)
    }
}

extension UIViewController {
    
    func presentAlertWithTitle(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func Delete(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}


extension UIImageView{
    func CircleImageView(BorderColour:UIColor,Radious:CGFloat)  {
        self.layoutIfNeeded()
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.borderWidth = Radious
        self.layer.masksToBounds = true
        self.layer.borderColor = BorderColour.cgColor
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}

struct Constants {
    static let Base_url = "http://ogmaconceptions.com/demo/my_perfect_trainer/MyPerfectTrainerApp/"
     static let Client_url = "http://ogmaconceptions.com/demo/my_perfect_trainer/ClientApp/"
    static let Local_url = "http://10.1.1.11/my_perfect_trainer/MyPerfectTrainerApp/"
    //http://ogmaconceptions.com/demo/my_perfect_trainer/
}

extension UIView{
    func ViewRoundCorner(Roundview:UIView,radious:Float)  {
        Roundview.layer.cornerRadius = CGFloat(radious);
        Roundview.layer.masksToBounds = true;
        
        Roundview.layer.borderColor = UIColor.white.cgColor;
        Roundview.layer.borderWidth = 0.5;
        
    }
    func UIViewRoundCorner(radious:Float,Colour:UIColor)  {
        self.layer.cornerRadius = CGFloat(radious);
        self.layer.masksToBounds = true;
        
        self.layer.borderColor = Colour.cgColor;
        self.layer.borderWidth = 0.5;
        
    }

    
    }

/*
 func FetchWorkSchdule()  {
 
 SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
 SVProgressHUD.show()
 let userDefaults = Foundation.UserDefaults.standard
 let User_id:String = userDefaults.string(forKey: "user_id")!
 let param=["trainer_id": User_id as AnyObject]
 let url=Constants.Base_url+"trainerWorkScheduleList"
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

 }
 
 else{
 
 SVProgressHUD.dismiss()
 }
 
 default:
 print("error with response status: \(status)")
 }
 }
 //to get JSON return value
 /*     if let result = response.result.value {
 let JSON = result as! NSDictionary
 print("new result",JSON)
 }*/
 
 }
 }
 

 */
