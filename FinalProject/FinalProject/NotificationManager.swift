//
//  NotificationManager.swift
//  FinalProject
//
//  Created by Evelyn Lima on 7/13/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    //Singleton
    static let shared: NotificationManager = NotificationManager()
    
    private let center = UNUserNotificationCenter.current()
    private init() {}
    
    func requestAuthorization() {
        
        isAuthorized { [weak self] isAuthorized in
            
//            self?.center.getPendingNotificationRequests(completionHandler: { (requests) in
//                print(requests)
//            })
            
            if !isAuthorized {
                
                let options: UNAuthorizationOptions = [.alert, .sound];
                self?.center.requestAuthorization(options: options) { (granted, error) in
                    if !granted {
                        print("Something went wrong")
                    }
                }
            }
        }
    }
    
    func createNotification(for date: Date, billName: String, uuid: UUID) {
        
        //["None", "On the day", "1 day before", "2 days before", "1 week before"]
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder for Bill"
        content.body = "Your Bill \(billName) is close due"
        content.sound = UNNotificationSound.default
        
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        triggerDate.hour = 9
        triggerDate.minute = 0
        triggerDate.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: uuid.uuidString, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func editPendingNotification(for date: Date, billName: String, uuid: UUID) {
        
        // Delete Old One
        deleteNotification(for: uuid)
        
        // Create a New One with the updated stuff
        createNotification(for: date, billName: billName, uuid: uuid)
    }
    
    func deleteNotification(for uuid: UUID) {
        center.removePendingNotificationRequests(withIdentifiers: [uuid.uuidString])
    }
    
    
    private func isAuthorized(completionHandler: @escaping (Bool) -> Void) {
        center.getNotificationSettings { (settings) in
            completionHandler(settings.authorizationStatus == .authorized)
        }
    }
    
}
