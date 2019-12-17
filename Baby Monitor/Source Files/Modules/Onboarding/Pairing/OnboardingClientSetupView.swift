//
//  OnboardingClientSetupView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingClientSetupView: BaseOnboardingView {

    let backButtonItem = UIBarButtonItem(
       image: #imageLiteral(resourceName: "arrow_back"),
       style: .plain,
       target: nil,
       action: nil
    )

    let tableView: UITableView = {
      let tableView = UITableView(frame: .zero)
      tableView.register(AvailablePairingDevicesTableViewCell.self, forCellReuseIdentifier: AvailablePairingDevicesTableViewCell.identifier)
      tableView.separatorStyle = .none
      return tableView
    }()

    private let spinner = BaseSpinner()

    private lazy var separatorView: UIView = {
        let separator = UIView(frame: CGRect(width: self.frame.width, height: 1))
        separator.backgroundColor = .babyMonitorSeparatorGray
        return separator
    }()

    fileprivate let bottomButton = RoundedRectangleButton(title: Localizable.General.cancel, backgroundColor: .babyMonitorPurple)

    private lazy var tableFooterView: UIView = {
        let view = UIView()
        view.addSubview(spinner)
        return view
    }()

    private var currentTopOrCenterYSpinnerConstraint: NSLayoutConstraint?
    private var heightAndWidthConstraints: [NSLayoutConstraint] = []
    private let largeSpinnerHeight: CGFloat = 80
    private let smallSpinnerHeight: CGFloat = 32
    private var isInitialLoading = true

    override init() {
        super.init()
        setup()
    }

    func update(buttonTitle: String) {
        bottomButton.setTitle(buttonTitle, for: .normal)
    }

    func update(for state: PairingSearchState) {
        switch state {
        case .noneFound:
            bottomButton.isHidden = true
            tableView.tableFooterView?.isHidden = false
            guard !isInitialLoading else { return }
            animateSpinner(for: state)
        case .someFound:
            bottomButton.isHidden = false
            tableView.tableFooterView?.isHidden = false
            animateSpinner(for: state)
            isInitialLoading = false
        case .timeoutReached:
            tableView.tableFooterView?.isHidden = true
        }
    }

    private func animateSpinner(for state: PairingSearchState) {
        guard let constraint = currentTopOrCenterYSpinnerConstraint else { return }
        switch state {
        case .noneFound:
            [spinner, tableView, tableFooterView].forEach { $0.removeConstraints([constraint]) }
            currentTopOrCenterYSpinnerConstraint = spinner.addConstraints { [ $0.equalTo(tableView, .centerY, .centerY) ] }.first
            heightAndWidthConstraints.forEach { $0.constant = largeSpinnerHeight }
        case .someFound:
            [spinner, tableView].forEach { $0.removeConstraints([constraint]) }
            currentTopOrCenterYSpinnerConstraint = spinner.addConstraints { [ $0.equal(.top, constant: 12) ] }.first
            heightAndWidthConstraints.forEach { $0.constant = smallSpinnerHeight }
        case .timeoutReached:
            break
        }
        UIView.animate(withDuration: 0.6) {
            self.layoutIfNeeded()
        }
    }

    private func setup() {
        [tableView, bottomButton].forEach {
            addSubview($0)
        }
        setupBottomButton()
        setupTableView()
        setupSpinner()
    }

    private func setupSpinner() {
        spinner.startAnimating()
        currentTopOrCenterYSpinnerConstraint = spinner.addConstraints {[
            $0.equalTo(tableView, .centerY, .centerY),
            $0.equalTo(tableView, .centerX, .centerX)
        ]
        }.first
        heightAndWidthConstraints = spinner.addConstraints {[
            $0.equalConstant(.height, largeSpinnerHeight),
            $0.equalConstant(.width, largeSpinnerHeight)
        ]
        }
    }

    private func setupTableView() {
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        tableView.tableFooterView = tableFooterView
        tableView.tableHeaderView = separatorView
        tableView.addConstraints {[
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.equalTo(bottomButton, .bottom, .top, constant: -12)
        ]
        }
        guard let descriptionBottomAnchor = descriptionBottomAnchor else { return }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: descriptionBottomAnchor, constant: 24)
        ])
    }

    private func setupBottomButton() {
        bottomButton.addConstraints {[
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -32),
            $0.equalConstant(.height, 56),
            $0.equal(.centerX),
            $0.equal(.leading, constant: 24)
        ]
        }
    }
}

extension Reactive where Base: OnboardingClientSetupView {

    var backButtonTap: ControlEvent<Void> {
       return base.backButtonItem.rx.tap
   }

    var bottomButtonTap: ControlEvent<Void> {
        return base.bottomButton.rx.tap
    }
}
