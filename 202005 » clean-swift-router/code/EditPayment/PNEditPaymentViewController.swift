//
//  PNEditPaymentViewController.swift.swift
//  Payman
//
//  Created by tkuo on 2020/5/16.
//  Copyright (c) 2020 com.tykuo. All rights reserved.
//

import UIKit

protocol PNEditPaymentDisplayLogic: AnyObject {
    func displayPayment(viewModel: PNEditPayment.FetchPayment.ViewModel)
    func displayEditPayment(viewModel: PNEditPayment.EditPayment.ViewModel)
    func displayError(viewModel: PNEditPayment.ShowError.ViewModel)
}

class PNEditPaymentViewController: PNBaseViewController, PNEditPaymentDisplayLogic {
    private let nameTextField = UITextField.inputTextField()
    private let payerIdTextField = UITextField.inputTextField()
    private let costTextField = UITextField.inputTextField().then {
        $0.keyboardType = .numberPad
    }
    private let dateTimeTextField = UITextField.inputTextField().then {
        $0.isEnabled = false
        $0.textColor = .systemGray
    }

    var interactor: PNEditPaymentBusinessLogic?
    var router: (PNEditPaymentRoutingLogic & PNEditPaymentDataPassing)?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.BackgroundColor
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let request = PNEditPayment.FetchPayment.Request()
        interactor?.fetchPayment(request: request)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        router?.routeBackToRoom()
    }

    @objc func handleTextInputChange() {
        let readyToSubmit = nameTextField.text?.isEmpty == false
            && payerIdTextField.text?.isEmpty == false
            && costTextField.text?.isEmpty == false

        if readyToSubmit {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    @objc func handleDone() {
        guard let name = nameTextField.text,
            let payerId = payerIdTextField.text,
            let cost = costTextField.text else {
                return
        }

        let request = PNEditPayment.EditPayment.Request(name: name,
                                                        payerId: payerId,
                                                        cost: cost)
        interactor?.editPayment(request: request)
    }

    func displayPayment(viewModel: PNEditPayment.FetchPayment.ViewModel) {
        nameTextField.text = viewModel.name
        payerIdTextField.text = viewModel.payerId
        costTextField.text = viewModel.cost
        dateTimeTextField.text = viewModel.dateTime
    }

    func displayEditPayment(viewModel: PNEditPayment.EditPayment.ViewModel) {
        toast(viewModel.successMessage) { [navigationController = self.navigationController] in
            navigationController?.popViewController(animated: true)
        }
    }

    func displayError(viewModel: PNEditPayment.ShowError.ViewModel) {
        toast(viewModel.errorMessage)
    }
}

// MARK: - Private funcs.

private extension PNEditPaymentViewController {
    func setupViews() {
        [nameTextField, payerIdTextField, costTextField].forEach {
            $0.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        }

        view.directionalLayoutMargins = Constant.Margins

        let stackView = createStackView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
        }

        setupNavigationItems()
    }

    func setupNavigationItems() {
        title = Constant.NavigationItem.TitleText
        navigationItem.rightBarButtonItem = .init(title: Constant.NavigationItem.DoneText,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    func createStackView() -> UIStackView {
        let subViews = [
            nameTextField,
            payerIdTextField,
            costTextField,
            dateTimeTextField
        ]

        let stackView = UIStackView(arrangedSubviews: subViews).then {
            $0.axis = Constant.InputTextFields.Axis
            $0.spacing = Constant.Spacing.InputTextFields
        }

        return stackView
    }

    func setup() {
        let viewController = self
        let interactor = PNEditPaymentInteractor()
        let presenter = PNEditPaymentPresenter()
        let router = PNEditPaymentRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

// MARK: - Constant

extension PNEditPaymentViewController {
    private enum Constant {
        static let Margins = NSDirectionalEdgeInsets(top: 40, leading: 20, bottom: 60, trailing: 20)
        static let BackgroundColor: UIColor = .white

        enum NavigationItem {
            static let TitleText = "Edit Payment"
            static let DoneText = "Done"
        }

        enum InputTextFields {
            static let Axis: NSLayoutConstraint.Axis = .vertical
        }

        enum Spacing {
            static let InputTextFields: CGFloat = 10
        }
    }
}
