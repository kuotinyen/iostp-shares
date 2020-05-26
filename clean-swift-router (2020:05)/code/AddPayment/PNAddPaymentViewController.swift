//
//  PNAddPaymentViewController.swift
//  Payman
//
//  Created by tkuo on 2020/5/7.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import UIKit

protocol PNAddPaymentDisplayLogic: AnyObject {
    func displayAddPayment(viewModel: PNAddPayment.AddPayment.ViewModel)
    func displayError(viewModel: PNAddPayment.ShowError.ViewModel)
}

class PNAddPaymentViewController: PNBaseViewController, PNAddPaymentDisplayLogic {
    private let nameTextField = UITextField.inputTextField(placeholder: Constant.Inputs.EventNamePlaceholder)
    private let payerIdTextField = UITextField.inputTextField(placeholder: Constant.Inputs.PayerIdPlaceholder)
    private let costTextField = UITextField.inputTextField(placeholder: Constant.Inputs.CostPlaceholder).then {
        $0.keyboardType = .numberPad
    }

    var interactor: PNAddPaymentBusinessLogic?
    var router: (PNAddPaymentRoutingLogic & PNAddPaymentDataPassing)?
    weak var roomViewController: UIViewController?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func insertPushNotification(info: [String: Any]) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavigationItems()
        setupViews()
    }

    @objc func handleClose() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleDone() {
        guard let name = nameTextField.text,
            let payerId = payerIdTextField.text,
            let costText = costTextField.text,
            let cost = Int(costText) else {
            toast("Empty fields.")
            return
        }

        let request = PNAddPayment.AddPayment.Request(name: name,
                                                      payerId: payerId,
                                                      cost: cost)
        interactor?.addPayment(request: request)
    }

    func displayAddPayment(viewModel: PNAddPayment.AddPayment.ViewModel) {
        toast(viewModel.successMessage) { [拐子 = router] in
            拐子?.routeBackToRoom()
        }
    }

    func displayError(viewModel: PNAddPayment.ShowError.ViewModel) {
        toast(viewModel.errorMessage)
    }
}

// MARK: - Private helper

extension PNAddPaymentViewController {
    private func setup() {
        let viewController = self
        let interactor = PNAddPaymentInteractor()
        let presenter = PNAddPaymentPresenter()
        let router = PNAddPaymentRouter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }

    private func setupViews() {
        [nameTextField, payerIdTextField, costTextField].forEach {
            $0.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        }

        view.directionalLayoutMargins = Constant.Margins

        let stackView = createStackView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
    }

    private func createStackView() -> UIStackView {
        let subViews = [
            nameTextField,
            payerIdTextField,
            costTextField
        ]

        let stackView = UIStackView(arrangedSubviews: subViews).then {
            $0.axis = Constant.InputTextFields.Axis
            $0.spacing = Constant.Spacing.InputTextFields
        }

        return stackView
    }

    private func setupNavigationItems() {
        navigationItem.title = Constant.NavigationItem.TitleText
        navigationItem.leftBarButtonItem = .init(title: Constant.NavigationItem.CloseText,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(handleClose))
        navigationItem.rightBarButtonItem = .init(title: Constant.NavigationItem.DoneText,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
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
}

// MARK: - Constant

extension PNAddPaymentViewController {
    private enum Constant {
        static let Margins = NSDirectionalEdgeInsets(top: 40, leading: 20, bottom: 60, trailing: 20)
        static let AutoDismissDelay: TimeInterval = 3

        enum NavigationItem {
            static let TitleText = "Add Payment"
            static let CloseText = "Close"
            static let DoneText = "Done"
        }

        enum InputTextFields {
            static let Axis: NSLayoutConstraint.Axis = .vertical
        }

        enum Spacing {
            static let InputTextFields: CGFloat = 10
        }

        enum Inputs {
            static let EventNamePlaceholder = "Event Name"
            static let PayerIdPlaceholder = "Payer ID"
            static let CostPlaceholder = "Cost"
        }
    }
}
