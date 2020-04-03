//
//  CaptureManager.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/20/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
protocol CaptureManagerDelegate: class {
    func processCapturedImage(image: UIImage)
}

class CaptureManager: NSObject {
    internal static let shared = CaptureManager()
    weak var delegate: CaptureManagerDelegate?
    var session: AVCaptureSession?
    var customPreviewLayer: AVCaptureVideoPreviewLayer?

    override init() {
        super.init()
        session = AVCaptureSession()
        self.configureDeviceInputsOutputs()
        
        // 3
        // Add a sublayer containing the video preview to the imageView
        customPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
        
    }

    private func configureDeviceInputsOutputs() {
        //setup input
        
        // Set media type as video because we want a live stream so it should always be running
        let device = AVCaptureDevice.default(for: .video)

        // 2
        // The input is what the camera sees
        let input = try! AVCaptureDeviceInput(device: device!)
        session?.addInput(input)

        // The output is what the video should appear as
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .default))
        self.session?.addOutput(output)
        
    }
    func statSession() {
        session?.startRunning()
    }

    func stopSession() {
        session?.stopRunning()
    }


}
extension CaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    //Take the video output and convert it into a CMSampleBuffer
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return
        }
        delegate?.processCapturedImage(image: outputImage)
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        var requestOptions: [VNImageOption: Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)

        do {
            try imageRequestHandler.perform(VisionManager.shared.requests)
         } catch {
            print(error)
        }
    }
    
    func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
          guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
              return nil
          }
          CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
          let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
          let width = CVPixelBufferGetWidth(pixelBuffer)
          let height = CVPixelBufferGetHeight(pixelBuffer)
          let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
          let colorSpace = CGColorSpaceCreateDeviceRGB()
          let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
          guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
              return nil
          }
          guard let cgImage = context.makeImage() else {
              return nil
          }
          let image = UIImage(cgImage: cgImage, scale: 1, orientation:.right)
          CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
          return image
    }
}
extension CameraViewController {
    private func highlightWord(box: VNTextObservation) {
        guard let boxes = box.characterBoxes else { return }
        var maxX: CGFloat = 9999.0
        var minX: CGFloat = 0.0
        var maxY: CGFloat = 9999.0
        var minY: CGFloat = 0.0
        
        for char in boxes {
            if char.bottomLeft.x < maxX {
                maxX = char.bottomLeft.x
            }
            if char.bottomRight.x > minX {
                minX = char.bottomRight.x
            }
            
            if char.bottomRight.y < maxY {
                maxY = char.bottomRight.y
            }
            if char.topRight.y > minY {
                minY = char.topRight.y
            }
        }
        
        let xCord = maxX * imageView.frame.size.width
        let yCord = (1 - minY) * imageView.frame.size.height
        let width = (minX - maxX) * imageView.frame.size.width
        let height = (minY - maxY) * imageView.frame.size.height
        addOutlineToImageView(xCord, yCord, width, height, borderWidth: 2.0, color: UIColor.red)
      
    }
    
    // Use VNRectangleObservation to define the contraints that will make outlining the box easier
    func highlightLetters(box: VNRectangleObservation) {
        let xCord = box.topLeft.x * imageView.frame.size.width
        let yCord = (1 - box.topLeft.y) * imageView.frame.size.height
        let width = (box.topRight.x - box.topLeft.x) * imageView.frame.size.width
        let height = (box.topRight.y - box.bottomRight.y) * imageView.frame.size.height
        addOutlineToImageView(xCord, yCord, width, height, borderWidth: 1.0, color: UIColor.blue)
        
    }

    
    private func addOutlineToImageView(_ xCord: CGFloat, _ yCord: CGFloat, _ width: CGFloat, _ height: CGFloat, borderWidth: CGFloat, color: UIColor ) {
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = borderWidth
        outline.borderColor = color.cgColor
        imageView.layer.addSublayer(outline)
    }
        
}
