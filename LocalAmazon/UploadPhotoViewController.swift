//
//  UploadPhotoViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/1/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UploadPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var ref: FIRDatabaseReference?
    
    var counter = 0


    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func tapUpload(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func tapCreate(_ sender: Any) {
        

        
        let storage = FIRStorage.storage()
        
        let storageRef = storage.reference()
        
        var logoimagedata = Data()
        
        logoimagedata = UIImageJPEGRepresentation(self.imageView.image!, 0.8)!
        
        self.counter += 1
        
        // set upload path
        
//        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user: FIRUser?, error) in
//            
//            if error != nil {

        
        let filePath = "logoimage\(self.counter)"
        
        
        let metaData = FIRStorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        storageRef.child(filePath).put(logoimagedata, metadata: metaData){(metaData,error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                
                return
                
            } else {
                
                // store download url
                let logodownloadURL = metaData!.downloadURL()!.absoluteString
                
                self.ref?.child("Images").childByAutoId().setValue(["ImageURL" : "\(logodownloadURL)"])
                
            }
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        
        let storage = FIRStorage.storage()
        
        let storageRef = storage.reference()
        
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

}
