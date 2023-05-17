//
//  ImagePicker.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 16/11/2022.
//

import Foundation
import UIKit
import KRProgressHUD
import LanguageManager_iOS

class ImagePicker: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var  Vc : ProfileVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
    }
    
    
    func Open(){
        if LanguageManager.shared.currentLanguage == .en{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
                self.imagePicker.mediaTypes = ["public.image"]
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.OpenPcikImageOrCamera()
            }
            let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.imagePicker.mediaTypes = ["public.image"]
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.OpenPcikImageOrCamera()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(gallery)
            self.present(alert,animated: true,completion: nil)
        }else{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let gallery = UIAlertAction(title: "إستديو", style: .default) { (action) in
                self.imagePicker.mediaTypes = ["public.image"]
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.OpenPcikImageOrCamera()
            }
            let camera = UIAlertAction(title: "كاميرا", style: .default) { (action) in
                self.imagePicker.mediaTypes = ["public.image"]
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.OpenPcikImageOrCamera()
            }
            let cancel = UIAlertAction(title: "إلغاء", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(gallery)
            self.present(alert,animated: true,completion: nil)

        }
    }
    
    func SelectedImage(image: UIImage){
        
    }
    
    func SelectedImgprescription(image: UIImage){
        
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        SelectedImage(image: image)
        KRProgressHUD.show()
        ControllerService.instance.editImageProfile(avatar: image) { message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.Vc?.imgUser.sd_setImage(with: URL(string: Shared.shared.getAvatar()!), completed: nil)
            }
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func OpenPcikImageOrCamera (){
        self.present(self.imagePicker,animated: true,completion: nil)
    }
}

