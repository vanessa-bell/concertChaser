//
//  ConcertDetailsViewController.swift
//  ConcertChaser
//
//  Created by Vanessa Bell on 9/28/16.
//  Copyright © 2016 Vanessa Bell. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ConcertDetailsViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var performanceDetails: UITextView!
    @IBOutlet weak var favoriteButton: DOFavoriteButton!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    @IBAction func buyTicketsButtonPressed(sender: UIButton) {
        if let url = NSURL(string: uri) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            print("button pressed")
            sender.deselect()
        } else {
            // select with animation
            sender.imageColorOn = UIColor.redColor()
            print("button pressed")
            sender.select()
            let entity = NSEntityDescription.entityForName("Favorite",inManagedObjectContext: managedObjectContext)
            let newFavorite = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            newFavorite.setValue(concert!, forKey: "displayName")
            newFavorite.setValue(concertID!, forKey: "concertID")
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }

        }
    }
    
    
    // MARK: Properties
    var concert: String?
    var concertID: Int?
    var currentEvent: NSMutableArray?
    var url = String()
    var spotifySearch: String?
    var spotifyUrl: String?
    var headlinerArtist: String?
    var performers: [String?] = []
    var uri = String()
    var thumbnail = String()
    weak var delegate: ConcertDetailsViewControllerDelegate?
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        return true
    }
    override func viewDidLoad() {
        favoriteButton.addTarget(self, action: #selector(ConcertDetailsViewController.tapped(_:)), forControlEvents: .TouchUpInside)
        
        displayName.text = concert
        performanceDetails.tintColor = UIColor.blueColor()
        
        super.viewDidLoad()
        
        if concertID != nil {
            url = "https://api.songkick.com/api/3.0/events/" + String(concertID!) + ".json?apikey=53sfqCvKDdsUawIy"
        }
        else {
            print("concertID is nil")
        }
        Alamofire.request(.GET,url).responseJSON { response in
            let responseJSON = response.result.value!["resultsPage"]!!["results"]
            let event = responseJSON!!["event"] as! NSDictionary
            print("event info",event)
            let performance = event["performance"] as! NSArray
            self.uri = event["uri"] as! String
            for item in performance {
                var performer = item["artist"]!!["displayName"]!! as! String
                self.performers.append(performer)
                self.spotifySearch = performer.encodeURIComponent()
                self.spotifyUrl = "https://api.spotify.com/v1/search?q=" + self.spotifySearch! + "&type=artist"
                
                Alamofire.request(.GET,self.spotifyUrl!).responseJSON { response in
                    
                    if let responseJSON = response.result.value {
                        let artists = responseJSON["artists"] as! NSDictionary
                        let items = artists["items"] as! NSArray
                        //TODO: guard against no headliner
                        
                        let firstArtist = items[0] as! NSDictionary
                        let images = firstArtist["images"] as! NSArray
                        print(firstArtist["images"] as! NSArray)
                        if images.count > 0 {
                            var thumbnailInfo = images[images.count-1] as! NSDictionary
//                            self.thumbnail = thumbnailInfo["url"]! as! String
//                            if let url = NSURL(string: self.thumbnail){
//                                print(url)
////                                if let data = NSData(contentsOfURL: url) {
////                                    self.artistImage.image = UIImage(data: data)
////                                }
//                            }
                            
                        }
                        let external_urls = firstArtist["external_urls"] as! NSDictionary
                        let spotifyLink = external_urls["spotify"] as! String
                        
                        self.performanceDetails.text = self.performanceDetails.text.stringByAppendingString(performer + ": " + spotifyLink + "\n\n")
                    }
                    
                }

            }
        }
        
        }
    
    override func viewWillAppear(animated: Bool) {
        
            print(self.performers)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    
    func encodeURIComponent() -> String? {
        var characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-_.!~*'()")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
}
