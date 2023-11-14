# Daily Alarm
- ### Local Notification 을 사용하여 간단한 알람 App 을 만들어보자 ⏰

<br><br>

## 사용한 Framework
- [x] User Notifications
<br><br>

## 프로젝트 세부내용

#### 2021.01.29
- [x] Alarm TableView 구성
- [x] Launch Screen 구성
- [x] Floating Button 만들기
- [x] Custom Half Modal View 생성
- [x] Alarm Model 설계
<br>

#### 2021.02.02
- [x] Quick Alarm, Normal Alarm View 구현
- [x] TableView와 연동
- [x] Local Notification 생성 및 notification 확인
- [x] TableView EditMode 

<br><br>


## 결과
![](https://images.velog.io/images/sangwoo24/post/cae5d07b-94e8-407d-b8ef-99e87f5d56fe/ezgif.com-resize.gif)
<br><br>

## 알게 된 점

- Notification 사용법
- Closure 변수를 통한 View 간 Data 송 수신
- Tap gesture
<br><br>


## 실패한 것

- Local Notification Sound
  - NotificationContent 의 Sound Property 에 다양한 값들을 넣고 실험해봤지만, Default sound 에서 바뀌지 않는다.
  - 근데 또 sound 를 nil 로 설정하면 sound가 들리지 않는다. 그렇다면 분명 설정이 되는 것 같긴 한데 왜 sound 가 바뀌지 않는지 모르겠다. 이건 추후 다시 해볼 예정이다.