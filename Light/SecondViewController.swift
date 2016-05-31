//
//  SecondViewController.swift
//  Light
//
//  Created by Limon on 5/30/16.
//  Copyright © 2016 Light. All rights reserved.
//

import UIKit
import WaveTransition

class SecondViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    weak var waveTransitionManager: WaveTransitionManager? {
        didSet {
            waveTransitionManager?.destination = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = tintColor
    }
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = "John Doe"
        cell.detailTextLabel?.text = "Transitions fanatic"
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
}

extension SecondViewController: WaveTransiting {
    var visibleCells: UITableView {
        return tableView
    }
}