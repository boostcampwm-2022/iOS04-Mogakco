<img src="https://user-images.githubusercontent.com/86254784/207755078-06711011-268b-4b6e-82ac-d33ffe86628f.png">

 
### 🧑🏻‍💻 모여서 각자 코딩 👩🏻‍💻  



  
<p align="left">
  <a href="https://apps.apple.com/kr/app/%EB%AA%A8%EA%B0%81%EC%BD%94/id6444737400"><img height=70 src="https://user-images.githubusercontent.com/86254784/207811927-21d4df1e-669b-4a52-a5cc-26d31ccb2626.png">
 <a href="https://apps.apple.com/kr/app/%EB%AA%A8%EA%B0%81%EC%BD%94/id6444737400"> <img src="https://user-images.githubusercontent.com/86254784/207810834-d72ca8c7-59fd-4d0e-82d1-76bd3f2ed7ac.png" height=70>
</p>
  
> **개발자 스터디 통합 커뮤니티 플랫폼 ‘모각코’입니다.**

- 원하는 스터디를 만들고 참여할 수 있습니다.
- 관심있는 언어, 카테고리를 고를 수 있습니다.
- 함께하는 스터디원과 채팅을 할 수 있습니다.

<p align = "center">

| <img src="https://avatars.githubusercontent.com/u/73675540?v=4" width="200"> | <img src="https://avatars.githubusercontent.com/u/109145755?v=4" width="200"> | <img src="https://avatars.githubusercontent.com/u/75964073?v=4" width="200"> | <img src="https://avatars.githubusercontent.com/u/86254784?v=4" width="200"> |
| ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| **S005\_김범수**                                                             | **S026\_신소민**                                                              | **S030\_오국원**                                                             | **S043\_이주훈**                                                             |
| [@beomsoo0](https://github.com/beomsoo0)                                     | [@sominn9](https://github.com/sominn9)                                        | [@oguuk](https://github.com/oguuk)                                           | [@juhoon-lee](https://github.com/juhoon-lee)                                 |

</p>

## **주요 기능 소개**

### **스터디 생성 및 참여 기능**

<p>
<img alt="스터디" src="https://user-images.githubusercontent.com/86254784/207770387-4814f769-c904-4972-b760-2fa926281b59.png">
</p>

### **스터디원들과 채팅하기**

<img alt="채팅" src="https://user-images.githubusercontent.com/86254784/207770500-60b027a1-5395-48ea-8a02-515e6ffa6703.png">

### **프로필 정보 확인**

<img alt=" 프로필" src="https://user-images.githubusercontent.com/86254784/207770549-8b80c295-7370-415d-abff-91b1bad837a9.png">

### **시연 영상**

[![시연 영상](https://user-images.githubusercontent.com/86254784/207779809-9a53db40-2620-4bc5-a120-75b028517dbf.jpeg)](https://youtu.be/BBaBAikJPl4)

## **실행 화면**

| 로그인, 회원가입 | 스터디 목록(정렬, 필터링) | 스터디 참여 |
| ---------------- | ------------------------- | ----------- |
| ![회원가입](https://user-images.githubusercontent.com/86254784/207792906-0675cd63-acc7-4a24-a2ae-6b9e2957667c.gif)| ![정렬 필터링](https://user-images.githubusercontent.com/86254784/207793078-456db56c-b75a-4f1e-b901-58b6f0f42cd9.gif)|![스터디 참여](https://user-images.githubusercontent.com/86254784/207793864-1e14f3d0-fd26-4118-9217-2d89b1afb5fa.gif)|
| 스터디 생성      | 채팅                      | 프로필      |
| ![스터디 생성](https://user-images.githubusercontent.com/86254784/207795259-054d39d7-77ea-485c-bb1e-2caa72efe58b.gif)|![채팅](https://user-images.githubusercontent.com/86254784/207795485-4c078a9d-b265-49d4-8e3d-7c04105f5d25.gif)|![프로필](https://user-images.githubusercontent.com/86254784/207795926-75ae4c8e-ffbb-4031-8f24-92084365356c.gif) |

---

## **⚒️ 기술적 도전**

### **Clean Architecture**

<img alt="클린아키텍쳐" src="https://user-images.githubusercontent.com/86254784/207780189-8b1b1b08-5d3c-41cc-8df7-62b2d4fbf100.png">

**Why**
5주라는 짧은 기간 안에 앱스토어 출시라는 타겟을 잡았고, 이후 제품을 추가적으로 develop하게 되면 서버와 디자인에 가변적인 상황이 벌어질 수 있을 것이라 생각했습니다. 비즈니스 로직을 앱의 핵심적인 파트로 보고 결합도를 낮출 수 있는 구조 설계를 고민하였고, Clean-Architecture의 철학이 저희의 목적과 일치하다고 판단하여 채택하였습니다.

**Result**

- View - ViewModel - UseCase - Repository - DataSource로 레이어를 나누고 모든 의존성이 outer에서 inner를 향하도록 구현하였습니다.
- 서버에서 온 데이터의 모델과 앱 내에서 사용되는 데이터의 모델을 분리하여 서버의 변경에 유연하게 대처할 수 있었습니다.
- Repository 패턴을 이용해 DataSource를 캡슐화했습니다.
- 앱의 핵심적인 로직인 UseCase를 작은 기능의 단위로 나누어 단일 책임 원칙을 준수하도록 구현하여 재사용성을 높여 생산성을 높일 수 있었습니다.
- 계층과 모듈의 역할이 명확하게 분리되어 코드 가독성, 재사용성, 테스트 코드 작성 시 리소스 절감으로 이어졌습니다.

---

### **RxSwift + MVVM**

<img alt="Coodinator" src="https://user-images.githubusercontent.com/86254784/207780194-e8af1149-f392-4266-aa68-162b0fcc2c33.png">

**Why**

사용자 입력 및 뷰의 로직과 비즈니스에 관련된 로직을 분리하기 위해 MVVM 패턴을 채택하고 데이터 흐름을 단방향으로 관리하기 위해 ViewModel을 Input과 Output으로 모델링하였습니다.

**Result**

- Input에 대한 처리 결과를 Output에 담아서 보낼 때 RxTraits를 사용하여 Thread-Safe하게 UI를 업데이트할 수 있었습니다.
- ViewController에 의존하지 않고 테스트 용이한 구조의 ViewModel을 구성할 수 있었습니다.

---

### **Coordinator**

<img alt="RXMVVM" src="https://user-images.githubusercontent.com/86254784/207780195-1d2a6544-c57b-425b-885c-2fae7af3a87b.png">

**Why**

화면 전환 로직을 ViewController에서 분리하기 위해 Coordinator 패턴을 도입했습니다.

**Result**

- 코디네이터로 화면 전환 로직이 모이게 되면서 전체 흐름을 파악하기 쉬워졌습니다.
- 의존성 주입 코드를 코디네이터로 분리할 수 있었습니다.
- ViewController를 더 가볍고 쉽게 재사용할 수 있게 되었습니다.

---

### **DI Container**

**Why**

화면 전환을 담당하는 Coordinator에서 의존성 주입의 역할을 분리하기 위해 DIContainer를 도입했습니다.

**Result**

- 의존성 주입에 대한 보일러 플레이트 코드가 감소했습니다.
- 의존성 주입을 한 곳에서 관리할 수 있게 되었습니다.

---

### **Firebase + REST API**

**Why**

서버 개발자없이 프로젝트를 진행하기 위해 Firebase를 사용했습니다. 그러나 Firebase SDK에 대한 의존도를 낮추고자 REST API를 이용하여 네트워크 통신을 진행했습니다.

**Result**

- 한가지 액션에 대한 다중 네트워크 호출 처리를 Data Layer에서 진행하여 다른 Layer에 영향을 끼치지 않도록 구현하였습니다.
- 외부 라이브러리에 대한 의존성을 낮추기 위해 자체 네트워크 레이어를 구현하였고, 템플릿화된 코드 덕분에 Endpoint의 재사용성이 올라갔습니다.
- Firebase REST API 통신으로 인한 복잡한 요청∙응답에 맞는 DTO를 모델링하였습니다.

---

### **Tuist**

<p>
<img width = "50%" alt="tuist1" src="https://user-images.githubusercontent.com/86254784/207780843-1b303ffa-d7ac-42b5-8ebb-1add1d1a3c01.png">
<img width = "45%" alt="tuist2" src="https://user-images.githubusercontent.com/86254784/207780860-531eedfd-5f57-4dfb-bdfa-772c61d35642.png">
</p>

**Why**

협업 초반 반복되는 `.xcodeproj` 파일의 충돌로 생산성 저하를 느꼈고, 수동적인 해결에 의존하기보다 자동화 시킬 수 있는 프로젝트 관리 툴의 필요성을 느꼈습니다.

**Result**

- `.xcodeproj` 파일 conflict 문제 해결로 생산성 저하 문제를 해결할 수 있었습니다.
- 자체 Animation, Image Cacher, Network Layer를 모듈화하여 관리할 수 있었습니다.

---

### **Animation**

|런치 애니메이션|스켈레톤 애니메이션|
|--|--|
|![로그인 애니메이션](https://user-images.githubusercontent.com/86254784/207800065-728d56e9-a379-4ad2-8f89-c91f6f2fb29b.gif)|![스켈레톤](https://user-images.githubusercontent.com/86254784/207800059-8c3b764a-4879-4ce9-bed8-eda25236cb3d.gif)|


**Why**

개발자들을 위한 플랫폼이라는 앱의 정체성을 UI적으로 표현하고, 데이터를 불러오는 동안 작업이 진행되고 있음을 사용자에게 알리기 위해 커스텀 애니메이션을 구현했습니다.

**Result**

비동기 작업이 진행되는 동안 화면에 Skeleton View를 배치하여 UX를 향상시킬 수 있었습니다.

---

## **협업 방식**

### **Github**

- 이슈를 **세부적인 단위**를 작게 가져가려 노력하여, 효율적인 **코드 리뷰**를 진행할 수 있었습니다.
  - 6주간 약 **900개의 commit**
  - 6주간 약 **420개의 Issue 및 PR** 해결
  - 평균 10개 이상의 PR comment
- 모든 브랜치에 2명 이상이 approve를 해야 PR이 merge되도록 설정하였습니다.

### **Zenhub**

<img width="1236" alt="젠헙" src="https://user-images.githubusercontent.com/86254784/207796474-5aba875e-6a7b-4137-b0b0-a0fd245d6723.png">

- **제품 백로그**를 스프린트 기간마다 **스프린트 백로그**로 할당하여 **애자일**하게 개발을 진행하였습니다.
- 이슈마다 **Estimate**을 기반으로 일정을 산출하여 기간 내 **제품을 배포**할 수 있었습니다.
- **칸반** 기능을 적극 활용하여 팀원 간의 **작업 현황을 공유**할 수 있었습니다.

### **Slack**

![슬랙](https://user-images.githubusercontent.com/86254784/207796437-8a195eb8-bb33-4ef6-9c4b-f3ac1737b2b3.png)

- **Github** 앱을 활용해 Repository와 연동을 통해 작업 현황을 공유하고 **커뮤니케이션**을 더 효율적으로 가져갈 수 있었습니다.
- Picker 앱을 활용해 Scrum 진행자를 선정하여 진행하였습니다.

### **Convention**

<img width="657" alt="소통" src="https://user-images.githubusercontent.com/86254784/207796358-0656e549-d140-44e0-a5f6-8465bd7d055c.png">

- StyleShare의 **code-convention**을 모각코 팀의 스타일에 맞춰 커스텀하여 사용했습니다.
- Code-convention 준수를 위해 **SwiftLint**를 적용하였습니다.
- **Git-hooks**를 이용해 **code, commit convention**을 지키지 못한 내용은 commit되지 않도록 **자동화**하였습니다.

### **Misc.**

- 스프린트 미팅을 통해, 스프린트 기간동안 업무 목록을 설정하고 공유하였습니다.
- 매일 아침 데일리 스크럼에서 오늘의 기분과 업무 상태를 공유하는 소통 시간을 가졌습니다.
- 모든 스크럼은 상세하게 문서화하였습니다.
- Issue, PR, Scrum Template을 만들어 문서화를 했습니다. [위키](https://github.com/boostcampwm-2022/iOS04-Mogakco/wiki)
