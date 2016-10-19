//
//  Event.swift
//  ConcertChaser
//
//  Created by Vanessa Bell on 9/28/16.
//  Copyright © 2016 Vanessa Bell. All rights reserved.
//

import Foundation
import AlamofireSwiftyJSON
import Alamofire
import SwiftyJSON
//
//class SongkickEventWrapper {
//    var events: [SongkickEvent]?
//    var totalEntries: Int?
//    var page: Int?
//}
//
enum EventFields: String {
    case Type = "type"
    case URI = "uri"
    case DisplayName = "displayName"
    case Start = "start"
    case Performance = "performance"
    case Location = "location"
    case Venue = "venue"
    case Status = "status"
    case Popularity = "popularity"
}
//
//class SongkickEvent {
//    var idNumber: Int?
//    var type: String?
//    var uri: NSURL?
//    var displayName: String?
//    var start: [JSON]?
//    var performance: [JSON]?
//    var location: NSObject?
//    var venue: [JSON]?
//    var status: String?
//    var popularity: Int?
//    
//    required init(json: JSON, id: Int?) {
//        self.idNumber = id
//        self.uri = json[EventFields.URI.rawValue].URL
//        self.displayName = json[EventFields.DisplayName.rawValue].stringValue
//        self.start = json[EventFields.Start.rawValue].arrayValue
//        self.performance = json[EventFields.Performance.rawValue].arrayValue
//        self.venue = json[EventFields.Venue.rawValue].array
//    }
//    
//    class func endpointForEvent() -> String {
//        return "https://api.songkick.com/api/3.0/metro_areas/26330/calendar.json?apikey=53sfqCvKDdsUawIy"
//    }
//    private class func getEventAtPath(path: String, completionHandler: (SongkickEventWrapper?,NSError?) -> Void) {
//        let securePath = path.stringByReplacingOccurrencesOfString("http://", withString: "https://", options: .AnchoredSearch)
//        Alamofire.request(.GET, path)
//            .responseJSON { response in
//                completionHandler(response.result.value as? SongkickEventWrapper, response.result.error)
//        }
//    }
//    
//    class func getEvents(completionHandler: (SongkickEventWrapper?, NSError?) -> Void) {
//        getEventAtPath(SongkickEvent.endpointForEvent(), completionHandler: completionHandler)
//    }
//    
//    // TODO can get more pages from API
//    
//}
//
//extension Alamofire.Request {
//    func responseEventsArray(completionHandler: Response<SongkickEventWrapper, NSError> -> Void) -> Self {
//        let responseSerializer = ResponseSerializer<SongkickEventWrapper, NSError> {request, response, data, error in
//            guard error == nil else {
//                return .Failure(error!)
//            }
//            guard let responseData = data else {
//                let failureReason = "Array could not be serialized because input data was nil."
//                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
//                return .Failure(error)
//            }
//            
//            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
//            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
//            
//            switch result {
//            case .Success(let value):
//                let json = SwiftyJSON.JSON(value)
//                let wrapper = SongkickEventWrapper()
//                wrapper.page = json["page"].intValue
//                wrapper.totalEntries = json["totalEntries"].intValue
//                
//                var allEvents = [SongkickEvent]()
//                print(json)
//                let results = json["results"]
//                print(results)
//                for jsonEvent in results {
//                    print(jsonEvent.1)
//                    let event = SongkickEvent(json: jsonEvent.1, id: Int(jsonEvent.0))
//                    allEvents.append(event)
//                }
//                wrapper.events = allEvents
//                return .Success(wrapper)
//            case .Failure(let error):
//                return .Failure(error)
//            }
//    }
//        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
//}
//}