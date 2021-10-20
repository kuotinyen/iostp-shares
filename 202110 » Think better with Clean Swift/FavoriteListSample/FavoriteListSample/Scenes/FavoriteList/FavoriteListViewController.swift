//
//  FavoriteListViewController.swift
//  MultipleSelectionSample
//
//  Created by TK on 2021/10/19.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FavoriteListDisplayLogic: AnyObject {
    func displayData(viewModel: FavoriteList.FetchData.ViewModel)
}

class FavoriteListViewController: UIViewController, FavoriteListDisplayLogic {
    var interactor: FavoriteListBusinessLogic?
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.register(QuoteFavoriteCell.self, forCellReuseIdentifier: QuoteFavoriteCell.reusableIdentifier)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("完成", for: .normal)
        button.setBackgroundImage(.imageWithColor(tintColor: .systemBlue), for: .normal)
        button.setBackgroundImage(.imageWithColor(tintColor: .systemGray), for: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(tapConfirm), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.snp.makeConstraints { $0.height.equalTo(60) }
        return button
    }()
    
    private let equities: [Equity]
    private var quoteViewModels: [QuoteViewModel] = []
    private var canFavoriteAll: Bool = true {
        didSet {
            navigationItem.rightBarButtonItem?.title = canFavoriteAll ? "全選" : "取消全選"
        }
    }
    
    init(with equities: [Equity]) {
        self.equities = equities
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "選擇多隻股票"
        navigationItem.leftBarButtonItem = .init(title: "取消", style: .plain, target: self, action: #selector(tapCancel))
        navigationItem.rightBarButtonItem = .init(title: "全選", style: .plain, target: self, action: #selector(tapFavoriteAll))
        
        let stackView = UIStackView(arrangedSubviews: [tableView, makeFooterView()])
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchData(request: .init())
    }
    
    private func setup() {
        let viewController = self
        let interactor = FavoriteListInteractor(with: equities)
        let presenter = FavoriteListPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    @objc func tapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapFavoriteAll() {
        if canFavoriteAll {
            interactor?.favoriteAll(request: .init())
        } else {
            interactor?.unfavoriteAll(request: .init())
        }
    }
    
    @objc func tapConfirm() {
        // TODO: Impl....
        dismiss(animated: true, completion: nil)
    }
    
    func displayData(viewModel: FavoriteList.FetchData.ViewModel) {
        self.quoteViewModels = viewModel.quoteViewModels
        self.canFavoriteAll = viewModel.canFavoriteAll
        self.confirmButton.isEnabled = viewModel.canConfirm
        tableView.reloadData()
    }
    
    private func makeFooterView() -> UIView {
        let footerView = UIView()
        footerView.directionalLayoutMargins = .init(top: 8, leading: 20, bottom: 8, trailing: 20)
        footerView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { $0.edges.equalTo(footerView.layoutMarginsGuide) }
        return footerView
    }
}

// MARK: - DataSource

extension FavoriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        equities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuoteFavoriteCell.reusableIdentifier, for: indexPath)
        guard quoteViewModels.indices.contains(indexPath.row) else { return .init() }
        
        if let cell = cell as? QuoteFavoriteCell {
            cell.populate(with: quoteViewModels[indexPath.row])
        }
        return cell
    }
}

// MARK: - Delegate

extension FavoriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = FavoriteList.ToggleFavorite.Request(index: indexPath.row)
        interactor?.toggleFavorite(request: request)
    }
}
