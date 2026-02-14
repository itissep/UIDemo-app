import UIKit

class VCLifecycleDemoViewController: UIViewController {

    private let label = UILabel()
    private let imageView = UIImageView()

    override func loadView() {
        super.loadView()

        print("1 | loadView() — view creation")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("2 | viewDidLoad() — setup UI")

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("3 | viewWillAppear() — appearing on screen")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("4 | viewDidAppear() — UI is ready")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("5 | viewWillDisappear() — leaving the screen")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        print("6 | viewDidDisappear() — screen was left behind")
    }

    private func setupUI() {
        view.backgroundColor = .vcBg

        label.text = "Keep an eye\non the logs!"
        label.textColor = .vcText
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0

        let image = UIImage(systemName: "eyes.inverse")
        imageView.image = image
        imageView.tintColor = .vcText

        view.addSubview(label)
        view.addSubview(imageView)

        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12)
        ])
    }
}
