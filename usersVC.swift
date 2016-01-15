//
//  usersVC.swift
//  Messager
//
//  Created by Mario  on 11/30/15.
//  Copyright © 2015 BBG. All rights reserved.
//

import UIKit

var userName = ""

class usersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var resultsTable: UITableView!
    
    
    var resultsUsernameArray = [String]()
    var resultsProfileNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        
        resultsTable.frame = CGRectMake(0, 0, theHeight, theHeight-64)
        
        userName = PFUser.currentUser()!.username!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let predicate = NSPredicate(format: "username != '"+userName+"'" )
        var query = PFQuery (className: "_User", predicate: predicate)
        let objects = try! query.findObjects()
        
        for object in objects {
            
            self.resultsUsernameArray.append(object.objectForKey("username") as! String)
            self.resultsProfileNameArray.append(object["profileName"] as! String)
            self.resultsImageFiles.append(object["photo"] as! PFFile)
            
            self.resultsTable.reloadData()
          
            
        
            
        }
    
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! resultsCell
        
        otherName = cell.usernameLbl.text!
        otherProfileName = cell.profileNameLbl.text!
        self.performSegueWithIdentifier("goToConversationVC", sender: self)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        resultsUsernameArray.removeAll(keepCapacity: false)
        
        resultsProfileNameArray.removeAll(keepCapacity: false)
        
        resultsImageFiles.removeAll(keepCapacity: false)
        
        let predicate = NSPredicate(format: "username != '"+userName+"'")
        

        
        
        self.navigationItem.hidesBackButton = true
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: resultsCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! resultsCell
        
        cell.usernameLbl.text = self.resultsUsernameArray[indexPath.row]
        cell.profileNameLbl.text = self.resultsProfileNameArray[indexPath.row]
        
        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            
            (imageData: NSData?, error:NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.profileimg.image = image
        }
        }
        return cell
    }
    
    @IBAction func logoutBtn_Click(sender: AnyObject) {
        
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    

}
