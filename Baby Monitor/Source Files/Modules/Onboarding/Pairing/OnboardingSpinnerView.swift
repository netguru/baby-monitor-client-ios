//
//  OnboardingSpinnerView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingSpinnerView: BaseOnboardingView {

    private let spinner = UIActivityIndicatorView()

    let tableView: UITableView = {
           let tableView = UITableView(frame: .zero)
           tableView.register(AvailablePairingDevicesTableViewCell.self, forCellReuseIdentifier: AvailablePairingDevicesTableViewCell.identifier)
           tableView.separatorStyle = .none
           return tableView
       }()

    fileprivate let cancelButton = RoundedRectangleButton(title: Localizable.General.cancel,
                                                          backgroundColor: .clear,
                                                          borderColor: .babyMonitorPurple,
                                                          borderWidth: 2.0)

    override init() {
        super.init()
        setup()
    }

    func stopLoading() {
        spinner.stopAnimating()
        imageView.isHidden = true
        spinner.isHidden = true
    }
    private func setup() {
        [spinner, tableView].forEach {
            addSubview($0)
        }
        setupSpinner()
        setupTableView()
        addCancelButton()
    }

    private func setupSpinner() {
        spinner.style = .gray
        spinner.startAnimating()
        spinner.addConstraints {[
            $0.equal(.centerX)
        ]
        }
        guard let imageCenterYAnchor = imageCenterYAnchor else {
            return
        }
        spinner.centerYAnchor.constraint(equalTo: imageCenterYAnchor).isActive = true
    }

    private func setupTableView() {
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        tableView.addConstraints {[
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.equal(.bottom)
        ]
        }
        guard let descriptionBottomAnchor = descriptionBottomAnchor else { return }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: descriptionBottomAnchor, constant: 24)
        ])
    }

    private func addCancelButton() {
        addSubview(cancelButton)
        cancelButton.addConstraints {[
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -32),
            $0.equalConstant(.height, 56),
            $0.equal(.centerX),
            $0.equal(.leading, constant: 24)
        ]
        }
    }
}

extension Reactive where Base: OnboardingSpinnerView {

    var cancelTap: ControlEvent<Void> {
        return base.cancelButton.rx.tap
    }
}
