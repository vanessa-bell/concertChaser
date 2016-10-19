//
//  ConcertsViewController.swift
//
//  Created by Vanessa Bell on 9/28/16.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConcertsViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Properties
    let searchController = UISearchController(searchResultsController: nil)
    
    class SongkickEvent {
        var idNumber: Int?
        var type: String?
        var uri: NSURL?
        var displayName: String?
        var start: [NSDictionary]?
        var performance: [NSDictionary]?
        var headliner: String?
        var location: [NSDictionary]?
        var venue: [NSDictionary]?
        var status: String?
        var popularity: Int?
        
        required init(dict: NSDictionary) {
            self.idNumber = dict["id"]! as! Int
            self.displayName = dict["displayName"] as! String
            self.start = dict[EventFields.Start.rawValue]! as? [NSDictionary]
            self.performance = dict[EventFields.Performance.rawValue]! as? [NSDictionary]
            self.headliner = dict["performance"]![0]["artist"]!!["displayName"]!! as? String
            self.venue = dict[EventFields.Venue.rawValue]! as? [NSDictionary]
        }
    }
    var events = [SongkickEvent]()
    var filteredConcerts = [SongkickEvent]()
    var delegate: ConcertDetailsViewControllerDelegate?
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        tableView.tableFooterView?.hidden = true
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredConcerts = events.filter { event in
            return event.displayName!.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.tableFooterView?.hidden = true
        tableView.reloadData()
    }
    
    // MARK: Load View
    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        if searchController.active && searchController.searchBar.text != "" {
            tableView.tableFooterView?.hidden = true
        }
        
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

        let url = "https://api.songkick.com/api/3.0/metro_areas/26330/calendar.json?apikey=53sfqCvKDdsUawIy"
        
        Alamofire.request(.GET,url).responseJSON { response in
            // TODO: guard against no results
            let responseJSON = response.result.value!["resultsPage"]!!["results"]!!
            let results = responseJSON["event"]!! as! NSMutableArray

            for jsonEvent in results {
                    let dict = jsonEvent as! NSMutableDictionary
                    let concert = SongkickEvent(dict: dict)
                print("HEADLINER: ",concert.headliner)
                    self.events.append(concert)
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
            tableView.tableFooterView?.hidden = true
            return filteredConcerts.count
        }
        return self.events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConcertCell", forIndexPath: indexPath) as! ConcertCell
        if searchController.active && searchController.searchBar.text != "" {
            cell.textLabel?.text = self.filteredConcerts[indexPath.row].displayName!
        } else {
            cell.textLabel?.text = self.events[indexPath.row].displayName
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
    func concertDetailViewControllerDelegate(concertCell: ConcertCell) {
        if searchController.active && searchController.searchBar.text != "" {
            performSegueWithIdentifier("ShowDetails", sender: filteredConcerts[tableView.indexPathForCell(concertCell)!.row])
        } else {
            performSegueWithIdentifier("ShowDetails", sender: events[tableView.indexPathForCell(concertCell)!.row])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetails" {
            let controller = segue.destinationViewController as! ConcertDetailsViewController
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                if searchController.active && searchController.searchBar.text != "" {
                    //TODO: change to "events"
                    controller.concert = filteredConcerts[indexPath.row].displayName!
                    controller.concertID = filteredConcerts[indexPath.row].idNumber!
                    controller.headlinerArtist = filteredConcerts[indexPath.row].headliner!
                } else {
                    controller.concert = events[indexPath.row].displayName!
                    controller.concertID = events[indexPath.row].idNumber!
                    controller.headlinerArtist = events[indexPath.row].headliner!
                }
            }
            controller.delegate = delegate
        }
    }
}

