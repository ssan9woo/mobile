# Delegate

- ### 객체 지향 프로그래밍에서 하나의 객체가 모든 일을 처리하는 것이 아니라 처리 해야 할 일 중 일부를 다른 객체에 넘기는 것을 뜻함.

<br>

## Delegate 패턴 적용순서

<br>

### 1. 채택
```swift
class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
}
```
- `UITextFieldDelegate` 를 `채택`
- 프로토콜을 선언한게 아니라 `채택` 한다고 말한다.

<br>

### 2. 위임자 선택
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    textField.delegate = self
}
```
- 위임자(대리자)가 누구인지 알려주는 과정
- `textField` 에게 이벤트가 발생하면 해당 `ViewController` 가 프로토콜에 따라 응답을 준다.
<br>

### 3. 구현
```swift
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // TODO
    return true
}
```
- `textField` 에서 `Return` 이 인지되면, 해당 `ViewController` 가 함수를 처리해준다.