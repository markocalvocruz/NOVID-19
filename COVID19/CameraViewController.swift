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
    var product: Entry?

    //TIMER VARIABLES
    var timer = Timer()
    var isTimerRunning = false
    var seconds = 5
    
    @IBOutlet weak var timerLabel: UILabel!
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
            }
        }) { [weak self] _ in
            if self?.outputText.isEmpty == false {
//                self?.timerLabel.show()
                self?.runTimer()
                
                print("TIMER CALLED")
            }
        }


    }
    
    override func viewWillAppear(_ animated: Bool) {
        CaptureManager.shared.statSession()
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
        } else { print("previewLayerNotLoaded")}
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }

    func animateBarView() {
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1, options: [.repeat, .autoreverse], animations: {
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
        print("procesCapturedText called for \(text)")
        outputText = text
        product = CoreApp.searchProductsForString(text)

       // print("prod: \(prod)")
        if let product = product {
            print("Found \(product.name), image: \(self.outputImage)")
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
            let vc = segue.destination as! ImageViewController
            vc.productFound = productFound
            vc.image = image
        }
    }
}

extension CameraViewController {
    private func retrieveData() {
        guard let url = prepareURL() else { preconditionFailure("Failed to construct URL") }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let data = data {
                do {
                    let responseModel = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
                    guard let entries = responseModel.feed?.entry else { fatalError("Could not retrieve products")}
                    CoreApp.products = entries
                    print("decoded")
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
        print("Updating Timer")
        if seconds >= 0 {
            seconds -= 1
        //    self.timerLabel.text = "\(seconds)"
            if seconds == 0 { //    //self.timerLabel.hide() }
            }
        } else {
            pauseTimer()
            performSegue(withIdentifier: "showProductImage", sender: false)
        }
    }
    func pauseTimer() {
    //    isTimerRunning = false
//        isTimePaused = true
        timer.invalidate()
    }
    

    func runTimer() {
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo:  nil, repeats: true)
            self.isTimerRunning = true
        }
    }
}

/*

private func startLiveVideo() {
    // 1
    session.sessionPreset = AVCaptureSession.Preset.photo
    // Set media type as video because we want a live stream so it should always be running
    let captureDevice = AVCaptureDevice.default(for: .video)
    
    // 2
    // The input is what the camera sees
    // The output is what the video should appear as
    let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
    let deviceOutput = AVCaptureVideoDataOutput()
    deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
    deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .default))
    // Add the input and output to the AVCaptureSession
    session.addInput(deviceInput)
    session.addOutput(deviceOutput)
    
    // 3
    // Add a sublayer containing the video preview to the imageView
    let imageLayer = AVCaptureVideoPreviewLayer(session: session)
    imageLayer.frame = imageView.bounds
    imageView.layer.addSublayer(imageLayer)
    startSession()


}
*/

    //AVFoundation
//    var session = AVCaptureSession()
    
//    //Vision Framework
//    var requests = [VNRequest]()
//    @objc
//    private func randomString(length: Int) -> String {
//
//    }
//    var timer = Timer()
//    func animateNavigationHeader() {
//        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
//       // if !detectedText.isEmpty {
//            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(changeNavigationHeader), userInfo: nil, repeats: true)
////        } else {
////            timer.invalidate()
////        }
////    }
//    @objc
//    func changeNavigationHeader() {
//        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        self.navigationController?.title = String((0..<30).map{ _ in letters.randomElement()! })
//        // = randomString(length: 30)
//    }
//

    
//extension CameraViewController: UISearchResultsUpdating {
//        func updateSearchResults(for searchController: UISearchController) {
//            if let searchText = searchController.searchBar.text {
//                filteredProducts = searchText.isEmpty ? [] : products.filter({(product: Entry) -> Bool in
//                    return product.name?.t!.range(of: searchText, options: .caseInsensitive) != nil
//                })
//            }
//        }
//    private func prepareSearchController() {
//
//        //Initialize searchController
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//
//        searchController.dimsBackgroundDuringPresentation = false
//       // searchController.searchbar.sizeToFit()
//
//        // Sets this view controller as presenting view controller for the search interface
//        definesPresentationContext = true
//    }
//}

