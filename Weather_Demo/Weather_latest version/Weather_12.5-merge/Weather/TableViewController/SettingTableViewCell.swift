//
//  SettingTableViewCell.swift
//  Weather
//
//  Created by 徐艺文 on 9/9/21.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var timeSlider: UISlider!
    
    private var time:Float = 5
    var navigationViewController:NavigationViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func autoChangeTriggered(_ sender: Any) {
        if(autoSwitch.isOn){
            print("On")
        }else{
            print("Off")
        }
        navigationViewController?.timerStart(timerInterval: Double(time), status: autoSwitch.isOn)
        
    }
    

    @IBAction func timeSliderTouchUpInside(_ sender: Any) {
        time = timeSlider.value
        navigationViewController?.timerStart(timerInterval: Double(time), status: autoSwitch.isOn)
        print(time)
    }
    
    @IBAction func timeSliderValueChange(_ sender: Any) {
        timeLable.text = "\(Int(timeSlider.value))"+"s"

    }
    
    

}
