//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion
import CoreData


class ViewController: UIViewController {

//    var test:Int = pedometer.queryPedometerData(from: NSCalendar.current.date(from: components), to: NSCalendar.current.date(byAdding: .hour, value: -24, to: todayStart)!, withHandler: self.handleQueryYesterdayPedometer)
    let couldPlayGame = false
    var targetSteps:Float = 6000.0
    //var transferValueGamescene = GameScene()
    //MARK: View variables
    let shapeLayer = CAShapeLayer()
    private lazy var label: UILabel = UILabel(frame: CGRect(x: 80, y: 80, width: 100, height: 100))
  
    //MARK: class variables
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let motion = CMMotionManager()
    
    
    //MARK: progress variables
    var totalSteps: Float = 0.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                let steps = newtotalSteps + self.totalTodaySteps
                self.stepsLabel.text = "Steps: \(steps)"
                self.progress = CGFloat(steps/self.targetSteps)
                
            }
        }
    }
    var totalTodaySteps: Float = 0.0 {
        willSet(newtotalTodaySteps){
            DispatchQueue.main.async{

                self.todaySteps.text = "Today Steps: \(newtotalTodaySteps)"
                
                
            }
        }
    }
    var totalYesterdaySteps: Float = 1000.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                //self.testValue = newtotalSteps
                self.yesterdaySteps.text = "Yesterday Steps: \(newtotalSteps)"
                
                
            }
        }
    }
    
    var progress:CGFloat = 0.0{
        willSet(newProgress){
            DispatchQueue.main.async {

                self.shapeLayer.strokeEnd = newProgress
                var showTemp = 1.0
                if newProgress > 1{
                    showTemp = 1.0
                }else{
                    showTemp = newProgress
                }
                self.label.text = "\(String(format: "%.1f", showTemp * 100))%"
            }
        }
    }
    
    //MARK: UI Elements
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var isWalking: UILabel!
    
    @IBOutlet weak var todaySteps: UILabel!
    @IBOutlet weak var yesterdaySteps: UILabel!
    
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var showMoveStatus: UITextView!
    
    @IBOutlet weak var showGoalSteps: UITextField!
    @IBOutlet weak var setGoalSteps: UIButton!
    //MARK: View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showGoalSteps.keyboardType = UIKeyboardType.numberPad
        
        
        self.totalSteps = 0.0
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
        self.startMotionUpdates()
        self.showProgressView()
        //startActivityMonitoring()
        startActivityUpdates()
