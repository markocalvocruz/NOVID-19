//
//  CameraViewController.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/18/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class DeprecatedCameraViewController: UIViewController {
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var capturePreviewView: UIView!
    
    @IBOutlet weak var toggleFlashButton: UIButton!
    @IBOutlet weak var toggleCameraButton: UIButton!
    
    override var prefersStatusBarHidden: Bool  { return true }
    var cameraController: DeprecatedCameraController!
    var lastCapturedImage: UIImage?
    @IBAction func toggleFlash(_ sender: UIButton) {
        toggleFlash()
    }
    @IBAction func switchCameras(_ sender: UIButton) {
        switchCameras()
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        captureImage()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cameraSelected()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleCaptureButton()
        cameraController = DeprecatedCameraController()
    }
    
    func styleCaptureButton() {
        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.borderWidth = 2
        
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
    }
    
    func configureCameraController() {
        cameraController.prepare { (error) in
            if let error = error { print(error)     }
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
        }
    }


   

}

extension DeprecatedCameraViewController {


    private func toggleFlash() {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        } else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    private func switchCameras() {
        do {
            try cameraController.switchCameras()
        } catch {
            print(error)
        }
        switch cameraController.currentCameraPosition {
            case .some(.front):
                toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
            case .some(.rear) :
                toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            case .none:
                return
        }
        
    }
    
    private func captureImage() {
        cameraController.captureImage { [weak self] (image,error) in
            guard let image = image else {
                print(error ?? " Image capture error")
                return
            }
            print("image: \(image.description)")
            self?.lastCapturedImage = image
            //Use PHPhotoLibrary.shared() class to save the image to the built-in photo library
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            print("seguing")
            self?.performSegue(withIdentifier: "showCaptureImage", sender: image)
        }
    }
}

extension DeprecatedCameraViewController {
    func cameraSelected() {
         // First we check if the device has a camera (otherwise will crash in Simulator - also, some iPod touch models do not have a camera).
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
             let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
             switch authStatus {
                 case .authorized:
                    configureCameraController()
                 case .denied:
                     alertPromptToAllowCameraAccessViaSettings()
                 case .notDetermined:
                     permissionPrimeCameraAccess()
                 default:
                     permissionPrimeCameraAccess()
             }
         } else {
             let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
             let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                //Analytics
             })
             alertController.addAction(defaultAction)
             present(alertController, animated: true)
         }
     }


     func alertPromptToAllowCameraAccessViaSettings() {
         let alert = UIAlertController(title: "\"<Your App>\" Would Like To Access the Camera", message: "Please grant permission to use the Camera so that you can  <customer benefit>.", preferredStyle: .alert )
         alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
             if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                 UIApplication.shared.openURL(appSettingsURL as URL)
             }
         })
         present(alert, animated: true, completion: nil)
     }


     func permissionPrimeCameraAccess() {
         let alert = UIAlertController( title: "\"<Your App>\" Would Like To Access the Camera", message: "<Your App> would like to access your Camera so that you can <customer benefit>.", preferredStyle: .alert )
         let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
             if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                 AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self] granted in
                     DispatchQueue.main.async {
                         self?.cameraSelected() // try again
                     }
                 })
             }
         })
         alert.addAction(allowAction)
         let declineAction = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in
           //Analytics
         }
         alert.addAction(declineAction)
         present(alert, animated: true, completion: nil)
     }

}


extension DeprecatedCameraViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("called, sender = \(sender != nil)")

        if segue.identifier == "showCaptureImage" {
            print("in here")
            assert(sender != nil, "There's no image sent from captureImage()")
            guard let image = sender as? UIImage else { preconditionFailure("No Image Contained")}

            assert(segue.destination.isKind(of: ImageViewController.self))
            print("seguing")
            let vc = segue.destination as! ImageViewController
            vc.image = image
            print("IMAGE TRANSFERRED")
            
        }
        print("no here")
    }
}
