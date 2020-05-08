//
//  ImageViewController.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/19/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import UIKit
import Vision
class ImageViewController: UIViewController {

    @IBOutlet weak var share_button: DesignableButton!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    @IBOutlet weak var emojiImageView: UIImageView!
    
    @IBOutlet weak var bannerView: UIView!
    var image: UIImage? {
        didSet {
            print("Image loaded")
        }
    }
    var productFound: Bool!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var previewImageViewFrame: UIView!
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var bannerTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        shareButtonTapped()
        
    }

}
extension ImageViewController {



    override func viewDidLoad() {
        super.viewDidLoad()
        setBannerText()
        setImageView()
        setMessage()
        setEmojiImage()
        setBannerViewBackgroundColor()
        share_button.setTitleColor(.white, for: .highlighted)
       // share_button.adjustsImageWhenHighlighted = false
        
        previewImageViewFrame.layer.cornerRadius = 2.0
        previewImageView.layer.cornerRadius = 2.0
    }

    private func setEmojiImage() {
        if !productFound {
            emojiImageView.image = #imageLiteral(resourceName: "X icon")
        } else {
            emojiImageView.image = #imageLiteral(resourceName: "✅")
        }
    }
    private func setMessage() {
        let msg: String
        if productFound {
            msg = "Great news! This product kills COVID-19 germs. Help your friends and family stay safe and informed."
        } else {
            msg = "This product does NOT kill COVID-19 germs. Make sure your friends and family know this will not protect."
        }
        messageLabel.text = msg
    }
    private func setImageView() {
        guard let image = self.image else { preconditionFailure("NO image found")}
        imageView.image = image
        previewImageView.image = image
    }
    private func setBannerViewBackgroundColor() {
        if productFound {
            bannerView.backgroundColor = #colorLiteral(red: 0.1465550065, green: 0.7826710343, blue: 0, alpha: 1)
        } else {
            bannerView.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.1333333333, blue: 0.03529411765, alpha: 1)
        }
    }
    private func setBannerText() {
        let str = productFound ? "Fights the virus!" : "Does NOT protect!"
        let attributes = stroke(strokeWidth: 1, insideColor: .white, strokeColor: .white)
        bannerTitleLabel.attributedText = NSMutableAttributedString(string: str, attributes: attributes)
    }
  
    public func stroke(font: UIFont = UIFont.boldSystemFont(ofSize: 30), strokeWidth: Float, insideColor: UIColor, strokeColor: UIColor) -> [NSAttributedString.Key: Any]{
        return [
            NSAttributedString.Key.strokeColor : strokeColor,
            NSAttributedString.Key.foregroundColor : insideColor,
            NSAttributedString.Key.strokeWidth : -strokeWidth,
            NSAttributedString.Key.font : font
            ]
    }
    private func shareButtonTapped() {
        share_button.isSelected = false
        let image = self.view.screenshot()

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true)
        
    }
        

}

extension UIView {

  func screenshot() -> UIImage {
    return UIGraphicsImageRenderer(size: bounds.size).image { _ in
      drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: false)
    }
  }
//    func screenshot() -> UIImage? {
//        if let window = window,
//            let snapView = window.snapshotView(afterScreenUpdates: false) {
//            if let statusBarSnapView = (UIApplication.shared.value(forKey: "statusBar") as? UIView)?.snapshotView(afterScreenUpdates: false) {
//                snapView.addSubview(statusBarSnapView)
//            }
//
//            if let statusBarSnapView = window.windowScene?.statusBarManager.uiview
//
//
//
//                if #available(iOS 13.0, *) {
//                       let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//                       // Reference - https://stackoverflow.com/a/57899013/7316675
//                       let statusBar = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
//                       statusBar.backgroundColor = .white
//                       window?.addSubview(statusBar)
//                } else {
//                       UIApplication.shared.statusBarView?.backgroundColor = .white
//                       UIApplication.shared.statusBarStyle = .lightContent
//                }
//            UIGraphicsBeginImageContextWithOptions(snapView.bounds.size, true, 0)
//            snapView.drawHierarchy(in: snapView.bounds, afterScreenUpdates: true)
//            let snapImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return snapImage
//        }
//        return nil
//    }

}

    extension UIImage {
        class var screenShot: UIImage? {
            let imageSize = UIScreen.main.bounds.size as CGSize;
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            guard let context = UIGraphicsGetCurrentContext() else {return nil}
            for obj : AnyObject in UIApplication.shared.windows {
                if let window = obj as? UIWindow {
                    if window.responds(to: #selector(getter: UIWindow.screen)) || window.screen == UIScreen.main {
                        // so we must first apply the layer's geometry to the graphics context
                        context.saveGState();
                        // Center the context around the window's anchor point
                        context.translateBy(x: window.center.x, y: window.center
                            .y);
                        // Apply the window's transform about the anchor point
                        context.concatenate(window.transform);
                        // Offset by the portion of the bounds left of and above the anchor point
                        context.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x,
                                             y: -window.bounds.size.height * window.layer.anchorPoint.y);

                        // Render the layer hierarchy to the current context
                        window.layer.render(in: context)

                        // Restore the context
                        context.restoreGState();
                    }
                }
            }
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return nil}
            return image
        }
    }
  