//        self.switchToGame(<#Any#>)
        //self.testValue

    }

    @IBAction func setGoalStepsAction(_ sender: Any) {

        showGoalSteps.resignFirstResponder()
        //transferValueGamescene.lifeRemain =
        addData()
        if(totalTodaySteps > targetSteps){
            startGameButton.isEnabled = true
        }else{
            startGameButton.isEnabled = false
        }
        print(showGoalSteps.text)
    }
    
    func addData() -> Int{
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        var testValue:Float = 0
        //initialize object
        let goalSteps = NSEntityDescription.insertNewObject(forEntityName: "Goal_Steps",
                                                            into: context) as! Goal_Steps
        //set value
        goalSteps.steps = showGoalSteps.text ?? "0"
        print("goalSteps:",goalSteps.steps)
        targetSteps = Float(goalSteps.steps) ?? 10
        print("targetSteps:",targetSteps)
        print("context:",context)
        //save data
        do {
            try context.save()
            print("Saved")
        } catch {
            fatalError("Failed\(error)")
        }
        return Int(goalSteps.steps) ?? 100
    }
    
    
    func showProgressView(){
        
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
            
        view.layer.addSublayer(trackLayer)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeEnd = 0
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        
        label.textColor = UIColor .brown
        label.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        label.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        
        view.addSubview(label)
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        
        
    }
  
    @objc func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .backwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "stokeAnimation")
        
    }
    
    
    // MARK: Raw Motion Functions
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device
        
        // TODO: should we be doing this from the MAIN queue? You may need to fix that!  ...
        if self.motion.isDeviceMotionAvailable{
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main,
                                                 withHandler: handleMotion)
        }
    }
    
    // Raw motion handler, update a label
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let gravity = motionData?.gravity {
            // assume phone is in portrait
            // atan give angle of opposite over adjacent
            //   (y is out top of phone, x is out the side)
            //   but UI origin is top left with increasing down and to the right
            //   therefore proper rotation is the angle pointing opposite of motion
            //
            let rotation = atan2(gravity.x, gravity.y) - Double.pi
            self.isWalking.transform = CGAffineTransform(rotationAngle:
                                                            CGFloat(rotation))
        }
    }
    
    // MARK: Activity Functions
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: self.handleActivity)
        }
        
    }
    
    // activity function handler, display activity in label
    func handleActivity(_ activity:CMMotionActivity?)->Void{
        // unwrap the activity and disp
        if let unwrappedActivity = activity {
            DispatchQueue.main.async{
                self.isWalking.text = "Walking: \(unwrappedActivity.walking)\n Still: \(unwrappedActivity.stationary)"
            }
        }
    }
    
    // MARK: Pedometer Functions
    
    
    func startPedometerMonitoring(){
        //separate out the handler for better readability
        if CMPedometer.isStepCountingAvailable(){
            let components = NSCalendar.current.dateComponents(Set<Calendar.Component>.init(arrayLiteral: .year, .month, .day), from: Date())
            
     
            //Today's Date
            let todayStart = NSCalendar.current.date(from: components)!
            
            //Yesterday's Date
            let yesterdayStart = NSCalendar.current.date(byAdding: .hour, value: -24, to: todayStart)!
            let endDate = Date()
            
            //Realtime count of steps
            pedometer.startUpdates(from: Date(),withHandler: self.handlePedometer )
            //Yesterday count of steps
            pedometer.queryPedometerData(from: yesterdayStart, to: todayStart, withHandler: self.handleQueryYesterdayPedometer)
            
            //Today count of steps
            pedometer.queryPedometerData(from: todayStart, to: endDate, withHandler: self.handleQueryTodayPedometer)
            
        }
    }
    
    //ped handler, show steps on slider
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?){
        if let steps = pedData?.numberOfSteps {
            self.totalSteps = steps.floatValue
          
        }
        
    }
    func handleQueryYesterdayPedometer(_ pedData:CMPedometerData?, error:Error?){
        if let steps = pedData?.numberOfSteps {
            self.totalYesterdaySteps = steps.floatValue
            aaaaaaaa = steps.intValue/100
            print("aaaaaaaa:",aaaaaaaa)
        }
    }
    func handleQueryTodayPedometer(_ pedData:CMPedometerData?, error:Error?){
        if let steps = pedData?.numberOfSteps {
            self.totalTodaySteps = steps.floatValue
            self.progress = CGFloat(self.totalTodaySteps/self.targetSteps)
            print(self.progress)
 
        }
    }
    @IBAction func switchToGame(_ sender: Any) {
        print("press")
    }
    
    let motionActivityManager = CMMotionActivityManager()
         
    func startActivityUpdates() {
        // Check whether the device is supported
        guard CMMotionActivityManager.isActivityAvailable() else {
            self.showMoveStatus.text = "\nCurrent device does not support obtaining the current motion status\n"
            return
        }
        
        //
        let queue = OperationQueue.current
        self.motionActivityManager.startActivityUpdates(to: queue!, withHandler: {
            activity in
            //get data
            var text = "---Move data---\n"
            text += "Status: \(activity!.getDescription())\n"
            if (activity!.confidence == .low) {
                text += "Accuracy: low\n"
            } else if (activity!.confidence == .medium) {
                text += "Accuracy: medium\n"
            } else if (activity!.confidence == .high) {
                text += "Accuracy: high\n"
            }
            self.showMoveStatus.text = text
            print(text)
            print(self.showMoveStatus.text)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    }
     
extension CMMotionActivity {
    /// get status
    func getDescription() -> String {
        if self.stationary {
            return "Stand"
        } else if self.walking {
            return "Walking"
        } else if self.running {
            return "Running"
        } else if self.automotive {
            return "Driving"
        }else if self.cycling {
            return "Cycling"
        }
        return "Unknown status"
    }
}



