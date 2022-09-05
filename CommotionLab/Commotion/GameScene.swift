//
//  GameScene.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion
//import CoreData
var aaaaaaaa:Int = 123456789
class GameScene: SKScene, SKPhysicsContactDelegate {

    var arr = ["b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "b9","b10", "b11"]
//    let defaults = UserDefaults.standard
    
    
    // MARK: Raw Motion Functions
    let motion = CMMotionManager()
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device
        
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 0.1
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion )
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let gravity = motionData?.gravity {
            self.physicsWorld.gravity = CGVector(dx: CGFloat(9.8*gravity.x), dy: CGFloat(9.8*gravity.y))
        }
//        if let userAccel motionData?.userAcceleration{
//            if (spinBlock.position.x<0 && userAccel.x<0) || (spinBlock.position.x>self.size.width && userAccel.x, > 0)
//            {
//                return
//            }
//            let action = SKAction.moveBy(x: userAccel.x * 100,y:0,duration:0.1)
//            self.spinBlock.run(action,withKey: "temp")
//        }
    }
    
    // MARK: View Hierarchy Functions
    let spinBlock = SKSpriteNode()
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    var score:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async{
                self.scoreLabel.text = "Score: \(newValue)"
//                print(self.spriteA)
//                print("update score！")
                
            }
        }
    }
    
    let lifeRemainLable = SKLabelNode(fontNamed: "Count")

    lazy var lifeRemain:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async{
                self.lifeRemainLable.text = "Life: \(newValue)"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        
        // start motion for gravity
        self.startMotionUpdates()
        
        // make sides to the screen
        self.addSidesAndTop()
        
        // add some stationary blocks
        self.addStaticBlockAtPoint(CGPoint(x: size.width * 0.05, y: size.height * 0.25))
//        self.addStaticBlockAtPoint(CGPoint(x: size.width * 0.1, y: size.height * 0.25))
        self.addStaticBlockAtPoint(CGPoint(x: size.width * 0.95, y: size.height * 0.25))
        self.addStaticBlockAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.75))
        self.addStaticBlockAtPoint(CGPoint(x: size.width * 0.9, y: size.height * 0.75))
        self.addStaticBlockAtPoint(CGPoint(x: size.width * (-0.1), y: size.height * 0.75))
//        self.addStaticBlockAtPointNo2(CGPoint(x:size.width * 0.5, y: size.height * 0.75))
        // add a spinning block
        self.addBlockAtPoint(CGPoint(x: size.width * 0.75, y: size.height * 0.65))
        
