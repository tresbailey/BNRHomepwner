//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Tres Bailey on 12/9/14.
//  Copyright (c) 2014 TRESBACK. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate,
        UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var itemStore: ItemStore
    var item: Item? {
        didSet {
            navigationItem.title = item?.name
        }
    }
    var imageStore: ImageStore
    
    var isNew: Bool = false {
        didSet {
            if isNew {
                // If this is a new item, provide cancel and done buttons
                let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel,
                    target: self,
                    action: "cancel:"
                )
                
                navigationItem.leftBarButtonItem = cancelItem
                
                let doneItem = UIBarButtonItem(barButtonSystemItem: .Done,
                    target: self,
                    action: "save:"
                )
                
                navigationItem.rightBarButtonItem = doneItem
            } else {
                // If this is not a new item, use the default items
                
                navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var serialNumberField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var assetTypeButton: UIBarButtonItem!
    
    // Closures that will handle the cancel and save for detail view
    var cancelClosure: (() -> ())?
    var saveClosure: (() -> ())?
    
    func save(sender: AnyObject) {
        saveClosure?()
    }
    
    func cancel(sender: AnyObject) {
        cancelClosure?()
    }
    
    @IBAction func showAssetTypePicker(sender: AnyObject) {
        println("Type picker was pressed")
        view.endEditing(true)
        
        let avc = AssetTypeViewController()
        avc.item = self.item
        avc.itemStore = itemStore
        
        showViewController(avc, sender: self)
    }
//    /*
//    Checks if any of the subviews has an ambiguous layout
//    */
//    override func viewDidLayoutSubviews() {
//        for subview in view.subviews as [UIView] {
//            if subview.hasAmbiguousLayout() {
//                println("AMBIGUOUS: \(subview)")
//            }
//        }
//    }
    
    /*
    Called when a user clicks the Trash button in the UIToolbar at the bottom
    */
    @IBAction func clearPicture(sender: AnyObject) {
        if let itemKey = item?.itemKey {
            imageStore.deleteImageForKey(itemKey)
            imageView.image = nil
        }
    }
    
    /*
    Called when a user taps anywhere outside the fields and images
    */
    @IBAction func backgroundTapped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    /*
    Forces the keyboard to dismiss when Return key is pressed in a field
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    Called when a user clicks the Camera button in the UIToolbar at the bottom
    */
    @IBAction func takePicture(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        
        // Challenges
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.Popover
        imagePicker.popoverPresentationController?.barButtonItem = sender as UIBarButtonItem
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /*
    Called when an image has been selected from the image or taken with the camera
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        // Store the image in the ImageStore for the item's key
        if let iKey = item?.itemKey {
            imageStore.setImage(image, forKey: iKey)
        }
        
        // Put that image onto the screen in our image view
        imageView.image = image
        
        // Take image picker off the screen
        // you must call this dismiss method
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    Called before a controller's view is about to be shown
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = item?.name
        serialNumberField.text = item?.serialNumber
        valueField.text = "\(item?.valueInDollars ?? 0)"
        
        if let date = item?.dateCreated {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .NoStyle
            
            dateLable.text = dateFormatter.stringFromDate(date)
        }
        
        // If there is an item and an associated image ...
        if let key = item?.itemKey {
            if let imageToDisplay = imageStore.imageForKey(key) {
                //  ... display it on the image view
                imageView.image = imageToDisplay
            }
        }
        
        if let typeLabel = item?.assetType?.valueForKey("label") as? String {
            
            let localizedTypeLabel = NSLocalizedString(typeLabel, comment: "Type label")
            let formatString = NSLocalizedString("Type: %@", comment: "Asset type button")
            let assetButtonTitle = NSString(format: formatString, localizedTypeLabel)
            assetTypeButton.title = assetButtonTitle
        } else {
            assetTypeButton.title =  NSLocalizedString("None", comment: "Type label None")
        }
    }
    
    /*
    Called when this controller's view is about to be no longer shown
    */
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item
        item?.name = nameField.text
        item?.serialNumber = serialNumberField.text
        item?.valueInDollars = valueField.text.toInt() ?? 0
    }
//    Chapter 12, going back to using from Interface Builder
//    /*
//    Creating an instance of UIImageView in code
//    */
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let iv = UIImageView()
//        
//        // The ContentMode of the image view in the XIB was Aspect Fit
//        iv.contentMode = .ScaleAspectFit
//        
//        // Do not produce a translated constraint for this view
//        iv.setTranslatesAutoresizingMaskIntoConstraints(false)
//        
//        // The image view was a subview of the view
//        view.addSubview(iv)
//        
//        // The image view was pointed to by the imageView property
//        imageView = iv
//        
//        imageView.setContentHuggingPriority(200, forAxis: .Vertical)
//        
//        let nameMap = ["imageView": imageView,
//            "dateLabel": dateLable,
//            "toolbar": toolbar
//        ]
//        
//        // imageView is 0 pts from superview at left and right edges
//        let horizontalConstraints =
//            NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imageView]-0-|", options: nil, metrics: nil, views: nameMap)
//        
//        // imageView is 8 pts from dateLabel at its top edge...
//        // ... and 8 pts from toolbar at its bottom edge
//        let verticalConstraints =
//            NSLayoutConstraint.constraintsWithVisualFormat("V:[dateLabel]-[imageView]-[toolbar]", options: nil, metrics: nil, views: nameMap)
//        
//        NSLayoutConstraint.activateConstraints(horizontalConstraints)
//        NSLayoutConstraint.activateConstraints(verticalConstraints)
//    }
    
    init(itemStore: ItemStore, imageStore: ImageStore) {
        self.itemStore = itemStore
        self.imageStore = imageStore
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("User init(itemStore:)")
    }
}
