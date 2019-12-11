//
//  OnboardingSpinnerView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingSpinnerView: BaseOnboardingView {

    let tableView: UITableView = {
              let tableView = UITableView(frame: .zero)
              tableView.register(AvailablePairingDevicesTableViewCell.self, forCellReuseIdentifier: AvailablePairingDevicesTableViewCell.identifier)
              tableView.separatorStyle = .none
              return tableView
          }()

    private let spinner = BaseSpinner()

    fileprivate let bottomButton = RoundedRectangleButton(title: Localizable.General.cancel,
                                                          backgroundColor: .clear,
                                                          borderColor: .babyMonitorPurple,
                                                          borderWidth: 2.0)

    private lazy var tableFooterView: UIView = {
        let view = UIView()
        let spinner = BaseSpinner()
        view.addSubview(spinner)
        spinner.addConstraints {[
            $0.equal(.top, constant: 12),
            $0.equal(.centerX),
            $0.equalConstant(.height, 32),
            $0.equalConstant(.width, 32)
        ]
        }
        spinner.startAnimating()
        return view
    }()

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
            spinner.isHidden = false
            tableView.isHidden = true
            spinner.startAnimating()
        case .someFound:
            spinner.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func setup() {
        [spinner, tableView, bottomButton].forEach {
            addSubview($0)
        }
        setupSpinner()
        setupCancelButton()
        setupTableView()
    }

    private func setupSpinner() {
        spinner.startAnimating()
        spinner.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY),
            $0.equalConstant(.height, 80),
            $0.equalConstant(.width, 80)
        ]
        }
        guard let descriptionBottomAnchor = descriptionBottomAnchor else {
            return
        }
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: descriptionBottomAnchor, constant: 24)
        ])
    }

    private func setupTableView() {
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        tableView.tableFooterView = tableFooterView
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

    private func setupCancelButton() {
        bottomButton.addConstraints {[
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -32),
            $0.equalConstant(.height, 56),
            $0.equal(.centerX),
            $0.equal(.leading, constant: 24)
        ]
        }
    }
}

extension Reactive where Base: OnboardingSpinnerView {

    var bottomButtonTap: ControlEvent<Void> {
        return base.bottomButton.rx.tap
    }
}
