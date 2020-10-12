//
//  ModelReport.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

struct Anchor {
    var top: NSLayoutYAxisAnchor
    var left: NSLayoutXAxisAnchor
    var right: NSLayoutXAxisAnchor?
    var width: NSLayoutDimension?
    init(_ top: NSLayoutYAxisAnchor, _ left: NSLayoutXAxisAnchor, _ right: NSLayoutXAxisAnchor?, _ width: NSLayoutDimension? = nil) {
        self.top = top
        self.left = left
        self.right = right
        self.width = width
    }
}

class Report {
    var leftReports: [LeftReport]
    var rightReport: RightReport?
    private var selectedReportId: Int?
    private var archive: Bool
    
    var selectedIndex: Int {
        get {
            return selectedReportId ?? -1
        }
        set {
            selectedReportId = newValue
            if let id = selectedReportId {
                self.rightReport = DB().getRightTBReports(id)
            }
        }
    }
    
    var isArchive: Bool {
        get {
            return archive
        }
        set {
            archive = newValue
            if archive {
                self.leftReports = DB().getListReports(true)
            } else {
                self.leftReports = DB().getListReports(false)
            }
            if count > 0 {
                selectedIndex = leftReports[0].id
            }
        }
    }
    
    var count: Int {
        get {
            return leftReports.count
        }
    }
    
    init() {
        self.leftReports = DB().getListReports(false)
        if leftReports.count > 0 {
            self.rightReport = DB().getRightTBReports(0)
            selectedReportId = 0
            let images = DB().getImagesForReport(0)
            rightReport?.image01 = images[0]
        }
        archive = false
    }
    
    func sendReport(_ newRightReport: RightReport?) {
        if let report = newRightReport {
            DB().updateReport(report)
            DB().sendReport(report.id)
        }
    }
    
    func updateReport(_ newRightReport: RightReport?) {
        if let report = newRightReport {
            DB().updateReport(report)
        }
    }
}

struct LeftReport {
    let id: Int
    let name: String
    let meetDay: String
}

struct RightReport {
    var id: Int
    var country: String
    var city: String
    var countPeople: Int
    var visitType: Int
    var data: String?
    var presentationName: String?
    var comment: String
    var image01: UIImage?
    var image02: UIImage?
    var image03: UIImage?
}

let reportVisitTypeEnglish = [ReportsWords.shared.hcpVisite, ReportsWords.shared.pharmacyVisit, ReportsWords.shared.roundTable, ReportsWords.shared.clinicaMeeting, ReportsWords.shared.others]

enum ImageMode {
    case open
    case canAdd
    case close
}

enum namesId: Int {
      case country = 0
      case city
      case numberOfPeople
      case typeOfEvent
      case comment
}
  
let names = [ReportsWords.shared.country,
             ReportsWords.shared.city,
             ReportsWords.shared.numberOfPeople,
             ReportsWords.shared.typeEvent,
             ReportsWords.shared.comment]
