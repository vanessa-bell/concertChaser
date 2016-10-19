//
//  PreferencesViewController.swift
//  ConcertChaser
//
//  Created by Vanessa Bell on 9/28/16.
//  Copyright © 2016 Vanessa Bell. All rights reserved.
//

import UIKit

class PreferencesViewController: UITableViewController {
    
    @IBOutlet weak var metroAreaTextField: UITextField!
    
    override func viewDidLoad() {
        metroAreaTextField.text = "San Francisco Bay Area"
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "MetroSearchResults" {
//            let controller = segue.destinationViewController as! SearchResultsViewController
//
//            }
//
//        }

}
