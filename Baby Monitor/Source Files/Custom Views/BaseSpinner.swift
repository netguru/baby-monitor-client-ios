//
//  BaseSpinner.swift
//  Baby Monitor
//

import UIKit

protocol Spinner {
    func startAnimating()
    func stopAnimating()
}

final class BaseSpinner: UIView, Spinner {

    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "onboarding-oval")
        view.contentMode = .scaleAspectFit
        return view
       }()

    private let loadingIndicator = UIActivityIndicatorView()

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        [backgroundImageView, loadingIndicator].forEach {
            addSubview($0)
            $0.addConstraints {
                $0.equalEdges()
            }
        }
    }

    func startAnimating() {
        loadingIndicator.style = .gray
        loadingIndicator.startAnimating()
    }

    func stopAnimating() {
        loadingIndicator.stopAnimating()
    }
}
