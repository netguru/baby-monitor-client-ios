//
//  StreamVideoView.swift
//  Baby Monitor
//

import UIKit
import WebRTC

/// A view used to render RTC stream video.
internal final class StreamVideoView: UIView, RTCVideoRenderer {

    // MARK: Types

    /// Describes transform to be applied to the video.
    internal enum ContentTransform {

        /// No transform.
        case none

        /// Video should be flipped horizontally.
        case flippedHorizontally

        /// The actual `CGAffineTransform` representation of the transform.
        fileprivate var affineTransform: CGAffineTransform {
            switch self {
            case .none: return .identity
            case .flippedHorizontally: return .init(scaleX: -1, y: 1)
            }
        }

    }

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - contentTransform: Transform to be applied to the video.
    internal init(contentTransform: ContentTransform) {
        self.contentTransform = contentTransform
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    private let contentTransform: ContentTransform

    private lazy var renderView: RTCMTLVideoView = {
       let view = RTCMTLVideoView()
        view.videoContentMode = .scaleAspectFill
        return view
    }()

    // MARK: Setup

    private func setup() {

        // Since `renderView` is always bigger than `self`, it should be clipped
        // so that it doesn't overflow onto other UI elements.
        clipsToBounds = true

        addSubview(renderView)

        renderView.addConstraints {
            $0.equalEdges()
        }

        renderView.transform = contentTransform.affineTransform
    }

    // MARK: RTCVideoRenderer

    internal func setSize(_ size: CGSize) {
        renderView.setSize(size)
    }

    internal func renderFrame(_ frame: RTCVideoFrame?) {
        renderView.renderFrame(frame)
    }
    
}
