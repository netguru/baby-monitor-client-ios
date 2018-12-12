//
//  ButtonView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class DashboardButtonView: UIView {
    
    fileprivate let button: UIButton = UIButton()
    enum Role {
        case liveCamera, talk, playLullaby
        
        var image: UIImage {
            switch self {
            case .liveCamera:
                return #imageLiteral(resourceName: "video")
            case .playLullaby:
                return #imageLiteral(resourceName: "lullabies")
            case .talk:
                return #imageLiteral(resourceName: "mic")
            }
        }
    }
    
    init(role: Role) {
        super.init(frame: .zero)
        setup(role: role)
    }
    
    @available(*, unavailable, message: "Use init(image:text:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private functions
    private func setup(role: Role) {
        button.setImage(role.image, for: .normal)
        addSubview(button)
        setupConstraints()
    }
    
    private func setupConstraints() {
        button.addConstraints {
            $0.equalEdges()
        }
    }
}

extension Reactive where Base: DashboardButtonView {
    
    var tap: ControlEvent<Void> {
        return base.button.rx.tap
    }
}
