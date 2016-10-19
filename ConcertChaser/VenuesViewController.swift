//
//  VenuesViewController.swift
//  ConcertChaser
//
//  Created by Vanessa Bell on 9/29/16.
//  Copyright © 2016 Vanessa Bell. All rights reserved.
//

import UIKit
import Alamofire

class VenuesViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, VenueCalendarViewControllerDelegate { 

    // MARK: Properties
    let searchController = UISearchController(searchResultsController: nil)
    
    class SongkickVenue {
        var phone: String?
        var displayName: String?
        var city: [NSDictionary]?
        var description: String?
        var website: String?
        var street: String?
        var uri: String?
        var id: Int?
        
        required init(dict: NSDictionary) {
            self.phone = dict["phone"]! as? String
            self.displayName = dict["displayName"] as? String
            self.city = dict["city"]! as? [NSDictionary]
            self.description = dict["description"]! as? String
            self.website = dict["website"]! as? String
            self.street = dict["street"]! as? String
            self.uri = dict["uri"]! as? String
            self.id = dict["id"]! as? Int
        }
    }
    var venues = [SongkickVenue]()
    var filteredVenues = [SongkickVenue]()

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredVenues = venues.filter { venue in
            return venue.displayName!.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    // MARK: Load View
    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

        let url = "https://api.songkick.com/api/3.0/search/venues.json?query=sf&bay&area&apikey=53sfqCvKDdsUawIy"
        
        Alamofire.request(.GET,url).responseJSON { response in
            
            let responseJSON = response.result.value!["resultsPage"]!!["results"]!!
            let results = responseJSON["venue"]!! as! NSMutableArray
            for jsonEvent in results {
                let dict = jsonEvent as! NSMutableDictionary
                let venue = SongkickVenue(dict: dict)
                self.venues.append(venue)
            }
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredVenues.count
        }
        return self.venues.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VenueCell", forIndexPath: indexPath) as! VenueCell
        if searchController.active && searchController.searchBar.text != "" {
            cell.textLabel?.text = self.filteredVenues[indexPath.row].displayName!
        } else {
            cell.textLabel?.text = self.venues[indexPath.row].displayName
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let myImage: UIImage = UIImage(named: "Songkick")!
        //frame: CGRectMake(0, 0, tableView.frame.size.width, 40
        let footerView = UIImageView(frame: CGRectMake(20, 20, 280, 280))
        footerView.autoresizingMask = UIViewAutoresizing.None
        footerView.image = myImage
        footerView.backgroundColor = UIColor.whiteColor()
        footerView.contentMode = .ScaleAspectFit
        
        
        tableView.tableFooterView  = footerView
        
        
        return footerView
    }
    
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func venueCalendarViewControllerDelegate(venueCell: VenueCell) {
        if searchController.active && searchController.searchBar.text != "" {
            performSegueWithIdentifier("ShowVenueCalendar", sender: filteredVenues[tableView.indexPathForCell(venueCell)!.row])
        } else {
            performSegueWithIdentifier("ShowVenueCalendar", sender: venues[tableView.indexPathForCell(venueCell)!.row])
        }
    
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowVenueCalendar" {
            let controller = segue.destinationViewController as! VenueCalendarViewController
            //
            if let indexPath = tableView.indexPathForCell(sender as! VenueCell) {
                if searchController.active && searchController.searchBar.text != "" {
                    //TODO: change to "events"
                    controller.venueName = filteredVenues[indexPath.row].displayName!
                    controller.venueID = filteredVenues[indexPath.row].id!
                } else {
                    controller.venueName = venues[indexPath.row].displayName!
                    controller.venueID = venues[indexPath.row].id!
                }
                
            }
        
        }
        
    }

}
