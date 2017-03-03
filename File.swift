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
        
//        Roundview.layer.contentsScale = UIScreen.main.scale;
//        Roundview.layer.shadowColor = UIColor.black.cgColor;
//        Roundview.layer.shadowRadius = 5.0;
//        Roundview.layer.shadowOpacity = 0.5;
//        Roundview.layer.masksToBounds = false;
//        Roundview.clipsToBounds = false;
    }
    
    }
