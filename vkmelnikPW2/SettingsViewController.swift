//
//  SettingsViewController.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 21.09.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    private var locationToggle: LocationToggle!
    private weak var mainView: ViewController!
    private let settingsView = UIStackView()
    
    convenience init(of: ViewController) {
        self.init(nibName: nil, bundle: nil)
        mainView = of
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSettingsView()
        setupLocationToggle()
        setupCloseButton()
        setupSliders()
    }
    
    private func setupSettingsView() {
        view.backgroundColor = .white
        
        view.addSubview(settingsView)
        settingsView.axis = .vertical
        settingsView.pinTop(to: view)
        settingsView.pinLeft(to: view)
        settingsView.pinRight(to: view)
    }
    
    private func setupLocationToggle() {
        
        locationToggle = LocationToggle(frame: .null, object: self, action: #selector(locationToggleSwitched), isOn: mainView.locationOn)
        settingsView.addArrangedSubview(locationToggle)
    }
    
    private var sliders = [LabeledSlider(), LabeledSlider(), LabeledSlider()]
    private let colors = ["Red", "Green", "Blue"]
    private func setupSliders() {
        var top = 80
        for i in 0..<sliders.count {
            let labeledSlider = LabeledSlider(frame: .null, title: colors[i], object: self, action: #selector(sliderChangedValue))
            sliders[i] = labeledSlider
            settingsView.addArrangedSubview(labeledSlider)
            labeledSlider.setHeight(to: 30)
            labeledSlider.value = mainView.sliders[i].value
            
            top += 40
        }
    }
    
    @objc
    func sliderChangedValue() {
        mainView.sliders[0].value = sliders[0].value
        mainView.sliders[1].value = sliders[1].value
        mainView.sliders[2].value = sliders[2].value
        mainView.sliderChangedValue()
    }
    
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        mainView.locationToggleSwitched(sender)
    }
    
    private func setupCloseButton() {
        let button = UIButton(type: .close)
        view.addSubview(button)
        button.pinRight(to: view, 10)
        button.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        button.setHeight(to: 30)
        button.pinWidth(to: button.heightAnchor)
        button.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }
    
    @objc
    private func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
}
