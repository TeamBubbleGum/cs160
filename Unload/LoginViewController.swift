//
//  LoginViewController.swift
//  Unload
//
//  Created by Cagan Sevencan on 3/4/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //We want to segue conditonally after the network confirms
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {   //if we make it inside this function meaning we have a user otherwise its null
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("Succesfully signed in!")
            }else{
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()       //changing to a constant using let, since we are not changing the user
        user.username = usernameField.text
        user.password = passwordField.text
        //user.email = "email@example.com"
        // other fields can be set just like with PFObject
       // user["phone"] = "415-392-0202"
         
        //if it is sucessful go to navigation pane
        user.signUpInBackground { (success, error) in
            if success{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("Succesfully signedup!")
            }else{
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
