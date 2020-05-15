//
//  ViewController.swift
//  Temp
//
//  Created by mohammed balegh on 4/28/20.
//  Copyright © 2020 mohammed balegh. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButon: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    let attributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: UIColor.white,
               .font: UIFont(name: "Impact", size: 40)!,
               .strokeColor: UIColor.black,
               .strokeWidth: -4
           ]
    
    func textProperties (toTextField textField: UITextField,_ text: String)
    {
        textField.defaultTextAttributes =  self.attributes
        textField.text = text
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
        textField.autocapitalizationType = .allCharacters
        textField.adjustsFontSizeToFitWidth = true
        
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        textProperties(toTextField: topText, "TOP")
        textProperties(toTextField: bottomText, "BOTTOM")
        imagePickerView.image = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
        cameraButon.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        textProperties(toTextField: topText, "TOP")
        textProperties(toTextField: bottomText, "BOTTOM")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        keyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isEditing {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save() {
        let memedImage = generateMemedImage()
        // Create the meme
        let meme = Meme(top: topText.text!, bottom: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        hideToolbars(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        
        shareButton.isEnabled = true
        
        return memedImage
    }
    
    func hideToolbars(_ hide: Bool) {
        toolbar.isHidden = hide
        navBar.isHidden = hide
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func share(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.save()
            
        }
        
        dismiss(animated: true, completion: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        openImagePicker(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        openImagePicker(.camera)
    }
    
    func openImagePicker(_ type: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = type
        present(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as?  UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
        
        
        
        
    }
    
}

