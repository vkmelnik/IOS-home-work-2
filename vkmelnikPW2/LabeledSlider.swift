//
//  LabeledSlider.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 23.09.2021.
//

import UIKit

class LabeledSlider: UIView {
    
    private let slider = UISlider()
    private let label = UILabel()
    private var selector: Selector!
    private var actionObject: AnyObject!
    
    public var title : String {
        set(newTitle) {
            label.text = newTitle
        }
        get {
            return label.text!
        }
    }
    
    public var value : Float {
        set(newValue) {
            slider.value = newValue
        }
        get {
            return slider.value
        }
    }
    
    convenience init (frame: CGRect, title: String, object: AnyObject, action: Selector) {
        self.init(frame: frame)
        self.actionObject = object
        self.selector = action
        self.title = title
        setupSlider()
    }
    
    private func setupSlider() {
        self.addSubview(label)
        label.pinTop(to: self, 5)
        label.pinLeft(to: self)
        label.setWidth(to: 50)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(actionObject, action: selector, for: .valueChanged)
        self.addSubview(slider)
        slider.pinTop(to: self, 5)
        slider.setHeight(to: 20)
        slider.pinLeft(to: label.trailingAnchor, 10)
        slider.pinRight(to: self)
    }
}
