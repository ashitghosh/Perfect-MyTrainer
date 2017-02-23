//
//  BookNowViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 22/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class BookNowViewController: UIViewController {

    @IBOutlet var About_btn: UIButton!
    @IBOutlet var Send_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        About_btn.ButtonRoundCorner(radious: 10.0)
         Send_btn.ButtonRoundCorner(radious: 10.0)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func DidTabBackBtn(_ sender: Any) {
self.navigationController! .popViewController(animated: true)
    }
}
