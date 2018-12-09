//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143153 on 22/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit
import CoreLocation

class DetailController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,
     UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate, ManagerPlacesStoreObserver {
    
    @IBOutlet weak var constrainHeight : NSLayoutConstraint!
    
    @IBOutlet weak var viewPicker : UIPickerView!
    @IBOutlet weak var imagePicked : UIImageView!
    @IBOutlet weak var textName : UITextField!
    @IBOutlet weak var textDescription : UITextView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
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

        self.activityIndicator.hidesWhenStopped = true
        
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
            
            // lace!.image_in = Data(contentsOf: FileSystem.GetPathImage(id: place!.id))
            
            viewPicker.selectRow(rowInComponent,inComponent: 0, animated: true)
            imagePicked.image = UIImage(data: place!.image_in!)
            
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
    
    
    func onPlacesStoreEnd(result: Int) {
        self.performSelector(onMainThread: #selector(endStore), with: nil, waitUntilDone: false)
    }
    
    // It closes the view and return to previous view
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func update(_ sender: Any) {
        
        let newPlace : Place
        let newTPlace : PlaceTourist
        let managerPlaces : ManagerPlaces
        let managerLocation : ManagerLocation
        
        let vName : String
        let vDescription : String
        let vLocation : CLLocationCoordinate2D
        let vImage: Data
        let vType: Place.PlacesTypes
        let vDiscount : String = "5%"
        
        // *********************************************************************************
        // Services
        // *********************************************************************************
        managerPlaces = ManagerPlaces.shared()
        managerPlaces.delegate = self
        managerLocation = ManagerLocation.shared()
        
        // *********************************************************************************
        // Data from screen
        // *********************************************************************************
        
        // Selected Image
        var data:Data? = nil
        data = imagePicked.image?.jpegData(compressionQuality: 1.0)
        
        // Picker
        if (viewPicker.selectedRow(inComponent: 0) == 0 ) { vType = Place.PlacesTypes.GenericPlace }
        else { vType = Place.PlacesTypes.TouristicPlace }
        
        vName = textName.text!
        vDescription = textDescription.text!
        vLocation = managerLocation.getLocation()
        vImage = data!
        
        // ********************************************************************************
        
        // Empezamos la animacion.
        activityIndicator.startAnimating()
        
        // Corresponde a una operación de New
        if (place==nil) {
        
            if  (vType == Place.PlacesTypes.GenericPlace) {
                newPlace = Place(name: vName,description: vDescription,image_in: vImage)
                newPlace.location = vLocation
                managerPlaces.append(_value: newPlace)
            } else {
                newTPlace = PlaceTourist(name: vName,description: vDescription, discount_tourist: vDiscount, image_in: vImage)
                newTPlace.location = vLocation
                managerPlaces.append(_value: newTPlace)
            }
        }
        // Corresponde a una operación de Update
        else {
            newPlace = ManagerPlaces.shared().remove(_value: place!)
            newPlace.name = vName
            newPlace.description = vDescription
            newPlace.image_in = vImage
            newPlace.location = vLocation
            managerPlaces.append(_value: newPlace)
        }
        
        // It misses treatment of Data type.
        managerPlaces.updateObservers()
        
        // Seriliazating ...... all datababse.
        managerPlaces.store()
        
    }
    
    @IBAction func remove(_ sender: Any) {
        
        // Empezamos la animacion.
        activityIndicator.startAnimating()
        
        let managerPlaces = ManagerPlaces.shared()
        managerPlaces.delete(_value: place!)
        managerPlaces.updateObservers()
    
        // Seriliazating ...... all datababse.
        managerPlaces.store()
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
    
    @objc func endStore() {
        
        activityIndicator.stopAnimating()
        let manager = ManagerPlaces.shared()
        
        dismiss(animated: true, completion: nil)
        manager.updateObservers()
        
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
