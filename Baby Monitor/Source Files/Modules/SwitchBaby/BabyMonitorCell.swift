//
//  BabyMonitorCell.swift
//  Baby Monitor
//


import UIKit

class BabyMonitorCell: UITableViewCell, Identifiable {
    
    enum `Type` {
        case switchBaby(SwitchBabyType)
        case lullaby
        case activityLog
    }
    
    enum SwitchBabyType {
        case baby
        case addAnother
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //TODO: remove color once assets are available, ticket: https://netguru.atlassian.net/browse/BM-65
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let mainLabel = UILabel()
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(5)
        return label
    }()
    
    private let additionalButton: UIButton = {
        let button = UIButton()
        //TODO: remove color once assets are available, ticket: https://netguru.atlassian.net/browse/BM-65
        button.backgroundColor = .green
        return button
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainLabel, secondaryLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
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
    
    var type: Type = .activityLog {
        didSet {
            updateViews()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Internal functions
    
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
    
    //MARK: - Private functions
    private func setup() {
        selectionStyle = .none
        contentView.addSubview(mainStackView)
        
        photoImageView.addConstraints {[
            $0.equalConstant(.height, 40),
            $0.equalConstant(.width, 40)
        ]}
        
        additionalButton.addConstraints {[
            $0.equalConstant(.height, 40),
            $0.equalConstant(.width, 40)
        ]}
        
        mainStackView.addConstraints {[
            $0.equal(.top),
            $0.equal(.bottom),
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8)
        ]}
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
            }
        case .activityLog:
            [photoImageView, secondaryLabel].forEach {
                $0.isHidden = false
            }
        case .lullaby:
            [secondaryLabel, additionalButton].forEach {
                $0.isHidden = false
            }
        }
    }
}
