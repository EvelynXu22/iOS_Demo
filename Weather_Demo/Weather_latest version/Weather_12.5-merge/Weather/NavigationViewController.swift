//
//  NavigationViewController.swift
//  Weather
//
//  Created by yinze cui on 2021/9/9.
//

import UIKit
import CoreLocation

class NavigationViewController: UIViewController, CLLocationManagerDelegate {
    
    //var showLocationFromViewCon:NavigationViewController = 
    @IBOutlet weak var switchWeather: UISegmentedControl!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var showCurrentLocation: UILabel!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var temperatureScreen: UILabel!
    @IBOutlet weak var imageScreen: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set stepper
        let stepper=UIStepper(frame:CGRect(x:270,y:800,width:0,height:0))
        stepper.minimumValue=0
        stepper.maximumValue=3
        stepper.stepValue=1
        stepper.addTarget(self, action: #selector(click), for:UIControl.Event.valueChanged)
        stepper.wraps = true
        self.view.addSubview(stepper)
        
        //call timer function
        
        timerStart(timerInterval: 5.0, status: true)
        
        switchWeather.addTarget(self, action: #selector(NavigationViewController.segmentDidchange(_:)),
                                for: .valueChanged)
        
        //when user launch app then request
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    @objc func segmentDidchange(_ segmented:UISegmentedControl){
        weatherImage.image = UIImage(named: "101")
    }
    @objc func click(stepper:UIStepper){
        //print(stepper.value)
        switch stepper.value {
        case 0.0: imageScreen.image = UIImage(named: "bg")
        case 1.0: imageScreen.image = UIImage(named: "shanghai_cityscape")
        case 2.0: imageScreen.image = UIImage(named: "dallas_cityscape")
        //case 3.0: imageScreen.image = UIImage(named: "25")

        default:
            print("end")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let lon = locations[0].coordinate.longitude
        let lat = locations[0].coordinate.latitude
        print(lon)
        print(lat)
    }
    
    func locationManager(_ manager: CLLocationManager,didFailWithError error:Error) {
        print(error)
    }
    // Do any additional setup after aselfloading} the view
    
    func timerStart(timerInterval:Double, status:Bool){
        var countTimer = 0;
        let countdownTimer = Timer(timeInterval: timerInterval, repeats: status){_ in
            switch countTimer%3 {
            case 0: self.imageScreen.image = UIImage(named: "bg")
            case 1: self.imageScreen.image = UIImage(named: "shanghai_cityscape")
            case 2: self.imageScreen.image = UIImage(named: "dallas_cityscape")
           // case 3: self.imageScreen.image = UIImage(named: "25")

            default:
                print("end")
            }
            
            switch countTimer%3{
            case 0: self.temperatureScreen.text = "25°"
            case 1: self.temperatureScreen.text = "27°"
            case 2: self.temperatureScreen.text = "29°"
            default:
                print("end")
            }
            
            switch countTimer%3{
            case 0: self.showCurrentLocation.text = "Dallas"
            case 1: self.showCurrentLocation.text = "Huston"
            case 2: self.showCurrentLocation.text = "Boston"
            default:
                print("end")
            }
            
            
            countTimer += 1
        }
        RunLoop.current.add(countdownTimer, forMode: .default)
        countdownTimer.fire()
        
    }
    
//    func timerStartChangeTemperature(timerInterval:Double, status:Bool) {
//        var countTimer = 0;
//        let countdownTimer = Timer(timeInterval: timerInterval, repeats: status){_ in
//            switch countTimer%3 {
//            case 0: self.temperatureScreen.text = "25"
//            case 1: self.temperatureScreen.text = "25"
//            case 2: self.temperatureScreen.text = "25"
//           // case 3: self.imageScreen.image = UIImage(named: "25")
//
//            default:
//                print("end")
//            }
//
//            countTimer += 1
//        }
//        RunLoop.current.add(countdownTimer, forMode: .default)
//        countdownTimer.fire()
//    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
