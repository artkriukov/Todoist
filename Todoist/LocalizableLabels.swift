//
//  LocalizableLabels.swift
//  Todoist
//
//  Created by Artem Kriukov on 01.07.2025.
//

import Foundation

enum LocalizableLabels: String {
    case name = "name"
    case save = "save"
    case add = "add"
    case back = "back"
    case cancel = "cancel" 
    
    case profileKey = "profile_key"
    case changePhoto = "change_photo"
    case viewLogs = "view_logs"
    case systemLogs = "system_logs"
    
    case toDoList = "to_do_list"
    case overdue = "overdue"
    case title = "title"
    case note = "note"
    case date = "date"
    case time = "time"
    case newReminders = "new_reminders"
    
    func localize() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
