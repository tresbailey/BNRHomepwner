//
//  ItemsTableViewController.swift
//  Homepwner
//
//  Created by Tres Bailey on 12/8/14.
//  Copyright (c) 2014 TRESBACK. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    let itemStore: ItemStore
    let imageStore: ImageStore
    @IBOutlet var headerView: UIView!
    
    init(itemStore: ItemStore, imageStore: ImageStore) {
        self.itemStore = itemStore
        self.imageStore = imageStore
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = NSLocalizedString("Homepwner", comment: "Name of application")
        
        // Create a new bar button item that will send
        // addNewItem(_:) to ItemsViewController
        let addItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewItem:")
        
        // Set this bar button item as the right item in the navigationItem
        navigationItem.rightBarButtonItem = addItem
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as ItemCell
        // Iter 2
        //        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        
        
        
        // Set the text on the cell with the description of  the item
        // that is at the nth index of items, where n=row this cell
        // will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]
        
        // Configure the cell with the Item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        cell.valueLabel.text = currencyFormatter.stringFromNumber(item.valueInDollars)
        
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Iter 2
        //        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        // Load the NIB file
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        // Register this NIB, which contains the cell
        tableView.registerNib(nib, forCellReuseIdentifier: "ItemCell")
        
        
    }
    
    /**
    This handles the New button press
    */
    func addNewItem(send: AnyObject) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        // Rotation Chapter Removes
//        // Figure out where that item is in the array
//        if let index = find(itemStore.allItems, newItem) {
//            let indexPath = NSIndexPath(forRow: index, inSection: 0)
//            
//            // Insert this new row into the table
//            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
//        }
        
        let dvc = DetailViewController(itemStore: itemStore, imageStore: imageStore)
        dvc.item = newItem
        dvc.isNew = true
        
        dvc.cancelClosure = {
            // Remove the item from the itemStore
            self.itemStore.removeItem(newItem)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        dvc.saveClosure = {
            self.dismissViewControllerAnimated(true, completion: {
                // Figure out the index of the new item
                if let index = find(self.itemStore.allItems, newItem) {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    // Insert this new row into the table
//                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                }
            })
        }
        
        let nc = UINavigationController(rootViewController: dvc)
        
        nc.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        presentViewController(nc, animated: true, completion: nil)
        
    }
    
    // ITER 3
//    /**
//    This turns on the view for editing
//    */
//    @IBAction func toggleEditingMode(sender: AnyObject) {
//        // If you are currently in editing mode...
//        if editing {
//            // Change text of button to inform user of state
//            sender.setTitle("Edit", forState: .Normal)
//            
//            // Turn off editing mode
//            setEditing(false, animated: true)
//        } else {
//            // Change text of button to inform user of state
//            sender.setTitle("Done", forState: .Normal)
//            
//            // Enter editing mode
//            setEditing(true, animated: true)
//        }
//    }
    
    /**
    This is the Delete Edit Action
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.row]
            // Remove the item from the store
            itemStore.removeItem(item)
            
            // Remove the image from the store
            imageStore.deleteImageForKey(item.itemKey)
            
            // Also remove that row from the table view with an animation
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    /**
    This is the Move Item Action
    */
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        // Update the model
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    /**
    This is the hanlder for selecting a row in the table
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Create a DetailViewController for showing Item details
        let dvc = DetailViewController(itemStore: itemStore, imageStore: imageStore)
        
        // Give the detail view controller the item
        let item = itemStore.allItems[indexPath.row]
        dvc.item = item
        
        // Push it onto the navigation controller's stack
        showViewController(dvc, sender: self)
    }
    
    /*
    Called before this controller's view is shown
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}
