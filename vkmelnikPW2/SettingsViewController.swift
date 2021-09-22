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
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 55
        ).isActive = true
        locationLabel.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 10
        ).isActive = true
        locationLabel.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -10
        ).isActive = true
    }
    
    private func setupLocationToggle() {
        view.addSubview(locationToggle)
        if (mainView.locationOn) {
            locationToggle.isOn = true
        }
        
        locationToggle.translatesAutoresizingMaskIntoConstraints = false
        locationToggle.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 50
        ).isActive = true
        locationToggle.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -10
        ).isActive = true
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -10
        ).isActive = true
        button.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 10
        ).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalTo:
        button.heightAnchor).isActive = true
        button.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }
    
    @objc
    private func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
}
