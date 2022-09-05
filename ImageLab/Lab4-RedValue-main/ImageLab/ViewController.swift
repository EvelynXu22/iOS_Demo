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
import Accelerate
import Foundation

var redValue:[Float] = []



class ViewController: UIViewController   {

    //MARK: Class Properties
    var filters : [CIFilter]! = nil
    var videoManager:VideoAnalgesic! = nil
    let pinchFilterIndex = 2
    var detector:CIDetector! = nil
    let bridge = OpenCVBridge()

    
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
        
        self.videoManager.setProcessingBlock(newProcessBlock: self.processImageSwift)
        
        if !videoManager.isRunning{
            videoManager.start()
        }

    
    }

    
    func processHeartRate() -> UInt32{
        
        var redMax:Float = -1000.0
        var redMin:Float = 1000.0
        var heartRate:UInt32 = 0
        var countFlag = true
        var countPeak:UInt32 = 0
        //using GPU
        let gapLength = Int(6)
        let slidelength = Int(1)
        var max:Float = .nan
        let seperateIndex = Int(redValue.count) - gapLength
        var part2MaxFftData:[Float] = []
        
        if redValue.count == 100{
            for i in 0..<(Int((redValue.count/slidelength))-1){
                if(i<=seperateIndex){
                    var toDoArray:[Float] = Array.init(redValue[(i * slidelength)..<((i) * slidelength) + gapLength])
                    
                    
                    vDSP_maxv(toDoArray, 1, &max, vDSP_Length(gapLength))
                    //print(max)
                    part2MaxFftData.append(max)
                }
                else{
                    var toDoArray:[Float] = Array.init(redValue[(i * slidelength)..<redValue.count])
                    
                    
                    vDSP_maxv(toDoArray, 1, &max, vDSP_Length(gapLength))
                    //print(max)
                    part2MaxFftData.append(max)
                }
                if part2MaxFftData.count > 50{
                    part2MaxFftData.removeFirst()
                }
            print("vdspmax:",part2MaxFftData)
            print("length:",part2MaxFftData.count)
            if part2MaxFftData.count > 49{
                var a_1 = (part2MaxFftData).sorted(by: >)
                print("a_1:",a_1)
                    var peakOne:Float = 0.0//find two biggest
                    var peakTwo:Float = 0.0
                    for i in 0..<a_1.count{
                        if a_1[i] == a_1[i+1]{
                            
                            peakOne = a_1[i]
                            print("peakOne",peakOne)
                            break
                            
                        }
                    }
                    
                    for i in 2..<a_1.count{
                        print(i)
                        if a_1[i] == a_1[i-1] && peakOne != a_1[i-1]{
                            peakTwo = a_1[i-1]
                            print("peakTwo",peakTwo)
                            break
                        }
                    }
                //to find the peakIndex
                    var tempStart = 0
                    var tempEnd = 0
                    var peakOneIndex = 0
                    var peakTwoIndex = 0
                    tempStart = part2MaxFftData.firstIndex(of: peakOne) ?? 0
                    tempEnd = part2MaxFftData.lastIndex(of: peakOne) ?? 0
                    peakOneIndex = Int((tempEnd+tempStart)/2)
                    print("peakOneIndex",peakOneIndex)
                    tempStart = part2MaxFftData.firstIndex(of: peakTwo) ?? 0
                    tempEnd = part2MaxFftData.lastIndex(of: peakTwo) ?? 0
                    peakTwoIndex = Int((tempEnd+tempStart)/2)
                    print("peakTwoIndex",peakTwoIndex)
                    print(peakTwoIndex - peakOneIndex)
                    
                    heartRate = UInt32(1800/abs(peakTwoIndex - peakOneIndex))//base on the 30fps camera, if run at 24fps 1800should be 1440
                if heartRate > 180//some noise signal
                {
                    heartRate = 60
                }
            }
        }


        }

        return heartRate
    }
    
    //MARK: Process image output
    func processImageSwift(inputImage:CIImage) -> CIImage{
    
        
        var retImage = inputImage
        
        DispatchQueue.main.async{
//            print(self.bridge.processType)
            
            // directly turn on the flash
            if self.bridge.processType == 0{
                self.flashSlider.value = 1.0
            }
            else{
                self.flashSlider.value = 0
            }
            if(self.flashSlider.value>0.0){
                let val = self.videoManager.turnOnFlashwithLevel(self.flashSlider.value)
                if val {
                    print("Flash return, no errors.")
                }
            }
            else if(self.flashSlider.value==0.0){
                self.videoManager.turnOffFlash()
            }

        }
        
        // if you just want to process on separate queue use this code
        // this is a NON BLOCKING CALL, but any changes to the image in OpenCV cannot be displayed real time
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
//            self.bridge.setImage(retImage, withBounds: retImage.extent, andContext: self.videoManager.getCIContext())
//            self.bridge.processImage()
//        }
        
        // use this code if you are using OpenCV and want to overwrite the displayed image via OpenCV
        // this is a BLOCKING CALL
//        self.bridge.setTransforms(self.videoManager.transform)
//        self.bridge.setImage(retImage, withBounds: retImage.extent, andContext: self.videoManager.getCIContext())
//        self.bridge.processImage()
//        retImage = self.bridge.getImage()
        
        //HINT: you can also send in the bounds of the face to ONLY process the face in OpenCV
        // or any bounds to only process a certain bounding region in OpenCV
        self.bridge.setTransforms(self.videoManager.transform)
//        self.bridge.setImage(retImage,
//                             withBounds: f[0].bounds, // the first face boundsx
//                             andContext: self.videoManager.getCIContext())
        self.bridge.setImage(retImage,
                             withBounds: retImage.extent, // the first face boundsx
                             andContext: self.videoManager.getCIContext())
        
        // get the red value from opencv
        let red = self.bridge.processFinger()
        if(red>=0){
            // push back
            redValue.append((red-210)/50)
            if(redValue.count>100){
                // pop first
                redValue.removeFirst()
            }
//            print(redValue.count)
        }
        else{
            // remove the finger. Clear.
            redValue.removeAll()
        }
//        print(redValue)
        
        // process heart rate
        let heartRate = processHeartRate()
        
        // print heart rate on image
        self.bridge.printText(Int32(heartRate))
        
        
        retImage = self.bridge.getImageComposite() // get back opencv processed part of the image (overlayed on original)
        
        
        return retImage
    }
    
    //MARK: Setup Face Detection
    
    func getFaces(img:CIImage) -> [CIFaceFeature]{
        // this ungodly mess makes sure the image is the correct orientation
        let optsFace = [CIDetectorImageOrientation:self.videoManager.ciOrientation]
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

