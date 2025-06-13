# LLM Evaluator

**LLM Evaluator**는 대규모 언어모델(LLM) 및 데이터셋의 관리, 평가, 리더보드 제공을 위한 현대적 웹 기반 도구입니다.
Flutter Web(프론트엔드) + FastAPI(백엔드) 구조로, 실제 API 연동 및 CRUD, 반응형 UI, 모듈화된 서비스 구조를 갖추고 있습니다.

---

## 주요 기능

- **대시보드**: 최근 평가 내역, 모델/데이터셋/지표/리더보드 요약
- **데이터셋 관리**: 데이터셋 목록, 상세, 추가/수정/삭제, API 연동
- **모델 관리**: 모델 목록, 상세, 추가/수정/삭제, API 연동
- **평가 관리**: 평가 실행, 진행상황, 로그, 결과 확인
- **지표 관리**: 평가 지표(정량/정성) 관리
- **리더보드**: 모델별 성능 비교, 순위 제공
- **모달, 알림, 반응형, 애니메이션 등 현대적 UI/UX**

---

## 폴더 구조

```
llm_evaluator/             # Flutter 프론트엔드
  ├── lib/
  │   ├── main.dart        # 앱 진입점
  │   ├── models/          # 데이터 모델 (Model, Dataset, Evaluation 등)
  │   ├── services/        # API 연동 서비스 (model_service, dataset_service 등)
  │   └── screens/         # 주요 화면 (dashboard, dataset, model, evaluation, metric, leaderboard)
  ├── web/                 # Flutter Web 정적 파일
  ├── test/                # 테스트 코드
  ├── pubspec.yaml         # Flutter 의존성 관리
  └── README.md            # 프로젝트 설명

llm_evaluator_backend/     # FastAPI 백엔드
  ├── main.py              # FastAPI 서버 진입점 (API 엔드포인트)
  └── requirements.txt     # Python 의존성
```

---

## 개발 및 실행 방법

### 1. 백엔드(FastAPI) 실행

```bash
cd llm_evaluator_backend
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

- API 문서: [http://localhost:8000/docs](http://localhost:8000/docs)

### 2. 프론트엔드(Flutter Web) 실행

```bash
cd llm_evaluator
flutter pub get
flutter run -d chrome
```

- 기본 접속: [http://localhost:8080](http://localhost:8080) (포트는 환경에 따라 다를 수 있음)

### 3. 빌드 및 배포

```bash
flutter build web
# build/web 폴더를 Netlify, Vercel, Firebase Hosting 등에서 배포 가능
```

---

## 주요 기술 스택

- **Flutter 3.x (Dart)**
- **FastAPI (Python 3.9+)**
- RESTful API, http 패키지, FutureBuilder, 반응형 UI, 모달/애니메이션 등

---

## API 연동 구조

- `lib/services/model_service.dart` : 모델 CRUD API 연동
- `lib/services/dataset_service.dart` : 데이터셋 CRUD API 연동
- `lib/services/api_service.dart` : (이전 더미 데이터, 현재는 평가 등 일부만 사용)
- 모든 화면은 FutureBuilder 등으로 비동기 API 연동

---

## 커스텀/확장 안내

- **데이터 모델 추가**: `lib/models/`에 모델 정의, 서비스/화면에 연동
- **API 엔드포인트 추가**: `llm_evaluator_backend/main.py`에 FastAPI 라우터 추가
- **UI/UX 개선**: `lib/screens/` 내 각 화면별 위젯/스타일 수정
- **배포**: `flutter build web` 후 정적 호스팅 서비스에 업로드

---

## 참고

- 요구사항 명세: `SRS.md` 참고
- .gitignore 예시: Flutter + Python 통합 프로젝트 기준
- 문의/이슈: [GitHub Issues](https://github.com/your-repo/issues) (예시)

---

## License

MIT (or your license)