//        self.addSpriteBottle()
        self.addAninmalIcon()
        
        self.addScore()
        self.addLifeRemain()
        self.score = 0
        self.lifeRemain = aaaaaaaa//read from yesterday's step
    }
    
    // MARK: Create Sprites Functions
    func addScore(){
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.blue
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)//minY could be obscured by the system UI
        addChild(scoreLabel)
    }
    func addLifeRemain(){
        
        lifeRemainLable.text = "Life:"
        lifeRemainLable.fontSize = 20
        lifeRemainLable.fontColor = SKColor.blue
        lifeRemainLable.position = CGPoint(x: frame.midX, y: (frame.midY+20.0))
        addChild(lifeRemainLable)
    }
    
    
    func addSpriteBottle(){
        let spriteA = SKSpriteNode(imageNamed: "sprite") // this is literally a sprite bottle... 😎
        
        spriteA.size = CGSize(width:size.width*0.1,height:size.height * 0.1)
        
        let randNumber = random(min: CGFloat(0.1), max: CGFloat(0.9))
        spriteA.position = CGPoint(x: size.width * (1-randNumber), y: size.height * 0.9)
        
        spriteA.physicsBody = SKPhysicsBody(rectangleOf:spriteA.size)
//        spriteA.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        
        spriteA.physicsBody?.restitution = random(min: CGFloat(0.5), max: CGFloat(1.2))//bouncy could be adjest
        spriteA.physicsBody?.isDynamic = true
        spriteA.physicsBody?.contactTestBitMask = 0x00000001
        spriteA.physicsBody?.collisionBitMask = 0x00000001
        spriteA.physicsBody?.categoryBitMask = 0x00000001
        
        self.addChild(spriteA)
    }
    
    func addAninmalIcon(){
        if self.lifeRemain > 0{
            //        let arr = ["b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "b9","b10", "b11"]
                    let randomIndex = Int(arc4random_uniform(UInt32(arr.count)))

                    let aninmalIconA = SKSpriteNode(imageNamed: arr[randomIndex]) //🐶
            //        let aninmalIconA = SKSpriteNode(imageNamed: "b1")//🐶
                    aninmalIconA.size = CGSize(width:size.width*0.1,height:size.width * 0.1)
                    
                    let randNumber = random(min: CGFloat(0.1), max: CGFloat(0.9))
                    aninmalIconA.position = CGPoint(x: size.width * (1-randNumber), y: size.height * 0.9)
                    
                    aninmalIconA.physicsBody = SKPhysicsBody(rectangleOf:aninmalIconA.size)
                    
                    
                    aninmalIconA.physicsBody?.restitution = random(min: CGFloat(0.5), max: CGFloat(1.2))//bouncy could be adjest
                    aninmalIconA.physicsBody?.isDynamic = true
                    aninmalIconA.physicsBody?.contactTestBitMask = 0x00000001
                    aninmalIconA.physicsBody?.collisionBitMask = 0x00000001
                    aninmalIconA.physicsBody?.categoryBitMask = 0x00000001
                    
                    self.lifeRemain -= 1
                    print("life",self.lifeRemain)
            
                    self.addChild(aninmalIconA)
        }

    }
    
    func addBlockAtPoint(_ point:CGPoint){
        
        spinBlock.color = UIColor.cyan
        spinBlock.size = CGSize(width:size.width*0.1,height:size.height * 0.05)
        spinBlock.position = point
        
        spinBlock.physicsBody = SKPhysicsBody(rectangleOf:spinBlock.size)
        spinBlock.physicsBody?.contactTestBitMask = 0x00000001
        spinBlock.physicsBody?.collisionBitMask = 0x00000001
        spinBlock.physicsBody?.categoryBitMask = 0x00000001
        spinBlock.physicsBody?.isDynamic = true
        spinBlock.physicsBody?.pinned = true
        
        self.addChild(spinBlock)

    }
    
    func addStaticBlockAtPoint(_ point:CGPoint){
        let 🔲 = SKSpriteNode()
        
        🔲.color = UIColor.red
//        🔲.size = CGSize(width:size.width*0.1,height:size.height * 0.05)
        🔲.size = CGSize(width:size.width*0.4,height:size.height * 0.05)
        🔲.position = point
        
        🔲.physicsBody = SKPhysicsBody(rectangleOf:🔲.size)
        🔲.physicsBody?.isDynamic = true
        🔲.physicsBody?.pinned = true
        🔲.physicsBody?.allowsRotation = false
        
        self.addChild(🔲)
        
    }
    func addStaticBlockAtPointNo2(_ point:CGPoint){
        let 🔲 = SKSpriteNode()
        
        🔲.color = UIColor.red
//        🔲.size = CGSize(width:size.width*0.1,height:size.height * 0.05)
        🔲.size = CGSize(width:size.height*0.05,height:size.width * 0.4)
        🔲.position = point
        
        🔲.physicsBody = SKPhysicsBody(rectangleOf:🔲.size)
        🔲.physicsBody?.isDynamic = true
        🔲.physicsBody?.pinned = true
        🔲.physicsBody?.allowsRotation = false
        
        self.addChild(🔲)
        
    }
    func addSidesAndTop(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        let bottom = SKSpriteNode()
        let midx = SKSpriteNode()
        let midy = SKSpriteNode()
        
        left.size = CGSize(width:size.width*0.1,height:size.height)
        left.position = CGPoint(x:0, y:size.height*0.5)
        
        right.size = CGSize(width:size.width*0.1,height:size.height)
        right.position = CGPoint(x:size.width, y:size.height*0.5)
        
        top.size = CGSize(width:size.width,height:size.height*0.1)
        top.position = CGPoint(x:size.width*0.5, y:size.height)
        
        bottom.size = CGSize(width:size.width,height:size.height*0.1)
        bottom.position = CGPoint(x:size.width*0.5, y:0)
        
        midx.size = CGSize(width:size.width*0.6,height:size.height*0.05)
        midx.position = CGPoint(x:size.width*0.5, y:size.height*0.5)
        
        midy.size = CGSize(width:size.width*0.1,height:size.height*0.75)
        midy.position = CGPoint(x:size.width*0.5, y:size.height*0.5)
        
        
        for obj in [left,right,top,bottom,midx,midy]{
            obj.color = UIColor.red
            obj.physicsBody = SKPhysicsBody(rectangleOf:obj.size)
            obj.physicsBody?.isDynamic = true
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }
    }
    
    // MARK: =====Delegate Functions=====
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.addSpriteBottle()
        self.addAninmalIcon()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == spinBlock || contact.bodyB.node == spinBlock {
            self.score += 1
            print(self.score)
            //print(contact.bodyA.node,"bady A",contact)
            //print(contact.bodyB.node,"bady B",contact)            self.lifeRemain -= 1
            var ball : SKNode? = nil
            if contact.bodyA.node == spinBlock{
                ball = contact.bodyB.node
            }
            else{
                ball = contact.bodyA.node
            }
//            ball = contact.bodyB.node
            
            ball?.removeFromParent()//delete node
        }
    }
    
    // MARK: Utility Functions (thanks ray wenderlich!)
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(Int.max))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    var totalYesterdaySteps: Float = 10000000.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                //self.testValue = newtotalSteps
               // self.yesterdaySteps.text = "Yesterday Steps: \(newtotalSteps)"
                //self.lifeRemain = Int(newtotalSteps)
                
            }
        }
    }
    func handleQueryYesterdayPedometer(_ pedData:CMPedometerData?, error:Error?) -> Int{
        if let steps = pedData?.numberOfSteps {
            self.totalYesterdaySteps = steps.floatValue
       
        }
        return Int(totalYesterdaySteps)
    }
}
