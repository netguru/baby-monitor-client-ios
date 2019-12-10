//
//  AvailablePairingDevicesTableViewCell.swift
//  Baby Monitor
//

import UIKit

final class AvailablePairingDevicesTableViewCell: UITableViewCell, Identifiable {

    private let deviceImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "phone")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(withSize: .caption)
        label.textColor = .white
        return label
    }()

    private lazy var separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .babyMonitorSeparatorGray
        return separator
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable, message: "Use init(style:reuseIdentifier:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String) {
        titleLabel.text = title
    }

     private func setup() {
        backgroundColor = .none
        [deviceImageView, titleLabel, separatorView].forEach {
            addSubview($0)
        }
        deviceImageView.addConstraints {[
            $0.equalConstant(.height, 17),
            $0.equal(.centerY),
            $0.equal(.leading, constant: 21)
        ]
        }
        titleLabel.addConstraints {[
            $0.equal(.centerY),
            $0.equalTo(deviceImageView, .leading, .trailing, constant: 30)
        ]
        }
        separatorView.addConstraints {[
            $0.equalConstant(.height, 1.0),
            $0.equal(.centerX),
            $0.equal(.bottom),
            $0.equal(.leading, constant: 16)
        ]
        }
    }
}
