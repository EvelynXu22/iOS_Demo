//
//  BGViewController.swift
//  Weather
//
//  Created by Shuang Liang on 9/10/21.
//

import UIKit

class BGViewController: UIViewController, UIScrollViewDelegate {
    lazy var imageModel = {
        return ImageModel.bgsharedInstance()
    }()
    
    lazy private var imageView: UIImageView? = {
        return UIImageView.init(image: self.imageModel.getbackgroundImage(withName: displayImageName))//?
    }()
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var displayImageName = "dallas_cityscape"//……BGimage
    override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            print("运行viewdidlaod");
    //        if let size = self.imageView?.image?.size{
    //            print("zooming!")
    //            self.BGCityScape.addSubview(self.imageView!)
    //            self.BGCityScape.contentSize = size
    //            self.BGCityScape.minimumZoomScale = 0.1
    //            self.BGCityScape.delegate = self
    //        }
    //        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    //            return self.imageView
    //        }
        if let size = self.imageView?.image?.size{
            self.scrollView.addSubview(self.imageView!)
            self.scrollView.contentSize = size
            self.scrollView.minimumZoomScale = 0.1
            self.scrollView.delegate = self
        }
            
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView?{
            print("suofang")
            return self.imageView
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
