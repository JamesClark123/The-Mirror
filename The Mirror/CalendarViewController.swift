//
//  CalendarViewController.swift
//  The Mirror
//
//  Created by BC Swift Student Loan 1 on 12/3/18.
//  Copyright © 2018 BC Swift Student Loan 1. All rights reserved.
//

import UIKit
import FSCalendar
import Charts

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var pieChart: PieChartView!
    
    let blueColor = UIColor(red: CGFloat(81.0/255), green: CGFloat(157.0/255), blue: CGFloat(148.0/255), alpha: 1.0)
    let redColor = UIColor(red: CGFloat(172.0/255), green: CGFloat(62.0/255), blue: CGFloat(22.0/255), alpha: 1.0)
    let armyGreenColor = UIColor(red: CGFloat(70.0/255), green: CGFloat(51.0/255), blue: CGFloat(20/255), alpha: CGFloat(1.0))
    
    var todaysValues = [Double]()
    var happy = PieChartDataEntry(value: 0)
    var sad = PieChartDataEntry(value: 0)
    var pieChartEntries = [PieChartDataEntry] ()
    
    var user: MirrorUser!
    
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
        
        calendar.delegate = self
        calendar.dataSource = self
        
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        
        self.calendar.appearance.eventDefaultColor = UIColor(red: CGFloat(70.0/255), green: CGFloat(51.0/255), blue: CGFloat(20/255), alpha: CGFloat(1.0))
        
        self.calendar.accessibilityIdentifier = "calendar"
        
        
        if let tv = user.happySadDictionary[formatter.string(from: Date())] {
            todaysValues = tv
            happy.value = tv[0]
            sad.value = tv[1]
        }
        
        happy.label = "Happy"
        sad.label = "Sad"
        pieChart.entryLabelColor = armyGreenColor
        pieChart.entryLabelFont = UIFont(name: "Cormorant-Bold", size: CGFloat(12.0))
        pieChartEntries = [happy, sad]
        pieChart.holeColor = pieChart.backgroundColor
        updatePieChart()
    }
    
    func updatePieChart() {
        let chartDataSet = PieChartDataSet(values: pieChartEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [blueColor, redColor   ]
        chartDataSet.colors = colors
        chartDataSet.valueFont = UIFont(name: "Cormorant-Regular", size: CGFloat(12.0)) ?? UIFont.systemFont(ofSize: CGFloat(12.0))
        
        
        pieChart.entryLabelFont = UIFont(name: "Cormorant-Regular", size: CGFloat(12.0))
        chartData.setValueFont(UIFont(name: "Cormorant-Regular", size: CGFloat(12.0)) ?? UIFont.systemFont(ofSize: CGFloat(12.0)))
        pieChart.accessibilityElementsHidden = true
        
        
        pieChart.data = chartData
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
//        return Date()
//    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let day: Int! = self.gregorian.component(.day, from: date)
//        return day % 5 == 0 ? day/5 : 0;
        if let _ = user.happySadDictionary[formatter.string(from: date)] {
            return 1
        } else {
            return 0
        }
//        return 2
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
        
        if let tv = user.happySadDictionary[formatter.string(from: date)] {
            print("Values found: \(tv[0]) and \(tv[1])")
            happy.value = tv[0]
            sad.value = tv[1]
            updatePieChart()
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
