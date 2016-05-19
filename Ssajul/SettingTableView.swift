

import UIKit
import MapKit
import JGSettingsManager

/// SETTINGS STORAGE MODEL
/// user defined struct that contains the JGUserDefaults
struct LocationOptions {
    
    /// each JGUserDefault's type is defined based on the default value initially assigned
    
    let mapType = JGUserDefault (key: "mapTypeIndex", defaultValue: "standard") // String
    
    let zoomLevel = JGUserDefault (key: "zoomLevel", defaultValue: 10) // Int
    
    let displayLocationPin = JGUserDefault (key: "displayLocationPin", defaultValue: true) // Bool
    
    let displayPizzaLocations = JGUserDefault (key: "displayPizzaLocations", defaultValue: false) // Bool
    
    let userName = JGUserDefault (key: "userName", defaultValue: "") // String, empty to start
    
    let userGenderIndex = JGUserDefault (key: "userGenderIndex", defaultValue: 2) // Int
}


/// SETTINGS SECTIONS DISPLAY
/// Inherit JGSettingsTableController and implement SettingsSectionsData protocol
/// Load and return an array of Section data types to the controller's superclass
/// UserDefaults storage structure is instantiated and passed into settings cells
class SettingTableView: JGSettingsTableController, SettingsSectionsData {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableSections = loadSectionsConfiguration()
    }
    
    /// loads and returns the sections array
    /// used by JGSettingManager - TableController to build settings display
    internal func loadSectionsConfiguration() -> [Section] {
        
        let userDefaults = LocationOptions()
        
        let sections = [
            

            
            // switch table cell to store Bool type
            Section (
                header: "스피드설정",
                footer: "",
                settingsCells: [
                    SwitchTableCell (switchData: userDefaults.displayLocationPin, label: "본문/댓글 따로 가져오기"),
                    SwitchTableCell (switchData: userDefaults.displayPizzaLocations, label: "Display pizza locations")
                ],
                heightForHeader: 50.0,
                heightForFooter: 60.0
            ),
            
            // text table cell to store freeform String type
            Section (
                header: "블락",
                footer: "",
                settingsCells: [
                    TextTableCell(textData: userDefaults.userName, placeholder: "block_userid")
                ],
                heightForFooter: 10.0
            ),
            
            // using SegmentedControlTableCell with Int type for storage value
            Section (
                header: "Gender",
                footer: "",
                settingsCells: [
                    SegmentedControlTableCell (index: userDefaults.userGenderIndex, segments: ["male","female","other"])
                ],
                heightForFooter: 10.0
            )
        ]
        
        return sections
    }
    
}
