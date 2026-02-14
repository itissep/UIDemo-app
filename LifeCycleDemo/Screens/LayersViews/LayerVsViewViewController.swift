import UIKit

class LayerDemoViewController: UIViewController {

    let purpleView = UIView(frame: CGRect(x: 50, y: 100, width: 300, height: 300))
    let smallWhiteView = UIView(frame: CGRect(x: 20, y: 20, width: 40, height: 40)) // идентичный фрейм

    let purpleCALayer = CALayer()
    let smallWhiteLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // MARK: UIView

        purpleView.backgroundColor = .accent
        view.addSubview(purpleView)

        smallWhiteView.backgroundColor = .systemBackground
        purpleView.addSubview(smallWhiteView)


        // MARK: CALayer

        purpleCALayer.frame = CGRect(x: 50, y: 500, width: 300, height: 300)
        purpleCALayer.backgroundColor = UIColor.accent.cgColor
        view.layer.addSublayer(purpleCALayer)


        smallWhiteLayer.frame = CGRect(x: 20, y: 20, width: 40, height: 40) // идентичный фрейм
        smallWhiteLayer.backgroundColor = UIColor.systemBackground.cgColor
        purpleCALayer.addSublayer(smallWhiteLayer)
    }
}
