//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143153 on 22/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

class DetailController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,
     UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var constrainHeight : NSLayoutConstraint!
    
    @IBOutlet weak var viewPicker : UIPickerView!
    @IBOutlet weak var imagePicked : UIImageView!
    @IBOutlet weak var textName : UITextField!
    @IBOutlet weak var textDescription : UITextView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var place: Place? = nil
    var keyboardHeight: CGFloat!
    var activatedHeight: UIView!
    var activeField : UIView!
    var lastOffSet: CGPoint!
    

    var pickerElements1 = ["Generic Place","Touristic Place"]	
    
    // ****************************************************************************************
    // * UIPickerViewDelegate
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerElements1.count
    }
    
    public func  pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElements1[row]
    }
    // ****************************************************************************************
 
    // ****************************************************************************************
    // * UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any])
    {
        view.endEditing(true)
        let image = info[.originalImage] as! UIImage
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker:
        UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    // ****************************************************************************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewPicker.delegate = self
        self.viewPicker.dataSource = self

        // Do any additional setup after loading the view.
        if (place != nil) {
            
            // Change of properties
            textName.text = place?.name
            textDescription.text = place?.description
            
            var rowInComponent: Int!
            
            if place?.type == Place.PlacesTypes.GenericPlace {
                rowInComponent = 0
            } else {
                rowInComponent = 1
            }
            viewPicker.selectRow(rowInComponent,inComponent: 0, animated: true)
            
            // Change of Btn title
            btnUpdate.setTitle("Update",for:.normal)
            
        
        } else {
            
            // Change of Btn title
            btnUpdate.setTitle("New",for:.normal)
            // Cloear the lorep Ipsum
            textDescription.text = ""
            
        }
        
        // Soft Keyboard Control
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification,object: nil)
        notificationCenter.addObserver(self,selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification,object: nil)
        
        textName.delegate = self
        textDescription.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // It closes the view and return to previous view
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func update(_ sender: Any) {
        
        let newPlace : Place
        
        // Corresponde a una operación de New
        if (place==nil) {
            
            // Chosen Type of Place
            if (viewPicker.selectedRow(inComponent: 0) == 0 ) {
                newPlace = Place()
            }
            else {
            // Chosen Touristic Places
                newPlace = Place()
                // newPlace.discount_tourist = "Casa de la pradera"
            }
        }
        // Corresponde a una operación de Update
        else {
            newPlace = ManagerPlaces.shared().remove(_value: place!)
        }
        
        newPlace.name = textName.text!
        newPlace.description = textDescription.text!
        newPlace.location = ManagerLocation().getLocation()
        if (viewPicker.selectedRow(inComponent: 0) == 0 ) { newPlace.type = Place.PlacesTypes.GenericPlace }
        else { newPlace.type = Place.PlacesTypes.TouristicPlace }
        
        // Selected Image
        var data:Data? = nil
        // data = UIImageJPEGRepresentation(imagePicked.image!,1.0) -- Deprecated.
        data = imagePicked.image?.jpegData(compressionQuality: 1.0)
        newPlace.image_in = data
    
        
        // It misses treatment of Data type.
        ManagerPlaces.shared().append(_value: newPlace)
        ManagerPlaces.shared().updateObservers()
        
        
    }
    
    @IBAction func remove(_ sender: Any) {
        ManagerPlaces.shared().delete(_value: place!)
        ManagerPlaces.shared().updateObservers()
    }
    
    @IBAction func selectImage(_ sender: Any) {
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker,animated: true, completion: nil)
        
    }
    
    // Functions del object-c (Cambiar poder), del TextField, i del TextView.
    @objc func textViewShouldBeginEditing(_ textView: UITextView) {
        activeField = textView
        lastOffSet = self.scrollView.contentOffset
    }
    
    @objc func textViewShouldEndEditing(_ textView: UITextView) {
        if (activeField == textView) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
    }
    
    @objc func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffSet = self.scrollView.contentOffset
        return true
    }
    
    @objc func textFieldShouldEndEditing(_ textField: UITextField) {
        if (activeField == textField) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
    }
    
    // Funcions de object-c by el Delegate del Heyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func hideKeyboard(notification: Notification){
        if (keyboardHeight != nil) {
            self.scrollView.contentOffset = CGPoint(x: self.lastOffSet.x, y:self.lastOffSet.y)
            self.constrainHeight.constant -= self.keyboardHeight
        }
        keyboardHeight = nil
    }
    
    @objc func showKeyboard(notification: Notification){
        if (activeField != nil) {
            let userInfo = notification.userInfo!
            let keyboardSreenEndFrame = (userInfo [UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardSreenEndFrame, from: view.window)
            
            keyboardHeight = keyboardViewEndFrame.size.height
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
                if collapseSpace > 0 {
                    self.scrollView.setContentOffset(CGPoint(x: self.lastOffSet.x, y: collapseSpace + 10), animated: false)
                    self.constrainHeight.constant += self.keyboardHeight
                }
                else {
                    keyboardHeight = nil
                }
    }
        
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
