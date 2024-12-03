//
//  CalendarEventManager.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 03.12.2024.
//
import UIKit
import EventKit

protocol CalendarEventManager {
    func create(eventModel: CalendarEventModel) -> Bool
}

struct CalendarEventModel: Encodable, Decodable {
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var note: String?
}

final class CalendarManager: CalendarEventManager {
    //MARK: - Variables
    private let eventStore : EKEventStore = EKEventStore()
    
    //MARK: - Private methods
    func create(eventModel: CalendarEventModel) -> Bool {
        var result: Bool = false
        let group = DispatchGroup()
        group.enter()
        
        create(eventModel: eventModel) { isCreated in
            result = isCreated
            group.leave()
        }
        
        group.wait()
        
        return result
    }
    
    //MARK: - Public methods
    func create(eventModel: CalendarEventModel, completion: ((Bool) -> Void)?) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted,
                                                                                     error) in
            guard granted, error == nil, let self else {
                completion?(false)
                return
            }
            
            let event: EKEvent = EKEvent(eventStore: self.eventStore)
            
            event.title = eventModel.title
            event.startDate = eventModel.startDate
            event.endDate = eventModel.endDate
            event.notes = eventModel.note
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            
            do {
                try self.eventStore.save(event, span: .thisEvent)
            } catch let error as NSError {
                print("failed to save event with error : \(error)")
                completion?(false)
            }
            
            completion?(true)
        }
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: createEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: createEvent)
        }
    }
}
