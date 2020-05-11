//
//  TextDetectionViewController.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/19/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import UIKit
import AVFoundation
import Vision



class CameraViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
        
    //CAMERA VARIABLES
    var outputImage: UIImage?
    var flashMode: AVCaptureDevice.FlashMode = .off // Not currently supporting flash-mode
    var outputText: String = "" {
        didSet {
            performSelector(onMainThread: #selector(textDetected), with: nil, waitUntilDone: true)
        }
    }
    var customPreviewLayer: AVCaptureVideoPreviewLayer?

    // DATA PROCESSING VARIABLES
    var host = "spreadsheets.google.com"
    var id = "1GNOa-8FtKdLDesBfcoXNgquA1RxF3JZp4MzxWPTjXvw"
    var sheet: Int = 1
   // var product: Entry?
    var product: String?

    //TIMER VARIABLES
    var timer = Timer()
    var isTextTimerRunning = false
    var isTimerRunning = false
    var seconds: Int!
    let PRODUCT_TIMER_MAX = 2
    let PRODUCT_TIMER_MIN = 0
    let TEXT_TIMER_MAX = 25
    let TEXT_TIMER_MIN = 20
    @IBOutlet weak var hintLabel: UILabel!
   // @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var imageView: UIImageView!

   // var barView: UIView!

}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveData()
//        barView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: view.frame.height))
        barView.backgroundColor = #colorLiteral(red: 0.4598584771, green: 0.721824944, blue: 0.9476643205, alpha: 1)
//        view.addSubview(barView)
       barView.frame.size.height = view.frame.height
       // testButton.isHighlighted
        self.startTextTimer()
       // self.timerLabel.alpha = 0.0
    }

    //MARK: Func called when text is recognized by the camera
    @objc func textDetected() {
        
        print("Text detected")
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            if self.outputText.isEmpty {
                self.instructionView.show()
            } else {
                    self.instructionView.hide()
                self.hintLabel.isHidden = true
            }
        }) { [weak self] _ in
            if self?.outputText.isEmpty == false {
                
                self?.startProductTimer()
                
            }
        }


    }
    
    override func viewWillAppear(_ animated: Bool) {
        CaptureManager.shared.startSession()
        CaptureManager.shared.delegate = self
        customPreviewLayer = CaptureManager.shared.customPreviewLayer
        VisionManager.shared.startTextDetection()
        VisionManager.shared.delegate = self
        animateBarView()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        CaptureManager.shared.stopSession()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if customPreviewLayer != nil {
            customPreviewLayer!.frame = imageView.bounds
            imageView.layer.addSublayer(customPreviewLayer!)
        } else { print("previewLayerNotLoaded") }
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }

    func animateBarView() {
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1, options: [.repeat, .autoreverse], animations: {
            self.barView.transform = CGAffineTransform(translationX: self.view.frame.width + 20, y: 0)
        }, completion: nil)
    }
}


extension CameraViewController: CaptureManagerDelegate, VisionManagerDelegate {
    func processCapturedTextBox(box: VNTextObservation) {
        //MARK: TO fill
    }
    
  
    func processCapturedImage(image: UIImage) {
        self.outputImage = image
        

    }
    func processCapturedText(text: String) {
        //print("procesCapturedText called for \(text)")
        outputText = text
        product = DataManager.searchProductsForString(text)

       // print("prod: \(prod)")
        if let product = product {
           // print("Found \(product.name), image: \(self.outputImage)")
            print("Found \(product), image: \(self.outputImage)")

           // product = prod
            if self.outputImage != nil {
                print("SEGUING")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showProductImage", sender: true)
                    CaptureManager.shared.stopSession()
                }
            }
        }
    }

}


//MARK: PREPARE VC SEGUE
extension CameraViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductImage" {
            assert(segue.destination.isKind(of: ImageViewController.self))
            guard let productFound = sender as? Bool else { preconditionFailure("Invalid sender, unknown Product found status") }
            guard let image = self.outputImage else {
                print("Invalid sender for showProductImage segue")
                return
            }
            print("IMAGE FOUND \(image)")
            print("PRODUCT FOUND: \(productFound)")
            let vc = segue.destination as! ImageViewController
            vc.productFound = productFound
            vc.image = image
            vc.outputText = self.outputText
        }
        pauseTimer()

    }
}

extension CameraViewController {
    private func retrieveData() {
        guard let url = prepareURL() else { preconditionFailure("Failed to construct URL") }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print(json)
                    let responseModel = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
                    guard let entries = responseModel.feed?.entry else { fatalError("Could not retrieve products")}
                    DataManager.products = entries.compactMap { $0.name?.t }
                } catch {
                    print(error)
                }
            }
            else {
                print(error?.localizedDescription)
            }

        }.resume()
    }
    private func prepareURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/feeds/list/\(id)/\(sheet)/public/full"
        components.queryItems = [URLQueryItem(name: "alt", value: "json")]
        print(components.url)
        return components.url

    }
    
}




/*
 TIMER METHODS
 */


extension CameraViewController {

    @objc
    func updateTimer() {
        print("SECONDS: \(seconds)")
        if (seconds >= TEXT_TIMER_MIN) {
            seconds -= 1
        } else if (seconds < TEXT_TIMER_MIN) && (seconds > PRODUCT_TIMER_MAX) {
            //user not pointing camera at text, show hint
            pauseTimer()
            hintLabel.isHidden = false
        } else if (seconds >= PRODUCT_TIMER_MIN) {
            seconds -= 1
        } else {
            //user's product not found in registry, segue to next screen
            pauseTimer()
            performSegue(withIdentifier: "showProductImage", sender: false)
        }
        
      
    }

   
    
    func startTextTimer() {
        if !isTimerRunning {
            seconds = TEXT_TIMER_MAX
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo:  nil, repeats: true)
            self.isTimerRunning = true
        }
    }
    func startProductTimer() {
        if !isTimerRunning {
            seconds = PRODUCT_TIMER_MAX
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo:  nil, repeats: true)
            self.isTimerRunning = true
        }
    }

    func pauseTimer() {
        print("timer disabled!!!")
        timer.invalidate()
        self.isTimerRunning = false
    }
}

