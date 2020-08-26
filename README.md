# Bash Shell Script 실습용 vagrant 스크립트
---
![tescom](https://en.gravatar.com/userimage/96759029/aa4308f795041de37cc2fedf0d1071ca?size=128)


# Virtual Web Service사의 가상 서버 구축용 스크립트
---

## 서버 정보
  - cent1 (웹)
  ```script
    OS : CentOS8 
    CPU : 1 Core
    MEM : 2G
    Disk : 20G
    Middleware : nginx
    DMZ : 172.18.1.91
    Local : 10.18.1.91
   ```
  - cent2 (데이터베이스)
  ```script
    OS : CentOS8 
    CPU : 1 Core
    MEM : 2G
    Disk : 20G
    Middleware : mariadb
    DMZ : 172.18.1.92
    Local : 10.18.1.92
   ```
  - cent3 (스토리지)
  ```script
    OS : CentOS8 
    CPU : 1 Core
    MEM : 2G
    Disk : 20G
    Middleware : nfs
    DMZ : 172.18.1.93
    Local : 10.18.1.93
   ```

---
## 파일 및 디렉토리 설명
 - Vagrantfile : 가상서버 생성용 vagrant 스크립트 파일
 - WORK : 필요한 패키지 및 데이터
 - SHELL : 필요한 쉘 스크립트
 - CONF : 필요한 설정 파일

---
## 실행전 필요한 환경 준비
 - virtualbox 설치
   - URL : https://www.virtualbox.org/
 - vagrant 설치
   - URL : https://www.vagrantup.com/
 - vagrant 스크립트 가져오기
```script
git clone https://github.com/t2sc0m/VWS_vagrant_script.git 
```

---
## 서버 구축
```script
cd VWS_vagrant_script
vagrant up
```

---
## 실행/정지/삭제 방법
```script
cd VWS_vagrant_script

## 괄호 안의 cent[1-3]은 각각 가상서버를 의미하며 생략 가능
## 생략하면 모든 서버를 실행/정지/삭제 

# 실행
vagrant up (cent[1-3])

# 정지
vagrant halt (cent[1-3])

# 삭제
vagrant destroy (cent[1-3])
```

---
## 포트 및 프로세스 확인
```script
vagrant ssh cent[1-3] 
sudo netstat -nltpu
sudo ps -ef | grep (nginx|mysql|nfs)
```

---
## 주의점
  - 이 스크립트에서 구현이 되지 않은 부분
    - Local IP사이의 통신 설정
    - Gateway설정을 추가하지 않기 위해 각 서버에 DMZ대역의 IP를 할당
  - 실제 서비스와의 다른 점
    - 데이터베이스와 스토리지는 실제 환경에서는 DMZ대역의 통신을 허용하지 않음

---
