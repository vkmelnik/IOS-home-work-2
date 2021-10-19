//
//  SettingsViewController.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 21.09.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    private weak var presenter: MainPresenter!
    private var locationToggle: LocationToggle!
    private weak var mainView: ViewController!
    private let settingsView = UIStackView()
    
    convenience init(of: ViewController, presenter: MainPresenter) {
        self.init(nibName: nil, bundle: nil)
        mainView = of
        self.presenter = presenter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        settingsView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        settingsView.pinLeft(to: view)
        settingsView.pinRight(to: view)
    }
    
    private func setupLocationToggle() {
        locationToggle = LocationToggle(frame: .null, object: presenter, action: #selector(presenter.locationToggleSwitched), isOn: presenter.locationOn)
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
    
    // TODO - update this method for VIPER.
    @objc
    func sliderChangedValue() {
        for i in 0...2 {
            mainView.sliders[i].value = sliders[i].value
        }
        presenter.sliderChangedValue()
    }
    
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        presenter.locationToggleSwitched(sender)
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
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
