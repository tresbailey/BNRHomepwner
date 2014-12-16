//
//  AssetTypeViewController.swift
//  Homepwner
//
//  Created by Tres Bailey on 12/10/14.
//  Copyright (c) 2014 TRESBACK. All rights reserved.
//

import UIKit

class AssetTypeViewController: UITableViewController {
    var item: Item!
    var itemStore: ItemStore!
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = NSLocalizedString("Asset Type", comment: "Asset type title")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allAssetTypes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        
        let assetType = itemStore.allAssetTypes[indexPath.row]
        if let assetString = assetType.valueForKey("label") as? String {
            let localizedAssetString = NSLocalizedString(assetString, comment: "Asset type string")
            cell.textLabel?.text = localizedAssetString
        }
        
        if assetType == item.assetType {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .Checkmark
            
            let assetType = itemStore.allAssetTypes[indexPath.row]
            item.assetType = assetType
        }
    }
}

