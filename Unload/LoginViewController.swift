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
    
    //MARK: Private Methods
    private func showErrorAlert(with title: String, message: String){
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            
            present(alertController, animated: true)
    }
     
    
    //We want to segue conditonally after the network confirms
    @IBAction func onSignIn(_ sender: Any) {
        guard let username = usernameField.text,
            let password = passwordField.text else{
                return
        }
        
        let errorTitle = "Cannot Sign In"
        if username.isEmpty || password.isEmpty{
         
            let message = "Please fill out all fields"
            showErrorAlert(with: errorTitle, message: message)
        }
        if username.contains(" ") || password.contains(" "){
                   let message = "Username/Password cannot contain spaces"
                   showErrorAlert(with: errorTitle, message: message)
               }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            
            if user != nil {   //if we make it inside this function meaning we have a user otherwise its null
               let vc = FeedViewController()
               vc.modalPresentationStyle = .fullScreen
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("Succesfully signed in!")
            }else{
                let errorMessage = error?.localizedDescription ?? "There was a problem signing in."
                self.showErrorAlert(with: errorTitle, message: errorMessage)
                
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        guard let username = usernameField.text,
            let password = passwordField.text else{
                return
        }
        let errorTitle = "Cannot Sign Up"
        
        if username.isEmpty || password.isEmpty{
                let message = "Please fill out all fields"
                 showErrorAlert(with: errorTitle, message: message)
        }
        if username.contains(" ") || password.contains(" "){
            let message = "Username/Password cannot contain spaces"
            showErrorAlert(with: errorTitle, message: message)
        }
        
        let user = PFUser()       //changing to a constant using let, since we are not changing the user
        user.username = username
        user.password = password
        //user.email = "email@example.com"
        // other fields can be set just like with PFObject
       // user["phone"] = "415-392-0202"
         
        //if it is sucessful go to navigation pane
        user.signUpInBackground { (success, error) in
            let vc = FeedViewController()
            vc.modalPresentationStyle = .fullScreen
            if success{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
                print("Succesfully signedup!")
            }else{
                let errorMessage = error?.localizedDescription ?? "There was a problem signing up."
                self.showErrorAlert(with: errorTitle, message: errorMessage)
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
