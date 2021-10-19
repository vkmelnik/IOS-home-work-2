//
//  MainInteractor.swift
//  vkmelnikPW2
//
//  Created by Vsevolod Melnik on 23.09.2021.
//

import Foundation

class MainInteractor {
    weak var presenter: MainPresenter!
    var settings = Settings()
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
    }
    
    public func getColor(index: Int) -> Float {
        return settings.colors[index]
    }
    
    public func setColor(index: Int, value: Float) {
        settings.colors[index] = value
    }
}
