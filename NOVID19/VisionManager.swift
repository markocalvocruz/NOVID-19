//
//  VisionManager.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/20/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import Foundation
import Vision
protocol VisionManagerDelegate: class {
    func processCapturedText(text: String)
    func processCapturedTextBox(box: VNTextObservation)
}
class VisionManager: NSObject {
    static let shared = VisionManager()
    weak var delegate: VisionManagerDelegate?
    var requests: [VNRequest] = []
    var recognizedText: String?
    func startTextDetection() {
        // VNDetectTextRangles only looks for rectangles with some text in them
        let request = VNRecognizeTextRequest(completionHandler: self.detectTextHandler)
        request.customWords = ["Clorox", "Disinfecting", "Wipes"]
        self.requests = [request]
        //let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
       // request.reportCharacterBoxes = true
        
    }
    


    private func detectTextHandler(request: VNRequest, error: Error?)  {
        //The observations contains the result of the textRequest
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            print("no result")
            return
        }
        // Result will iterate through all of the observations and transform them into VNTextObservation
        //let result = observations.map({$0 as? VNTextObservation})
        var capturedText = ""
        for observation in observations {
            guard let bestCandidate = observation.topCandidates(1).first else {
                print("no candidate")
                continue
            }
            capturedText.append("\(bestCandidate.string) ")
        }
        delegate?.processCapturedText(text: capturedText)

        
    }

        
    
    }
//        DispatchQueue.main.async {
//            self.imageView.layer.sublayers?.removeSubrange(1...)
//            for region in result {
//                guard let rg = region else { continue }
//                self.highlightWord(box: rg)
//                if let boxes = region?.characterBoxes {
//                    for characterBox in boxes {
//                        self.highlightLetters(box: characterBox)
//                    }
//                }
//            }
//        }
    
