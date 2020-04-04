# RGDirectXP

## 소개

RGD 프로젝트는 개발자 *invwindy*님과 *Fux2*님이 배포한 프로젝트로, **DirectX9** 엔진을 Game.exe 파일에 주입하여 새로 만들었습니다.

하지만 *RGD* 프로젝트는 *RPG Maker VX ACE*로 만든 게임에만 적용할 수 있습니다. 이제는 *RPG Maker XP* 환경에서도 *RGDirectXP* 에서 제공하는 스크립트를 추가만 하면 사용할 수 있습니다.

## Introduction

The *[RGD](http://invwindy.mist.so/archives/290)* project have been released by two developers *invwindy* and *Fux2*. They injected **DirectX9** Engine into Game.exe and rebuilt it. 

But *RGD* is only working in *RPG Maker VX Ace*. That's why *RGDirectXP* project comes out. You can apply *RGD* with games made from *RPG Maker XP* by adding and complementing combatibility scripts.

## 사용법

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
        d3dx9_43.dll이(가) 없어 코드 실행을 진행할 수 없습니다.
        프로그램을 다시 설치하면 이 문제가 해결될 수 있습니다. 
        ---------------------------
        확인   
        ---------------------------

    Game.exe을 실행할 때, 위 에러 메세지가 나온다면 [DirectX9 Runtime](https://www.microsoft.com/en-us/download/confirmation.aspx?id=8109) 또는 [DirectX9 SDK](https://www.microsoft.com/en-us/download/details.aspx?id=6812) 링크를 눌러 설치하세요.
7. [rgdxp_head.rb](https://github.com/jubin-park/RGDirectXP/blob/master/src/rgdxp_head.rb) 파일의 내용을 복사해서 스크립트 섹션 최상단에 넣습니다.
8. [rgdxp_tail.rb](https://github.com/jubin-park/RGDirectXP/blob/master/src/rgdxp_tail.rb) 파일의 내용을 복사해서 스크립트 섹션 Main 바로 위에 넣습니다.
9. 마지막으로 Data/PreCacheMapData.rxdata 파일을 생성해야 합니다. F12 버튼을 눌러서 디버그 모드로 게임을 실행하면 생성됩니다. 이 파일은 ForeverZer0님의 타일맵 클래스와 관련이 있습니다.

## How To Use

1. Enter this page: http://invwindy.mist.so/archives/290
2. In **Instructions and Download Link** Section, click a link *RGDv1.x.x.zip* and download file.
3. After unzip the file, then move Game.exe into your project directory.
4. Remove RGSS10XX.dll file, and then locate RGSS301.dll in your project directory.
5. Open Game.ini file, rename `Library=RGSS10XX.dll` to `Library=RGSS301.dll`, and save file.
6. Execute Game.exe file. If you get a error below, read 6-1.

    6-1. You should install DirectX9 in your computer. Because RGD use DirectX9 Engine.

        ---------------------------
        Game.exe - System Error
        ---------------------------
        The program can't start because d3dx9_43.dll is missing from your computer.
        Try reinstalling the program to fix this problem.
        ---------------------------
        OK
        ---------------------------
    When you get above error message, please download and install  [DirectX9 Runtime](https://www.microsoft.com/en-us/download/confirmation.aspx?id=8109) or [DirectX9 SDK](https://www.microsoft.com/en-us/download/details.aspx?id=6812).
    
7. After copy [rgdxp_head.rb](https://github.com/jubin-park/RGDirectXP/blob/master/src/rgdxp_head.rb) to clipboard, paste and locate the script **at the TOP** of script list.
8. After copy [rgdxp_tail.rb](https://github.com/jubin-park/RGDirectXP/blob/master/src/rgdxp_tail.rb) to clipboard, paste and locate the script **above Main** section.
9. In The End, trigger **F12 button** to start game in debug-mode. You'll get Data/PreCacheMapData.rxdata file. This file is related to ForeverZer0's Tilemap script.

# RGDirect (RGD)
Copyright(C), 2018-2020, invwindy and Fux2

* Link: [https://cirno.mist.so/archives/290](http://invwindy.mist.so/archives/290)