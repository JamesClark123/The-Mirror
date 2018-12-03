//
//  CalendarViewController.swift
//  The Mirror
//
//  Created by BC Swift Student Loan 1 on 12/3/18.
//  Copyright © 2018 BC Swift Student Loan 1. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    let gregorian = Calendar(identifier: .gregorian)
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.calendar.select(Date())
        
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        
        self.calendar.accessibilityIdentifier = "calendar"
        
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
     // MARK:- FSCalendarDataSource

//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return self.gregorian.isDateInToday(date) ? "今天" : nil
//    }
    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        guard self.lunar else {
//            return nil
//        }
//        return self.lunarFormatter.string(from: date)
//    }
    
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        return self.formatter.date(from: "2017/10/30")!
//    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let day: Int! = self.gregorian.component(.day, from: date)
//        return day % 5 == 0 ? day/5 : 0;
        return 2
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let day: Int! = self.gregorian.component(.day, from: date)
        return [13,24].contains(day) ? UIImage(named: "icon_cat") : nil
    }
    
    
    // MARK:- FSCalendarDelegate
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(self.formatter.string(from: date))")
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.calendarHeightConstraint.constant = bounds.height
//        self.view.layoutIfNeeded()
//    }
    
    
    // MARK:- Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let config = segue.destination as? CalendarConfigViewController {
//            config.lunar = self.lunar
//            config.theme = self.theme
//            config.selectedDate = self.calendar.selectedDate
//            config.firstWeekday = self.calendar.firstWeekday
//            config.scrollDirection = self.calendar.scrollDirection
//        }
//    }
//
//    @IBAction
//    func unwind2InterfaceBuilder(segue: UIStoryboardSegue) {
//        if let config = segue.source as? CalendarConfigViewController {
//            self.lunar = config.lunar
//            self.theme = config.theme
//            self.calendar.select(config.selectedDate, scrollToDate: false)
//            if self.calendar.firstWeekday != config.firstWeekday {
//                self.calendar.firstWeekday = config.firstWeekday
//            }
//            if self.calendar.scrollDirection != config.scrollDirection {
//                self.calendar.scrollDirection = config.scrollDirection
//            }
//        }
//    }

}
