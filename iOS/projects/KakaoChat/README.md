<p align="center">
  <img src="https://user-images.githubusercontent.com/56511253/122338236-6907a300-cf7a-11eb-9a19-bea1026cdab0.jpg" width="100">
  <h3 align="center"> Kakao Chat </h3>
</p><br><br>

## Index
- [Index](#index)
- [OverView](#overview)
- [About The Project](#about-the-project)
  - [Main Component Used](#main-component-used)
  - [Learning Contents](#learning-contents)
  - [Result](#result)
  - [To Learn](#to-learn)
<br><br><br>

## OverView
Firebase Realtime Database 를 이용한 Chatting Program.
<br><br>

## About The Project

<div align = "center">
<img src="https://user-images.githubusercontent.com/56511253/122335495-57bc9780-cf76-11eb-92ac-a7a9607cfff9.png" width = "20%">
&nbsp&nbsp&nbsp
<img src="https://user-images.githubusercontent.com/56511253/122335348-17f5b000-cf76-11eb-9f99-67b332b01c60.png" width = "20%">
&nbsp&nbsp&nbsp
<img src="https://user-images.githubusercontent.com/56511253/122335368-1cba6400-cf76-11eb-87ba-49733b9adc60.png" width = "20%">
&nbsp&nbsp&nbsp
<img src="https://user-images.githubusercontent.com/56511253/122335372-1fb55480-cf76-11eb-96b4-4b08b9e12e99.png" width = "20%">
</div>
<br><br>

### Main Component Used
- Firebase Real-time DB
- Firebase Storage

<br>

### Learning Contents
- Firebase 를 이용해 로그인, 회원가입 구성하기.
- Firebase Database Reference 를 이용하여 Real-time DB 에 Data 읽기 및 쓰기.
- StoryBoard 를 사용하지 않고 Code 로 View 를 구성.
- 비 동기 Data 수신시, DispatchQueue 와 Closure 를 사용하여 적절히 처리하기.
<br><br>

### Result
<br>

<div align = "center">
<img src="https://user-images.githubusercontent.com/56511253/122338626-eb906280-cf7a-11eb-943d-184aa857fc92.gif" width = "20%">
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<img src="https://user-images.githubusercontent.com/56511253/122338996-71aca900-cf7b-11eb-936e-bb41c2cd55a9.gif" width = "20%">
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<img src="https://user-images.githubusercontent.com/56511253/122339434-0f07dd00-cf7c-11eb-815a-160e1e03f967.gif" width = "20%">
</div><br>

- 왼쪽부터 차례대로 **회원가입**, **로그인**, **채팅** 순서이다.
- 이름, 이메일, 비밀번호, 프로필 사진 을 이용하여 회원가입을 진행하며, 이메일과 비밀번호로 로그인을 한다. real-time DB 에 저장된 모든 user 들을 불러와 친구 목록으로 보여주며, 원하는 user 를 선택하여 1:1 로 채팅할 수 있도록 구현했다.
<br><br>


### To Learn

- observer pattern 을 사용하면 더욱 간결하게 코드를 설계할 수 있다.
- completion closure 외에 다른 비 동기 data 수신 처리 방식 필요.
- 코드로 view 를 구성하기 때문에, view 구성과 비지니스 로직 구성을 분리시켜야 가독성이 높아진다.
- convenience init 을 사용하여 원하는 형식으로 초기화를 할 수 있도록 하면, 가독성이 높아진다.