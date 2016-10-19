//
//  File.swift
//  ConcertChaser
//
//  Created by Vanessa Bell on 9/30/16.
//  Copyright © 2016 Vanessa Bell. All rights reserved.
//

//import Foundation
//
//
//spotifySearch = headlinerArtist!.encodeURIComponent()
//spotifyUrl = "https://api.spotify.com/v1/search?q=" + spotifySearch! + "&type=artist"
//
//Alamofire.request(.GET,spotifyUrl!).responseJSON { response in
//    
//    if let responseJSON = response.result.value {
//        let artists = responseJSON["artists"] as! NSDictionary
//        let items = artists["items"] as! NSArray
//        //TODO: guard against no headliner
//        
//        let firstArtist = items[0] as! NSDictionary
//        let external_urls = firstArtist["external_urls"] as! NSDictionary
//        let spotifyLink = external_urls["spotify"] as! String
//        // TODO: have to loop through performers
//        for performer in self.performers {
//            self.performanceDetails.text = spotifyLink + "\n\n"
//            self.performanceDetails.text = self.performanceDetails.text.stringByAppendingString("Hello")
//        }
//        
//        //+ String(self.performers[1]!)
//        self.performanceDetails.tintColor = UIColor.blueColor()
//    }
//    
//    
//}