# DeepLink

```
사용자를 특정 앱으로 이동시켜서 원하는 화면을 보여주거나, 사용자 액션을 유도하는 링크.
```

<br><br>


### 🌵 URI Scheme

![](https://velog.velcdn.com/images/ssan9woo/post/bbb78d8d-ffdd-4248-b770-a396d0dc9360/image.png)

앱에 Scheme 값을 등록하여 사용하는 딥 링크 방식이다. Scheme은 각 앱의 고유한 값인데, URL Scheme 방식에서는 내 앱의 Scheme가 고유한 값인지 확인할 수 없기 때문에 각 Scheme값이 중복될 수 있다. 

iOS에서는 Scheme가 중복될 시 가장 마지막에 설치한 앱이 열리며, AOS에서는 어떤 앱으로 열지 선택하는 팝업이 뜬다. 이와 같은 이유 때문에 나온 방식이 `Universal Link` 와 `App Link` 다.

<br><br>

### Universal Link, App Link
URI Scheme 방식의 한계점을 보완하기 위해 출시한 딥링크 방식이며, 웹에서 사용하는 도메인 주소를 딥링크 실행 값으로 사용하는 방식이다.

스마트폰 브라우저 주소창에 [http://naver.com](http://naver.com)을 입력하면 네이버 앱이 바로 오픈되는 것과 같은 기능. 스마트폰에 앱이 설치되어있지 않다면, 브라우저에서 도메인 주소에 해당하는 웹페이지가 열린다. App의 고유한 도메인 주소를 사용할 수 있지만, 모든 환경에서 딥링크가 동작하는 것이 아니기 때문에 URL Scheme 방식과 같이 사용해야 한다. [링크 테스트 결과](https://help.dfinery.io/hc/ko/articles/360039757433-%EB%94%A5%EB%A7%81%ED%81%AC-Deeplink-URI%EC%8A%A4%ED%82%B4-%EC%9C%A0%EB%8B%88%EB%B2%84%EC%85%9C-%EB%A7%81%ED%81%AC-%EC%95%B1%EB%A7%81%ED%81%AC-%EA%B5%AC%EB%B6%84%EA%B3%BC-%EC%9D%B4%ED%95%B4#toc7)

<br><br>

### 🍎 Direct DeepLink

![](https://velog.velcdn.com/images/ssan9woo/post/f3eceaea-aa66-4ec0-b575-cf3c237119de/image.png)

초기 딥링크의 형태로, 앱이 설치되어 있다면 특정 페이지로 랜딩되지만, 앱이 설치되어있지 않다면 각 플랫폼의 스토어로 이동되며 설치 후 앱을 열면 링크가 유실된다.

<br><br>

### 🌤️ Deferred DeepLink

![](https://velog.velcdn.com/images/ssan9woo/post/611764fd-9c25-4db7-8374-2c8080936089/image.png)

Direct 딥링크 방식의 문제점을 해결하기 위해 나온 딥링크 방식이다. 앱을 설치 후에도 링크가 유실되지 않도록 하며, 앱 설치 후 실행 시 딥링크에 해당하는 페이지로 랜딩된다.

딥링크 솔루션 업체(Firebase, AppsFlyer, Airbridge...) 에서 쉽게 사용할 수 있도록 지원을 해주기 때문에 외부 솔루션을 사용하는 경우가 많다. App이 설치되지 않은 사용자는 링크를 클릭할 시 솔루션 업체의 DB에 링크 정보를 저장한 뒤, 앱을 실행시켰을 때 해당 솔루션 업체 관련 SDK에서 DB에 존재하는 딥링크 정보를 가져와 랜딩한다.

<br><br>

### 🍊 One Link
Deferred DeepLink는 각각의 플랫폼 별로 링크를 생성해야 하기 때문에 두 번 작업을 해야하는데, 이러한 문제를 해결하기 위해 각 솔루션 업체들은 하나의 링크에서 각 플랫폼별로 분기를 시켜주는 딥링크인 `OneLink` 를 만들었다.
