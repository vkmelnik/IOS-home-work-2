//
//  ViewController.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 21.09.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private var presenter: MainPresenter!
    
    public let setView = UIView()
    private let settingsView = UIStackView()
    public let locationTextView = UITextView()
    public let locationManager = CLLocationManager()
    public var locationToggle: LocationToggle!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        presenter = MainPresenter(view: self)
        
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
        
        settingsButton.addTarget(presenter, action: #selector(presenter.settingsButtonPressed),
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
        locationToggle = LocationToggle(frame: .null, object: presenter, action: #selector(presenter.locationToggleSwitched), isOn: false)
        settingsView.addArrangedSubview(locationToggle)
    }
    
    // Sliders
    public var sliders = [LabeledSlider(), LabeledSlider(), LabeledSlider()]
    private let colors = ["Red", "Green", "Blue"]
    private func setupSliders() {
        var top = 80
        for i in 0..<sliders.count {
            let labeledSlider = LabeledSlider(frame: .null, title: colors[i], object: presenter, action: #selector(presenter.sliderChangedValue))
            sliders[i] = labeledSlider
            settingsView.addArrangedSubview(labeledSlider)
            labeledSlider.setHeight(to: 30)
            
            top += 40
        }
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

