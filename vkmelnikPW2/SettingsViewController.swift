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
    
    convenience init(of: ViewController) {
        self.init(nibName: nil, bundle: nil)
        mainView = of
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSettingsView()
        setupLocationToggle()
        setupCloseButton()
    }
    
    private func setupSettingsView() {
        view.backgroundColor = .white
    }
    
    private func setupLocationToggle() {
        
        locationToggle = LocationToggle(frame: .null, object: self, action: #selector(locationToggleSwitched), isOn: mainView.locationOn)
        view.addSubview(locationToggle)
        locationToggle.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 50)
        locationToggle.pinRight(to: view)
        locationToggle.pinLeft(to: view)
        locationToggle.setHeight(to: 50)
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
