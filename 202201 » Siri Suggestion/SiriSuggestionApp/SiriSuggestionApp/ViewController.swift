//
//  ViewController.swift
//  SiriSuggestionApp
//
//  Created by TK on 2022/1/10.
//

// # Siri Suggestion: -> NSUserActivity

// 1. Define userActivity
// Info.plist

// 2. Donate userActivity with (responder, binding)
// UIResponder.userActivity = <Open BusViewController UserActivity>

// 3. Handle userActivity
// AppDelegate / SceneDelegate #continueUserActivity(userActivity)
// userActivity.busName, busId ->
// Open BusViewController(busName, busId)

import UIKit
import Intents // for userActivity.suggestedInvocationPhrase
import CoreSpotlight // for CSSearchableItemAttributeSet
import MobileCoreServices // for kUTTypeItem

struct Bus {
    let title: String
    let startPoint: String
    let terminalPoint: String
    
    var userInfo: [AnyHashable: Any] {
        ["title": title,
         "startPoint": startPoint,
         "terminalPoint": terminalPoint]
    }
    
    init(title: String,
         startPoint: String,
         terminalPoint: String) {
        self.title = title
        self.startPoint = startPoint
        self.terminalPoint = terminalPoint
    }
    
    init(userInfo: [AnyHashable: Any]) {
        self.title = userInfo["title"] as? String ?? "-"
        self.startPoint = userInfo["startPoint"] as? String ?? "-"
        self.terminalPoint = userInfo["terminalPoint"] as? String ?? "-"
    }
}

extension Bus: CustomStringConvertible {
    var description: String { "[\(title)] \(startPoint) to \(terminalPoint)" }
}

class BusesViewController: UITableViewController {

    private var buses: [Bus] = [
        .init(title: "藍1", startPoint: "蘆洲總站", terminalPoint: "臺北車站(忠孝)"),
        .init(title: "202", startPoint: "及人中學", terminalPoint: "捷運國父紀念館站(忠孝)"),
        .init(title: "紅10", startPoint: "富洲里", terminalPoint: "捷運劍潭站(北藝中心)"),
        .init(title: "236", startPoint: "福安居", terminalPoint: "溫州街口"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "公車列表"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reusableIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        buses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reusableIdentifier, for: indexPath)
        cell.textLabel?.text = buses[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BusViewController()
        vc.bus = buses[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let deletedBus = buses[indexPath.row]
        self.buses.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        // Ref: https://developer.apple.com/documentation/sirikit/deleting_donated_shortcuts
        // Summary: Both CSSearchableIndex#deleteSearchableItems and NSUserActivity#deleteSavedUserActivities works!
  
        // When you delete a Spotlight item, the system deletes the related user activity and its donations.
        // Must use property `\.relatedUniqueIdentifier` for deletion.
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [deletedBus.title]) { error in
            print("#### error: \(error)")
            print("#### deleted \(deletedBus.title)")
        }
        
        // Use deleteSavedUserActivities(withPersistentIdentifiers:completionHandler:), passing in the list of persistent identifiers, to delete individual activities. This method also deletes user activities stored by Core Spotlight that have a matching persistent identifier.
        NSUserActivity.deleteSavedUserActivities(withPersistentIdentifiers: [deletedBus.title]) {
            print("#### deleted \(deletedBus.title)")
        }
    }
}


class BusViewController: UITableViewController {
    
    var bus: Bus?
    
    private var dataSource: [String] {
        guard let bus = bus else { return [] }
        return [bus.startPoint, bus.terminalPoint]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = bus?.title
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reusableIdentifier)
        
