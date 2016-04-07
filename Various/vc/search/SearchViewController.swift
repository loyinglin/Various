//
//  SearchViewController.swift
//  Various
//
//  Created by 林伟池 on 16/4/7.
//  Copyright © 2016年 林伟池. All rights reserved.
//

import Foundation

class SwiftSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = Dictionary(dictionaryLiteral: (NSForegroundColorAttributeName, UIColor.whiteColor()))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(format: "cell%d", arguments: [indexPath.row]), forIndexPath: indexPath)
        return cell
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.performSegueWithIdentifier(String(format: "cell%d", indexPath.row), sender: nil)
        return nil
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}