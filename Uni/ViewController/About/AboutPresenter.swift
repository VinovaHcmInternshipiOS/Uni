//
//  AboutPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 30/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import Foundation

// MARK: View -
protocol AboutViewProtocol: class {

}

// MARK: Presenter -
protocol AboutPresenterProtocol: class {
	var view: AboutViewProtocol? { get set }
    func viewDidLoad()
}

class AboutPresenter: AboutPresenterProtocol {

    weak var view: AboutViewProtocol?

    func viewDidLoad() {

    }
}