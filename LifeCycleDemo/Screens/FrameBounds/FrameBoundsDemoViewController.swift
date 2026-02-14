import UIKit


class FrameBoundsDemoViewController: UIViewController {
    let draggableView = UIView()
    let infoLabel = UILabel()

    var isBig: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPanGesture()
    }

    private func setupUI() {
        view.backgroundColor = .systemGray6

        draggableView.frame = CGRect(x: 50, y: view.center.y - 50, width: view.frame.width - 100, height: 100)
        draggableView.backgroundColor = .accent
        draggableView.layer.cornerRadius = 12
        view.addSubview(draggableView)

        // Информационные лейблы
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.textAlignment = .left
        infoLabel.frame = CGRect(x: 50, y: 200, width: view.bounds.width - 100, height: 60)
        view.addSubview(infoLabel)
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        draggableView.addGestureRecognizer(panGesture)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        draggableView.addGestureRecognizer(doubleTap)
    }

    private func updateInfoLabel() {
        infoLabel.text = """
        🟦 frame: \(draggableView.frame)
        📐 bounds: \(draggableView.bounds)
        """
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
//        draggableView.transform = CGAffineTransform(scaleX: isBig ? 0.5 : 1, y: isBig ? 0.5 : 1)
        if isBig {
            draggableView.bounds = CGRect(x: 50, y: 100, width: view.bounds.width - 100, height: 60)
        } else {
            draggableView.bounds = CGRect(x: 0, y: 0, width: view.bounds.width - 100, height: 60)
        }
        isBig.toggle()
        updateInfoLabel()
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .changed:
            draggableView.frame.origin = CGPoint(
                x: 50 + translation.x,
                y: self.view.center.y - 50 + translation.y
            )

            updateInfoLabel()

        case .ended:
            UIView.animate(withDuration: 0.5) {
                self.draggableView.frame.origin = CGPoint(x: 50, y: self.view.center.y - 50)
            } completion: { _ in
                self.updateInfoLabel()
            }

        default:
            break
        }
    }
}
