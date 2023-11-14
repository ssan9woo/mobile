# iOS Weather App
- ### Open API 를 사용하여 위치에 대한 날씨를 보여주는 어플을 만들어보자
    ![](https://images.velog.io/images/sangwoo24/post/f01d3a8a-299e-4a2d-84f5-340f40cf1894/ezgif.com-video-to-gif.gif)

<br>

## 프로젝트 세부내용
- `Open API` : https://openweathermap.org 에서 사용.

- `JSON` 형태의 Data 를 받아와 사용.
- 기본적인 방식은 [MyNetflix](https://github.com/sangwoo24/ios-Develop/tree/master/iOS%20Project/MyNetflix) 프로젝트와 유사함.

<br>

## 새롭게 알게 된 것들
- CoreLocation 을 이용하여 위치 기반 서비스 사용
- Container View의 사용
- UITableViewCell Animate

<br>

## 단계별 구성순서

#### 2021.01.21
- [x] Model 재정의
- [x] 주소 -> 좌표 변환 찾기.
- [x] SearchView Component 찾기
- [x] SearchBar 생성
- [x] 현재 위치 기본 Cell 만들기
- [x] Search 할 시, String 값을 주소로 변환하여 해당 주소에 대한 날씨 Data 수신

<br>

#### 2021.01.22
- [x] self model -> viewModel
- [ ] 첫 번째(현재위치) Response 받지 못할경우? 첫번째 셀은 뭐로채우나?? -> default : 서울로 go
- [x] 첫 번째 Cell 처리
- [x] Search 시 Cell 처리
- [x] 각 cell delegate 처리 -> WeatherView Controller로
- [x] WeatherView Controller의 각 Container ViewController 초기화 수
- [x] CurrentView ContainerView Outlet 연결

<br>

### 2020.01.23
- [x] 위치 Text 찾기
- [x] CurrentView Data mapping
- [x] Hourly, Daily View Data mapping
- [x] View design

<br>

### 2020.01.24
- [x] SearchTableView Accessory mode
- [x] Delete, move 추가
- [x] indicator 추가
- [x] launch screen

<br>

