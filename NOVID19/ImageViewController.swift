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

    var shareImage: UIImage!
  //  @IBOutlet weak var share_button: DesignableButton!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    @IBOutlet weak var emojiImageView: UIImageView!
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var bannerView: UIView!
    var image: UIImage? {
        didSet {
            print("Image loaded")
        }
    }
    var outputText: String = ""
    var showingFront: Bool = true
    var productFound: Bool!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var previewImageViewFrame: UIView!
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var bannerTitleLabel: UILabel!
//    @IBOutlet weak var messageLabel: UILabel!
    
 //   @IBOutlet weak var buttonStack: UIStackView!
    
//    @IBAction func shareButtonTapped(_ sender: UIButton) {
//        print("BUTTON TAPPED")
//        shareButtonTapped()
//
//    }
    
//    @IBAction func flipCard(_ sender: UIButton) {
//        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
//
//        UIView.transition(with: self.cardView, duration: 1.0, options: transitionOptions, animations: {
//            if self.showingFront {
//                self.showingFront = false
//                self.buttonStack.isHidden = true
//            } else {
//                self.buttonStack.isHidden = false
//                self.showingFront = true
//            }
//            self.setMessage()
//        })
//
//
//    }
    

}
extension ImageViewController {



    override func viewDidLoad() {
        super.viewDidLoad()
        setBannerText()
        setImageView()
        //setMessage()
        setEmojiImage()
        setBannerViewBackgroundColor()
      //  share_button.setTitleColor(.white, for: .highlighted)
       // share_button.adjustsImageWhenHighlighted = false
//      cardView.messageLabel.text = "testing"
        previewImageViewFrame.layer.cornerRadius = 2.0
        previewImageView.layer.cornerRadius = 2.0
        cardView = CardView()
    }

    private func setEmojiImage() {
        emojiImageView.image = productFound ? #imageLiteral(resourceName: "✅") : #imageLiteral(resourceName: "X icon")
       
    }
//    private func setMessage() {
//        let msg: String
//        if productFound {
//            messageLabel.text = "Great news! This product kills COVID-19 germs. Help your friends and family stay safe and informed."
//        } else {
//            if showingFront {
//                messageLabel.text = "This product does NOT kill COVID-19 germs. Make sure your friends and family know this will not protect."
//            } else {
//                messageLabel.attributedText = NSMutableAttributedString().bold("Think we were wrong? Our app detected the following: \n").normal(outputText.trimmingCharacters(in: .whitespacesAndNewlines))
//                // messageLabel.text = "This product does NOT kill COVID-19 germs. Make sure your friends and family know this will not protect."
//            }
//            
//        }
//        print(messageLabel.text)
//    }
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
//    private func shareButtonTapped() {
//        share_button.isSelected = false
//        shareImage = self.view.screenshot()
//
//        let vc = UIActivityViewController(activityItems: [self.shareImage], applicationActivities: [])
//        present(vc, animated: true)
//        
//    }
    
        

}

extension UIView {
  
  func screenshot() -> UIImage {
    let snap = window!.snapshotView(afterScreenUpdates: false)!
    return snap.asImage()
//    return UIGraphicsImageRenderer(size: bounds.size).image { _ in
//      drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: false)
//    }
  }

    func asImage() -> UIImage {
          let renderer = UIGraphicsImageRenderer(bounds: bounds)

          return renderer.image {
              rendererContext in

              layer.render(in: rendererContext.cgContext)
          }
      }
    func captureScreen() -> UIImage {
        var window: UIWindow? = UIApplication.shared.keyWindow
        window = UIApplication.shared.windows[0] as? UIWindow
        UIGraphicsBeginImageContextWithOptions(window!.frame.size, window!.isOpaque, 0.0)
        window!.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func screenshot2() -> UIImage? {
        if let window = window,
            let snapView = window.snapshotView(afterScreenUpdates: false) {

            if #available(iOS 13.0, *) {
                   let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                   // Reference - https://stackoverflow.com/a/57899013/7316675
                   let statusBar = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
                   statusBar.backgroundColor = .white

                   window?.addSubview(statusBar)
            } else {
                 //  UIApplication.shared.statusBarView?.backgroundColor = .white
                   UIApplication.shared.statusBarStyle = .lightContent
            }
            UIGraphicsBeginImageContextWithOptions(snapView.bounds.size, true, 0)
            snapView.drawHierarchy(in: snapView.bounds, afterScreenUpdates: false)
            let snapImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return snapImage
        }
        return nil
    
    }
    


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
  
