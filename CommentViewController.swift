//
//  CommentViewController.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 17/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet var Comment_txt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CommentCell! = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
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

    @IBAction func DidTabBackBtn(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
}
