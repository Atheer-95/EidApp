//
//  MemeViewcontroller.swift
//  TuwaiqProject
//
//  Created by Eth Os on 25/09/1442 AH.
//

import Foundation
import UIKit

class MemeViewController: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var MoaLabel: UILabel!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var pickImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    let pickerController = UIImagePickerController()
    
    var moveHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolBarShareAndCancel(false)
        pickerController.delegate = self
        
        textFieldsPopulate(textField:top ,textValue:" ( ... ) ")
        
    }
    
    
  
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    
    }
    
    func toolBarShareAndCancel (_ show :Bool){
        shareButton.isEnabled = show
        cancelButton.isEnabled = show
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
    //TODO: - Create a `UIImagePickerController`, set its source, and present it here.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)

    }
    @IBAction func libraryButton(_ sender: Any) {
        //Pick an Image From Library
        presentPickerViewController(source:.photoLibrary )
    }

    @IBAction func cameraButton(_ sender: Any) {
        // Pick an Image From a Camera
        presentPickerViewController(source:.camera )
    }
    
    // Image Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]){
        toolBarShareAndCancel(true)
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickImageView.contentMode = UIView.ContentMode.scaleAspectFit
                   pickImageView.image = image
               }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        toolBarShareAndCancel(false)
            dismiss(animated: true, completion: nil)
 }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        pickImageView.image = nil
        top.text = "( ... )"
       
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let share = UIActivityViewController.init(activityItems: [generateMemedImage()], applicationActivities: nil)
        present(share, animated: true, completion: nil)
        
        share.completionWithItemsHandler = {(_ , completed: Bool, _ , _) in
            
            if completed
            {
                self.save()
                share.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func save() {
            // Create the meme
        _ = Meme(topText: top.text!,originalImage: pickImageView.image!, memedImage: generateMemedImage())
    }
    
    // Memed Image : original image with text
    
    func generateMemedImage() -> UIImage {

        // Render view to an image
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return memedImage
    }

    
    
  
    
    // KEYBOARD
    
    @objc func keyboardWillShow(_ notification: Notification) {

        view.frame.origin.y = -getKeyboardHeight(notification)
        
    }
    
    
    
     @objc func keyboardWillHide(_ notification: Notification) {
        
            view.frame.origin.y = moveHeight

        
      }
     
    
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)) , name: UIResponder.keyboardWillHideNotification , object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
                  return keyboardSize.cgRectValue.height
     
    }

    
   
    // TextField

    func  textFieldsPopulate(textField:UITextField,textValue:String){
        
        textField.text = textValue
        
        textField.delegate = self
        
        
        let color : UIColor = UIColor.white
        let titleFont :UIFont = UIFont(name: "Mishafi", size: 60)!
        let outline : UIColor = .black
        let width : NSNumber = NSNumber(-1.0)
        
       let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: color,
        NSAttributedString.Key.font : titleFont,
        NSAttributedString.Key.strokeColor :outline,
        NSAttributedString.Key.strokeWidth: width
       ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.text = " "
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }


}


