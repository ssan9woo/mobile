import UIKit
import UserNotifications

class AlarmViewController: UIViewController, GetAlarmData {
    
    @IBOutlet weak var addAlarmButton: UIButton!
    @IBOutlet weak var addNomalAlarm: UIButton!
    @IBOutlet weak var addQuickAlarm: UIButton!
    @IBOutlet weak var floatingStackView: UIStackView!
    @IBOutlet weak var alarmTable: UITableView!
    
    var quickAlarms: [QuickAlarm] = []
    var normalAlarms: [NormalAlarm] = []
    
    lazy var buttons: [UIButton] = [self.addNomalAlarm, self.addQuickAlarm]
    lazy var floatingDimView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0
        view.isHidden = true
        self.view.insertSubview(view, belowSubview: self.floatingStackView)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatingButtons()
    }
    
    @IBAction func addQuickAlarmButton(_ sender: Any) {
        guard let quickVC = storyboard?.instantiateViewController(identifier: "quickAlarm") as? QuickAlarmViewController else { return }
        quickVC.delegate = self
        present(quickVC, animated: true, completion: nil)
    }
    
    @IBAction func addNormalAlarmButton(_ sender: Any) {
        guard let normalVC = storyboard?.instantiateViewController(identifier: "normalAlarm") as? NormalAlarmViewController else { return }
        normalVC.completionClosure = { normalAlarm in
            if normalAlarm.day.filter({ $0 == 0 }).count != normalAlarm.day.count {
                self.normalAlarms.append(normalAlarm)
                self.alarmTable.reloadData()
            }
        }
        present(normalVC, animated: true, completion: nil)
    }
    
    func setFloatingButtons() {
        addAlarmButton.backgroundColor = .black
        addAlarmButton.tintColor = .white
        addAlarmButton.layer.cornerRadius = addAlarmButton.layer.bounds.width / 2
        addNomalAlarm.layer.cornerRadius = addNomalAlarm.layer.bounds.width / 2
        addQuickAlarm.layer.cornerRadius = addQuickAlarm.layer.bounds.width / 2
    }
    
    @IBAction func addAlarm(_ sender: UIButton) {
        self.addAlarmButton.isSelected = !self.addAlarmButton.isSelected
        
        if addAlarmButton.isSelected {
            appearButtons(buttons: self.buttons)
            appearBackgroundDimView(view: self.floatingDimView)
        } else {
            disappearButtons(buttons: buttons)
            disappearBackgroundDimView(view: self.floatingDimView)
        }
        selectAndRotationButton(button: self.addAlarmButton, isSelected: self.addAlarmButton.isSelected)
    }
    
    func getQuickAlarmData(quickAlarm: QuickAlarm) {
        self.quickAlarms.append(quickAlarm)
        self.alarmTable.reloadData()
    }

    func disappearBackgroundDimView(view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            self.floatingDimView.alpha = 0
        }){ _ in self.floatingDimView.isHidden = true }
    }
    
    func disappearButtons(buttons: [UIButton]) {
        buttons.reversed().forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func appearBackgroundDimView(view: UIView) {
        view.isHidden = false
        UIView.animate(withDuration: 0.5) {
            view.alpha = 1
        }
    }
    
    func appearButtons(buttons: [UIButton]) {
        buttons.forEach { button in
            button.isHidden = false
            button.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                button.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func selectAndRotationButton(button: UIButton, isSelected: Bool) {
        let rotation = button.isSelected ? CGAffineTransform(rotationAngle: .pi - (.pi / 4)) : CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.5) {
            let bgColor = isSelected ? UIColor.white : UIColor.black
            let tintColor = isSelected ? UIColor.black : UIColor.white
            button.backgroundColor = bgColor
            button.tintColor = tintColor
            button.transform = rotation
        }
    }
}


extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.normalAlarms.count
        } else {
            return self.quickAlarms.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "normalAlarmCell", for: indexPath) as? NormalAlarmCell else { return UITableViewCell() }
            let normalAlarm = self.normalAlarms[indexPath.row]
            cell.updateCell(normalAlarm: normalAlarm)
            cell.normalAlarmAddToNotification(normalAlarm: normalAlarm)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "quickAlarmCell", for: indexPath) as? QuickAlarmCell else { return UITableViewCell() }
            let quickAlarm = self.quickAlarms[indexPath.row]
            cell.updateCell(quickAlarm: quickAlarm)
            cell.quickAlarmAddToNotificaion(quickAlarm: quickAlarm)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                // normal
                guard let cell = tableView.cellForRow(at: indexPath) as? NormalAlarmCell,
                      let alarmInfo = cell.alarmInfo else { return }
                cell.normalAlarmRemoveToNotification(normalAlarm: alarmInfo)
                self.normalAlarms.remove(at: indexPath.row)
                self.alarmTable.deleteRows(at: [indexPath], with: .right)
            } else {
                // quick
                guard let cell = tableView.cellForRow(at: indexPath) as? QuickAlarmCell, let alarmInfo = cell.alarmInfo else { return }
                cell.quickAlarmRemoveToNotification(quickAlarm: alarmInfo)
                self.quickAlarms.remove(at: indexPath.row)
                self.alarmTable.deleteRows(at: [indexPath], with: .right)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Normal Alarm"
        } else {
            return "Quick Alarm"
        }
    }
}


class NormalAlarmCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var alarmDay: UILabel!
    @IBOutlet weak var normalAlarmSwitch: UISwitch!
    
    private let week = ["일","월","화","수","목","금","토"]
    var alarmInfo: NormalAlarm?
    var notiManager = NotificationManager.shared
    
    func updateCell(normalAlarm: NormalAlarm) {
        self.alarmInfo = normalAlarm
        self.timeLabel.text = normalAlarm.time
        self.label.text = normalAlarm.label
        self.alarmDay.text = getAlarmDay(day: normalAlarm.day)
    }
    
    @IBAction func alarmOnOffSwitch(_ sender: UISwitch) {
        guard let normalAlarm = self.alarmInfo else { return }
        if sender.isOn {
            self.normalAlarmAddToNotification(normalAlarm: normalAlarm)
        } else {
            self.normalAlarmRemoveToNotification(normalAlarm: normalAlarm)
        }
    }
    
    func normalAlarmRemoveToNotification(normalAlarm: NormalAlarm) {
        self.notiManager.removeNotification(id: normalAlarm.id)
    }
    
    func normalAlarmAddToNotification(normalAlarm: NormalAlarm) {
        guard let hour = Int(normalAlarm.time.split(separator: ":")[0]),
              let minute = Int(normalAlarm.time.split(separator: ":")[1]) else { return }
        let label = normalAlarm.label
        let week = normalAlarm.day
        
        self.notiManager.addNormalAlarm(id: normalAlarm.id, label: label, week: week, hour: hour, minute: minute)
    }
    
    func getAlarmDay(day: [Int]) -> String {
        let totalCount = day.filter { $0 == 1 }.count
        
        if totalCount == day.count {
            return "매일"
        } else {
            var alarmDays = ""
            for i in 0..<day.count {
                if day[i] == 1 {
                    alarmDays += self.week[i]
                }
            }
            return alarmDays
        }
    }
}

class QuickAlarmCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var quickAlarmSwitch: UISwitch!
    var notiManager = NotificationManager.shared
    var alarmInfo: QuickAlarm?
    
    func updateCell(quickAlarm: QuickAlarm) {
        self.alarmInfo = quickAlarm
        self.timeLabel.text = intToTime(time: quickAlarm.time)
    }
    
    @IBAction func alarmOnOffSwitch(_ sender: UISwitch) {
        guard let quickAlarm = self.alarmInfo else { return }
        if sender.isOn {
            self.quickAlarmAddToNotificaion(quickAlarm: quickAlarm)
        } else {
            self.quickAlarmRemoveToNotification(quickAlarm: quickAlarm)
        }
    }
    
    func quickAlarmAddToNotificaion(quickAlarm: QuickAlarm) {
        self.notiManager.addQuickAlarm(interval: quickAlarm.time * 60, id: quickAlarm.id)
    }
    
    func quickAlarmRemoveToNotification(quickAlarm: QuickAlarm) {
        self.notiManager.removeNotification(id: quickAlarm.id)
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
}

protocol GetAlarmData {
    func getQuickAlarmData(quickAlarm: QuickAlarm)
}
