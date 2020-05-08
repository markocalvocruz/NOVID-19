//
//  CameraController.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/18/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import AVFoundation
import UIKit
import Vision
class DeprecatedCameraController: NSObject {

    lazy var captureSession: AVCaptureSession = AVCaptureSession()

    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    
    
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput? {
        didSet {
            print("Front Camera Input configured")
        }
    }
    var rearCameraInput: AVCaptureDeviceInput? {
        didSet {
            print("Rear Camera Input configured")
        }
    }
    
    
    var photoOutput: AVCapturePhotoOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode: AVCaptureDevice.FlashMode = .off {
        didSet {
            print("FLASH MODE TOGGLED to \(flashMode.rawValue)")
        }
    }
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var requests: [VNRequest] = []
    
}



extension DeprecatedCameraController {
    //We create a prepare func with a completionHandler because configuring and starting a camera is relatively intensive
    // This function will handle the creatoin and configuration of a new capture session
    
    /* The 4 steps of setting up a camera session
        1. Creating a capture session. (done in the property variable declaration)
        2. Obtaining and configuring the necessary capture devices.
        3. Creating inputs using the capture devices.
        4.Configuring a photo output object to process captured images.
     */
    

    // Step 2 - Obtain and configure the necessary capture devices
    private func configureCaptureDevices() throws {
        // Find all the wide-angle cameras available on the current device
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        // Convert all wide-angle cameras on device into an array of non-optional AVCaptureDevice instances (i.e Camera)
        let cameras = session.devices.compactMap { $0 }
        
        // Throw error if no cameras found
        if cameras.isEmpty { throw CameraControllerError.noCamerasAvailable }

        // Look through all the found cameras and appropriately assign them to frontView and rearView
        // Additionally, configure rearCamera to AutoFocus and throw errors if necessary
        for camera in cameras {
            if camera.position == .front {
                self.frontCamera = camera
            }
            if camera.position == .back {
                self.rearCamera = camera
                try camera.lockForConfiguration()
                camera.focusMode = .continuousAutoFocus
                camera.unlockForConfiguration()
            }
            
            
        }
    }
    

    /*
     
         Step 3: Capture devices connect CaptureDevice --> CaptureSession
         Create the necessary capture Device input to support photo capture
         AVFoundation only allows one camera-based input per capture session at a time
         The rear camera is the default, so we try first to create an input from it and add to captureSession
         If fails, we try with front camera, and throw an error if that fails
 
     */
    private func configureDeviceInputs() throws {
        
        if let rearCamera = self.rearCamera { try? assignRearCamera() }
        else if let frontCamera = self.frontCamera { try assignFrontCamera() }
        else { throw CameraControllerError.noCamerasAvailable }
        
    }
    // Step 4
    private func configurePhotoOutput() throws {
  
        self.photoOutput = AVCapturePhotoOutput()
        self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)

        if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!)}
        captureSession.startRunning()
        
    }
    

    func prepare(completionHandler: @escaping (Error?) -> Void) {
        DispatchQueue(label: "prepare").async { [weak self] in
            do {
                try self?.configureCaptureDevices()
                try self?.configureDeviceInputs()
                try self?.configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
   
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //Set the preview to portrait orientation
        self.previewLayer?.connection?.videoOrientation = .portrait
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
}




extension DeprecatedCameraController: AVCapturePhotoCaptureDelegate {
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        var requestOptions: [VNImageOption: Any] = [:]

        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }

        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil), let image = UIImage(data: data) {
            self.photoCaptureCompletionBlock?(image, nil)
        }
            
        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
        
        
    }
    
    //Take the video output and convert it into a CMSampleBuffer
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        var requestOptions: [VNImageOption: Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)

        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }

}

extension DeprecatedCameraController {
        private func startTextDetection() {
            // VNDetectTextRangles only looks for rectangles with some text in them
            let request = VNRecognizeTextRequest(completionHandler: self.detectTextHandler)
            //let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
           // request.reportCharacterBoxes = true
            self.requests = [request]
        }
        

        private func detectTextHandler(request: VNRequest, error: Error?) {
            var str = ""
            //The observations contains the result of the textRequest
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("no result")
                return
            }
            // Result will iterate through all of the observations and transform them into VNTextObservation
            //let result = observations.map({$0 as? VNTextObservation})
    //        count += 1
    //        print("CALLED \(count) times")
            for observation in observations {
                guard let bestCandidate = observation.topCandidates(1).first else {
                    print("no candidate")
                    continue
                }
                str.append("\(bestCandidate.string) ")

            }
            let prod = CoreApp.searchProductsForString(str)
            if !prod.isEmpty {
                print("Found this string: \(prod)")
               // performSegue(withIdentifier: "showProductImage", sender: imageView.image)
            }
        }
}
extension DeprecatedCameraController {
    enum CameraControllerError: Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}


//Flip cameras
extension DeprecatedCameraController {
    func switchCameras() throws {
        // Verify we have a valid running capture session & an active camera
        let currentCameraPosition = self.currentCameraPosition
        captureSession.beginConfiguration()
        
        switch currentCameraPosition {
        case .front: try switchToRearCamera()
        case .rear: try switchToFrontCamera()
        case .none: return
        }
        
        
    }

    private func assignCamera(position: CameraPosition, addInput: AVCaptureInput, removeInput: AVCaptureInput? = nil) throws {
        if let removeInput = removeInput { captureSession.removeInput(removeInput) }
        if captureSession.canAddInput(addInput) {
            captureSession.addInput(addInput)
            self.currentCameraPosition = position
        }
        else { throw CameraControllerError.invalidOperation }
    }
    private func assignFrontCamera(removeInput: AVCaptureDeviceInput? = nil) throws {
        if let frontCamera = self.frontCamera {
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            try assignCamera(position: .front, addInput: self.frontCameraInput!, removeInput: removeInput)
        }
    }
    
    private func assignRearCamera(removeInput: AVCaptureDeviceInput? = nil) throws {
        if let rearCamera = self.rearCamera {
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            try assignCamera(position: .rear, addInput: self.rearCameraInput!, removeInput: removeInput)

        }
    }

    private func switchToFrontCamera() throws {
        print("SWITCHING TO FRONT CAMERA")
        guard let inputs = captureSession.inputs as? [AVCaptureInput],
            let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput) else { throw CameraControllerError.invalidOperation}
        try assignFrontCamera(removeInput: rearCameraInput)


    }
    private func switchToRearCamera() throws {
        print("SWITCHING TO REAR CAMERA")
        guard let inputs = captureSession.inputs as? [AVCaptureInput],
            let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput) else { throw CameraControllerError.invalidOperation}
        try assignRearCamera(removeInput: frontCameraInput)

    }

}
