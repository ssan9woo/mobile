import UIKit

class QuickAlarmViewController: UIViewController {
    @IBOutlet weak var quickAlarmSettingView: UIView!
    @IBOutlet weak var quickAlarmTimeLabel: UILabel!
    
    var quickTime: Int = 0
    var delegate: GetAlarmData?
    static var quickAlarmCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMinute(_ sender: UIButton) {
        self.quickTime += sender.tag
        self.quickAlarmTimeLabel.text = intToTime(time: self.quickTime)
    }
   
    @IBAction func complete(_ sender: Any) {
        dismiss(animated: true) {
            if self.quickTime > 0 {
                let quickAlarm = self.intToQuickAlarm(time: self.quickTime)
                self.delegate?.getQuickAlarmData(quickAlarm: quickAlarm)
            }
        }
    }
    
    func intToQuickAlarm(time: Int) -> QuickAlarm {
        QuickAlarmViewController.quickAlarmCount += 1
        return QuickAlarm(time: time, isOn: true, id: "quick\(QuickAlarmViewController.quickAlarmCount)")
    }
    
    func intToTime(time: Int) -> String {
        let hour = time / 60
        let minute = time - ((time / 60) * 60)
        
        if hour == 0 {
            return "+ \(minute) 분"
        } else {
            return "+ \(hour) 시간 \(minute) 분"
        }
    }
    
    func setView() {
        self.view.backgroundColor = .clear
        self.quickAlarmSettingView.frame = CGRect(x: 0, y: self.view.frame.height / 2, width: self.view.frame.width, height: self.view.frame.height / 2)
        self.quickAlarmSettingView.layer.cornerRadius = 10
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
}
