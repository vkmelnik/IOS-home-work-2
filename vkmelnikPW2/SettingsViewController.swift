//
//  SettingsViewController.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 21.09.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let locationToggle = UISwitch()
    private weak var mainView: ViewController!
    
    convenience init(of: ViewController) {
        self.init(nibName: nil, bundle: nil)
        mainView = of
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSettingsView()
        setupLocationToggle()
        setupLocationManager()
        setupCloseButton()
    }
    
    private func setupSettingsView() {
        view.backgroundColor = .white
    }
    
    private func setupLocationManager() {
        let locationLabel = UILabel()
        view.addSubview(locationLabel)
        locationLabel.text = "Location"
        locationLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 55)
        locationLabel.pinLeft(to: view, 10)
        locationLabel.pinRight(to: view, 10)
    }
    
    private func setupLocationToggle() {
        view.addSubview(locationToggle)
        if (mainView.locationOn) {
            locationToggle.isOn = true
        }
        
        locationToggle.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 50)
        locationToggle.pinRight(to: view, 10)
        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )
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
