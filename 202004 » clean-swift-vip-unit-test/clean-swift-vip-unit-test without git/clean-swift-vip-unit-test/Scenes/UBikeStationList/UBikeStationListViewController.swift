//
//  UBikeStationListViewController.swift
//  clean-swift-vip-unit-test
//
//  Created by tkuo on 2020/4/15.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import UIKit
import SnapKit
import Then

protocol UBikeStationListDisplayLogic: AnyObject {
    func displayStations(viewModel: ShowUBikeStationList.ShowStations.ViewModel)
    func displayError(viewModel: ShowUBikeStationList.ShowError.ViewModel)
}

class UBikeStationListViewController: UIViewController, UBikeStationListDisplayLogic {
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .white
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        $0.dataSource = self
    }

    var interactor: UBikeStationListBusinessLogic?
    var presenter: UBikeStationListPresentationLogic?
    var stationViewModels: [ShowUBikeStationList.UBikeStationViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupTableView()
        fetchUBikeStations()
    }

    func fetchUBikeStations() {
        interactor?.fetchUBikeStation(request: .init(area: .taipei))
    }

    func displayStations(viewModel: ShowUBikeStationList.ShowStations.ViewModel) {
        self.stationViewModels = viewModel.stationViewModels
        tableView.reloadData()
    }

    func displayError(viewModel: ShowUBikeStationList.ShowError.ViewModel) {
        let retryAction = UIAlertAction(title: viewModel.retryTitle, style: .default) { (action) in
            self.fetchUBikeStations()
        }
        let cancelAction = UIAlertAction(title: viewModel.cancelTitle, style: .destructive, handler: nil)

        let alert = UIAlertController.init(title: nil, message: viewModel.text, preferredStyle: .alert)
        alert.addAction(retryAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Private Helpers

extension UBikeStationListViewController {
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }

    private func setup() {
        let viewController = self
        let interactor = UBikeStationListInteractor()
        let presenter = UBikeStationListPresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        self.interactor = interactor
        self.presenter = presenter
    }
}

// MARK: - UITableViewDataSource

extension UBikeStationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = stationViewModels[indexPath.row].title
        return cell
    }
}
