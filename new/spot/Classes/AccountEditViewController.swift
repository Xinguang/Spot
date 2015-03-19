//
//  AccountEditViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/22.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class AccountEditViewController: UITableViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    
    var user: User!
    var nameEditVC: AccountNameEditTableViewController?
//    var genderSelectVC: GenderSelectViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()


//        sexLabel.text = 
//        stationLabel.text = 
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        userImage.image = user.avatarImage()
        nameLabel.text = user.displayName
        
        idLabel.text = user.username
        
        if let gender = user.gender {
            sexLabel.text = user.genderStr()
        }
        
        if let station = user.stations.firstObject as? Station {
            stationLabel.text = station.name
        } else {
            stationLabel.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueNameEdit" {
            nameEditVC = segue.destinationViewController as? AccountNameEditTableViewController
            nameEditVC?.user = user
        }
        
        if segue.identifier == "SegueGender" {
            let vc = segue.destinationViewController as GenderSelectViewController
            vc.user = user
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let cameraAction = UIAlertAction(title: "写真を撮る", style: .Default, handler: { (action) -> Void in
                let picker = UIImagePickerController()
                picker.sourceType = .Camera
                picker.allowsEditing = true
                picker.delegate = self
                self.presentViewController(picker, animated: true, completion: nil)
            })
            let albumAction = UIAlertAction(title: "写真から選択", style: .Default, handler: { (action) -> Void in
                let picker = UIImagePickerController()
                picker.sourceType = .PhotoLibrary
                picker.allowsEditing = true
                picker.delegate = self
                self.presentViewController(picker, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: { (action) -> Void in
                
            })
            
            alertController.addAction(cameraAction)
            alertController.addAction(albumAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

extension AccountEditViewController: UINavigationControllerDelegate {
    
    
}

extension AccountEditViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let smallImage = image.scaleToFitSize(CGSize(width: 250, height: 250))
        let orgImage = image.scaleToFitSize(CGSize(width: 750, height: 750))
        
        user.avatarThumbnail = UIImagePNGRepresentation(smallImage)
        user.avatarOrg = UIImagePNGRepresentation(orgImage)
        
        UserController.saveUser(user)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        ParseController.updateUserImage(user, thumbnail: smallImage, org: orgImage)
    }
}
