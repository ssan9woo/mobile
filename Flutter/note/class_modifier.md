### Class Modifier

```
Modifier들은 단순히 해당 class의 특성을 나타내며, 
설계에 따라 적절한 Modifier를 사용하여 재사용성을 높히면 될 것 같다.
```

<br><br>

### abstract

```dart
abstract class Clothes {
  final int price;
  Clothes(this.price);

  void wear(); // abstract method

  void takeOff() {}
}
```

- 상속 및 추상화를 위한 `modifier`로, 인스턴스화 할 수 없음
- 추상 메소드는 상속받는 측에서 반드시 구현해야 함

<br><br>

### interface

```dart
interface class RemoteControl {
  void turnOn() {}

  void turnOff() {}
}

class TvRemocon implements RemoteControl {
  @override
  void turnOff() {}

  @override
  void turnOn() {}
}
```

- 인터페이스를 정의하기 위해 사용함
- 앵간하면 `abstract + implement`조합으로 사용함
- 외부 라이브러리에선 상속이 불가능한데, 인터페이스 클래스 내부의 다른 메소드가 예상하지 못한 방식으로 호출이 될 수 있다고 해서 같은 라이브러리만 상속 가능하도록 만들었음. [참고](https://en.wikipedia.org/wiki/Fragile_base_class)

<br><br>

### mixin

```dart
class Player {
  void play() {}
}

mixin MusicPlayer on Player {
  @override
  void play() {
    super.play();

    print('music play');
  }
}

mixin VideoPlayer on Player {
  @override
  void play() {
    super.play();

    print('video play');
  }
}

class IPhone extends Player with MusicPlayer, VideoPlayer {
  @override
  void play() {
    super.play();

    print('play in iPhone');
  }
}
```

- 여러 class계층에서 재사용이 가능하도록 해주는 modifier
- `with`키워드를 사용하여 다중 mixin이 가능함
- `on`키워드를 사용하여 특정 superClas를 지정할 수 있음
- 생성자 선언 불가


<br><br>

### base

```dart
base class Vehicle {
  final String name;
  Vehicle(this.name) {
    print('vechicle init');
  }

  int get _price => 1000;
}

base class Car extends Vehicle {
  Car(super.name) {
    print('car init, price: $_price');
  }
}

```

- 상속이나 mixin구현을 강제로 시키기 위해 사용
- 타 라이브러리에선 구현(implements) 불가
- subClass 생성자에서 superClass 생성자 자동호출
- base class 를 상속하거나 구현하려면, `base, final, sealed` modifier중 하나를 사용해야 함

<br><br>

### final

```dart
final class Vehicle {
  void go() {}
}

base class Car extends Vehicle {}

```

- 클래스 계층화를 막기 위해 사용하며, 타 라이브러리에서 상속 및 구현이 모두 불가능하다.
- base modifier를 포함하기 때문에 해당 클래스를 상속하거나 구현하려면 base class 처럼 subClass에 `base, final, sealed` modifier중 하나를 사용해야 함

<br><br>

### sealed

```dart
sealed class State {}

class InitialState extends State {}

class InLoadingState extends State {}

class LoadedState extends State {}

String currentState(State state) {
  switch (state) {
    case InitialState():
      return 'init';
    case InLoadingState():
      return 'loading';
    case LoadedState():
      return 'loaded';
  }
}
```

- subClass들이 열거되는 형식일 때 사용하며, switch문 사용이 가능함
- 암묵적으론 abstract와 동일하다고 하는데, subClass들은 abstract가 아님
- final과 같이 타 라이브러리에서 상속, 구현이 불가능함