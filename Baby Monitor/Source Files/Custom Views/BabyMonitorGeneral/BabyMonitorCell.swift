//
//  BabyMonitorCell.swift
//  Baby Monitor
//

import UIKit

class BabyMonitorCell: UITableViewCell, Identifiable, BabyMonitorCellProtocol {
    
    private enum Constants {
        static let mainWidthHeight: CGFloat = 36
        enum Alpha {
            static let separator: CGFloat = 0.3
            static let background: CGFloat = 0.2
        }
        enum FontSize {
            static let header: CGFloat = 16
            static let main: CGFloat = 11
            static let secondary: CGFloat = 8
        }
        enum Color {
            static let font = UIColor(rgb: 0x211E35)
        }
        enum Spacing {
            static let labels: CGFloat = 3
        }
        enum Height {
            static let separator: CGFloat = 1.0
        }
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        //TODO: remove color once assets are available, ticket: https://netguru.atlassian.net/browse/BM-65
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = Constants.mainWidthHeight / 2
        return imageView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.FontSize.main)
        label.textColor = Constants.Color.font
        return label
    }()
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.FontSize.secondary)
        label.textColor = Constants.Color.font
        return label
    }()
    
    private let additionalButton: UIButton = {
        let button = UIButton()
        //TODO: remove color once assets are available, ticket: https://netguru.atlassian.net/browse/BM-65
        button.backgroundColor = .blue
        button.layer.cornerRadius = Constants.mainWidthHeight / 2
        return button
    }()
    
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
        let stackView = UIStackView(arrangedSubviews: [photoImageView, labelsStackView, additionalButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()

    private lazy var separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.white.withAlphaComponent(Constants.Alpha.separator)
        return separator
    }()
    
    var type: BabyMonitorCellType = .activityLog {
        didSet {
            updateViews()
        }
    }
    
    var didTap: (() -> Void)?
    
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
    
    /// Updates main image
    func update(image: UIImage) {
        photoImageView.image = image
    }
    
    /// Updates selected state
    func showCheckmark(_ showing: Bool) {
        if showing {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
    
    /// Configures cell to look like a header
    func configureAsHeader() {
        [secondaryLabel, photoImageView, additionalButton].forEach {
            $0.isHidden = true
        }
        mainLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.header, weight: .bold)
        backgroundColor = .clear
    }
    
    // MARK: - Private functions
    private func setup() {
        selectionStyle = .none
        backgroundColor = UIColor.white.withAlphaComponent(Constants.Alpha.background)
        contentView.addSubview(mainStackView)
        contentView.addSubview(separatorView)
        
        photoImageView.addConstraints {
            [$0.equalConstant(.height, Constants.mainWidthHeight),
            $0.equalConstant(.width, Constants.mainWidthHeight)]
        }
        
        additionalButton.addConstraints {
            [$0.equalConstant(.height, Constants.mainWidthHeight),
            $0.equalConstant(.width, Constants.mainWidthHeight)]
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        addGestureRecognizer(tapRecognizer)
        
        mainStackView.addConstraints {
            [$0.equal(.top),
            $0.equal(.bottom),
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8)]
        }

        separatorView.addConstraints {
            [$0.equalConstant(.height, Constants.Height.separator),
             $0.equalTo(contentView, .leading, .leading),
             $0.equalTo(contentView, .trailing, .trailing),
             $0.equalTo(contentView, .bottom, .bottom)]
        }
    }
    
    @objc private func didTapCell() {
        didTap?()
    }
    
    private func updateViews() {
        [secondaryLabel, photoImageView, additionalButton].forEach {
            $0.isHidden = true
        }
        
        switch type {
        case .switchBaby(let switchBabyType):
            photoImageView.isHidden = false
            switch switchBabyType {
            case .baby:
                break
            case .addAnother:
                mainLabel.text = Localizable.SwitchBaby.addAnotherBaby
                photoImageView.backgroundColor = .blue
                photoImageView.image = #imageLiteral(resourceName: "add")
            }
        case .activityLog:
            [photoImageView, secondaryLabel].forEach {
                $0.isHidden = false
            }
        case .lullaby:
            additionalButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            [secondaryLabel, additionalButton].forEach {
                $0.isHidden = false
            }
        case .settings:
            additionalButton.isHidden = true
        }
    }
}
