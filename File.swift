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
        self.layer.borderWidth = Radious
        self.layer.masksToBounds = true
        self.layer.borderColor = BorderColour.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}

struct Constants {
    static let Base_url = "http://ogmaconceptions.com/demo/my_perfect_trainer/MyPerfectTrainerApp/"
}

extension UIView{
    func ViewRoundCorner(Roundview:UIView,radious:Float)  {
        Roundview.layer.cornerRadius = CGFloat(radious);
        Roundview.layer.masksToBounds = true;
        
        Roundview.layer.borderColor = UIColor.white.cgColor;
        Roundview.layer.borderWidth = 0.5;
        
    }

    
    }
