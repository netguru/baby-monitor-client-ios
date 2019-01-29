//
//  ActivityLogCell.swift
//  Baby Monitor
//

import UIKit

class ActivityLogCell: UITableViewCell, Identifiable {
    
    private enum Constants {
        static let mainWidthHeight: CGFloat = 36
        enum Alpha {
            static let separator: CGFloat = 0.3
        }
        enum FontSize {
            static let header: CGFloat = 16
            static let main: CGFloat = 12
            static let secondary: CGFloat = 10
        }
        enum Color {
            static let mainFont = UIColor.white
            static let secondaryFont = UIColor.babyMonitorBrownGray
        }
        enum Spacing {
            static let labels: CGFloat = 2
        }
        enum Height {
            static let separator: CGFloat = 1.0
        }
    }
    
    private var stackViewLeadingAnchor: NSLayoutConstraint?
    private var separatorViewLeadingAnchor: NSLayoutConstraint?
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainLabel, secondaryLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = Constants.Spacing.labels
        stackView.alignment = .leading
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stackView
    }()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [informationImageView, labelsStackView])
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = .center
        stackView.spacing = 29
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(rgb: 0x363253)
        return separator
    }()
    private let informationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "information")
        return imageView
    }()
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.FontSize.main)
        label.textColor = Constants.Color.mainFont
        return label
    }()
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.FontSize.secondary)
        label.textColor = Constants.Color.secondaryFont
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal functions
    /// Updates main text
    func update(mainText: String) {
        mainLabel.text = mainText
    }
    
    /// Updates secondary text
    func update(secondaryText: String) {
        secondaryLabel.text = secondaryText
    }
    
    /// Configures cell to look like a header
    func configureAsHeader() {
        separatorViewLeadingAnchor?.constant = 0
        stackViewLeadingAnchor?.constant = 16
        [secondaryLabel, informationImageView].forEach {
            $0.isHidden = true
        }
        mainLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.header, weight: .bold)
        backgroundColor = .clear
    }
    
    // MARK: - Private functions
    private func setup() {
        selectionStyle = .none
        contentView.addSubview(mainStackView)
        contentView.addSubview(separatorView)
        backgroundColor = .clear
        stackViewLeadingAnchor = mainStackView.addConstraints {[
            $0.equal(.top),
            $0.equal(.bottom),
            $0.equal(.trailing),
            $0.equal(.leading, constant: 21)
        ]
        }.last
        separatorViewLeadingAnchor = separatorView.addConstraints {[
            $0.equalConstant(.height, Constants.Height.separator),
            $0.equalTo(contentView, .centerX, .centerX),
            $0.equalTo(contentView, .bottom, .bottom),
            $0.equalTo(contentView, .leading, .leading, constant: 16)
        ]
        }.last
    }
}
