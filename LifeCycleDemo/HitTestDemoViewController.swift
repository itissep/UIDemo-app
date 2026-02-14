import UIKit

/// Вью, у которой pointInside расширяет hit-область за пределы bounds (на inset по краям).
final class ExpandHitView: UIView {
    var hitExpandInset: CGFloat = 24

    // MARK: point(inside:)
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let expanded = bounds.insetBy(dx: -hitExpandInset, dy: -hitExpandInset)
        return expanded.contains(point)
    }
}

// MARK: hitTest
/// Вью-оверлей: hitTest возвращает nil для самой себя и подвью с tag == 0 — касания «пролетают» к вью ниже. Подвью с tag == 1 принимают касания.
final class PassthroughOverlayView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hit = super.hitTest(point, with: event) else { return nil }
        if hit == self { return nil }
        if hit.tag == 0 { return nil }
        return hit
    }
}


final class HitTestDemoViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    private let feedbackLabel = UILabel()

    private weak var topTapView: UIView?
    private weak var bottomTapView: UIView?
    private weak var interactionToggle: UISwitch?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hit-testing"
        view.backgroundColor = .systemGray6
        setupScrollView()
        setupFeedback()
        addUserInteractionEnabledDemo()
        addPointInsideDemo()
        addHitTestDemo()

    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        stack.axis = .vertical
        stack.spacing = 28
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
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -100),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),
        ])
    }

    private func setupFeedback() {
        feedbackLabel.numberOfLines = 3
        feedbackLabel.font = .monospacedSystemFont(ofSize: 13, weight: .medium)
        feedbackLabel.textAlignment = .center
        feedbackLabel.backgroundColor = .accent.withAlphaComponent(0.5)
        feedbackLabel.layer.cornerRadius = 8
        feedbackLabel.layer.masksToBounds = true
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(feedbackLabel)
        NSLayoutConstraint.activate([
            feedbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            feedbackLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            feedbackLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 52),
        ])
        feedbackLabel.text = "Тапай по демо-областям — сюда пишется результат."
    }

    private func section(title: String, body: String, demo: UIView) -> UIView {
        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(titleLabel)

        let bodyLabel = UILabel()
        bodyLabel.text = body
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(bodyLabel)

        demo.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(demo)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: wrap.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: wrap.trailingAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            bodyLabel.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: wrap.trailingAnchor),
            demo.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            demo.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            demo.trailingAnchor.constraint(equalTo: wrap.trailingAnchor),
            demo.bottomAnchor.constraint(equalTo: wrap.bottomAnchor),
        ])
        return wrap
    }

    private func addUserInteractionEnabledDemo() {
        let body = """
        userInteractionEnabled = false → вью не участвует в hit-test (касания проходят «сквозь» неё). Включи/выключи верхнюю вью и тапай по области перекрытия.
        """

        let container = UIView()
        container.backgroundColor = .quaternarySystemFill
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.separator.cgColor

        let toggleRow = UIView()
        toggleRow.translatesAutoresizingMaskIntoConstraints = false
        let lbl = UILabel()
        lbl.text = "Верхняя (синяя) userInteractionEnabled:"
        lbl.font = .systemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        let sw = UISwitch()
        sw.isOn = true
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.addTarget(self, action: #selector(interactionToggleChanged(_:)), for: .valueChanged)
        toggleRow.addSubview(lbl)
        toggleRow.addSubview(sw)
        NSLayoutConstraint.activate([
            lbl.leadingAnchor.constraint(equalTo: toggleRow.leadingAnchor),
            lbl.centerYAnchor.constraint(equalTo: toggleRow.centerYAnchor),
            lbl.trailingAnchor.constraint(lessThanOrEqualTo: sw.leadingAnchor, constant: -8),
            sw.trailingAnchor.constraint(equalTo: toggleRow.trailingAnchor),
            sw.centerYAnchor.constraint(equalTo: toggleRow.centerYAnchor),
        ])
        interactionToggle = sw

        let area = UIView()
        area.translatesAutoresizingMaskIntoConstraints = false
        area.backgroundColor = .clear

        // Нижняя (accent) — левее и ниже
        let bottom = UIView()
        bottom.backgroundColor = .accent
        bottom.layer.cornerRadius = 10
        bottom.translatesAutoresizingMaskIntoConstraints = false
        area.addSubview(bottom)
        NSLayoutConstraint.activate([
            bottom.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 20),
            bottom.topAnchor.constraint(equalTo: area.topAnchor, constant: 16),
            bottom.widthAnchor.constraint(equalToConstant: 120),
            bottom.heightAnchor.constraint(equalToConstant: 80),
        ])
        bottomTapView = bottom

        // Верхняя (синяя) — перекрывает правый верх зелёной
        let top = UIView()
        top.backgroundColor = .systemBlue
        top.layer.cornerRadius = 10
        top.alpha = 0.85
        top.translatesAutoresizingMaskIntoConstraints = false
        area.addSubview(top)
        NSLayoutConstraint.activate([
            top.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 80),
            top.topAnchor.constraint(equalTo: area.topAnchor, constant: 8),
            top.widthAnchor.constraint(equalToConstant: 120),
            top.heightAnchor.constraint(equalToConstant: 80),
        ])
        topTapView = top

        let tapTop = UITapGestureRecognizer(target: self, action: #selector(tappedOverlapTop(_:)))
        top.addGestureRecognizer(tapTop)
        let tapBottom = UITapGestureRecognizer(target: self, action: #selector(tappedOverlapBottom(_:)))
        bottom.addGestureRecognizer(tapBottom)

        let overlapHint = UILabel()
        overlapHint.text = "Тапай по перекрытию"
        overlapHint.font = .systemFont(ofSize: 12)
        overlapHint.textColor = .tertiaryLabel
        overlapHint.translatesAutoresizingMaskIntoConstraints = false
        area.addSubview(overlapHint)
        NSLayoutConstraint.activate([
            overlapHint.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            overlapHint.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -8),
        ])

        container.addSubview(toggleRow)
        container.addSubview(area)
        NSLayoutConstraint.activate([
            toggleRow.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            toggleRow.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            toggleRow.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            toggleRow.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            area.topAnchor.constraint(equalTo: toggleRow.bottomAnchor, constant: 12),
            area.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            area.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            area.heightAnchor.constraint(equalToConstant: 120),
            area.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
        ])

        let wrap = section(
            title: "userInteractionEnabled",
            body: body,
            demo: container
        )
        stack.addArrangedSubview(wrap)
    }

    // MARK: isUserInteractionEnabled
    @objc private func interactionToggleChanged(_ sender: UISwitch) {
        topTapView?.isUserInteractionEnabled = sender.isOn
        feedbackLabel.text = "Верхняя вью: userInteractionEnabled = \(sender.isOn ? "true" : "false"). Тапай по перекрытию."
    }

    @objc private func tappedOverlapTop(_ g: UITapGestureRecognizer) {
        feedbackLabel.text = "Тап получила ВЕРХНЯЯ (синяя) вью.\nuserInteractionEnabled = true → участвует в hit-test."
    }

    @objc private func tappedOverlapBottom(_ g: UITapGestureRecognizer) {
        feedbackLabel.text = "Тап получила НИЖНЯЯ (фиолетовая) вью.\nЛибо синяя отключена (userInteractionEnabled = false), либо тап не по перекрытию."
    }

    private func addPointInsideDemo() {
        let body = """
        point(inside:with:) решает, считается ли точка «внутри» вью. По умолчанию — bounds.contains(point). Можно расширить или сузить hit-область. Здесь она расширена на 24pt — тапай рядом с кнопкой.
        """

        let container = UIView()
        container.backgroundColor = .quaternarySystemFill
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.separator.cgColor

        let expand = ExpandHitView()
        expand.backgroundColor = .accent
        expand.layer.cornerRadius = 10
        expand.hitExpandInset = 24 // MARK: hitExpandInset
        expand.translatesAutoresizingMaskIntoConstraints = false
        let expandWidth = expand.widthAnchor.constraint(equalToConstant: 100)
        let expandHeight = expand.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([expandWidth, expandHeight])

        let lbl = UILabel()
        lbl.text = "Кнопка"
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        expand.addSubview(lbl)
        NSLayoutConstraint.activate([
            lbl.centerXAnchor.constraint(equalTo: expand.centerXAnchor),
            lbl.centerYAnchor.constraint(equalTo: expand.centerYAnchor),
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedExpandHit(_:)))
        expand.addGestureRecognizer(tap)

        let hint = UILabel()
        hint.text = "Hit-область шире видимой (pointInside)"
        hint.font = .systemFont(ofSize: 12)
        hint.textColor = .tertiaryLabel
        hint.translatesAutoresizingMaskIntoConstraints = false

        let stackInner = UIStackView(arrangedSubviews: [expand, hint])
        stackInner.axis = .vertical
        stackInner.spacing = 8
        stackInner.alignment = .center
        stackInner.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackInner)
        NSLayoutConstraint.activate([
            stackInner.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stackInner.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stackInner.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
        ])

        let wrap = section(title: "point(inside:with:)", body: body, demo: container)
        stack.addArrangedSubview(wrap)
    }

    @objc private func tappedExpandHit(_ g: UITapGestureRecognizer) {
        feedbackLabel.text = "Тап по ExpandHitView (pointInside расширена).\nТочка могла быть рядом с видимой «кнопкой» — всё равно попали."
    }

    private func addHitTestDemo() {
        let body = """
        hitTest(_:with:) возвращает вью, которая получит касание. Можно переопределить: вернуть nil — «прозрачность», касание уйдёт к вью ниже; вернуть другую вью — подменить получателя. Здесь оверлей по умолчанию прозрачен; кнопка на оверлее — нет.
        """

        let container = UIView()
        container.backgroundColor = .quaternarySystemFill
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.separator.cgColor

        let area = UIView()
        area.translatesAutoresizingMaskIntoConstraints = false

        // «Фон» — кнопка под оверлеем (только она в area, чтобы hitTest по оверлею → nil шёл к сиблингу area)
        let under = UIButton(type: .system)
        under.setTitle("Кнопка ПОД оверлеем", for: .normal)
        under.setTitleColor(.white, for: .normal)
        under.backgroundColor = .accent
        under.layer.cornerRadius = 10
        under.translatesAutoresizingMaskIntoConstraints = false
        under.addTarget(self, action: #selector(tappedUnderOverlay), for: .touchUpInside)
        area.addSubview(under)
        NSLayoutConstraint.activate([
            under.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 20),
            under.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -20),
            under.topAnchor.constraint(equalTo: area.topAnchor, constant: 12),
            under.heightAnchor.constraint(equalToConstant: 44),
        ])

        // Оверлей — сиблинг area, а не подвью. При hitTest → nil контейнер переходит к area → under.
        let overlay = PassthroughOverlayView()
        overlay.backgroundColor = UIColor.systemRed.withAlphaComponent(0.25)
        overlay.layer.cornerRadius = 10
        overlay.translatesAutoresizingMaskIntoConstraints = false

        // Кнопка НА оверлее — её мы возвращаем из hitTest (тег 1)
        let onOverlay = UIButton(type: .system)
        onOverlay.tag = 1
        onOverlay.setTitle("Кнопка НА оверлее", for: .normal)
        onOverlay.backgroundColor = .systemBlue
        onOverlay.setTitleColor(.white, for: .normal)
        onOverlay.layer.cornerRadius = 10
        onOverlay.translatesAutoresizingMaskIntoConstraints = false
        onOverlay.addTarget(self, action: #selector(tappedOnOverlay), for: .touchUpInside)
        overlay.addSubview(onOverlay)
        NSLayoutConstraint.activate([
            onOverlay.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 20),
            onOverlay.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -20),
            onOverlay.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -12),
            onOverlay.heightAnchor.constraint(equalToConstant: 44),
        ])

        let hint = UILabel()
        hint.text = "Тап по красной области → уходит к зелёной кнопке (hitTest nil)"
        hint.font = .systemFont(ofSize: 12)
        hint.textColor = .tertiaryLabel
        hint.numberOfLines = 2
        hint.isUserInteractionEnabled = false
        hint.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(hint)
        NSLayoutConstraint.activate([
            hint.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 16),
            hint.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -16),
            hint.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 12),
        ])

        container.addSubview(area)
        container.addSubview(overlay)
        NSLayoutConstraint.activate([
            area.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            area.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            area.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            area.heightAnchor.constraint(equalToConstant: 140),
            overlay.leadingAnchor.constraint(equalTo: area.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: area.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: area.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: area.bottomAnchor),
            area.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
        ])

        let wrap = section(title: "hitTest(_:with:)", body: body, demo: container)
        stack.addArrangedSubview(wrap)
    }

    @objc private func tappedUnderOverlay() {
        feedbackLabel.text = "Тап по кнопке ПОД оверлеем.\nОверлей вернул hitTest = nil → касание прошло «сквозь» него."
    }

    @objc private func tappedOnOverlay() {
        feedbackLabel.text = "Тап по кнопке НА оверлее.\nЭту вью мы возвращаем из hitTest — она получает касание."
    }
}
