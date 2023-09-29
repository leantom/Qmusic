//
//  WEExtensions+TimerInterval.swift
//  FEMobile
//
//  Created by MrDatto on 6/24/21.
//
import UIKit

extension TimeInterval{
    func showFormatTimerCoundown() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        if let formattedDuration = formatter.string(from: self) {
            return formattedDuration
        }
        return nil
    }
    
    func showFormatTimerCoundownHours() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute ]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        if let formattedDuration = formatter.string(from: self) {
            return formattedDuration
        }
        return nil
    }
}
extension Date {
    func dateFormatter(partern: String) -> String {
        let datetimeFormat = DateFormatter()
        datetimeFormat.dateFormat = partern
        datetimeFormat.timeZone = TimeZone.current
        return datetimeFormat.string(from: self)
    }
}

extension String {
    
    
    func stringFormatter( partern: String) -> Date? {
        let datetimeFormat = DateFormatter()
        datetimeFormat.dateFormat = partern
        datetimeFormat.timeZone = TimeZone(secondsFromGMT: 0)
        datetimeFormat.locale = Locale(identifier: "en_US_POSIX")
        return datetimeFormat.date(from: self)
    }
    
    func stringFormatter() -> Date? {
        let datetimeFormat = DateFormatter()
        datetimeFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        datetimeFormat.timeZone = TimeZone(secondsFromGMT: 0)
        datetimeFormat.locale = Locale(identifier: "vi_VN")
        return datetimeFormat.date(from: self)
    }
    
    func dateToString(format: String, date: Date) -> String {
        let datetimeFormat = DateFormatter()
        datetimeFormat.dateFormat = format
        datetimeFormat.timeZone = TimeZone(secondsFromGMT: 0)
        datetimeFormat.locale = Locale(identifier: "vi_VN")
        return datetimeFormat.string(from: date)
    }
    
    
    func formatToDateRFC3339() -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let localDate = formatter.date(from: self)
        return localDate
    }
    
    func getDateFromStringRFC3339() -> Date {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let dateAt = RFC3339DateFormatter.date(from: self)!
        return dateAt
    }
    
    func getDateFromStringRFC3339() -> Date? {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let date = RFC3339DateFormatter.date(from: self)
        return date
    }
    
    
    func getDateFromUTCString() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = formatter.date(from: self)
        return localDate
    }
    
    func getDateFromDateFormat() -> Date? {
        let formats = DateFormat.allCases
        for format in formats {
            let date = self.stringFormatter(partern: format.rawValue)
            if date != nil {return date}
        }
        return nil
    }
    
    func convertDateToStringRFC3339(date: Date = Date()) -> String {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let dateAt = RFC3339DateFormatter.string(from: date)
        return dateAt
    }
    
    func convertStringDate(fromFM: String, toFM: String) -> String {
        let format = DateFormatter()
        format.dateFormat = fromFM
        
        let fromDate = format.date(from: self)
        
        format.dateFormat = toFM
        
        let toDateString = format.string(from: fromDate!)
        
        return toDateString
    }
}
enum DateFormat: String, CaseIterable{
    /** dd-MMM-yyyy */
    case dd_MMM_yyyy = "dd-MMM-yyyy"

    /**
    yyyy-MM-dd HH:mm:ssZ    */
    case date_sv_format = "yyyy-MM-dd HH:mm:ss"
    /**
    yyyy-MM-dd    */
    case date_sv_format2 = "yyyy-MM-dd"

    /**
     dd/MM/yyyy */
    case date_day_format = "dd/MM/yyyy"
    /**
     dd-MM-yyyy */
  //  case date_day_format = "dd-MM-yyyy"

   /** HH:mm dd/MM/yyyy */
    case date_time_format = "HH:mm dd/MM/yyyy"

    /** MM/yy */
     case MM_yy = "MM/yy"
    
    /** MM/yyyy */
     case MM_yyyy = "MM/yyyy"
    
    /** yyyy */
    case yyyy = "yyyy"

    /** dd-MM-yyyy HH:mm */
     case date_time_format2 = "dd-MM-yyyy HH:mm"
    
    /** dd-MM-yyyy HH:mm */
     case date_time_format3 = "dd/MM/yyyy HH:mm"

    /** yyyy-MM-dd'T'HH:mm:ssZ */
    case date_server_full = "yyyy-MM-dd'T'HH:mm:ssZ"
    /*esign */
    case date_server_esign = "yyyy-MM-dd'T'HH:mm:ss"
    case date_server_offer = "yyyy/MM/dd"
}
