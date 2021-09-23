//
//  MainPresenter.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 23.09.2021.
//

import Foundation
import UIKit
import AVFoundation
import CoreLocation

class MainPresenter {
    weak var view: ViewController!
    var interactor: MainInteractor!
    var router: MainRouter!
    public var locationOn = false
    
    public func pushSettingsView() {
        router.pushSettingsView(view: view)
    }
    
    public func presentSettingsView() {
        router.presentSettingsView(view: view)
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
    
    private var buttonCount = 0
    @objc
    public func settingsButtonPressed() {
        audioPlayer.play()
        switch buttonCount {
        case 0, 1:
            UIView.animate(withDuration: 0.1, animations: {
                self.view.setView.alpha = 1 - self.view.setView.alpha
            })
        case 2:
            pushSettingsView()
        default:
            presentSettingsView()
            buttonCount = -1
        }
        buttonCount += 1
    }
    
    @objc public func locationToggleSwitched(_ sender: UISwitch) {
        if sender.isOn {
            locationOn = true
            if CLLocationManager.locationServicesEnabled() {
                view.locationManager.delegate = view
                view.locationManager.desiredAccuracy =
                kCLLocationAccuracyNearestTenMeters
                view.locationManager.startUpdatingLocation()
            } else {
                sender.setOn(false, animated: true)
            }
        } else {
            locationOn = false
            view.locationTextView.text = ""
            view.locationManager.stopUpdatingLocation()
        }
        toggleIfNeeded()
    }
    
    @objc public func sliderChangedValue() {
        for i in 0...2 {
            interactor.setColor(index: i, value: view.sliders[i].value)
        }
        updateColors()
    }
    
    public func updateColors() {
        let red: CGFloat = CGFloat(interactor.getColor(index: 0))
        let green: CGFloat = CGFloat(interactor.getColor(index: 1))
        let blue: CGFloat = CGFloat(interactor.getColor(index: 2))
        view.view.backgroundColor = UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 1
        )
    }
    
    public func toggleIfNeeded() {
        if (locationOn) {
            view.locationToggle.isOn = true
        } else {
            view.locationToggle.isOn = false
        }
    }
    
    init(view: ViewController) {
        self.view = view
        interactor = MainInteractor(presenter: self)
        router = MainRouter(presenter: self)
        setupAudioPlayer()
    }
}

