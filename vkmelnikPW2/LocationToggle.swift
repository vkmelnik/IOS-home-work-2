//
//  LocationToggle.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 23.09.2021.
//

import UIKit

class LocationToggle : UIView {
    
    private var selector: Selector!
    private var actionObject: AnyObject!
    private let locationToggle = UISwitch()
    
    public var isOn: Bool {
        set(newValue) {
            locationToggle.isOn = newValue
        }
        get {
            return locationToggle.isOn
        }
    }
    
    convenience init (frame: CGRect, object: AnyObject, action: Selector, isOn: Bool) {
        self.init(frame: frame)
        self.actionObject = object
        self.selector = action
        locationToggle.isOn = isOn
        
        setupLocationToggle()
    }
    
    private func setupLocationToggle() {
        let locationLabel = UILabel()
        self.addSubview(locationLabel)
        locationLabel.text = "Location"
        locationLabel.pinTop(to: self, 5)
        locationLabel.pinLeft(to: self, 10)
        locationLabel.pinRight(to: self, 10)
        
        self.addSubview(locationToggle)
        locationToggle.pinTop(to: locationLabel.bottomAnchor)
        locationToggle.pinLeft(to: self, 10)
        locationToggle.addTarget(
            actionObject,
            action: selector,
            for: .valueChanged
        )
        
        self.setHeight(to: 60)
    }
}
