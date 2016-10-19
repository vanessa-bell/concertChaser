//
//  VenueCalendarViewController.swift
//  ConcertChaser
//
//  Created by Vanessa Bell on 9/29/16.
//  Copyright © 2016 Vanessa Bell. All rights reserved.
//

import UIKit
import Alamofire

class VenueCalendarViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Properties
    let searchController = UISearchController(searchResultsController: nil)
    var venueName: String?
    var venueID: Int?
    var delegate: VenueCalendarViewControllerDelegate?
    var venueEvents = [VenueEvent]()
    var filteredVenueEvents = [VenueEvent]()
    
    class VenueEvent {
        var id: Int?
        var displayName: String?
        var headliner: String?
        
        required init(dict: NSDictionary) {
            self.displayName = dict["displayName"] as? String
            self.id = dict["id"]! as? Int
            self.headliner = dict["performance"]![0]["artist"]!!["displayName"]!! as? String
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredVenueEvents = venueEvents.filter { event in
            return event.displayName!.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let url = "https://api.songkick.com/api/3.0/venues/" + String(venueID!) + "/calendar.json?apikey=53sfqCvKDdsUawIy"
        
        
        Alamofire.request(.GET,url).responseJSON { response in
            print(response.result.value)
            if let responseJSON = response.result.value {
                let resultsPage = responseJSON["resultsPage"]!!
                if resultsPage["results"] != nil {
                    let results = resultsPage["results"]
           
                    if let events = results!!["event"] as? NSMutableArray {
            
                    for jsonEvent in events {
                        let dict = jsonEvent as! NSMutableDictionary
                        let event = VenueEvent(dict: dict)
                        self.venueEvents.append(event)
                }
                    }
                }
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredVenueEvents.count
        } else {
        return venueEvents.count
        }
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VenueEvent", forIndexPath: indexPath) as! ConcertCell

        if searchController.active && searchController.searchBar.text != "" {
            cell.textLabel?.text = String(self.filteredVenueEvents[indexPath.row].displayName!)
        } else {
            cell.textLabel?.text = self.venueEvents[indexPath.row].displayName
        }

        return cell
    }


    // MARK: - Navigation
    func concertDetailViewControllerDelegate(concertCell: ConcertCell) {
        if searchController.active && searchController.searchBar.text != "" {
            performSegueWithIdentifier("ShowConcertDetails", sender: filteredVenueEvents[tableView.indexPathForCell(concertCell)!.row])
        } else {
            performSegueWithIdentifier("ShowConcertDetails", sender: venueEvents[tableView.indexPathForCell(concertCell)!.row])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowConcertDetails" {
            let controller = segue.destinationViewController as! ConcertDetailsViewController
            if let indexPath = tableView.indexPathForCell(sender as! ConcertCell) {
                if searchController.active && searchController.searchBar.text != "" {
                    //TODO: change to "events"
                    controller.concert = filteredVenueEvents[indexPath.row].displayName!
                    controller.concertID = filteredVenueEvents[indexPath.row].id!
                    controller.headlinerArtist = filteredVenueEvents[indexPath.row].headliner!
                    
                } else {
                    controller.concert = venueEvents[indexPath.row].displayName!
                    controller.concertID = venueEvents[indexPath.row].id!
                    controller.headlinerArtist = venueEvents[indexPath.row].headliner!
                }
            }
        }
    }



}
