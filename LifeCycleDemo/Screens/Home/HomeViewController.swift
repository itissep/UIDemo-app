import UIKit

class HomeViewController: UIViewController {

    enum Demos {
        case vcLifeCycle
        case viewVsLayer
        case frameVsBounds
        case gestures
        case hitTest

        var title: String {
            switch self {
            case .vcLifeCycle:
                "UIViewController"
            case .viewVsLayer:
                "UIView vs CALayer"
            case .frameVsBounds:
                "Frame vs Bounds"
            case .gestures:
                "UIGestureRecognizer"
            case .hitTest:
                "Hit-test"
            }
        }

        var button: UIButton {
            let button = UIButton()
            button.setTitle(self.title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            button.setTitleColor(.homeText, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false

            switch self {
            case .vcLifeCycle:
                button.addTarget(self, action: #selector(buttonVCTapped), for: .touchUpInside)
            case .viewVsLayer:
                button.addTarget(self, action: #selector(buttonLayerViewTapped), for: .touchUpInside)
            case .frameVsBounds:
                button.addTarget(self, action: #selector(buttonFrameBoundsTapped), for: .touchUpInside)
            case .gestures:
                button.addTarget(self, action: #selector(buttonGesturesTapped), for: .touchUpInside)
            case .hitTest:
                button.addTarget(self, action: #selector(buttonHitTestTapped), for: .touchUpInside)
            }
            return button
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .homeBg

        let stackView = UIStackView()

        stackView.frame = .init(origin: .init(x: 0, y: 300), size: .init(width: view.frame.width, height: view.frame.height - 600))
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing

        view.addSubview(stackView)

        stackView.addArrangedSubview(Demos.vcLifeCycle.button)
        stackView.addArrangedSubview(Demos.viewVsLayer.button)
        stackView.addArrangedSubview(Demos.frameVsBounds.button)
        stackView.addArrangedSubview(Demos.gestures.button)
        stackView.addArrangedSubview(Demos.hitTest.button)

    }

    @objc func buttonHitTestTapped() {
        navigationController?.pushViewController(HitTestDemoViewController(), animated: true)
    }

    @objc func buttonGesturesTapped() {
        navigationController?.pushViewController(GesturesDemoViewController(), animated: true)
    }

    @objc func buttonVCTapped() {
        navigationController?.pushViewController(VCLifecycleDemoViewController(), animated: true)
    }

    @objc func buttonLayerViewTapped() {
        navigationController?.pushViewController(LayerDemoViewController(), animated: true)
    }

    @objc func buttonFrameBoundsTapped() {
        navigationController?.pushViewController(FrameBoundsDemoViewController(), animated: true)
    }
}
