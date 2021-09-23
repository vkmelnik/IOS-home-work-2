//
//  ViewController.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 21.09.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let settingsView = UIView()
    private let locationTextView = UITextView()
    private let locationManager = CLLocationManager()
    private let locationToggle = UISwitch()
    public var locationOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLocationTextView()
        setupSettingsView()
        setupSettingsButton()
        setupSliders()
        setupLocationToggle()
        setupLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupSettingsButton() {
        let settingsButton = UIButton(type: .system)
        view.addSubview(settingsButton)
        settingsButton.setImage(
            UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        settingsButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 15)
        settingsButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 15)
        settingsButton.setHeight(to: 30)
        settingsButton.pinWidth(to: settingsButton.heightAnchor)
        
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed),
                                 for: .touchUpInside)
    }
    
    private func setupLocationManager() {
        let locationLabel = UILabel()
        settingsView.addSubview(locationLabel)
        locationLabel.text = "Location"
        locationLabel.pinTop(to: settingsView, 55)
        locationLabel.pinLeft(to: settingsView, 10)
        locationLabel.pinRight(to: settingsView, 10)
    }
    
    private func setupSettingsView() {
        view.addSubview(settingsView)
        settingsView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        settingsView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 10)
        settingsView.setHeight(to: 300)
        settingsView.setWidth(to: 200)
        
        settingsView.backgroundColor = .white
        settingsView.alpha = 0
    }

    private func setupLocationTextView() {
        view.addSubview(locationTextView)
        
        locationTextView.backgroundColor = .white
        locationTextView.layer.cornerRadius = 20

        locationTextView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 60)
        locationTextView.pinCenter(to: view.centerXAnchor)
        locationTextView.setHeight(to: 300)
        locationTextView.pinLeft(to: view, 15)

        locationTextView.isUserInteractionEnabled = false
    }
    
    private func setupLocationToggle() {
        settingsView.addSubview(locationToggle)
        locationToggle.pinTop(to: settingsView, 50)
        locationToggle.pinRight(to: settingsView, 10)

        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )
    }
    
    private var buttonCount = 0
    @objc
    private func settingsButtonPressed() {
        switch buttonCount {
        case 0, 1:
            UIView.animate(withDuration: 0.1, animations: {
                self.settingsView.alpha = 1 - self.settingsView.alpha
            })
        case 2:
            let view = SettingsViewController(of: self)
            self.present(view, animated: true, completion: nil)
            buttonCount = -1
        default:
            // Is never reached.
            buttonCount = -1
        }
        buttonCount += 1
    }
    
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        if sender.isOn {
            locationOn = true
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy =
                kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            } else {
                sender.setOn(false, animated: true)
            }
        } else {
            locationOn = false
            locationTextView.text = ""
            locationManager.stopUpdatingLocation()
        }
        toggleIfNeeded()
    }
    
    private func toggleIfNeeded() {
        if (locationOn) {
            locationToggle.isOn = true
        } else {
            locationToggle.isOn = false
        }
    }
    
    // Sliders
    private let sliders = [UISlider(), UISlider(), UISlider()]
    private let colors = ["Red", "Green", "Blue"]
    private func setupSliders() {
        var top = 80
        for i in 0..<sliders.count {
            let view = UIView()
            settingsView.addSubview(view)
            view.pinLeft(to: settingsView, 10)
            view.pinRight(to: settingsView, 10)
            view.pinTop(to: settingsView, CGFloat(top))
            view.setHeight(to: 30)
            
            top += 40
            
            let label = UILabel()
            view.addSubview(label)
            label.text = colors[i]
            label.pinTop(to: view, 5)
            label.pinLeft(to: view)
            label.setWidth(to: 50)
            
            let slider = sliders[i]
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.addTarget(self, action: #selector(sliderChangedValue), for: .valueChanged)
            view.addSubview(slider)
            slider.pinTop(to: view, 5)
            slider.setHeight(to: 20)
            slider.pinLeft(to: label.trailingAnchor, 10)
            slider.pinRight(to: view)
        }
    }
    
    @objc private func sliderChangedValue() {
        let red: CGFloat = CGFloat(sliders[0].value)
        let green: CGFloat = CGFloat(sliders[1].value)
        let blue: CGFloat = CGFloat(sliders[2].value)
        view.backgroundColor = UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 1
        )
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coord: CLLocationCoordinate2D =
                manager.location?.coordinate else { return }
        locationTextView.text = "Coordinates = \(coord.latitude) \(coord.longitude)"
    }
}
