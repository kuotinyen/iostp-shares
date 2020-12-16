//
//  PNShowRoomViewController.swift
//  Payman
//
//  Created by tkuo on 2020/5/3.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import UIKit

protocol PNShowRoomDisplayLogic: AnyObject {
    func displayPayments(viewModel: PNShowRoom.ShowPayments.ViewModel)
    func displayError(viewModel: PNShowRoom.ShowError.ViewModel)
    func displayAddPayment(viewModel: PNShowRoom.AddPayment.ViewModel)
    func displayRemovePayment(viewModel: PNShowRoom.RemovePayment.ViewModel)
    func displayDutchPayments(viewModel: PNShowRoom.DutchPayments.ViewModel)
}

class PNShowRoomViewController: PNBaseViewController, PNShowRoomDisplayLogic {
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero).then {
            $0.register(PNPaymentCell.self, forCellReuseIdentifier: PNPaymentCell.reusableIdentifier)
            $0.register(PNPaymentDutchHeader.self, forHeaderFooterViewReuseIdentifier: PNPaymentDutchHeader.reusableIdentifier)
            $0.dataSource = self
            $0.delegate = self 
        }
        return tv
    }()

    private let loadingViewController = LoadingViewController()

    var interactor: PNShowRoomInteractor?
    var router: PNShowRoomRouter?

    var dutchPaymentTitle: String = "loading..."
    var dutchPaymentHeaderHeight: CGFloat = PNPaymentDutchHeader.height
    var paymentViewModels: [PaymentViewModel] = [] {
        didSet {
            if paymentViewModels.isEmpty {
                dutchPaymentHeaderHeight = 0
            } else {
                dutchPaymentHeaderHeight = PNPaymentDutchHeader.height
            }
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()

        fetchRoom()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let request = PNShowRoom.RefreshRoom.Request()
        interactor?.refreshRoom(request: request)
    }

    @objc func handleAddPayment() {
        router?.routeToAddPayment()
    }

    func displayPayments(viewModel: PNShowRoom.ShowPayments.ViewModel) {
        paymentViewModels = viewModel.paymentViewModels
        dutchPaymentTitle = viewModel.dutchPaymentTitle

        if !viewModel.shouldDisplayDutchHeader {
            dutchPaymentHeaderHeight = 0
        }

        tableView.reloadData()
        loadingViewController.remove()
    }

    func displayError(viewModel: PNShowRoom.ShowError.ViewModel) {
        toast(viewModel.errorMessage)
    }

    func displayAddPayment(viewModel: PNShowRoom.AddPayment.ViewModel) {
        paymentViewModels.insert(viewModel.paymentViewModel, at: 0)
        tableView.reloadData()
    }

    func displayRemovePayment(viewModel: PNShowRoom.RemovePayment.ViewModel) {
        paymentViewModels.remove(at: viewModel.removeIndex)
        toast(viewModel.successMessage)
        tableView.reloadData()

        let request = PNShowRoom.RefreshRoom.Request()
        interactor?.refreshRoom(request: request)
    }

    func displayDutchPayments(viewModel: PNShowRoom.DutchPayments.ViewModel) {
        paymentViewModels.removeAll()
        toast(viewModel.successMessage)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension PNShowRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PNPaymentCell.reusableIdentifier, for: indexPath)

        if let cell = cell as? PNPaymentCell {
            let viewModel = paymentViewModels[indexPath.row]
            cell.populateCell(with: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dutchPaymentHeaderHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PNPaymentDutchHeader.reusableIdentifier)

        if let header = header as? PNPaymentDutchHeader {
            header.populateHeader(with: dutchPaymentTitle)
            header.tapDutchClosure = { [weak self] in
                self?.handleDutch()
            }
        }

        return header
    }
}

// MARK: - UITableViewDelegate

extension PNShowRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let request = PNShowRoom.RemovePayment.Request(selectedIndex: indexPath.row)
        interactor?.removePayment(request: request)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = PNShowRoom.SelectPayment.Request(selectedIndex: indexPath.row)
        interactor?.selectPayment(request: request)
        router?.routeToEditPayment()
    }
}

// MARK: - Private helpers

private extension PNShowRoomViewController {
    func handleDutch() {
        let ok = UIAlertAction(title: "Yes, I want to dutch all bills.", style: UIAlertAction.Style.default) { [weak self] action in
            let request = PNShowRoom.DutchPayments.Request()
            self?.interactor?.dutchPayments(request: request)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let alert = UIAlertController(title: nil, message: "\(dutchPaymentTitle), Wanna dutch now?", preferredStyle: .actionSheet)
        alert.addAction(ok)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    func fetchRoom() {
        add(loadingViewController)
        let request = PNShowRoom.FetchRoom.Request()
        interactor?.fetchRoom(request: request)
    }

    func setup() {
        let viewController = self
        let interactor = PNShowRoomInteractor()
        let presenter = PNShowRoomPresenter()
        let router = PNShowRoomRouter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }

    func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let addPaymentButton = UIButton(type: .system).then {
            $0.backgroundColor = Constant.Color.AddPaymentIconBackground
            $0.setImage(Constant.AddPaymentButton.Icon.withRenderingMode(.alwaysOriginal),
                        for: .normal)
            $0.imageEdgeInsets = Constant.AddPaymentButton.ImageEdgeInsets
            $0.layer.cornerRadius = Constant.AddPaymentButton.CornerRadius
            $0.clipsToBounds = Constant.AddPaymentButton.ClipsToBounds
            $0.addTarget(self, action: #selector(handleAddPayment), for: .touchUpInside)
            $0.snp.makeConstraints { (make) in
                make.size.equalTo(Constant.AddPaymentButton.Size)
            }
        }

        view.addSubview(addPaymentButton)
        addPaymentButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
                .inset(Constant.Spacing.AddPaymentIconToTrailingEdge)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(Constant.Spacing.AddPaymentIconToBottomEdge)
        }
    }
}

// MARK: - Constant

extension PNShowRoomViewController {
    private enum Constant {
        enum Spacing {
            static let AddPaymentIconToTrailingEdge = 15
            static let AddPaymentIconToBottomEdge = 20
        }

        enum Color {
            static let AddPaymentIconBackground = UIColor(hex: 0x4d8fff)
        }

        enum AddPaymentButton {
            static let Icon = #imageLiteral(resourceName: "add")
            static let Size = CGSize(width: 60, height: 60)
            static let ImageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            static let CornerRadius: CGFloat = 30
            static let ClipsToBounds = true
        }

        enum Text {
            static let AddPaymentMessage = "Add Payment"
            static let AddAction = "Add"
            static let CancelAction = "Cancel"
        }
    }
}
