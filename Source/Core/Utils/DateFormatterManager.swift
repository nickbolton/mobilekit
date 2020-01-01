//
//  DateFormatterManager.swift
//  MobileKit
//
//  Created by Nick Bolton on 1/1/20.
//

import Foundation

public class DateFormatterManager {
  
  init() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(currentLocaleDidChangeNotification),
                                           name: NSLocale.currentLocaleDidChangeNotification,
                                           object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc private func currentLocaleDidChangeNotification() {
    abbreviatedDateFormatter = buildAbbreviatedDateFormatter()
  }
  
  /// DateFormatter with localized template: M/d/yyyy
  private (set) public lazy var abbreviatedDateFormatter: DateFormatter = buildAbbreviatedDateFormatter()
  private func buildAbbreviatedDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "M/d/yyyy", options: 0, locale: Locale.current)
    return formatter
  }
  
  /// DateFormatter with localized template: MMM d
  private (set) public lazy var abbreviatedMonthDayFormatter: DateFormatter = buildAbbreviatedMonthDayFormatter()
  private func buildAbbreviatedMonthDayFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMM d", options: 0, locale: Locale.current)
    return formatter
  }
  
  /// DateFormatter with localized template: yyyy
  private (set) public lazy var yearFormatter: DateFormatter = buildYearFormatter()
  private func buildYearFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale.current)
    return formatter
  }

  /// DateFormatter with localized template: M/d
  private (set) public lazy var numericalMonthDayFormatter: DateFormatter = buildNumericalMonthDayFormatter()
  private func buildNumericalMonthDayFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "M/d", options: 0, locale: Locale.current)
    return formatter
  }

  /// DateFormatter with localized template: E
  private (set) public lazy var alphaWeekdayFormatter: DateFormatter = buildAlphaWeekdayFormatter()
  private func buildAlphaWeekdayFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "E", options: 0, locale: Locale.current)
    return formatter
  }
}

private let AppContextDateFormatterManagerKey = "AppContextDateFormatterManager"

extension AppContext {
  public var dateFormatterManager: DateFormatterManager {
    if let manager = lookupItem(AppContextDateFormatterManagerKey) as? DateFormatterManager {
      return manager
    } else {
      let defaultManager = DateFormatterManager()
      register(dateFormatterManager: defaultManager)
      return defaultManager
    }
  }
  
  /**
   * Register a dateFormatterManager object and make it available to the rest of the app.
   */
  func register(dateFormatterManager: DateFormatterManager) {
    registerItem(dateFormatterManager, withKey: AppContextDateFormatterManagerKey)
  }
}
