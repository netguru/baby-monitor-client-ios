//
//  DescriptiveRoundedRectangleButton
//  Baby Monitor
//

import Foundation

final class DescriptiveRoundedRectangleButton: RoundedRectangleButton {
    
    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let customTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.customFont(withSize: .h3, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let customDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.customFont(withSize: .caption, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [customTitleLabel, customDetailLabel])
        stackView.isUserInteractionEnabled = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(title: String, description: String, image: UIImage) {
        super.init(title: title, backgroundColor: nil, borderColor: .white, borderWidth: 2.0)
        setTitle(nil, for: .normal)
        customTitleLabel.text = title
        customImageView.image = image
        customDetailLabel.text = description
        [customImageView, textStackView].forEach(addSubview)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let imageConstraintConstant: CGFloat = UIDevice.screenSizeBiggerThan4Inches ? 39 : 10
        let verticalMarginsConstraintConstant: CGFloat = UIDevice.screenSizeBiggerThan4Inches ? 17 : 7

        NSLayoutConstraint.activate([
            customImageView.widthAnchor.constraint(equalToConstant: 86),
            customImageView.heightAnchor.constraint(equalTo: customImageView.widthAnchor),
            customImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 39),
            customImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalMarginsConstraintConstant),
            customImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalMarginsConstraintConstant),
            textStackView.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: imageConstraintConstant),
            textStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            textStackView.centerYAnchor.constraint(equalTo: customImageView.centerYAnchor)])
    }
}
