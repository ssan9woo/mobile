import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var settingTableView: UITableView!
    private let settingCellText = ["날씨 알리미 설정","version","개발자"]
    private let reuseCellName = ["alarmCell", "versionCell", "nameCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellName[indexPath.row], for: indexPath)
        cell.textLabel?.text = settingCellText[indexPath.row]
        if indexPath.row == 1 {
            cell.detailTextLabel?.text = "1.0"
        } else if indexPath.row == 2 {
            cell.detailTextLabel?.text = "석상우"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "설정사항"
    }
}

