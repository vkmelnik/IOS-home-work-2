//
//  MainRouter.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 23.09.2021.
//

import Foundation
import UIKit

class MainRouter {
    weak var presenter: MainPresenter!
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
    }
    
    public func pushSettingsView(view: ViewController) {
        view.navigationController?.pushViewController(SettingsViewController(of: view, presenter: presenter), animated: true)
    }
    
    public func presentSettingsView(view: ViewController) {
        view.present(SettingsViewController(of: view, presenter: presenter), animated: true, completion: nil)
    }
}
