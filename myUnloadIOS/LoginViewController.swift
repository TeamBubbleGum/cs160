//
//  LoginViewController.swift
//  myUnloadIOS
//
//  Created by Cagan Sevencan on 4/10/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import UIKit

//struct User: Decodable{
//    let _id: String
//    let email: String
//    let password: String
//}

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
    
    
    @IBAction func signUpAction(_ sender: Any) {
        guard let username = usernameTextField.text,
                  let password = passwordTextField.text else{
                      return
              }
                let errorTitle = "Cannot Sign Up"
                if username.isEmpty || password.isEmpty{
                        let message = "Please fill out all fields"
                        showErrorAlert(with: errorTitle, message: message)
                }else if username.contains(" ") || password.contains(" "){
                let message = "Username/Password cannot contain spaces"
                showErrorAlert(with: errorTitle, message: message)
                }else{
              guard let url = URL(string: "http://localhost:3000/user/signup") else {return}
              
              var signupRequest = URLRequest(url: url)  //typecasting to URLRequest - takes in above url object
              signupRequest.httpMethod = "POST"
             
          let params = ["email": username , "password": password]
              do{
                //Passing params as our object
                let data = try JSONSerialization.data(withJSONObject: params, options:  .init())
                
        signupRequest.httpBody = data
        signupRequest.setValue("application/json", forHTTPHeaderField: "content-type")  //VERY IMPORTANT
                //set the header for JSON

                      //When we use this, it keeps Session information inside of the cookies in IOS app
                      URLSession.shared.dataTask(with: signupRequest) { (data, resp, err) in
                            //check error
                        if let err = err{
                            print("Failed to Sign Up:", err)
                            return
                        }
                        guard let data = data else { return }
                        print(String(data: data, encoding: .utf8) ?? "")
                        
                if let httpResponse = resp as? HTTPURLResponse {
                            print(httpResponse.statusCode)
                        DispatchQueue.main.async { [weak self] in
                                    if httpResponse.statusCode == 201 {
                                    self?.performSegue(withIdentifier: "loginSegue", sender: nil)
                                        print("Signed up successfully")
                                    }else{
                                        let message = "Invalid Request"
                                        self?.showErrorAlert(with: errorTitle, message: message)
                                    }
                                        }
                                            }
                        
                         }.resume() //don't forget!
                     }catch{
                         print("Failed to serialize data:", error)
                     }
        }
    }
    
    
    
    @IBAction func onLogin(_ sender: Any) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else{
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
        
        
        guard let url = URL(string: "http://localhost:3000/user/login") else {return}
        var loginRequest = URLRequest(url: url)  //typecasting to URLRequest - takes in above url object
        loginRequest.httpMethod = "POST"
        
        let params = ["email": username , "password": password]
       
        do{
        
            let data = try JSONSerialization.data(withJSONObject: params, options:  .init())
                   //Passing params as our object
            loginRequest.httpBody = data
            loginRequest.setValue("application/json", forHTTPHeaderField: "content-type")
            
                //When we use this, it keeps Session information inside of the cookies in IOS app
                URLSession.shared.dataTask(with: loginRequest) { (data, resp, err) in
                    
                      //check error
                    if let err = err{
                        print("Failed to login:", err)
                        return
                    }
                    guard let data = data else { return }
                    
                    print(String(data: data, encoding: .utf8) ?? "")
                    
                   if let httpResponse = resp as? HTTPURLResponse {
                       print(httpResponse.statusCode)
                      DispatchQueue.main.async { [weak self] in
                    if httpResponse.statusCode == 200 {
                    self?.performSegue(withIdentifier: "loginSegue", sender: nil)
                    
                    print("Logged in successfully")
                    }else{
                        let message = "Wrong Username/Password"
                        self?.showErrorAlert(with: errorTitle, message: message)
                    }
                        }
                            }
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
