import UIKit
import AVFoundation

class NormalAlarmViewController: UIViewController {
    @IBOutlet weak var editLabelText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var normalAlarmSettingView: UIView!
    
    static var normalAlarmCount = 0
    var completionClosure: ((NormalAlarm) -> Void)?
    private var day: [Int] = Array(repeating: 0, count: 7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func setView() {
        self.view.backgroundColor = .clear
        self.normalAlarmSettingView.frame = CGRect(x: 0, y: self.view.frame.height / 2, width: self.view.frame.width, height: self.view.frame.height / 2)
        self.normalAlarmSettingView.layer.cornerRadius = 10
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_: )))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        let dismissArea = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2 + 40)
        let point = gesture.location(in: self.view)
        
        if dismissArea.contains(point) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func weekButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.setTitleColor(.red, for: .selected)
            sender.tintColor = .clear
            self.day[sender.tag] = 1
        } else {
            sender.setTitleColor(.white, for: .normal)
            self.day[sender.tag] = 0
        }
    }
    
    @IBAction func completion(_ sender: Any) {
        let time = getTime()
        let day = self.day
        let labelText = getLabelText()
        let isOn = true
        
        NormalAlarmViewController.normalAlarmCount += 1
        let normalAlarm = NormalAlarm(isOn: isOn, label: labelText, time: time, day: day, id: "normal\(NormalAlarmViewController.normalAlarmCount)")
        completionClosure?(normalAlarm)
        dismiss(animated: true, completion: nil)
    }

    func getLabelText() -> String {
        if let text = self.editLabelText.text {
            return text
        } else {
            return ""
        }
    }
    
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let date = dateFormatter.string(from: self.datePicker.date)
        return date
    }
}

extension NormalAlarmViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.editLabelText.resignFirstResponder()
        return true
    }
}
