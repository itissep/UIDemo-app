import UIKit

class LifecycleDemoViewController: UIViewController {
    let label = UILabel()

    override func loadView() {
        super.loadView()
        print("1 | loadView() — создаём view")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("2 | viewDidLoad() — НАСТРОЙКА UI")

        // Настраиваем UI
        view.backgroundColor = .systemBackground
        label.text = "🔄 Следи за логами!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("3 | viewWillAppear() — появление на экране")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("4 | viewDidAppear() — UI готово!")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("5 | viewWillDisappear() — покидаем экран")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("6 | viewDidDisappear() — экран скрыт")
    }
}
