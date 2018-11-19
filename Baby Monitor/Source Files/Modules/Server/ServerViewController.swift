//
//  ServerViewController.swift
//  Baby Monitor
//

import UIKit
import RTSPServer

final class ServerViewController: BaseViewController {
    
    private let cameraView = UIView()
    private let viewModel: ServerViewModel
    
    init(viewModel: ServerViewModel) {
        self.viewModel = viewModel
        super.init()
        setup()
    }
    
    private func setup() {
        view.addSubview(cameraView)
        cameraView.addConstraints { $0.equalSafeAreaEdges() }
        viewModel.start(videoView: cameraView)
    }
}
