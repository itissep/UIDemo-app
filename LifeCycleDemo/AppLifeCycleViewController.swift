import UIKit

final class AppLifeCycleViewController: UIViewController {
    enum State {
        case active
        case inactive
        case background
        case disconnected

        var textColor: UIColor {
            switch self {
            case .active:
                UIColor.alcGreenText
            case .inactive:
                UIColor.alcYellowText
            case .background:
                UIColor.alcBlueText
            case .disconnected:
                UIColor.alcGrayText
            }
        }

        var bgColor: UIColor {
            switch self {
            case .active:
                UIColor.alcGreen
            case .inactive:
                UIColor.alcYellow
            case .background:
                UIColor.alcBlue
            case .disconnected:
                UIColor.alcGray
            }
        }
    }

    private lazy var label = UILabel()
    private lazy var button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        label.text = "Application\nLife Cycle"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center

        button.setTitle("Go to demos", for: .normal)
        button.addTarget(self, action: #selector(openDemos), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)

        view.addSubview(label)
        view.addSubview(button)

        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12)
        ])
    }

    @objc
    private func openDemos() {
        navigationController?.pushViewController(HomeViewController(), animated: true)
    }

    func updated(with state: State) {
        view.backgroundColor = state.bgColor
        button.setTitleColor(state.textColor.withAlphaComponent(0.6), for: .normal)
        label.textColor = state.textColor
    }
}
