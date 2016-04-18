//
//  ToolsCollectionViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/3/26.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import LocalAuthentication

private let reuseIdentifier = "Cell"

class ToolsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let toolsData: [(title: String, image: UIImage)] = [
        (title: "成绩", image: UIImage(named: "gpaBtn")!),
        (title: "课程表", image: UIImage(named: "classtableTab")!),
        (title: "图书馆", image: UIImage(named: "libTab")!),
        (title: "失物招领", image: UIImage(named: "lfTab")!),
        (title: "实验室", image: UIImage(named: "msBtn")!)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.collectionView?.alwaysBounceVertical = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(ToolsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.collectionView?.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toolsData.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.width/3, 152)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var nibCellLoaded = false
        if !nibCellLoaded {
            let nib = UINib(nibName: "ToolsCollectionViewCell", bundle: nil)
            collectionView.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
            nibCellLoaded = true
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ToolsCollectionViewCell
        cell.iconView.image = toolsData[indexPath.row].image
        cell.titleLabel.text = toolsData[indexPath.row].title
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.showGPAController()
        case 1:
            self.showClasstableController()
        case 2:
            self.showLibraryController()
        case 3:
            self.showLostFoundController()
        case 4:
            self.showMicroservicesController()
        default:
            return
        }
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: - push tools
    
    func showGPAController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gpaVC = storyboard.instantiateViewControllerWithIdentifier("GPATableViewController") as! GPATableViewController
        gpaVC.hidesBottomBarWhenPushed = true
        
        let userDefaults = NSUserDefaults()
        let touchIdEnabled = userDefaults.boolForKey("touchIdEnabled")
        if (touchIdEnabled) {
            let authContext = LAContext()
            var error: NSError?
            guard authContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
                return
            }
            authContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "GPA这种东西才不给你看", reply: {(success, error) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.navigationController?.showViewController(gpaVC, sender: nil)
                    })
                } else {
                    MsgDisplay.showErrorMsg("指纹验证失败")
                }
            })
        } else {
            self.navigationController?.showViewController(gpaVC, sender: nil)
        }
    }
    
    func showClasstableController() {
        let classtableVC = ClasstableViewController(nibName: nil, bundle: nil)
        classtableVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(classtableVC, sender: nil)
    }
    
    func showLibraryController() {
        let libVC = LibraryViewController(nibName: nil, bundle: nil)
        libVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(libVC, sender: nil)
    }
    
    func showLostFoundController() {
        let lfVC = LostFoundViewController()
        lfVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(lfVC, sender: nil)
    }
    
    func showMicroservicesController() {
        let msVC = MicroservicesTableViewController(style: .Plain)
        msVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(msVC, sender: nil)
    }

}