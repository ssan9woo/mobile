# Access Control(접근 제어)
- Access control 은 다른 소스파일 및 모듈의 코드에서, 코드의 일부에 대한 **액세스(접근) 을 제한**한다. 
- 코드의 구현 세부사항을 숨기고, 해당 코드를 접근하고 사용할 수 있는 기본 인터페이스를 지정할 수 있다.
- `개별 타입(클래스, 구조체, 열거형)` 뿐만 아니라, 해당 타입에 속하는 프로퍼티, 메소드, 이니셜라이저 및 서브스크립트에 대해 특정 접근 레벨을 지정할 수 있음.

<br>

> 객체 지향의 **은닉화** 와 같은 개념


<br>

### 1. 개별타입 접근레벨 지정
```swift
public class SomeClass{}
public struct SomeStruct{}
public enum SomeEnum{}
```

- `Struct` 와 `Enum` 은 **Public** 부터 가능하고, `Class` 는 **Open** 접근지정자를 붙힐 수 있다.

<br>

### 2. 해당 타입에 속하는 프로퍼티, 메소드, 이니셜라이저 및 서브스크립트 접근레벨 지정
```swift
public class SomeClass {
    fileprivate var someProperty: String = "sangwoo"
    private func someFunction() {}
}
```
- 프로퍼티와 메소드 앞에 접근지정자를 통해 특정 레벨을 지정할 수 있다.

<br>

### 3. Module 과 Source file
- `module` : 하나의 프레임워크를 의미, `import` 키워드로 추가되는 것들을 말한다.
  - `UIKit`, `Foundation`, 프로젝트 하위에 있는 `targets` 도 각각 하나의 모듈이다.
- `source file` : 각각의 `module` 안에 있는 파일들


<br>

### 4. Access Levels(접근 레벨)
> Swift 는 코드 내의 엔티티에 대해 **5가지 접근 레벨**을 제공한다.
> 엔티티는 접근제어자를 작성할 수 있는 **property, method, class, struct..** 등의 집합을 의미함.

<br>

- `Open`, `public` : 엔티티를 정의 모듈의 모든 소스 파일 내에서 사용할 수 있으며, 정의한 모듈을 가져오는 다른 모듈의 소스파일에서도 사용할 수 있다. 일반적으로 Framework에 공용 인터페이스를 지정할 때 사용한다.
<br>

- `internal` : 엔티티가 정의 모듈의 모든 소스 파일 내에서 사용되지만, 해당 모듈 외부의 소스파일에서는 사용되지 않도록 한다. 일반적으로 App이나 Framework의 내부 구조를 정의할 때 사용한다.
<br>

- `File-private` : 엔티티가 작성된 `source file` 에서만 접근할 수 있도록 한다. 서로 다른 클래스가 같은 파일안에 있고, `fileprivate`로 선언되어 있다면, 둘은 서로 접근할 수 있다. 해당 엔티티의 세부 정보가 파일 내에서 사용될 때 **특정 기능의 구현 세부 정보를 숨길 수 있다.**
<br>

- `private` : 특정 객체에서만 사용할 수 있도록 하는 가장 제한적인 접근제어자. `fileprivate` 와는 달리 같은 파일 안에 있어도 서로 다른 객체가 `private` 로 선언되어 있다면, 둘은 서로 접근할 수 없다.
<br>

> open class : Framework 내부, 외부 어디서든 서브클래싱 및 오버라이딩이 가능.
> public, internal, file private, private : Framework 내부에서만 서브 클래싱 및 오버라이딩이 가능.

<br><br>

### 5. `open` 과 `public` 의 차이점??
- `Open` 은 다른 모듈에서 `subclass` 가 가능하지만, `public` 은 그렇지 않다.
- [한 모듈에서 만든 class 를 `superClass` 로 하는 `subClass`] 를 다른 모듈에서 만들기 위해서는, 해당 `superClass` 가 `Open` 으로 선언되어야 한다. 
- **클래스를 명시적으로 open 으로 표시하면, 해당 클래스를 superClass 로 사용하는 다른 모듈에서 가져온 코드의 영향을 고려했으므로, 클래스 코드를 적절하게 디자인했음을 의미한다.**

<br>

### 6. `internal`
- 모듈의 모든 소스파일에서는 접근이 가능하지만, 모듈의 외부에서는 사용되지 않도록 하는 접근지정자.
- 한마디로, 모듈 내에서만 사용 가능함.
- **기본적인 접근수준은 전부 `internal` 이다.**

<br>

### 7. `file private`
- 정의 소스 파일 내에서만 사용이 가능한 접근지정자.(= 같은 모듈 내에서도 같은 소스파일 안에서만 사용 가능.)
```swift
fileprivate class FilePrivateClass {
    fileprivate func someMethod()
}

var filePriavateInstance = FilePrivateClass() // error!!
fileprivate var filePriavateInstance = FilePrivateClass()

private class A: FilePrivateClass {
    override func someMethod() {}
}
```
- 접근 수준이 file private 이기 때문에, 변수도 file private, private 형식으로 선언해야함.
- 단, override 할 때는 아무것도 안붙혀도 상관없다.


<br>

### 8. `private`

```swift
private class PrivateClass {
    public init() {}
    private var name = "sangwoo"
}

private let privateInstance = PrivateClass() // ok
print(privateInstance.name) // error
```

- `Swift 4` 에서부터 `extension` 내에서도 private 상수 및 변수를 접근할 수 있다.
- 하지만, 같은 소스파일 안에서의 `extension` 만 가능하다.

<br>

### 9. Protocol
```swift
internal protocol myProtocol {
    func someMethod()
}

public class Myclass: myProtocol {
    public func someMethod() {}
}
```
- protocol 의 someMethod 은 `internal` 이다.
- protocol 을 상속받은 클래스에서의 someMethod 는 `internal` 보다 제한적인 `private` 를 제외하고 모두 사용할 수 있다.

<br>

### 10. 기타 문법

```swift
private(set) var name: String
```
- `getter` 는 `internal`, `setter` 는 `private` 로 지정된다.
- `Swift` 에서는 `setter` 를 `getter` 보다 더 제한적으로 설정할 수 있다.(반대는 불가능)
- `getter` 와 `setter` 를 따로 작성하지 않아도 된다.

<br>

```swift
fileprivate class FilePrivateClass { 
    func someMethod() {}
}
```
- `someMethod` 는 자동으로 `fileprivate` 접근지정자가 된다.

<br>

```swift
public private(set) var numberOfEdits = 0
```
- `getter` : public
- `setter` : private

<br>

### 11. 정리

|지정자|범위|
|:------:|:---:|
|open|모듈 외부에서도 접근 가능|
|public|모듈 외부에서도 접근 가능|
|internal|하나의 모듈 내부에서만 접근 가능|
|file private|하나의 소스코드 내에서만 접근 가능|
|private|정의한 블록 내부에서만 접근 가능|
