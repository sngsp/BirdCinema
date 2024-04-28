# Table of Contents
1. [Description](#description)
2. [Period](#period)
3. [Demo](#Demo)
4. [Main Feature](#main-feature)
5. [Requirements](#requirements)
6. [Stacks](#stacks)
7. [Project Structure](#project-structure)
8. [Developer](#developer)

# 🕊️ Bird Cinema 🕊️ 

영화 정보를 모아 원하는 영화를 찾아보고 예약 할 수 있는 Bird Cinema!

## Description

현재 개봉한 영화, 가장 많이 본 영화, 곧 개봉할 영화 모든 정보를 한눈에 쉽게 확인하고 예약까지!

## Period

- 24.04.22
    - Project 아이디어 회의 및 역할 분담
        - 데이터 모델링 설정 및 API 네트워크 연결

- 24.04.23
    - 페이지 별 기능 구현 (마이 페이지, 영화 상세 줄거리, 영화 목록 페이지)
    - 추가 API 네트워크 연결

- 24.04.24
    - 마이페이지 기능 구현
      - 예약 및 결제 완료 시 해당 정보 표시 및 저장
    - 영화 상세 줄거리
      - 이미지 및 줄거리 구현, 배경 이미지 블러 설정
    - 영화 목록 페이지
      - 영화 목록 페이지 내 목록 추가 스크롤 뷰 구현
    - 영화 검색 페이지
      - 통합 데이터 설정 및 영화 목록 컬렉션 뷰 추가, 서치바 생성

- 24.04.25
    - 마이페이지 기능 구현
      - 찜기능 구현 
    - 영화 목록 페이지
      - 영화 목록 페이지 내 이미지 추가
    - 영화 검색 페이지
      - 서치바 기능 구현 및 디자인 수정
    - 로그인, 회원 가입 페이지
      - 로그인 기능 구현 및 회원가입 로직 구현

- 24.04.26
    - 마이페이지 기능 구현
      - 로그아웃 기능 추가
    - 영화 목록 페이지
      - 영화 목록 페이지 내 이미지 추가
    - 영화 검색 페이지
      - 서치바 기능 구현 및 디자인 수정
    - 로그인, 회원 가입 페이지
      - 자동로그인 구현
    - 전체 데이터 로직 연결

- 24.04.27
    - 데이터 연결 및 세부 디자인 설정
    - Launch Screen 디자인


## Demo
<p float="left">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/db6533e9-453c-4688-8f75-d44a4e76eacd" alt="로그인" width="200">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/bf652421-2c30-47f0-9cb0-9c70ef739585" alt="회원가입" width="200">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/e62ea905-98cc-48cd-95a7-08312a4614cb" alt="영화목록 1" width="200">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/4edaf211-4cb3-4ad7-bd49-9e1d66a44bb0" alt="영화목록 2" width="200">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/dfdf9918-38a5-4775-a677-6dc08539d351" alt="영화검색" width="200">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/17292203-e313-46f0-8aaf-280397a87c02" alt="영화찜하기" width="200">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/c1baac45-2292-4f9a-9a97-c5724233666f" alt="영화예매하기1" width="200">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/81b1449b-f8e8-4621-9bb9-8adae7448c3f" alt="영화예매하기2" width="200">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/d49748e9-3661-426a-9ce2-80320fa1efa4" alt="마이페이지" width="200">
    <img src="https://github.com/sngsp/BirdCinema/assets/158182449/b82cb9d7-fad4-4def-b03b-cdf012e96555" alt="영화상세페이지" width="200">
</p>


## Main Feature
### 영화 정보 확인
- 터치 한번으로 영화 정보를 한눈에!

### 영화 검색 기능
- 원하는 영화만 쏙쏙 골라 확인!

### 예약 및 결제 내용 확인
- 마이페이지에 한눈에 간편하게 확인!

### 영화 상세페이지
- 각 영화별로 정보를 확인하고 줄거리까지 한눈에!



## Requirements
- App requires **iOS 15 or above**

## Stacks
- **Environment**

    <img src="https://img.shields.io/badge/-Xcode-147EFB?style=flat&logo=xcode&logoColor=white"/> <img src="https://img.shields.io/badge/-git-F05032?style=flat&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/-github-181717?style=flat&logo=github&logoColor=white"/>

- **Language**

    <img src="https://img.shields.io/badge/-swift-F05138?style=flat&logo=swift&logoColor=white"/> 

- **Communication**

    <img src="https://img.shields.io/badge/-slack-4A154B?style=flat&logo=slack&logoColor=white"/> <img src="https://img.shields.io/badge/-notion-000000?style=flat&logo=notion&logoColor=white"/>  <img src="https://img.shields.io/badge/-figma-609926?style=flat&logo=slack&logoColor=white"/>


## Project Structure

```markdown
BirdCinema
├── Extension
│   ├── Int+
│   ├── UIImage+
├── Networking
│   ├── NetworkingManager
├── Model
│   ├── MovieData
│   ├── SelectedMovieData
│   ├── ReservationData
│   ├── ReservationManager
│   ├── WishMovieData
│   └── WishMovieManager
├── View
│   ├── Main
│   ├── Login
│   ├── MovieDetail
│   ├── MovieReservation
│   ├── MovieSearch
│   ├── MyPage
│   │   ├── CollectionReusableView
│   └── ├── Cells
├── controller
│   ├── MainViewController
│   ├── LoginViewController
│   ├── JoinViewController
│   ├── MovieDetailViewController
│   ├── MovieReservationViewController
│   ├── MyPageViewController
│   └── MovieSearchViewController
└ 
```

## Developer
*  **이승섭** ([sngsp](https://github.com/sngsp))
    - merge 담당
    - 영화 상세 페이지
    - 데이터 병합
*  **금세미** ([pond1225](https://github.com/pond1225))
    - 영화 검색 페이지 구현
    - 영화 검색 페이지 상세페이지 연결
*  **김시종** ([SijongKim93](https://github.com/SijongKim93))
    - 데이터 모델링
    - 영화 목록 페이지 구현
    - 로그인, 회원가입 구현
*  **정유진** ([yyujnn](https://github.com/yyujnn))
    - 마이페이지 구현
    - 찜기능 구현
    - 페이지 데이터 연결 및 세부 디자인 수정
