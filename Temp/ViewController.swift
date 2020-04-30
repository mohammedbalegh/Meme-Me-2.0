//
//  ViewController.swift
//  Temp
//
//  Created by mohammed balegh on 4/28/20.
//  Copyright © 2020 mohammed balegh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButon: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func cancelButton(_ sender: Any) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imagePickerView.image = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
        
        topText.delegate = self
        bottomText.delegate = self
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Impact", size: 25)!,
            .strokeColor: UIColor.black,
            .strokeWidth: -4
        ]
        topText.adjustsFontSizeToFitWidth = true
        bottomText.adjustsFontSizeToFitWidth = true
        
        topText.defaultTextAttributes = attributes
        bottomText.defaultTextAttributes = attributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButon.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        keyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeKeyboardNotifications()
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
        _ = Meme(top: topText.text!, bottom: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        toolbar.isHidden = true
        navBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        navBar.isHidden = false
        
        shareButton.isEnabled = true
        
        return memedImage
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
            self.dismiss(animated: true, completion: nil)
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
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

