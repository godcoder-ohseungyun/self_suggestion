# self_suggestion

사용자가 직접 선정한 자기암시 문장을 예약한 시간에 알림센터에 표시해주는 앱



### 구현할 기능 목록

~~**사용자 입력(자기 암시 문장)을 CRD하는 기능**~~ HomeScreen - Suggestions - NotificationManager
+ **[주의]** 활성화 여부 수정시 '알림'을 재설정 해야한다
  + 알림 예약 목록을 통해, 해당 시간에 알림을 모두 교체한다

</br>

~~**사용자 입력(자기 암시 문장)을 리스트 형태로 화면에 보여주는 기능**~~ HomeScreen - Suggestions
+ 왼쪽, 혹은 오른쪽으로 스와이프시 해당 리스트 요소는 제거되야한다 (사용자 손 잡이에  따라 결정)
+ 해당 리스트 요소 왼쪽에 '체크박스'를 통해 활성화 여부를 확인할 수 있어야한다
+ **[주의]** 활성화 되어있는 리스트 요소를 정렬상 우선순위로 한다 (화면 상단에 차례로 표시)

</br>

~~**알람을 설정하는 기능**~~ HomeScreen - NotificationSetScreen - NotificationManager - OfflineNotification - Notifications
+ **[주의]** 현재 활성화 되어있는 모든 '자기 암시 문장'을 가지고 알림을 맞춘다
+ **[주의]** 중복된 시간에 사용자가 알림을 저장하려고하면 "이미 존재하는 알림입니다"라는 문구를 표시한다
+ **[주의]** 활성화 되어있는 '자기 암시 문장'이 없는 경우 "활성화된 문장이 없습니다"라는 문구를 표시한다
+ 다이얼을 통해 시, 분을 맞춘다
+ 저장 시 "알림이 저장되었습니다" 라는 문구와 함께 '알림 예약 목록'으로 이동한다

</br>

~~**알림 예약 목록을 화면에 보여주는 기능**~~ HomeScreen - NotificationListScreen - Notifications
+ 알림 설정을 통해 맞춘 시, 분을 리스트로 화면에 표시해야한다
+ 왼쪽, 혹은 오른쪽으로 스와이프시 해당 리스트 요소는 제거되야한다 (사용자 손 잡이에  따라 결정)
    + 제거시 시스템에 예약된 알림도 제거해야한다

</br>

~~**추천 자기 암시 문구를 제공하는 기능**~~ HomeScreen - RecommendedSuggestionListScreen - RecommendedSuggestions - assets/txt/.txt
+ 추천 자기 암시 문구를 사용자가 스와이프시 사용자 목록에 자동으로 추기된다
+ 사용자 목록에 저장되었더라도 활성화는 사용자가 직접 해야한다


</br>

~~**main에서 싱글톤 객체들을 호출해 초기화 작업을 완수한다**~~ 
+ 기기 타임 데이터 초기화 및 타임존 추적 기능, 정확한 기기의 타임정보가 필요한 경우 TimzoneGenerator로 부터 타임 존을 불러와 사용한다
+ Suggestions initial
+ Notifications initial
+ OfflineNotifications initial
+ RecommendedSuggestions initial

</br>

앱 가이드 페이지 만들기
+ 앱 최소 시작시 스타터스크린이 나오며, 시작하기 버튼, 가이드 보기 버튼, 다신 보지 않음 채크 박스가 있다
+ 시작하기 버튼 : HomeScreen으로 이동
+ 가이드보기 버튼 : 가이드 블로그로 이동
+ 다신 보지않음 채크 : 스타터 스크린을 다시 보지 않게한다
+ HomeScreen 책 모양 아이콘을 누르면 스타터 스크린이 나온다

앱 후원 페이지 만들기

~~앱 아이콘 만들기~~

~~앱 작명 및 알림 제목 수정하기~~

</br>

### 테스트 목록

**자기 암시 문구 테스트**
+ 하단 + 버튼을 통해 자기 암시 문구를 추가할 수 있다
+ 자기 암시 문구를 스와이프하면 화면 및 데이터 베이스에서 삭제된다 (사용자 손 잡이에 따라 스와이프 방향이 다르다)
+ 자기 암시 문구를 활성화(check)할 수 있다
+ 자기 암시 문구를 비활성화(uncheck)할 수 있다

</br>

**알림 테스트**
+ 하단 왼쪽 아이콘을 통해 알림을 설정하면, 현재 활성화 된 목록을 기준으로 알림이 등록 되어야 한다
+ 등록된 알림은 하단 오른쪽 아이콘을 통해 확인할 수 있다
+ 활성화 된 자기 암시 문구를 삭제한 경우, 현재 활성화 된 목록을 기준으로 알림이 재 등록 되어야 한다
+ 기존 및 새로운 자기 암시 문구를 활성화 한 경우, 현재 활성화 된 목록을 기준으로 알림이 재 등록 되어야 한다
+ 기존 자기 암시 문구를 비 활성화 한 경우, 현재 활성화 된 목록을 기준으로 알림이 재 등록 되어야 한다
+ 오른쪽 아이콘에 관리되는 알림 목록을 스와이프하면 해당 알림이 삭제되어야한다 (사용자 손 잡이에 따라 스와이프 방향이 다르다)

</br>

**안내 테스트**
+ 하단 왼쪽 아이콘을 통해 알림을 설정하면, 다음 안내가 나와야 한다
  + 활성화된 자기 암시 문구가 없는 경우 : 활성화된 문구가 없습니다.
  + 문제가 발생한 경우 : 문제가 발생했습니다. 다시 시도해 주세요.
  + 정상적으로 등록된 경우 : 알림이 예약되었습니다. 이따 뵈요!

