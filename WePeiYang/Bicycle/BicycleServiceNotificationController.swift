//
//  BicycleServiceNotificationController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/7/11.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import MJRefresh

class BicycleServiceNotificationController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var notificationList = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData()
        })
        
        self.tableView.mj_header.beginRefreshing()
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData() {
        
        self.getData()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
        self.tableView.mj_header.endRefreshing()
    }
    
    
    func getData(){
        
        self.notificationList = []
        self.notificationList += [
            ["title": "诚园6斋车桩停用", "detail": "我也没有办法"],
            ["title": "诚园5斋车桩停用", "detail": "我也没有办法"],
            ["title": "诚园4斋车桩停用", "detail": "我也没有办法"],
            ["title": "诚园3斋车桩停用", "detail": "我也没有办法"],
            ["title": "诚园2斋车桩停用", "detail": "我也没有办法"],
            ["title": "诚园1斋车桩停用", "detail": "我也没有办法"]
        ]
    }
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier")
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "identifier")
        }
        
        cell?.textLabel?.text = self.notificationList[indexPath.row]["title"]
        cell?.detailTextLabel?.text = self.notificationList[indexPath.row]["detail"]
        
        return cell!
    }

    
}