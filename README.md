# RGDirectXP

## Introduction

The *[RGD](http://invwindy.mist.so/archives/290)* project have been released by two developers *invwindy* and *Fux2*. They injected **DirectX9** Engine into Game.exe and rebuilt it. 

But *RGD* is only working in *RPG Maker VX Ace*. That's why *RGDirectXP* project comes out. You can apply *RGD* with games made from *RPG Maker XP* by adding and complementing combatibility scripts.

## 소개

RGD 프로젝트는 개발자 *invwindy*님과 *Fux2*님이 배포한 프로젝트로, **DirectX9** 엔진을 Game.exe 파일에 주입하여 새로 만들었습니다.

하지만 *RGD* 프로젝트는 *RPG Maker VX ACE*로 만든 게임에만 적용할 수 있습니다. 이제는 *RPG Maker XP* 환경에서도 *RGDirectXP* 에서 제공하는 스크립트를 추가만 하면 사용할 수 있습니다.

## How To Use

1. http://invwindy.mist.so/archives/290 페이지에 접속합니다.
2. **Instructions and Download Link** 하단의 *RGDv1.x.x.zip* 링크를 눌러 파일을 받습니다.
3. 압축을 풀고 Game.exe 파일을 게임 프로젝트 폴더에 넣습니다.
4. RGSS10XX.dll 파일을 지우고, RGSS301.dll 파일을 게임 프로젝트 폴더에 넣습니다.
5. Game.ini을 실행해서 `Library=RGSS10XX.dll` 을 `Library=RGSS301.dll` 로 수정한 뒤 저장합니다.
6. Game.exe 파일을 실행합니다. 아래의 오류가 발생하는 경우 6-1를 참고하세요.

    6-1. RGD 프로젝트는 DirectX9 엔진을 사용하기 때문에, **DirectX9** 를 설치해야 합니다.

        ---------------------------
        Game.exe - 시스템 오류
        ---------------------------
        d3dx9_43.dll이(가) 없어 코드 실행을 진행할 수 없습니다. 프로그램을 다시 설치하면 이 문제가 해결될 수 있습니다. 
        ---------------------------
        확인   
        ---------------------------

    Game.exe을 실행할 때, 위 에러 메세지가 나온다면 아래의 링크로 들어가서 DirectX9 SDK를 설치하십시오.
    
    https://www.microsoft.com/en-us/download/details.aspx?id=6812

7. [rgdxp_head.rb](https://github.com/jubin-park/RGDirectXP/blob/master/src/rgdxp_head.rb) 파일의 내용을 복사해서 스크립트 섹션 최상단에 넣습니다.
8. [rgdxp_tail.rb](https://github.com/jubin-park/RGDirectXP/blob/master/src/rgdxp_tail.rb) 파일의 내용을 복사해서 스크립트 섹션 Main 바로 위에 넣습니다.

# RGDirect (RGD)
Copyright (C) 2018-2020 invwindy / fux2

## Introduction

* **EN**: RGD reimplements graphical classes and modules 
  in RGSS3, Bitmap, Graphics, Viewport, Sprite, Tilemap and Plane, using DirectX9 technique. 
  The performance for drawing maps, images of large size and scaling, rotating sprites of large number 
  with GPU is greatly higher compared to the lag in RGSS3. 
  RGD has a built-in shader interface in Sprites and Viewports which is used for real-time custom effect code. 
  On bitmap operations, besides the operators in RGSS3, RGD implements built-in pixel font option without using external DLLs. 

  In addition, RGD implements mouse input. 
  You may use module Mouse to get mouse position and button status easily.

  This work is completed by Fux2 and me. Fux2 completed all the communications between C++ and ruby, and functions on drawing texts. I completed the functions related to D3D rendering. Many thanks to Mayaru for drawing the character and icons of RGD.

  If you have any questions or advice, please send email to cirno@live.cn.

* **KR**: RGD는 DirectX9 기술을 사용하여 RGSS3, Bitmap, Graphics, Viewport, Sprite, Tilemap, Plane의 그래픽 클래스 및 모듈을 다시 구현합니다. 
  GPU를 사용하여 맵 그리기, 크기가 큰 이미지 및 크기 조정, 회전 스프라이트를 많이 사용하는 성능은 RGSS3의 지연에 비해 훨씬 높습니다. 
  RGD에는 Sprites 및 Viewports에 내장된 셰이더 인터페이스가 내장되어있어 실시간 사용자 정의 효과 코드에 사용됩니다. 
  비트 맵 작업에서 RGSS3의 연산자 외에도 RGD는 외부 DLL을 사용하지 않고 내장 픽셀 글꼴 옵션을 구현합니다. 

  RGD는 마우스 입력을 구현합니다. 마우스 모듈을 사용하여 마우스 위치와 버튼 상태를 쉽게 얻을 수 있습니다.

  C++과 루비 사이의 모든 통신과 텍스트 그리기 기능을 완료했습니다. 
  D3D 렌더링과 관련된 기능을 완료했습니다. 

  질문이나 조언이 있으면 cirno@live.cn으로 이메일을 보내주십시오.

## Terms of Use

* **EN**: RGDirect is permitted to use in non-commercial or commercial games made with RPG Maker VX Ace.

  Do not use RGDirect in violating the laws and regulations of related countries, and do not use it to harm the legitimate rights and interests of other people.

  Do not republish RGDirect outside the name of the developers.

  Developers on RGDirect are not responsible for any problems during and after use.

  In the event of any conflict, laws and regulations of related countries, and the official instructions from Enterbrain Corporation shall prevail.

* **KR**: RGDirect는 RPG Maker VX Ace로 제작된 비상업용 또는 상업용 게임에서 사용할 수 있습니다.
  관련 국가의 법률과 규정을 위반한다면 다른 사람들의 합법적인 권리와 이익을 해치지 않기 위해 RGDirect를 사용하지 마십시오.
  RGDirect의 개발자는 사용 중 및 사용 후 발생한 문제에 대해 책임을 지지 않습니다.
  충돌이 발생하는 경우 관련 국가의 법률과 규정 및 Enterbrain Corporation의 공식 지침을 우선합니다.

## More Information

[https://cirno.mist.so/archives/290](https://cirno.mist.so/archives/290)