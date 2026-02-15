import UIKit

class LayerDemoViewController: UIViewController {

    private let gridSize = 22
    private let padding: CGFloat = 12
    private let fontSize: CGFloat = 30

    private let bgColor: UIColor = .dinoBg
    private let accentColor: UIColor = .dinoAccent

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor

        let size = (view.frame.width - padding * 2) / 2

        let verticalPadding = (view.frame.height - size * 2) / 3

        let pixelSize = size / CGFloat(gridSize)

        let containerView = UIView(frame: CGRect(x: size / 3, y: verticalPadding, width: size, height: size))

        let containerLayer = CALayer()
        containerLayer.frame = CGRect(x: size / 3, y: verticalPadding * 2 + size, width: size, height: size)

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if pixels.contains(where: { coords in
                    coords[0] == gridSize - row && coords[1] == gridSize - col
                }) {
                    let frame = CGRect(
                        x: CGFloat(col) * pixelSize,
                        y: CGFloat(row) * pixelSize,
                        width: pixelSize,
                        height: pixelSize
                    )
                    let pixel = UIView(frame: frame)
                    pixel.backgroundColor = accentColor
                    containerView.addSubview(pixel)

                    let layer = CALayer()
                    layer.frame = frame
                    layer.backgroundColor = accentColor.cgColor
                    containerLayer.addSublayer(layer)
                }
            }
        }

        let viewLabel = UILabel()
        viewLabel.text = "UIView"
        viewLabel.font = .boldSystemFont(ofSize: fontSize)
        viewLabel.textColor = accentColor
        viewLabel.frame = CGRect(x: size + padding, y: verticalPadding + size - fontSize, width: size, height: fontSize)

        let layerLabel = UILabel()
        layerLabel.text = "CALayer"
        layerLabel.font = .boldSystemFont(ofSize: fontSize)
        layerLabel.textColor = accentColor
        layerLabel.frame = CGRect(x: size + padding, y: verticalPadding * 2 + size * 2 - fontSize, width: size, height: fontSize)


        view.addSubview(viewLabel)
        view.addSubview(layerLabel)
        view.addSubview(containerView)
        view.layer.addSublayer(containerLayer)
    }
}

private let pixels: [[Int]] =  [
                                                                                                            /*     */ [22, 10], [22, 9], [22, 8], [22, 7], [22, 6], [22, 5], [22, 4], [22, 3], /*   */  // 22
                                                                                                            [21, 11], [21, 10], [21, 9], [21, 8], [21, 7], [21, 6], [21, 5], [21, 4], [21, 3], [21, 2], // 21
                                                                                                            [20, 11], [20, 10], /*    */ [20, 8], [20, 7], [20, 6], [20, 5], [20, 4], [20, 3], [20, 2], // 20
                                                                                                            [19, 11], [19, 10], [21, 9], [19, 8], [19, 7], [19, 6], [19, 5], [19, 4], [19, 3], [19, 2], // 19
                                                                                                            [18, 11], [18, 10], [18, 9], [18, 8], [18, 7], [18, 6], [18, 5], [18, 4], [18, 3], [18, 2], // 18
                                                                                                            [17, 11], [17, 10], [17, 9], [17, 8], [17, 7], [17, 6], [17, 5], [17, 4], [17, 3], [17, 2], // 17
                                                                                                            [16, 11], [16, 10], [16, 9], [16, 8], [16, 7], /*                                       */  // 16
                                                                                                            [15, 11], [15, 10], [15, 9], [15, 8], [15, 7], [15, 6], [15, 5], [15, 4], /*            */  // 15
        [14, 21],                                                                                 [14, 12], [14, 11], [14, 10], [14, 9], [14, 8], /*                                                */  // 14
        [13, 21],                                                                       [13, 13], [13, 12], [13, 11], [13, 10], [13, 9], [13, 8], /*[                                               */  // 13
        [12, 21], [12, 20],                                         [12, 15], [12, 14], [12, 13], [12, 12], [12, 11], [12, 10], [12, 9], [12, 8], [12, 7], [12, 6], /*                              */  // 12
        [11, 21], [11, 20], [11, 19],                     [11, 16], [11, 15], [11, 14], [11, 13], [11, 12], [11, 11], [11, 10], [11, 9], [11, 8], /*    */ [11, 6], /*                              */  // 11
        [10, 21], [10, 20], [10, 19], [10, 18], [10, 17], [10, 16], [10, 15], [10, 14], [10, 13], [10, 12], [10, 11], [10, 10], [10, 9], [10, 8], /*                                                */  // 10
        [ 9, 21], [ 9, 20], [ 9, 19], [ 9, 18], [ 9, 17], [ 9, 16], [ 9, 15], [ 9, 14], [ 9, 13], [ 9, 12], [ 9, 11], [ 9, 10], [ 9, 9], [ 9, 8], /*                                                */  //  9
                  [ 8, 20], [ 8, 19], [ 8, 18], [ 8, 17], [ 8, 16], [ 8, 15], [ 8, 14], [ 8, 13], [ 8, 12], [ 8, 11], [ 8, 10], [ 8, 9],  /*                                                        */  //  8
                            [ 7, 19], [ 7, 18], [ 7, 17], [ 7, 16], [ 7, 15], [ 7, 14], [ 7, 13], [ 7, 12], [ 7, 11], [ 7, 10], [ 7, 9], /*                                                         */  //  7
                                      [ 6, 18], [ 6, 17], [ 6, 16], [ 6, 15], [ 6, 14], [ 6, 13], [ 6, 12], [ 6, 11], [ 6, 10], /*                                                                  */  //  6
                                                [ 5, 17], [ 5, 16], [ 5, 15], [ 5, 14], [ 5, 13], [ 5, 12], [ 5, 11], /*                                                                            */  //  5
                                                          [ 4, 16], [ 4, 15], [ 4, 14],           [ 4, 12], [ 4, 11], /*                                                                            */  //  4
                                                          [ 3, 16], [ 3, 15],                               [ 3, 11], /*                                                                            */  //  3
                                                          [ 2, 16],                                         [ 2, 11], /*                                                                            */  //  2
                                                          [ 1, 16], [ 1, 15],                               [ 1, 11], [ 1, 10], /*                                                                  */  //  1
]
