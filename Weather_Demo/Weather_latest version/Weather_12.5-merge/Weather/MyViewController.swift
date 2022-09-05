//
//  MyViewController.swift
//  Weather
//
//  Created by yinze cui on 2021/9/10.
//

import UIKit

class MyViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    let cityDictionary: [String: String] = ["Dallas":"31°", "Austin":"30°", "Huston":"29°", "Los angeles":"35°", "San Francisco":"30°", "San Jose":"31°", "Boston":"29°", "Worcester":"25°","Wellesley":"26°"]

    @IBOutlet weak var queryButton: UIButton!
    @IBOutlet weak var showLocation: UITextField!
    @IBOutlet weak var uiPickerView: UIPickerView!
    @IBOutlet weak var showTemperature: UILabel!
    var peopleData = ["TX","CA","MA"]
        var peopleData1 = ["TX":["Dallas","Austin","Huston"],"CA":["Los Angeles","San Francisco","San Jose"],"MA":["Boston","Worcester","Wellesley"]]
        // Records the value of the first column
        var selectOneValue = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiPickerView.dataSource = self
        uiPickerView.delegate = self
        queryButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
       //print( uiPickerView.hashValue)
        // Do any additional setup after loading the view.
        
        
    }
    
    
    @objc func tapped(sender: UIButton) {
        showTemperature.text = cityDictionary[showLocation.text!]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
      
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
            if(component == 0){
                return peopleData.count
            }else{
                //如果从字典中能找到对应的数组,数组不为空
                if(peopleData1[selectOneValue] != nil){
                    //Gets the array from the dictionary based on the value selected by the user
                    return peopleData1[selectOneValue]!.count
                }else{
                    return 0
                }
            }
        }
    

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
            if(component == 0){
                return peopleData[row]
            }else{
                if(peopleData1[selectOneValue] != nil){
                    //Gets the array from the dictionary based on the value selected by the user in the first column
                    showLocation.text = peopleData1[selectOneValue]?[row]
                    return (peopleData1[selectOneValue]?[row])!
                }else{
                    return ""
                }
            }
        }

    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if(component == 0){
                // Records the value
                selectOneValue = peopleData[row]
                //showLocation.text = peopleData[row]
                //Refresh the data source
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            }
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
