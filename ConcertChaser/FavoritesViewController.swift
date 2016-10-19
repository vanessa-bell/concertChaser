//
//  FavoritesViewController.swift
//  ConcertChaser
//
//  Created by Vanessa Bell on 9/30/16.
//  Copyright © 2016 Vanessa Bell. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UITableViewController {
    var favorites = [Favorite]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func fetchAllFavorites() {
        let userRequest = NSFetchRequest(entityName: "Favorite")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            favorites = results as! [Favorite]
        } catch {
            print("\(error)")
        }
    }
    
    override func viewDidLoad() {
        fetchAllFavorites()
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchAllFavorites()
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ConcertCell", forIndexPath: indexPath) as! ConcertCell
        cell.textLabel?.text = favorites[indexPath.row].displayName
        // return cell so that the Table View knows what to draw in each cell
        return cell
    
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(favorites[indexPath.row])
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            fetchAllFavorites()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            // reload the table view
            tableView.reloadData()
        }
    }
    //TODO: configure for favorites
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowConcertDetails" {
//            let controller = segue.destinationViewController as! ConcertDetailsViewController
//            if let indexPath = tableView.indexPathForCell(sender as! ConcertCell) {
//                
//                    controller.concert = favorites[indexPath.row].displayName!
//                    controller.concertID = favorites[indexPath.row].concertID!
//                
//            }
//        }
//    }
}



