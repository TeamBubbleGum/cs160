//
//  CameraViewController.swift
//  Unload
//
//  Created by Cagan Sevencan on 3/21/20.
//  Copyright © 2020 Cagan Sevencan. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let item = PFObject(className: "Items")
        
        item["description"] = commentField.text!
        item["user"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        //save in a seperate table for pics
       //Create a new Parse file
        let file = PFFileObject(data: imageData!) //Binary Object
        item["image"] = file //this column will have the URL to file
        
        item.saveInBackground { (success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("saved")
            }else{
                print("error!")
            }
        }
    }
    
    //When we tap the image we want this method to run
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController() // Special built in view controller
        picker.delegate = self  // when you are done taking a pic lmk what they took, call me back on a func that has the pic
        picker.allowsEditing = true //Presents second screen for editing
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){//swift enum - it figures what enum u expecting
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    //Will hand you back a dictionary that has the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage  // we take the image out and cast it coming out of dict.
        
        //once we have the image we have to resize it for it upload quickly - also Heroku has a limit
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        imageView.image = scaledImage
        
            dismiss(animated: true, completion: nil) //dismiss camera view
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
