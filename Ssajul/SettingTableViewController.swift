//
//  SettingTableViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 11. 27..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit

import RealmSwift
import ALCameraViewController
import AWSS3

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileInfo: UILabel!
    @IBOutlet weak var uiLogin: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        

        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        loginButtonChanger()
    }
    
    func setUp(){
        if SSajulClient.sharedInstance.isLogin() == false {
            profileInfo.isHidden = false
            return
        }
        
        profileInfo.isHidden = true
        
        guard let profileImage = UserDefaults.standard.data(forKey: "USER_PROFILE") else {
            return
        }
        
        
        self.profileImage.image = UIImage.init(data: profileImage)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        
        if identifier == "loginSegue" {
            if SSajulClient.sharedInstance.isLogin() == true {
                SSajulClient.sharedInstance.logout()
                loginButtonChanger()
                return false
            }
        }
        
        return true
    }
    
    func loginButtonChanger(){
        if SSajulClient.sharedInstance.isLogin() == true {
            uiLogin.title = "로그아웃"
            setUp()
            
            
        }else{
            uiLogin.title = "로그인"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
 
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            
            if SSajulClient.sharedInstance.isLogin() == false {
                return
            }
            
            let croppingEnabled = true
            let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
                // Do something with your image here.
                // If cropping is enabled this image will be the cropped version
                guard let userImage = image else {
                    
                    self!.dismiss(animated: true, completion: nil)
                    return
                }
                let profileImage = self?.resizeImage(image: userImage, newWidth: 100)
                self?.profileImage.image = profileImage
                
                
                
                self?.uploadToS3(image: profileImage!)
                self?.dismiss(animated: true, completion: nil)
            }
            
            present(cameraViewController, animated: true, completion: nil)
        }
        
        
        if indexPath.section == 2 {
            
            let realm = try! Realm()
            
            var result :Results<History>
            
            switch indexPath.row {
            case 0:
                result = realm.objects(History.self).filter( "type == '" + HistoryType.Read + "'")
            case 1: result = realm.objects(History.self).filter( "type == '" + HistoryType.Favorite + "'")
            case 2: result = realm.objects(History.self).filter( "type == '" + HistoryType.Comment + "'")
            case 3:
                result = realm.objects(History.self)
            default:
                result = realm.objects(History.self).filter( "type == '" + HistoryType.Read + "'")
                
            }
            
            realm.beginWrite()
            realm.delete(result)
            try! realm.commitWrite()
        }
        
    }
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func uploadToS3(image : UIImage){
        
        let image = image
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("profile.jpg")
        
        UserDefaults.standard.set( UIImageJPEGRepresentation(image, 90.0) , forKey: "USER_PROFILE")
        UserDefaults.standard.synchronize()
        
        let imageData = UIImageJPEGRepresentation(image, 0.99)
        fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)

        let fileUrl = NSURL(fileURLWithPath: path)
        
        let transferManager = AWSS3TransferManager.default()
        
        guard let uploadRequest = AWSS3TransferManagerUploadRequest() else {
            return
        }
        
        let loginId = SSajulClient.sharedInstance.getLoginID()
        uploadRequest.bucket = "cdn.wearecontrol.com/ssajul/thumb"
        uploadRequest.key = loginId + ".jpg"
        uploadRequest.contentType = "image/jpeg"
        uploadRequest.body =  fileUrl as URL!

        
        
        transferManager?.upload(uploadRequest).continue(with: AWSExecutor.mainThread(), withSuccessBlock: { (taskk : AWSTask) -> Any? in
            if taskk.error != nil {
                //err
            }else{
                let alertController = UIAlertController(title: "완료", message: "업로드 완료", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            return nil
        })
    }

}
