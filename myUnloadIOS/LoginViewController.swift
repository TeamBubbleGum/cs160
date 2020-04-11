//
//  LoginViewController.swift
//  myUnloadIOS
//
//  Created by Cagan Sevencan on 4/10/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import UIKit
struct User: Decodable{
    let _id: String
    let email: String
    let password: String
}

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        guard let username = usernameTextField.text,
                  let password = passwordTextField.text else{
                      return
              }
              guard let url = URL(string: "http://localhost:3000/signup") else {return}
              
              var loginRequest = URLRequest(url: url)  //typecasting to URLRequest - takes in above url object
              loginRequest.httpMethod = "POST"
              
              let params = ["email": username , "password": password]
              do{
                         //Passing params as our object
                      loginRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options:  .init())
                         
                      //When we use this, it keeps Session information inside of the cookies in IOS app
                      URLSession.shared.dataTask(with: loginRequest) { (data, resp, err) in
                            //check error
                          if let err = err{
                              print("Failed to Sign Up:", err)
                              return
                          }
                             print("Signed up successfully")
                             //self.fetchItems()
                         }.resume() //don't forget!
                     }catch{
                         print("Failed to serialize data:", error)
                     }
    }
    
    
    
    @IBAction func onLogin(_ sender: Any) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else{
                return
        }
        guard let url = URL(string: "http://localhost:3000/login") else {return}
        
        var loginRequest = URLRequest(url: url)  //typecasting to URLRequest - takes in above url object
        loginRequest.httpMethod = "POST"
        
        let params = ["email": username , "password": password]
        do{
                   //Passing params as our object
                loginRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options:  .init())
                   
                //When we use this, it keeps Session information inside of the cookies in IOS app
                URLSession.shared.dataTask(with: loginRequest) { (data, resp, err) in
                      //check error
                    if let err = err{
                        print("Failed to login:", err)
                        return
                    }
                       print("Logged in successfully")
                       //self.fetchItems()
                   }.resume() //don't forget!
               }catch{
                   print("Failed to serialize data:", error)
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
