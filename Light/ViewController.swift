//
//  ViewController.swift
//  Light
//
//  Created by Limon on 5/26/16.
//  Copyright © 2016 Light. All rights reserved.
//

import UIKit

let tintColor = UIColor(red: 0.912, green: 0.425, blue: 0.029, alpha: 1.0)

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var dataSource = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Light"

        tableView.backgroundColor = tintColor
        navigationController?.navigationBar.barTintColor = tintColor
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        dataSource.append(["text": "Stylized organs", "icon": "heart"])
        dataSource.append(["text": "Food pictures", "icon": "camera"])
        dataSource.append(["text": "Straight line maker", "icon": "pencil"])
        dataSource.append(["text": "Let's cook!", "icon": "beaker"])
        dataSource.append(["text": "That's the puzzle!", "icon": "puzzle"])
        dataSource.append(["text": "Cheers", "icon": "glass"])

    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let dict = dataSource[indexPath.row]

        cell.textLabel?.text = dict["text"]

        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        cell.imageView?.image = UIImage(named: dict["icon"]!)

        return cell
    }
}