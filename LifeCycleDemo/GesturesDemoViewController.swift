import UIKit

final class GesturesDemoViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stack = UIStackView()

    private var feedbackLabels: [String: UILabel] = [:]
    private var panCenterX: NSLayoutConstraint?
    private var panCenterY: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Жесты"
        view.backgroundColor = .systemGray6
        setupScrollView()
        addDemos()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),
        ])
    }

    private func section(title: String, demoView: UIView, key: String) -> UIView {
        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(label)

        demoView.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(demoView)

        let res = UILabel()
        res.text = "—"
        res.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        res.numberOfLines = 2
        res.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(res)
        feedbackLabels[key] = res

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: wrap.topAnchor),
            label.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: wrap.trailingAnchor),
            demoView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            demoView.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            demoView.trailingAnchor.constraint(equalTo: wrap.trailingAnchor),
            demoView.heightAnchor.constraint(equalToConstant: 88),
            res.topAnchor.constraint(equalTo: demoView.bottomAnchor, constant: 6),
            res.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            res.trailingAnchor.constraint(equalTo: wrap.trailingAnchor),
            res.bottomAnchor.constraint(equalTo: wrap.bottomAnchor),
        ])
        return wrap
    }

    private func card() -> UIView {
        let v = UIView()
        v.backgroundColor = .secondarySystemBackground
        v.layer.cornerRadius = 12
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.separator.cgColor
        return v
    }

    private func show(_ text: String, key: String) {
        feedbackLabels[key]?.text = text
    }

    private func addDemos() {

        // MARK: GestureRecognizers creation


        // 1. Tap (один или несколько тапов)
        let tapView = card()

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapSingle(_:)))
        tapView.addGestureRecognizer(singleTap)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(tapDouble(_:)))
        doubleTap.numberOfTapsRequired = 2
        tapView.addGestureRecognizer(doubleTap)


        singleTap.require(toFail: doubleTap)
        let tapWrap = section(title: "UITapGestureRecognizer — тап(ы)", demoView: tapView, key: "tap")
        addTapHint(to: tapView)
        stack.addArrangedSubview(tapWrap)

        // 2. Pan (перетаскивание)
        let panContainer = UIView()
        panContainer.backgroundColor = .secondarySystemBackground
        panContainer.layer.cornerRadius = 12
        panContainer.layer.borderWidth = 1
        panContainer.layer.borderColor = UIColor.separator.cgColor
        let panThumb = UIView()
        panThumb.backgroundColor = .systemBlue
        panThumb.layer.cornerRadius = 8
        panThumb.translatesAutoresizingMaskIntoConstraints = false
        panContainer.addSubview(panThumb)
        let cx = panThumb.centerXAnchor.constraint(equalTo: panContainer.centerXAnchor)
        let cy = panThumb.centerYAnchor.constraint(equalTo: panContainer.centerYAnchor)
        panCenterX = cx
        panCenterY = cy
        NSLayoutConstraint.activate([
            panThumb.widthAnchor.constraint(equalToConstant: 56),
            panThumb.heightAnchor.constraint(equalToConstant: 56),
            cx, cy,
        ])



        let panGes = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        panThumb.addGestureRecognizer(panGes)
        let panWrap = section(title: "UIPanGestureRecognizer — перетаскивание", demoView: panContainer, key: "pan")
        addHint("Перетащи синий квадрат", to: panContainer)
        stack.addArrangedSubview(panWrap)

        // 4. Pinch (масштабирование)
        let pinchView = card()
        let pinchGes = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        pinchView.addGestureRecognizer(pinchGes)
        let pinchWrap = section(title: "UIPinchGestureRecognizer — масштаб", demoView: pinchView, key: "pinch")
        addHint("Два пальца: pinch", to: pinchView)
        stack.addArrangedSubview(pinchWrap)

        // 5. Rotation (вращение)
        let rotView = card()
        let rotGes = UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:)))
        rotView.addGestureRecognizer(rotGes)
        let rotWrap = section(title: "UIRotationGestureRecognizer — вращение", demoView: rotView, key: "rotation")
        addHint("Два пальца: вращение", to: rotView)
        stack.addArrangedSubview(rotWrap)

        // 6. Long press
        let longView = card()
        let longGes = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longView.addGestureRecognizer(longGes)
        let longWrap = section(title: "UILongPressGestureRecognizer — долгое нажатие", demoView: longView, key: "long")
        addHint("Удерживай", to: longView)
        stack.addArrangedSubview(longWrap)

        // 3. Swipe (свайп по направлению)
        let swipeView = card()
        for d in [UISwipeGestureRecognizer.Direction.right, .left, .up, .down] {
            let g = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
            g.direction = d
            swipeView.addGestureRecognizer(g)
        }
        let swipeWrap = section(title: "UISwipeGestureRecognizer — свайп", demoView: swipeView, key: "swipe")
        addHint("Свайп ← → ↑ ↓", to: swipeView)
        stack.addArrangedSubview(swipeWrap)
    }

    private func addTapHint(to v: UIView) {
        let l = UILabel()
        l.text = "Один или два тапа"
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.isUserInteractionEnabled = false
        l.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(l)
        NSLayoutConstraint.activate([
            l.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            l.centerYAnchor.constraint(equalTo: v.centerYAnchor),
        ])
    }

    private func addHint(_ text: String, to v: UIView) {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.isUserInteractionEnabled = false
        l.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(l)
        NSLayoutConstraint.activate([
            l.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            l.centerYAnchor.constraint(equalTo: v.centerYAnchor),
        ])
    }

    // MARK: Actions

    @objc private func tapSingle(_ g: UITapGestureRecognizer) {
        guard g.state == .ended else { return }
        show("Один тап", key: "tap")
    }

    @objc private func tapDouble(_ g: UITapGestureRecognizer) {
        guard g.state == .ended else { return }
        show("Два тапа", key: "tap")
    }

    @objc private func pan(_ g: UIPanGestureRecognizer) {
        guard let v = g.view, let cx = panCenterX, let cy = panCenterY else { return }
        switch g.state {
        case .began:
            break
        case .changed:
            let t = g.translation(in: v.superview)
            cx.constant += t.x
            cy.constant += t.y
            g.setTranslation(.zero, in: v.superview)
            show("Перетаскивание: (\(Int(cx.constant)), \(Int(cy.constant)))", key: "pan")
        case .ended, .cancelled:
            show("Перетаскивание завершено", key: "pan")
        default:
            break
        }
    }

    @objc private func swipe(_ g: UISwipeGestureRecognizer) {
        guard g.state == .ended else { return }
        let dir: String
        switch g.direction {
        case .left: dir = "← влево"
        case .right: dir = "→ вправо"
        case .up: dir = "↑ вверх"
        case .down: dir = "↓ вниз"
        default: dir = "?"
        }
        show("Свайп \(dir)", key: "swipe")
    }

    @objc private func pinch(_ g: UIPinchGestureRecognizer) {
        guard let v = g.view else { return }
        switch g.state {
        case .changed:
            v.transform = v.transform.scaledBy(x: g.scale, y: g.scale)
            g.scale = 1
            let s = sqrt(v.transform.a * v.transform.a + v.transform.c * v.transform.c)
            show(String(format: "Масштаб %.2f", s), key: "pinch")
        case .ended, .cancelled:
            show("Масштаб завершён", key: "pinch")
        default:
            break
        }
    }

    @objc private func rotate(_ g: UIRotationGestureRecognizer) {
        guard let v = g.view else { return }
        switch g.state {
        case .changed:
            v.transform = v.transform.rotated(by: g.rotation)
            g.rotation = 0
            let a = atan2(v.transform.b, v.transform.a)
            show(String(format: "Угол %.1f°", a * 180 / .pi), key: "rotation")
        case .ended, .cancelled:
            show("Вращение завершено", key: "rotation")
        default:
            break
        }
    }

    @objc private func longPress(_ g: UILongPressGestureRecognizer) {
        guard g.state == .ended else { return }
        show("Долгое нажатие!", key: "long")
    }
}
