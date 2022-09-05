//
//  SecViewController.swift
//  ImageLab
//
//  Created by 徐艺文 on 10/31/21.
//  Copyright © 2021 Eric Larson. All rights reserved.
//

import UIKit

class SecViewController: UIViewController {

    
    lazy var graph:MetalGraph? = {
        return MetalGraph(mainView: self.view)
    }()
//    var redValue = UnsafeMutablePointer<Float>.allocate(capacity: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // add red value graph
        graph?.addGraph(withName: "red",
                            shouldNormalize: true,
                            numPointsInGraph: 50)
        // set a timer to update
        Timer.scheduledTimer(timeInterval: 0.05, target: self,
            selector: #selector(self.updateGraph),
            userInfo: nil,
            repeats: true)
    }
    
    @objc
    func updateGraph(){
        self.graph?.updateGraph(
            data:redValue,
            forKey: "red"
        )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
