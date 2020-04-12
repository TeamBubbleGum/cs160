//
//  CaptureViewController.swift
//  myUnloadIOS
//
//  Created by Cagan Sevencan on 4/11/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import UIKit
import AlamofireImage



class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        guard let name = nameField.text, let description = commentField.text,
            let weight = weightField.text, let zip = zipField.text else{
                return
        }
       // let imageData = picView.image!.pngData() //Save it as a png
        
        
        
        print("Adding the item")
        Service.shared.createItem(name: name, desc: description, weight: weight, dimen: "2 x 4 x 4", seller: "2424", zip: zip ) { (err) in   //make a call to the service class
                   if let err = err {
                       print("Failed to create an item object:", err)
                       return
                   }
                   print("Finished creating an item")
               }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCamera(_ sender: Any) {
        let picker = UIImagePickerController() //Special built in view controller
        //We then present it -- Not very configurable(not ideal for filters, custom views etc.)
        picker.delegate = self //After photo is taken lmk what they took, call me back on a func that has the photo
        picker.allowsEditing = true // presents second screen to edit
        
        //Since we are running on a simulator, after we create the controller
        //We need to check to see if the camera is avaiable
        if UIImagePickerController.isSourceTypeAvailable(.camera){ //swift enum - if we start with dot, it will figure out which enum we are expecting
            //If we are using our real phone, then by default open up the camera
            picker.sourceType = .camera
        }else{ //if running on simulator
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    //Retuns a dict. that has the image
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //It comes inside of a dict. called info, it comes with other info as well as image asset
        let image = info[.editedImage] as! UIImage //Cast it as a UIImage since its coming out of dictionary
        //We have to resize it to shrink its size
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size) //scaling it down to size
        //Put the scaled image inside the picView
        picView.image = scaledImage
        
        //Dismiss camera view
        dismiss(animated: true, completion: nil)
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
