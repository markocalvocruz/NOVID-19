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

  
    @IBOutlet weak var bannerView: UIView!
    var image: UIImage? {
        didSet {
            print("Image loaded")
        }
    }
    var productFound: Bool!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var bannerTitleLabel: UILabel!
    
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        shareButtonTapped()
        
    }

}
extension ImageViewController {



    override func viewDidLoad() {
        super.viewDidLoad()
        setBannerText()
        setImageView()
        setBannerViewBackgroundColor()
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
            bannerView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    private func setBannerText() {
        let str = productFound ? "CORONA FIGHTER" : "NOT HOTDOG"
        let attributes = stroke(strokeWidth: 1, insideColor: .white, strokeColor: .black)
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
        let image = self.view.screenshot()
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true)
        
    }
}

extension UIView {

  func screenshot() -> UIImage {
    return UIGraphicsImageRenderer(size: bounds.size).image { _ in
      drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
    }
  }

}

    
  
