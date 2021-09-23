//
//  ViewController.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 21.09.2021.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController {
    private let setView = UIView()
    private let settingsView = UIStackView()
    private let locationTextView = UITextView()
    private let locationManager = CLLocationManager()
    private var locationToggle: LocationToggle!
    public var locationOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupAudioPlayer()
        setupLocationTextView()
        setupSettingsView()
        setupSettingsButton()
        setupLocationToggle()
        setupSliders()
        
        locationManager.requestWhenInUseAuthorization()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var audioPlayer = AVAudioPlayer()
    private func setupAudioPlayer() {
        let sound = Bundle.main.path(forResource: "EmergencyMeeting", ofType: "mp3")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print(error)
        }
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
    
    private func setupSettingsView() {
        setView.backgroundColor = .systemGray4
        setView.alpha = 0
        setView.layer.cornerRadius = 10
        view.addSubview(setView)
        setView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        setView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 10)
        setView.setHeight(to: 300)
        setView.pinWidth(to: setView.heightAnchor, 2/3)
        
        setView.addSubview(settingsView)
        settingsView.axis = .vertical
        settingsView.pinTop(to: setView)
        settingsView.pinLeft(to: setView)
        settingsView.pinRight(to: setView)
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
        locationToggle = LocationToggle(frame: .null, object: self, action: #selector(locationToggleSwitched), isOn: false)
        settingsView.addArrangedSubview(locationToggle)
    }
    
    private var buttonCount = 0
    @objc
    private func settingsButtonPressed() {
        audioPlayer.play()
        switch buttonCount {
        case 0, 1:
            UIView.animate(withDuration: 0.1, animations: {
                self.setView.alpha = 1 - self.setView.alpha
            })
        case 2:
            self.navigationController?.pushViewController(SettingsViewController(of: self), animated: true)
        default:
            self.present(SettingsViewController(of: self), animated: true, completion: nil)
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
    public var sliders = [LabeledSlider(), LabeledSlider(), LabeledSlider()]
    private let colors = ["Red", "Green", "Blue"]
    private func setupSliders() {
        var top = 80
        for i in 0..<sliders.count {
            let labeledSlider = LabeledSlider(frame: .null, title: colors[i], object: self, action: #selector(sliderChangedValue))
            sliders[i] = labeledSlider
            settingsView.addArrangedSubview(labeledSlider)
            labeledSlider.setHeight(to: 30)
            
            top += 40
        }
    }
    
    @objc public func sliderChangedValue() {
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
