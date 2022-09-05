//
//  ViewController.swift
//  ImageLab
//
//  Created by Eric Larson
//  Copyright © Eric Larson. All rights reserved.
//

import UIKit
import AVFoundation
import Metal

class ViewController: UIViewController   {

    //MARK: Class Properties
    var filters : [CIFilter]! = nil
    var videoManager:VideoAnalgesic! = nil
    let pinchFilterIndex = 2
    var detector:CIDetector! = nil
    let bridge = OpenCVBridge()
    var redValue = UnsafeMutablePointer<Float>.allocate(capacity: 100)
    
    //MARK: Outlets in view
    @IBOutlet weak var flashSlider: UISlider!
    @IBOutlet weak var stageLabel: UILabel!
    
    @IBOutlet weak var graphView: UIView!

    //MARK: ViewController Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the OpenCV bridge nose detector, from file
        self.bridge.loadHaarCascade(withFilename: "frontface")
        
        self.videoManager = VideoAnalgesic(mainView: self.view)
        self.videoManager.setCameraPosition(position: AVCaptureDevice.Position.back)
        
        // create dictionary for face detection
        // HINT: you need to manipulate these properties for better face detection efficiency
        let optsDetector = [CIDetectorAccuracy:CIDetectorAccuracyLow,CIDetectorTracking:true] as [String : Any]
        
        // setup a face detector in swift
        self.detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: self.videoManager.getCIContext(), // perform on the GPU is possible
            options: (optsDetector as [String : AnyObject]))
        
        //detector.
        
        self.videoManager.setProcessingBlock(newProcessBlock: self.processImageSwift)
        
        if !videoManager.isRunning{
            videoManager.start()
        }
        
        
    
    }

    
    //MARK: Process image output
    func processImageSwift(inputImage:CIImage) -> CIImage{
        
        var retImage = inputImage
        
        self.bridge.setTransforms(self.videoManager.transform)

        self.bridge.setImage(retImage,
                             withBounds: retImage.extent, // the first face boundsx
                             andContext: self.videoManager.getCIContext())
        
        self.bridge.processFinger()
        retImage = self.bridge.getImageComposite() // get back opencv processed part of the image (overlayed on original)
        
        
        let faces = getFaces(img: retImage)
        
        for face in faces as! [CIFaceFeature] {
            //face bounds
            print("Found bounds are \(face.bounds)")
            
            //left eye position
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
                
                //initial a filter for left eye
                let filterLeftEye = CIFilter(name: "CIZoomBlur")!//CIPhotoEffectNoir
                filterLeftEye.setValue(retImage, forKey: kCIInputImageKey)
                filterLeftEye.setValue(CIVector(cgPoint: face.leftEyePosition), forKey: "inputCenter")
                retImage = filterLeftEye.outputImage!
            }
            
            //right eye position
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
                let filteRightEye = CIFilter(name: "CILineScreen")!//CIPhotoEffectNoir
                filteRightEye.setValue(retImage, forKey: kCIInputImageKey)
                //filteRightEye.setValue(0.5, forKey: kCIInputIntensityKey)
                filteRightEye.setValue(CIVector(cgPoint: face.rightEyePosition), forKey: "inputCenter")
                //filterLeftEye.setValue(CIVector(cgPoint: face.leftEyePosition), forKey: "")
                retImage = filteRightEye.outputImage!
           }
            
            //mouth positon
            if face.hasMouthPosition {
                //position is in terminal
                print("Mouth bounds are \(face.mouthPosition)")
//                let filteMouth = CIFilter(name: "CITwirlDistortion")!//CIPhotoEffectNoir
//                filteMouth.setValue(retImage, forKey: kCIInputImageKey)
//                //filteRightEye.setValue(0.5, forKey: kCIInputIntensityKey)
//                filteMouth.setValue(CIVector(cgPoint: face.leftEyePosition), forKey: "inputCenter")
//                //filterLeftEye.setValue(CIVector(cgPoint: face.leftEyePosition), forKey: "")
//                retImage = filteMouth.outputImage!
            }
            
            if face.hasSmile {
                //status is output in terminal
                print("Smiling")
            }
            
            if face.leftEyeClosed {
                //status is output in terminal
                print("Blinking left eye closed \(face.leftEyePosition)")
            }
            
            if face.rightEyeClosed {
                //status is output in terminal
               print("Blinking right eye closed \(face.rightEyePosition)")
            }
        }
        return retImage
    }
    
    //MARK: Setup Face Detection
    
    func getFaces(img:CIImage) -> [CIFaceFeature]{
        // this ungodly mess makes sure the image is the correct orientation
        let optsFace = [CIDetectorImageOrientation:self.videoManager.ciOrientation,CIDetectorSmile: true, CIDetectorEyeBlink: true, CIDetectorAccuracy: CIDetectorAccuracyHigh] as [String : Any]
        // get Face Features
        return self.detector.features(in: img, options: optsFace) as! [CIFaceFeature]
        
    }
    
    // change the type of processing done in OpenCV
    @IBAction func swipeRecognized(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            self.bridge.processType += 1
        case .right:
            self.bridge.processType -= 1
        default:
            break
            
        }
        
        stageLabel.text = "Stage: \(self.bridge.processType)"

    }
    
    //MARK: Convenience Methods for UI Flash and Camera Toggle
    @IBAction func flash(_ sender: AnyObject) {
        if(self.videoManager.toggleFlash()){
            self.flashSlider.value = 1.0
        }
        else{
            self.flashSlider.value = 0.0
        }
    }
    
    @IBAction func switchCamera(_ sender: AnyObject) {
        self.videoManager.toggleCameraPosition()
    }
    
    @IBAction func setFlashLevel(_ sender: UISlider) {
        if(sender.value>0.0){
            let val = self.videoManager.turnOnFlashwithLevel(sender.value)
            if val {
                print("Flash return, no errors.")
            }
        }
        else if(sender.value==0.0){
            self.videoManager.turnOffFlash()
        }
    }

   
}