        let suggestionConfig = UserActivityWorker.SiriSuggestionConfig(activityType: UserActivityWorker.ActivityType.openBus.rawValue,
                                                                       title: "立刻查看 \(bus?.title ?? "未知公車") 的動態",
                                                                       persistentIdentifier: bus?.title,
                                                                       userInfo: bus?.userInfo,
                                                                       suggestedInvocationPhrase: "QBus",
                                                                       relatedUniqueIdentifier: bus?.title,
                                                                       contentDescription: "點選 Bus app 看更多")
        UserActivityWorker.shared.donateSiriSuggestion(config: suggestionConfig, responder: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reusableIdentifier, for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    private func donateUserActivityInRawWay() {
        let userActivity = NSUserActivity(activityType: "com.sirisruggestionapp.openbus")
        userActivity.userInfo = bus?.userInfo
        userActivity.persistentIdentifier = bus?.title
        userActivity.isEligibleForPrediction = true // 🔑
        userActivity.isEligibleForSearch = true
        userActivity.title = "立刻查看 \(bus?.title ?? "未知公車") 的動態"
        userActivity.suggestedInvocationPhrase = "QBus"
//        userActivity.requiredUserInfoKeys = ["title"] // ❗️ as filter
        
        // Search meta
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.relatedUniqueIdentifier = bus?.title // ❗️ not \.identifier
        attributes.contentDescription = "點選 Bus app 看更多"
//        attributes.thumbnailData = UIImage(named: "bus_icon")?.pngData()
        // 🐛 thumbnailData will not work in siri shortcut and siri suggestion
        
        userActivity.contentAttributeSet = attributes
        
        // manual call
//        userActivity.becomeCurrent()
//        userActivity.resignCurrent()
        self.userActivity = userActivity // 🔑
    }
}

// MARK: - Helper

protocol IdentifiableCell {
    static var reusableIdentifier: String { get }
}

extension IdentifiableCell {
    static var reusableIdentifier: String { String(describing: type(of: self)) }
}

extension UITableViewCell: IdentifiableCell { }

class UserActivityWorker {
    enum ActivityType: String, CaseIterable {
        case openBus = "com.sirisruggestionapp.openbus"
    }
    
    struct SiriSuggestionConfig {
        let activityType: String
        let title: String
        let persistentIdentifier: String?
        let userInfo: [AnyHashable: Any]?
        let isEligibleForPrediction: Bool
        let isEligibleForSearch: Bool
        let suggestedInvocationPhrase: String?
        let requiredUserInfoKeys: Set<String>?
        let relatedUniqueIdentifier: String?
        let contentDescription: String?
        
        init(activityType: String,
             title: String,
             persistentIdentifier: String? = nil,
             userInfo: [AnyHashable: Any]? = nil,
             isEligibleForPrediction: Bool = true,
             isEligibleForSearch: Bool = true,
             suggestedInvocationPhrase: String? = nil,
             requiredUserInfoKeys: Set<String>? = nil,
             relatedUniqueIdentifier: String? = nil,
             contentDescription: String? = nil) {
            self.activityType = activityType
            self.title = title
            self.persistentIdentifier = persistentIdentifier
            self.userInfo = userInfo
            self.isEligibleForPrediction = isEligibleForPrediction
            self.isEligibleForSearch = isEligibleForSearch
            self.suggestedInvocationPhrase = suggestedInvocationPhrase
            self.requiredUserInfoKeys = requiredUserInfoKeys
            self.relatedUniqueIdentifier = relatedUniqueIdentifier
            self.contentDescription = contentDescription
        }
    }
    
    static let shared = UserActivityWorker()
    private init() { }
    
    func canHandle(userActivity: NSUserActivity) -> Bool {
        ActivityType.allCases.map(\.rawValue).contains(userActivity.activityType)
    }
    
    func handle(userActivity: NSUserActivity, delegate: SceneDelegate?) {
        guard let activityType = ActivityType(rawValue: userActivity.activityType), let userInfo = userActivity.userInfo else { return }
        switch activityType {
        case .openBus:
            let vc = BusViewController()
            vc.bus = Bus(userInfo: userInfo)
            delegate?.nav?.pushViewController(vc, animated: true)
        }
    }
    
    func donateSiriSuggestion(config: SiriSuggestionConfig, responder: UIResponder) {
        let userActivity = NSUserActivity(activityType: config.activityType)
        userActivity.persistentIdentifier = config.persistentIdentifier
        userActivity.isEligibleForSearch = config.isEligibleForSearch
        userActivity.isEligibleForPrediction = config.isEligibleForPrediction
        userActivity.title = config.title
        userActivity.requiredUserInfoKeys = config.requiredUserInfoKeys
        userActivity.userInfo = config.userInfo
        userActivity.suggestedInvocationPhrase = config.suggestedInvocationPhrase

        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.title = config.title
        attributes.relatedUniqueIdentifier = config.persistentIdentifier
        attributes.contentDescription = config.contentDescription
        userActivity.contentAttributeSet = attributes
        responder.userActivity = userActivity
    }
    
    func deleteSiriSuggestionDonations(with identifiers: [String]) {
        NSUserActivity.deleteSavedUserActivities(withPersistentIdentifiers: identifiers) {
            print("#### \(identifiers) deleted.")
        }
    }
}
