# self_suggestion

사용자가 직접 선정한 자기암시 문장을 예약한 시간에 알림센터에 표시해주는 앱



### 구현할 기능 목록

~~**사용자 입력(자기 암시 문장)을 CRD하는 기능**~~
+ **[주의]** 활성화 여부 수정시 '알림'을 재설정 해야한다
  + 알림 예약 목록을 통해, 해당 시간에 알림을 모두 교체한다

</br>

~~**사용자 입력(자기 암시 문장)을 리스트 형태로 화면에 보여주는 기능**~~
+ 왼쪽, 혹은 오른쪽으로 스와이프시 해당 리스트 요소는 제거되야한다 (사용자 손 잡이에  따라 결정)
+ 해당 리스트 요소 왼쪽에 '체크박스'를 통해 활성화 여부를 확인할 수 있어야한다
+ **[주의]** 활성화 되어있는 리스트 요소를 정렬상 우선순위로 한다 (화면 상단에 차례로 표시)

</br>

**알람을 설정하는 기능**
+ **[주의]** 현재 활성화 되어있는 모든 '자기 암시 문장'을 가지고 알림을 맞춘다
+ **[주의]** 중복된 시간에 사용자가 알림을 저장하려고하면 "이미 존재하는 알림입니다"라는 문구를 표시한다
+ **[주의]** 활성화 되어있는 '자기 암시 문장'이 없는 경우 "활성화된 문장이 없습니다"라는 문구를 표시한다
+ 다이얼을 통해 시, 분을 맞춘다
+ 저장 시 "알림이 저장되었습니다" 라는 문구와 함께 '알림 예약 목록'으로 이동한다

</br>

**알림 예약 목록을 화면에 보여주는 기능**
+ 알림 설정을 통해 맞춘 시, 분을 리스트로 화면에 표시해야한다
+ 왼쪽, 혹은 오른쪽으로 스와이프시 해당 리스트 요소는 제거되야한다 (사용자 손 잡이에  따라 결정)
    + 제거시 시스템에 예약된 알림도 제거해야한다




