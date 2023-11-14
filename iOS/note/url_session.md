# URLSession
- Overview

    > An object that coordinates a group of related, network data-transfer tasks.<br>
    -> 관련된 네트워크 데이터 전송 task 그룹을 조정하는 개체 <br><br>
    즉, 다양한 인터넷 프로토콜과 상호작용 하여 데이터를 송, 수신 하기위해 사용하는 Object 이다. 앱이 정지된 상태에서도 해당 API를 이용하여 백그라운드로 다운로드를 수행할 수 있다. 

- 앱은 하나 이상의 Session을 생성한다. 이 Session은 관련 데이터 전송 task 들을 관리하게 된다.
- 각 세션 내에서 앱은 특정 URL에 대한 요청을 나타내는 task들을 추가한다.<br><br>


    ![](https://images.velog.io/images/sangwoo24/post/09a91816-6bed-45ca-aa86-d1ee60ef2f56/1.PNG)

> - URLSessionConfiguration : URLSession 생성 <br>
> - URLSessionTask : URLSession 이 Task를 생성한 후 Server와 통신한다<br>
> - Delegate : 네트워킹의 중간 과정을 살펴볼 수 있다

<br><br>

## URLSession의 Request와 Response
- URLSession은 다른 HTTP 통신과 마찬가지로 `Request` 와 `Response` 의 구조를 가진다.<br>

    ### Request
    1. `URL` 객체를 통해 직접 통신
    2. `URLRequest` 객체를 만든 뒤, 옵션을 설정하여 통신
    
    ### Response
    1. Task의 `Completion Handler` 형태로 response를 수신
    2. `URLSessionDelegate` 를 통해 지정된 메소드를 호출하는 형태로 response를 수신

<br>

- 간단한 Response에서는 `Completion Handler` 를 사용하지만, 앱이 Background 상태로 들어갈 때에도 파일 다운로드를 지원하도록 설정하거나, 인증과 캐싱을 default 옵션으로 사용하지 않는 상황과 같은 경우에는 `Delegate` 패턴을 사용한다.

<br><br>

## URLSession Session Type

> URLSession class는 기본적으로 싱글톤 객체인 `shared session`이 존재한다. 하지만, 다른 종류의 Session을 사용 할 경우 아래의 세 가지 Configuration중 하나를 사용하여 URLSession을 만든다.

- Default session : 기본적인 Session으로 디스크 기반 캐싱을 지원한다.
- Ephemeral session : 캐시, 쿠키, 사용자 인증 정보 등을 디스크에 쓰지 않는다.
- Background session : 앱이 실행되지 않는 동안 백그라운드에서 컨텐츠 업로드 및 다운로드를 수행할 수 있다.
<br><br>


## URLSession Task Type

> Task 객체는 일반적으로 Session 객체가 서버로 Request를 보낸 후, Response를 받을 때 URL 기반의 내용들을 Retrieve 하는 역활을 한다.

- Data Task : NSData Object 형태로 데이터를 송, 수신 하며, Background를 지원하지 않는다.
- Upload Task : Data를 File의 형태로 전환 후 Upload하는 Task 객체로, 백그라운드로 업로드를 지원한다.
- Download Task : Data를 File의 형태로 전환 후 Download하는 Task 객체로, 백그라운드 업로드 및 다운로드를 지원한다.
<br><br>


## 🍎 Singleton session 사용
1. 세션 생성 
   ```swift
   let session = URLSession.shared
   ```
   - 싱글톤 객체인 `shared` 를 사용한다.

<br>
  
2. RequestURL 생성
    ```swift
            guard let requestURL = makeURL(person: person) else {
            print("--> URL error")
            return
        }
    ```
    - makeURL 은 URL Optional Type 으로 guard let 을 사용했다.

<br>

3. dataTask 생성
    ```swift
            let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            // error check
            guard error == nil else { return }
            
            // statusCode check
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            let successRange = 200..<300
            guard successRange.contains(statusCode) else { return }
            
            // data check
            guard let resultData = data else { return }

            do{
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: resultData)
                let tracks = response.tracks
                
                print("--> tracks: \(tracks)")
            } catch let error {
                print("--> error \(error.localizedDescription)")
            }
        }
    ```
    - 구성 요소들을 제대로 확인하기 위해 예외처리를 하나로 묶지 않았다
    - 임의의 struct인 `Response의` Type으로 `decoding` 시킨 후 내부 Property인 `traks`를 print 해봄으로서 Json 형식의 Data가 `Decoding` 되었는지 확인한다.
    - struct `Response` 는 `Codable Protocol` 을 준수해야 한다.

<br>

4. Task 실행
   ```swift
   dataTask.resume()
   ```
   - `resume` 으로 task를 실행한다.

<br><br>



## 🍟 Delegate 사용
> 세션의 델리게이트는 세션의 라이프 사이클 내에서 발생하는 변경에 따라 이를 처리하는 메소드를 제공하면서 동시에 세션 내에서 생성된 작업 객체의 라이프 사이클에 따른 이벤트도 함께 처리한다.

- `Delegate` 는 최소한 다음과 같은 두 가지의 이벤트를 처리해줘야 한다.
<br>

  #### 1. 서버로부터 응답 데이터 조각을 받았을 때, 이 데이터를 처리 

  #### 2. 서버로부터 모든 응답을 받고 통신이 종료되었을 때 이를 처리
<br><br>

### 특징
- `Delegate` 를 사용하면 일정량의 데이터를 수신할 때마다 1이 호출되기 때문에 통신의 전체 진행과정을 볼 수 있다.
- 응답 Data를 누적하여 수집하는 임무는 `Delegate` 의 일이며, `session` 이나 `task` 객체는 이에 대한 책임을 지지 않는다.

<br><br>

1. Delegate 구현
   ```swift
    class MyDelegate : NSObject {

    }

    extension MyDelegate : URLSessionDataDelegate {
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)     {
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                let tracks = response.tracks
                print("--> tracks : \(tracks)")
            } catch let error {
                print("--> error : \(error.localizedDescription)")
            }
        }
    }

    extension MyDelegate : URLSessionTaskDelegate {
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            print("--> Task complete!!!")
            session.invalidateAndCancel()
        }
    }
   ```
   - didReceive : NSData 형태로 Data 를 받은 후에 작업할 일
   - didCompleteWithError : Task 가 종료될 때 호출

<br>

2. session 및 Request URL 생성
    ```swift
    let session = URLSession(configuration: .default, delegate:MyDelegate(), delegateQueue: .current)
    guard let requestURL = makeURL(person: person) else { return }
    ```
    - shared 세션이 아닌 default 세션을 만든 후 delegate를 지정해준다.
    - delegate 속성은 읽기 전용이다.

<br>

3. Data Task 생성 및 실행
    ```swift
    let dataTask = session.dataTask(with: requestURL)
    dataTask.resume()
    ```
    - Task를 만들 때 보면 shared로 세션을 생성했을 때와 차이점을 볼 수 있을 것이다.

<br>

4. Session 삭제
   ```swift
   session.invalidateAndCancel()
   ```
   - Delegate 패턴을 사용할 시 session을 사용하고 난 뒤에는 세션을 제거해야 한다. 자세한 이유는 아래에 적어놨다.

<br>

### ⭐️ Important
> 통상 `Delegate`를 사용하는 경우에, `Delegate Property` 는 약한 참조 혹은 소유하지 않는 참조를 사용하는데, 세션 객체의 경우 `Delegate` 에 대해서 강한 참조를 가진다. 따라서 <b> `메모리 누수` </b> 를 방지하기 위해서 세션의 사용이 끝났을 때, 세션을 제거하여 `Delegate`가 앱 종료시까지 메모리에 유지되지 않도록 주의한다.
