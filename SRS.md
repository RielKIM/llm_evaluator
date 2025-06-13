# LLM 자동 평가 시스템 최종 개발 요구사항

## 1. 서론 (Introduction)

본 문서는 대규모 언어 모델(LLM)의 성능을 체계적이고 효율적으로 평가하기 위한 'LLM 자동 평가 시스템'의 최종 개발 요구사항을 정의합니다. 이 시스템은 다양한 LLM 모델과 평가 데이터셋을 관리하고, 사용자가 정의한 평가 기준(지표)에 따라 자동화된 평가 실행을 수행하며, 그 결과를 심층적으로 분석하고 시각화하여 제공합니다. 또한, 모델 성능 순위를 투명하게 공개하는 리더보드 기능을 포함합니다.

이 문서는 이전에 개별적으로 작성된 기능별 상세 명세서(데이터셋 관리, 모델 관리, 평가 실행 및 관리, 평가 지표 관리, 평가 결과 분석 및 시각화, 리더보드 관리)를 하나의 포괄적인 문서로 통합한 것입니다. 본 문서는 AI 개발자 'Cursor'를 포함한 프로젝트 참여자들이 시스템의 전체 아키텍처, 각 기능의 목적, 상세 요구사항, UI/UX 가이드, 데이터 모델, 그리고 수락 기준을 명확히 이해하고 개발을 진행하는 데 필요한 기준점을 제공하는 것을 목표로 합니다.

시스템 개발을 통해 사용자는 LLM 모델의 성능 변화를 지속적으로 추적하고, 다양한 모델을 객관적으로 비교하며, 특정 태스크에 대한 모델의 강점과 약점을 신속하게 파악하여 모델 개선 및 선정에 필요한 데이터 기반 의사결정을 내릴 수 있을 것입니다.

## 2. 통합 기능 명세 (Consolidated Feature Specifications)

### 2.1 데이터셋 관리 (Dataset Management)

1. Feature: 데이터셋 관리 (Dataset Management)

2. User Stories

*   As an AI Evaluator, I want to upload evaluation datasets in various formats (CSV, JSON, TXT), so that I can use my own data for LLM evaluation.
*   As an AI Evaluator, I want to add descriptive information (metadata) like name, description, and source to uploaded datasets, so that I can easily identify and manage them.
*   As an AI Evaluator, I want to view a list of all available datasets and their key details, so that I can quickly find the dataset I need.
*   As an AI Evaluator, I want to search and filter the dataset list, so that I can efficiently locate specific datasets even when managing many.
*   As an AI Evaluator, I want to preview the sample data within a dataset before running an evaluation, so that I can verify its structure and content.
*   As an AI Evaluator, I want to add, edit, or delete individual samples within a dataset, so that I can correct errors or update the dataset manually.
*   As an AI Evaluator, I want the system to track changes to datasets via versioning, so that I can maintain data integrity, reproduce past results, and compare different versions.
*   As an AI Evaluator, I want to easily import standard benchmark datasets (like ARC, MMLU), so that I can readily compare models against established benchmarks.
*   As an AI Evaluator, I want the system to support datasets with various structures (simple Q&A, multi-turn chat, RAG context, tool use), so that I can evaluate models on diverse tasks.

3. Detailed Functional Specifications

*   데이터셋 업로드 (Dataset Upload):
    *   지원 파일 형식: CSV, JSON, TXT. 시스템은 업로드 시 파일 확장자 및 내부 구조를 검사하여 유효성을 확인해야 합니다.
    *   업로드 인터페이스: 웹 UI는 드래그 앤 드롭 영역과 파일 선택 버튼을 제공합니다. 대용량 파일 처리를 위해 청크(chunk) 기반 스트리밍 업로드를 지원하고, 사용자에게 진행률 표시기(progress bar)를 제공해야 합니다.
    *   처리 방식: 업로드된 파일은 서버 측에서 포맷 파싱 및 기본 구조 유효성 검사를 거쳐 임시 저장됩니다. 검증 성공 시 데이터셋으로 등록되며, 실패 시 사용자에게 오류 상세 정보를 제공합니다. 데이터셋 구조 (Q&A, 멀티턴 등)는 업로드 시 또는 메타데이터 편집 시 지정 가능해야 하며, 시스템은 지정된 구조에 맞춰 데이터를 파싱하려 시도합니다.
*   메타데이터 관리 (Metadata Management):
    *   입력 필드:
        -   `이름 (Name)`: 필수, 문자열. 데이터셋을 식별하는 고유한 이름. (최대 길이 제한 필요)
        -   `설명 (Description)`: 선택 사항, 문자열. 데이터셋에 대한 상세 설명.
        -   `출처 (Source)`: 선택 사항, 문자열/URL. 데이터셋의 원본 위치 또는 생성 정보.
        -   `태그 (Tags)`: 선택 사항, 문자열 목록. 데이터셋 분류 및 검색을 위한 키워드.
        -   `데이터셋 유형 (Dataset Type)`: 필수, 열거형 (e.g., `QA`, `MultiTurn`, `RAG`, `ToolUse`, `Generic`). 데이터 샘플의 예상 구조를 나타냅니다.
    *   유효성 검사: 데이터셋 이름은 필수 입력 항목이며 시스템 내에서 고유해야 합니다. 특정 특수 문자 사용 제한 등의 규칙을 적용할 수 있습니다.
*   데이터셋 조회 및 미리보기 (Dataset Listing and Preview):
    *   목록 보기: 등록된 데이터셋 목록을 테이블 형태로 표시합니다. 각 행은 데이터셋의 `이름`, `설명 요약`, `출처`, `샘플 수`, `업로드 날짜`, `마지막 수정 날짜`, `Actions` (상세 보기, 편집, 삭제 등)를 포함해야 합니다. 페이지네이션 또는 무한 스크롤을 지원하여 대량의 데이터셋도 효율적으로 탐색할 수 있게 합니다.
    *   검색/필터링: 데이터셋 `이름`, `설명`, `출처`, `태그`를 포함한 검색 기능을 제공합니다. `업로드 날짜 범위`, `샘플 수 범위`, `데이터셋 유형` 등으로 필터링하는 기능을 제공합니다.
    *   샘플 미리보기: 데이터셋 상세 페이지 또는 별도의 모달에서 데이터 샘플의 일부 (예: 처음 10개 또는 무작위 10개)를 보여줍니다. 각 샘플은 `샘플 ID`, `입력 (Input)`, `골든 라벨 (Golden Label)`, `컨텍스트 (Context, RAG)`, `도구 호출 (Tool Calls, ToolUse)` 등 해당 `데이터셋 유형`에 맞는 필드를 구조화하여 표시해야 합니다.
*   데이터셋 편집 (Dataset Editing):
    *   개별 샘플 CRUD: 데이터셋 상세 페이지 내 샘플 목록 테이블에서 각 샘플 옆에 `편집 (Edit)`, `삭제 (Delete)` 버튼을 제공합니다. 테이블 하단 또는 별도의 모달/페이지에 `샘플 추가 (Add Sample)` 버튼을 제공합니다.
        -   `추가 (Create)`: 새로운 샘플 데이터를 입력할 수 있는 폼 또는 모달을 제공합니다. `데이터셋 유형`에 따라 필요한 필드를 동적으로 표시합니다.
        -   `읽기 (Read)`: 샘플 미리보기 기능과 동일하게 상세 데이터를 조회합니다.
        -   `업데이트 (Update)`: 기존 샘플 데이터를 수정할 수 있는 폼 또는 모달을 제공합니다.
        -   `삭제 (Delete)`: 선택된 샘플을 목록에서 제거합니다. 삭제 전 사용자에게 확인을 요청해야 합니다.
    *   변경 사항 저장: 개별 샘플 편집 내용은 즉시 저장되거나, 일련의 편집 작업을 마친 후 일괄 저장하는 방식을 고려할 수 있습니다. (저장 시 버전 관리와 연동)
*   버전 관리 (Version Control):
    *   변경 이력 추적: 데이터셋 업로드, 샘플의 대량 추가/수정/삭제 또는 사용자의 명시적 요청 시 새로운 버전이 생성됩니다. 각 버전은 고유한 `버전 번호`, `생성 시점`, `변경 요약`, `변경 사용자` 정보를 가집니다.
    *   버전 목록: 데이터셋 상세 페이지에 '버전' 탭을 제공하여 해당 데이터셋의 전체 버전 목록을 표시합니다.
    *   버전 비교: 두 버전 선택 시, 추가/삭제/수정된 샘플 목록과 변경된 필드 내용을 시각적으로 비교하여 보여주는 기능을 제공합니다.
    *   버전 활용: 평가 실행 시, 데이터셋의 특정 버전을 선택하여 사용할 수 있도록 합니다. (현재 버전이 기본값)
*   표준 벤치마크 임포트 (Standard Benchmark Import):
    *   지원할 벤치마크: ARC (AI2 Reasoning Challenge), MMLU (Massive Multitask Language Understanding), HellaSwag, OpenBookQA 등 널리 사용되는 LLM 벤치마크를 기본적으로 지원합니다.
    *   임포트 프로세스: '벤치마크 임포트' 인터페이스에서 지원되는 벤치마크 목록을 표시합니다. 사용자가 벤치마크를 선택하면, 시스템은 해당 벤치마크 데이터를 자동으로 가져와 파싱하고, 새로운 데이터셋으로 등록합니다. 임포트 과정 중 메타데이터(이름, 출처, 설명)는 벤치마크 정보로 자동 채워지며 수정 가능해야 합니다. 임포트 완료 전 샘플 데이터를 미리 볼 수 있는 옵션을 제공할 수 있습니다.

4. UI/UX Design Specifications

*   화면 레이아웃 (Screen Layout):
    *   데이터셋 업로드 모달: 중앙에 위치하는 모달 창. 상단에 제목 ("데이터셋 업로드"). 본문 영역에는 파일 업로드 드래그 앤 드롭 영역과 "파일 선택" 버튼. 하단에 메타데이터 입력 필드 (`이름`, `설명`, `출처`, `태그`, `데이터셋 유형`). 가장 하단에 "업로드" 및 "취소" 버튼. 업로드 중에는 진행률 표시기와 취소 버튼이 표시됩니다.
    *   데이터셋 목록 페이지: 페이지 상단에 제목 ("데이터셋 목록"). 그 아래에 검색 입력 필드와 필터 드롭다운/버튼 그룹. 주요 영역은 데이터셋 목록을 표시하는 테이블. 테이블 컬럼: `이름`, `설명`, `출처`, `샘플 수`, `업로드 날짜`, `수정 날짜`, `Actions`. 테이블 하단에 페이지네이션 컨트롤. 테이블 상단 또는 하단에 "데이터셋 업로드" 버튼.
    *   데이터셋 상세 페이지: 페이지 상단에 데이터셋 이름 및 핵심 메타데이터 요약. 그 아래에 탭 인터페이스 (`샘플`, `버전`, `평가 결과`).
        -   `샘플` 탭: 해당 데이터셋의 모든 샘플 목록을 표시하는 테이블. 샘플 목록 위에는 샘플 검색 및 필터링 기능. 테이블 컬럼: `샘플 ID`, `입력`, `골든 라벨` 등 (유형에 따라 동적). 각 샘플 행에는 `미리보기`, `편집`, `삭제` 버튼. 테이블 하단에 페이지네이션. 테이블 위 또는 아래에 "샘플 추가" 버튼.
        -   `버전` 탭: 해당 데이터셋의 버전 목록을 표시하는 테이블. 컬럼: `버전 번호`, `생성 일시`, `사용자`, `변경 요약`, `Actions` (`비교`, `이 버전으로 평가`, `삭제`). 테이블 상단에 "현재 버전 생성" 버튼.
        -   샘플 미리보기/편집 모달: 선택된 샘플의 상세 데이터를 표시/편집하는 모달 창. `데이터셋 유형`에 맞는 구조화된 입력 필드를 제공합니다.
*   사용자 상호작용 흐름 (User Interaction Flow):
    1.  데이터셋 업로드: 사용자 -> "데이터셋 목록" 페이지 이동 -> "데이터셋 업로드" 버튼 클릭 -> "데이터셋 업로드" 모달 열림 -> 파일 선택 또는 드래그 앤 드롭 -> 파일 업로드 시작, 진행률 확인 -> 메타데이터 입력 -> "업로드" 버튼 클릭 -> 업로드 및 처리 완료 후 목록 페이지로 돌아가서 새로 등록된 데이터셋 확인.
    2.  데이터셋 조회 및 미리보기: 사용자 -> "데이터셋 목록" 페이지 이동 -> (필요시 검색/필터) -> 데이터셋 목록 확인 -> 특정 데이터셋 이름 클릭 -> "데이터셋 상세" 페이지로 이동 (기본 '샘플' 탭) -> 샘플 목록 확인 -> 특정 샘플 옆 "미리보기" 버튼 클릭 -> "샘플 미리보기" 모달 열림 -> 샘플 상세 데이터 확인 -> 모달 닫기.
    3.  데이터셋 편집 (개별 샘플): 사용자 -> "데이터셋 상세" 페이지 ('샘플' 탭) -> 특정 샘플 옆 "편집" 버튼 클릭 -> "샘플 편집" 모달 열림 -> 데이터 수정 -> "저장" 버튼 클릭 -> 모달 닫힘, 샘플 목록에서 변경 확인. ('버전' 탭에서 새 버전 또는 변경 사항 기록 확인).
    4.  버전 관리: 사용자 -> "데이터셋 상세" 페이지 -> '버전' 탭 클릭 -> 버전 목록 확인 -> 원하는 두 버전 선택 -> "비교" 버튼 클릭 -> 버전 비교 화면에서 변경점 확인.
    5.  표준 벤치마크 임포트: 사용자 -> "데이터셋 목록" 페이지 또는 별도의 메뉴 -> "벤치마크 임포트" 메뉴 클릭 -> 지원 벤치마크 목록 확인 -> 원하는 벤치마크 선택 -> (필요시 설정 확인/미리보기) -> "임포트" 버튼 클릭 -> 임포트 진행 -> 완료 후 데이터셋 목록에서 새로 생성된 벤치마크 데이터셋 확인.

5. Data Model

데이터셋 관리를 위한 데이터 모델은 다음과 같습니다.

```
Dataset {
  "dataset_id": "uuid",             // 고유 식별자
  "name": "string",                 // 데이터셋 이름 (필수)
  "description": "string",          // 설명 (선택 사항)
  "source": "string",               // 출처 (선택 사항)
  "tags": ["string"],               // 태그 목록 (선택 사항)
  "dataset_type": "string",         // 데이터셋 유형 (QA, MultiTurn 등)
  "created_at": "datetime",         // 생성 일시
  "updated_at": "datetime",         // 마지막 수정 일시
  "created_by": "user_id",          // 생성 사용자
  "current_version_id": "uuid",     // 현재 활성 버전 ID
  "versions": [                     // 버전 목록 (Version 객체 참조)
    { "version_id": "uuid", "version_number": 1, ... }
  ]
}

Version {
  "version_id": "uuid",             // 고유 식별자
  "dataset_id": "uuid",             // 연결된 데이터셋 ID
  "version_number": "integer",      // 버전 번호 (데이터셋 내에서 순차적)
  "created_at": "datetime",         // 버전 생성 일시
  "created_by": "user_id",          // 버전 생성 사용자
  "changes_summary": "string",      // 이 버전에서 발생한 변경 요약 (예: "샘플 5개 추가")
  "samples": [                      // 이 버전에 포함된 샘플 목록 (DataSample 객체)
    { "sample_id": "uuid", "input": {}, "golden_label": {}, ... }
  ]
}

DataSample {
  "sample_id": "uuid",              // 고유 식별자 (버전 내에서 고유)
  "version_id": "uuid",             // 연결된 버전 ID
  "dataset_id": "uuid",             // 연결된 데이터셋 ID (참조용)
  "input": "object",                // 모델 입력 데이터 (텍스트, 대화 히스토리 등 구조화된 JSON/객체)
  "golden_label": "object",         // 정답 또는 기대 출력 데이터 (텍스트, 정답 옵션 등 구조화된 JSON/객체)
  "context": "object",              // RAG 시나리오를 위한 컨텍스트 데이터 (선택 사항, 구조화된 JSON/객체)
  "tool_calls": "object",           // 도구 사용 시나리오를 위한 도구 호출/응답 데이터 (선택 사항, 구조화된 JSON/객체)
  "metadata": "object"              // 샘플별 추가 메타데이터 (선택 사항, JSON/객체)
}
```

*   *참고: `input`, `golden_label`, `context`, `tool_calls`, `metadata` 필드는 `데이터셋 유형`에 따라 내부 구조가 달라질 수 있는 유연한 `object` 타입으로 정의됩니다.*

6. Acceptance Criteria

*   [ ] CSV, JSON, TXT 형식의 파일 업로드가 성공적으로 이루어진다.
*   [ ] 대용량 파일 업로드 시 진행률이 올바르게 표시되고 안정적으로 완료된다.
*   [ ] 업로드 또는 신규 생성 시 데이터셋 이름, 설명, 출처, 태그, 유형을 입력하고 저장할 수 있다.
*   [ ] 데이터셋 이름의 필수 입력 및 고유성 유효성 검사가 올바르게 작동한다.
*   [ ] 등록된 데이터셋 목록이 테이블 형태로 올바르게 표시된다.
*   [ ] 데이터셋 목록에서 이름, 설명, 출처, 태그 등으로 검색 및 필터링 기능이 정상 작동한다.
*   [ ] 데이터셋 상세 페이지에서 해당 데이터셋의 샘플 목록이 올바르게 표시된다.
*   [ ] 샘플 미리보기 기능이 `데이터셋 유형`에 따라 샘플 데이터를 구조화하여 올바르게 보여준다.
*   [ ] 데이터셋 상세 페이지에서 개별 샘플을 추가, 편집, 삭제할 수 있다.
*   [ ] 샘플 추가/편집 시 `데이터셋 유형`에 맞는 입력 필드가 제공된다.
*   [ ] 데이터셋 변경 (샘플 추가/편집/삭제 등) 시 새로운 버전이 자동으로 생성되거나, 사용자가 수동으로 버전을 생성할 수 있다.
*   [ ] 데이터셋 버전 목록이 올바르게 표시되며, 각 버전의 정보(번호, 생성 일시 등)가 정확하다.
*   [ ] 두 버전 간의 샘플 추가/삭제/수정 내역을 비교하는 기능이 정상 작동한다.
*   [ ] 평가 실행 시 데이터셋의 특정 버전을 선택할 수 있다.
*   [ ] 지원되는 표준 벤치마크(ARC, MMLU 등)를 선택하여 시스템 내 데이터셋으로 성공적으로 임포트할 수 있다.
*   [ ] 임포트된 벤치마크 데이터셋은 올바른 샘플 및 메타데이터를 포함한다.
*   [ ] UI/UX 디자인 사양에 명시된 각 화면(업로드 모달, 목록 페이지, 상세 페이지)의 주요 컴포넌트가 올바르게 배치된다.
*   [ ] 사용자 상호작용 흐름(업로드, 조회, 편집 등)이 명시된 단계대로 오류 없이 완료된다.
*   [ ] Data Model에 정의된 `Dataset`, `Version`, `DataSample` 객체의 필드들이 실제 데이터베이스 스키마에 반영된다.
*   [ ] 각 데이터 모델 객체 간의 관계(Dataset - Version, Version - DataSample)가 데이터베이스 수준에서 올바르게 구현된다.

### 2.2 모델 관리 (Model Management)

1. Feature: 모델 관리 (Model Management)

2. User Stories

*   As an AI Evaluator, I want to register LLM models from various sources such as Hugging Face, cloud APIs (OpenAI, Anthropic), or locally deployed endpoints, so that I can evaluate diverse models using the system.
*   As an AI Evaluator, I want to provide detailed information and configurations for each registered model, including API keys, endpoints, and inference parameters (like temperature, top\_p), so that the system can correctly call the models for evaluation.
*   As an AI Evaluator, I want to manage different configurations or versions of the same base model (e.g., different inference parameters, different fine-tuned versions), so that I can compare their performance under various settings.
*   As an AI Evaluator, I want to view a comprehensive list of all registered models and their key configurations, so that I can quickly overview the available models for evaluation.
*   As an AI Evaluator, I want to search and filter the model list by name, type, or other criteria, so that I can efficiently find specific models among many.
*   As an AI Evaluator, I want to activate or deactivate registered models, so that I can control which models are available for new evaluations without deleting their configurations entirely.
*   As an AI Evaluator, I want to edit or delete model configurations when they change or are no longer needed, so that I can keep my model inventory up-to-date.

3. Detailed Functional Requirements

*   모델 등록 (Model Registration):
    *   통합 등록 인터페이스: 사용자는 단일 인터페이스를 통해 다양한 유형의 모델을 등록할 수 있어야 합니다. 등록 시 모델 유형을 선택하고, 선택된 유형에 맞는 필수/선택적 설정 필드가 동적으로 제공되어야 합니다.
    *   지원 모델 유형:
        *   `Cloud API (e.g., OpenAI, Anthropic, Google AI, Azure OpenAI)`: API 키, 모델 이름 (e.g., `gpt-4-turbo`, `claude-3-opus-20240229`), 엔드포인트 URL (클라우드 제공 기본값 또는 커스텀), 추론 파라미터 (`temperature`, `top_p`, `max_tokens`, `stop_sequences`, `presence_penalty`, `frequency_penalty` 등). API 키는 안전하게 저장 및 관리되어야 하며, UI에서는 부분적으로만 표시하거나 접근 권한을 제어해야 합니다.
        *   `Hugging Face Model`: Hugging Face 모델 ID (e.g., `meta-llama/Llama-2-7b-hf`), 인증 토큰 (필요시), 태스크 타입 (e.g., `text-generation`, `text-classification`), 추론 파라미터. 시스템은 Hugging Face API를 통해 모델 정보를 (설명, 라이선스 등) 임포트할 수 있어야 합니다.
        *   `Local/Custom Endpoint`: 모델 이름, API 엔드포인트 URL, 요청/응답 형식 지정 (JSON 스키마 또는 템플릿), 필요한 인증 정보 (API 키, Bearer Token 등), 추론 파라미터. 시스템은 엔드포인트가 기대하는 요청 형식을 사용자에게 입력받아 저장해야 합니다.
        *   `(선택 사항) RAG/Agent System`: 시스템 이름, API 엔드포인트 URL, 입출력 형식 정의, 시스템 설명. (이 유형은 추론 파라미터 대신 시스템 자체 설정에 집중할 수 있음)
    *   필수 입력 필드: 모델 `이름` (시스템 내 고유해야 함), 모델 `유형`.
    *   유효성 검사: 입력된 엔드포인트 URL 형식, API 키 유효성 (가능한 경우), 필수 파라미터 누락 여부 등을 검사해야 합니다.
*   모델 정보 관리 (Model Information Management):
    *   메타데이터: 각 등록된 모델 구성은 다음 정보를 포함해야 합니다.
        -   `이름 (Name)`: 필수, 문자열. 이 특정 모델 구성을 식별하는 이름. (예: `GPT-4 Turbo - Temperature 0.7`, `Llama-2-7b - 로컬 배포`)
        -   `모델 유형 (Model Type)`: 필수, 열거형 (Cloud API, HF, Local/Custom, RAG/Agent 등).
        -   `기반 모델 (Base Model)`: 선택 사항, 문자열. 실제 모델 식별자 (예: `gpt-4-turbo`, `meta-llama/Llama-2-7b-hf`). Hugging Face 임포트 시 자동 채워질 수 있습니다.
        -   `설명 (Description)`: 선택 사항, 문자열. 이 구성에 대한 상세 설명.
        -   `설정 (Configuration)`: 필수, 객체/JSON. 선택된 `모델 유형`에 따른 구체적인 연결 및 추론 설정 (API 키, 엔드포인트, 파라미터 등).
        -   `라이선스 정보 (License Information)`: 선택 사항, 문자열. 모델의 라이선스 정보. Hugging Face 임포트 시 자동 채워질 수 있습니다.
        -   `태그 (Tags)`: 선택 사항, 문자열 목록. 모델 분류 및 검색을 위한 키워드.
        -   `등록 일시 (Registered At)`: 자동 생성, datetime.
        -   `수정 일시 (Updated At)`: 자동 업데이트, datetime.
        -   `등록 사용자 (Registered By)`: 자동 생성, user_id.
    *   편집 기능: 등록된 모델 구성의 모든 정보를 수정할 수 있는 기능을 제공합니다. (이름, 설명, 설정, 태그 등)
*   모델 구성/버전 관리 (Model Configuration/Version Management):
    *   시스템은 '모델' 자체보다는 '모델 구성(Model Configuration)' 단위로 관리합니다. 동일한 기반 모델이더라도 다른 파라미터나 다른 엔드포인트로 등록하면 별개의 '모델 구성'으로 시스템에 나타납니다.
    *   각 '모델 구성'은 고유한 ID를 가지며, 평가 실행 시 대상 모델로 선택됩니다.
    *   기존 모델 구성을 복제하여 새로운 설정을 빠르게 만들 수 있는 기능을 제공합니다. (예: GPT-4 설정 복사 후 Temperature만 변경)
*   모델 상태 관리 (Model State Management):
    *   각 모델 구성은 `활성 (Active)` 또는 `비활성 (Inactive)` 상태를 가집니다.
    *   `활성` 상태인 모델만 새로운 평가 작업의 대상으로 선택될 수 있습니다.
    *   `비활성` 상태인 모델은 목록에서 구분하여 표시하고, 평가 대상 선택 목록에는 나타나지 않습니다.
    *   사용자는 모델 구성의 상태를 변경할 수 있는 기능을 제공받습니다.
*   모델 검색 및 필터링 (Model Search and Filtering):
    *   등록된 모델 구성 목록에서 `이름`, `기반 모델`, `설명`, `태그` 등을 포함한 검색 기능을 제공합니다.
    *   `모델 유형`, `상태 (활성/비활성)`, `등록 사용자` 등으로 필터링하는 기능을 제공합니다.
*   모델 삭제 (Model Deletion):
    *   등록된 모델 구성을 시스템에서 제거하는 기능을 제공합니다.
    *   삭제 전 사용자에게 확인을 요청해야 합니다.
    *   종속성 처리: 삭제하려는 모델 구성이 현재 진행 중이거나 예약된 평가 작업에 사용되고 있다면 삭제를 제한하거나 경고를 표시해야 합니다. 완료된 평가 작업 결과는 해당 모델 구성 정보(삭제되어도 ID는 유지)를 참조하여 계속 조회 가능해야 합니다.

4. UI/UX Design Guide

*   화면 레이아웃 (Screen Layout):
    *   모델 목록 페이지:
        -   페이지 상단에 제목 ("모델 목록").
        -   그 아래에 검색 입력 필드와 필터 드롭다운/버튼 그룹 (`모델 유형`, `상태` 등).
        -   주요 영역은 등록된 모델 구성 목록을 표시하는 테이블.
        -   테이블 컬럼: `이름`, `기반 모델`, `유형`, `상태`, `설명 요약`, `등록 일시`, `Actions` (상세 보기, 편집, 복제, 상태 변경, 삭제).
        -   테이블 하단에 페이지네이션 컨트롤.
        -   테이블 상단 또는 하단에 "모델 등록" 버튼.
    *   모델 등록 모달/페이지:
        -   중앙에 위치하는 모달 창 또는 별도의 페이지. 상단에 제목 ("모델 등록").
        -   첫 단계 또는 상단에 `모델 유형` 선택 드롭다운 또는 라디오 버튼 그룹.
        -   `모델 유형` 선택에 따라 동적으로 변경되는 입력 폼 영역.
        -   필수 필드 (`이름`, `유형`) 및 선택 필드 (`설명`, `태그`).
        -   `모델 유형`별 상세 설정 필드 (`API 키`, `엔드포인트`, `파라미터` 그룹 등). API 키 입력 필드는 비밀번호 필드처럼 처리하고, 저장 후에는 수정 시에만 표시하거나 일부만 노출합니다.
        -   가장 하단에 "등록" 및 "취소" 버튼.
    *   모델 상세 정보 페이지:
        -   페이지 상단에 모델 구성 이름 및 핵심 정보 요약 (유형, 기반 모델, 상태).
        -   그 아래에 모델 구성의 모든 메타데이터 및 상세 설정 정보를 표시. 설정 정보는 읽기 전용으로 표시하되, `편집` 버튼을 통해 수정 모드로 전환 가능.
        -   `편집` 버튼, `상태 변경` 토글/버튼, `복제` 버튼, `삭제` 버튼.
        -   관련 정보 (예: 이 모델을 사용한 평가 작업 목록)를 보여주는 섹션 추가 고려.
*   사용자 상호작용 흐름 (User Interaction Flow):
    1.  모델 등록: 사용자 -> "모델 목록" 페이지 이동 -> "모델 등록" 버튼 클릭 -> "모델 등록" 모달/페이지 열림 -> `모델 유형` 선택 -> 유형에 맞는 폼 필드 입력 (이름, 설명, 설정 등) -> "등록" 버튼 클릭 -> 등록 완료 후 목록 페이지로 돌아가 새로 등록된 모델 구성 확인.
    2.  모델 조회 및 상세 보기: 사용자 -> "모델 목록" 페이지 이동 -> (필요시 검색/필터) -> 모델 목록 확인 -> 특정 모델 이름 클릭 -> "모델 상세" 페이지로 이동 -> 모델의 모든 정보 및 설정을 확인.
    3.  모델 편집: 사용자 -> "모델 상세" 페이지 이동 -> "편집" 버튼 클릭 -> 정보 수정 모드로 전환 (입력 필드 활성화) -> 정보 수정 -> "저장" 버튼 클릭 -> 수정 완료 후 읽기 전용 모드로 돌아가서 변경 사항 확인.
    4.  모델 상태 변경: 사용자 -> "모델 목록" 또는 "모델 상세" 페이지 -> 상태 변경 컨트롤 (토글 또는 버튼) 클릭 -> 상태 변경 확인 메시지 (필요시) -> 상태 변경 완료.
    5.  모델 복제: 사용자 -> "모델 목록" 또는 "모델 상세" 페이지 -> "복제" 버튼 클릭 -> "모델 등록" 모달/페이지가 기존 정보로 채워진 상태로 열림 -> (필요시 정보 수정, 특히 이름) -> "등록" 버튼 클릭 -> 복제된 새 모델 구성 등록 완료.
    6.  모델 삭제: 사용자 -> "모델 목록" 또는 "모델 상세" 페이지 -> "삭제" 버튼 클릭 -> 삭제 확인 메시지 -> 확인 클릭 -> 모델 구성 삭제 완료 후 목록 페이지로 돌아감.

5. Data Model

모델 관리를 위한 데이터 모델은 다음과 같습니다. 민감 정보는 직접 저장하지 않고 참조 ID를 사용합니다.

```
ModelConfiguration {
  "config_id": "uuid",                 // 고유 식별자
  "name": "string",                    // 모델 구성 이름 (필수, 시스템 내 고유)
  "model_type": "string",              // 모델 유형 (Cloud API, HF, Local/Custom 등, 필수)
  "base_model": "string",              // 기반 모델 식별자 (gpt-4-turbo, meta-llama/Llama-2-7b 등, 선택 사항)
  "description": "string",             // 설명 (선택 사항)
  "configuration": "json",             // 유형별 상세 설정 (API 키 참조, 엔드포인트, 파라미터 등, 필수) - JSONB 또는 유사 유연한 타입
  "license_info": "string",            // 라이선스 정보 (선택 사항)
  "tags": ["string"],                  // 태그 목록 (선택 사항)
  "status": "string",                  // 상태 (Active, Inactive, 필수)
  "registered_at": "datetime",         // 등록 일시
  "updated_at": "datetime",            // 마지막 수정 일시
  "registered_by": "user_id"           // 등록 사용자
}
```

`configuration` 필드의 예시 구조는 `model_type`에 따라 달라지며, API 키와 같은 민감 정보는 직접 저장하지 않고 별도의 보안 관리 시스템 참조 ID를 저장해야 합니다.

6. Acceptance Criteria

*   [ ] Hugging Face 모델 ID를 입력하면 모델 기본 정보(설명, 라이선스 등)가 자동으로 임포트된다.
*   [ ] Cloud API, Hugging Face, Local/Custom Endpoint 등 최소 3가지 이상의 `모델 유형`을 성공적으로 등록할 수 있다.
*   [ ] 각 `모델 유형`에 따라 필요한 설정 필드(API 키, 엔드포인트 URL, 파라미터 등)가 동적으로 제공된다.
*   [ ] 모델 `이름`은 필수 입력 항목이며, 시스템 내에서 고유해야 한다는 유효성 검사가 올바르게 작동한다.
*   [ ] API 키와 같은 민감 정보는 안전하게 처리되며, UI에 직접 노출되지 않는다.
*   [ ] 등록된 모델 구성 목록이 테이블 형태로 올바르게 표시되며, 주요 정보(`이름`, `유형`, `상태`, `기반 모델` 등)가 포함된다.
*   [ ] 모델 목록에서 `이름`, `유형`, `상태` 등으로 검색 및 필터링 기능이 정상 작동한다.
*   [ ] 모델 상세 페이지에서 해당 모델 구성의 모든 메타데이터 및 상세 설정 정보를 조회할 수 있다.
*   [ ] 모델 상세 페이지 또는 목록에서 모델 구성의 `상태`(활성/비활성)를 변경할 수 있다.
*   [ ] `비활성` 상태인 모델 구성은 새로운 평가 작업 생성 시 모델 선택 목록에 나타나지 않는다.
*   [ ] 등록된 모델 구성의 모든 정보를 편집하고 저장할 수 있다.
*   [ ] 기존 모델 구성을 복제하여 새로운 모델 구성을 빠르게 생성할 수 있다.
*   [ ] 등록된 모델 구성을 시스템에서 삭제할 수 있다.
*   [ ] 삭제하려는 모델 구성이 사용 중인 경우, 사용자에게 경고를 표시하거나 삭제를 제한한다.
*   [ ] Data Model에 정의된 `ModelConfiguration` 객체의 필드들이 실제 데이터베이스 스키마에 반영된다.
*   [ ] `configuration` 필드가 다양한 `모델 유형`의 설정을 유연하게 저장할 수 있는 구조로 구현된다.
*   [ ] UI/UX 디자인 사양에 명시된 각 화면(목록, 등록, 상세)의 주요 컴포넌트가 올바르게 배치된다.
*   [ ] 사용자 상호작용 흐름(등록, 조회, 편집, 상태 변경, 복제, 삭제)이 명시된 단계대로 오류 없이 완료된다.

### 2.3 평가 실행 및 관리 (Evaluation Run & Management)

1. Feature: 평가 실행 및 관리 (Evaluation Run & Management)

본 기능은 LLM 자동 평가 시스템의 핵심인 평가 작업의 생성, 실행, 모니터링, 그리고 완료된 평가 결과의 관리 기능을 제공합니다. 사용자는 '모델 관리' 기능을 통해 등록된 언어 모델과 '데이터셋 관리' 기능을 통해 준비된 평가 데이터셋을 조합하여 평가 작업을 정의하고 실행할 수 있습니다. 이 기능을 통해 다양한 모델의 성능을 일관된 기준과 환경에서 비교 분석할 수 있으며, 평가 프로세스의 투명성과 재현성을 확보합니다.

주요 목적:
- 사용자가 원하는 모델과 데이터셋을 선택하여 평가 작업을 쉽게 시작할 수 있도록 합니다.
- 평가 작업의 진행 상황을 실시간으로 모니터링하고 제어할 수 있는 기능을 제공합니다.
- 평가 실행 결과를 체계적으로 저장하고 관리하여, 추후 상세 분석 및 비교에 활용할 수 있도록 합니다.
- 평가 실패 시 원인을 파악하고 재실행할 수 있는 유연성을 제공합니다.

2. User Stories

*   As an AI Evaluator, I want to create a new evaluation task by selecting one or more registered LLM models and a specific version of a dataset, so that I can start evaluating different models on a known dataset.
*   As an AI Evaluator, I want to configure evaluation parameters for a task, such as the batch size for model calls, concurrency level, timeout per sample, and which metrics to apply, so that I can control the evaluation environment and focus on relevant performance aspects.
*   As an AI Evaluator, I want to start an evaluation task manually after creating it, so that I can initiate the process when ready.
*   As an AI Evaluator, I want to monitor the progress of running evaluation tasks in real-time, including the number of samples processed, completion percentage, estimated time remaining, and any errors encountered, so that I can stay informed about the evaluation status.
*   As an AI Evaluator, I want to stop a running evaluation task if needed (e.g., if errors are high or configuration is wrong), so that I can conserve resources or correct issues.
*   As an AI Evaluator, I want to view the aggregate results for a completed evaluation run, including overall scores for each metric for each evaluated model, so that I can quickly compare the performance of models.
*   As an AI Evaluator, I want to drill down into the detailed results of a completed evaluation run, viewing the input, model output, golden label, and sample-level metric scores for each individual sample, so that I can understand where models performed well or poorly.
*   As an AI Evaluator, I want to filter and search sample-level results by model, sample status (success/failure), or score range, so that I can easily find samples of interest (e.g., where a model failed).
*   As an AI Evaluator, I want to re-run a failed or completed evaluation task, with the option to re-evaluate only the samples that previously failed, so that I can retry after fixing issues or extend an evaluation.
*   As an AI Evaluator, I want to cancel a pending evaluation task that has not started yet, so that I can discard unwanted or misconfigured tasks.
*   As an AI Evaluator, I want to delete evaluation tasks and their associated results when they are no longer needed, so that I can manage storage and keep the system clean.
*   As an AI Evaluator, I want to receive notifications (e.g., email, in-app) when an evaluation task completes or fails, so that I don't have to constantly monitor the system.

3. Detailed Functional Requirements

*   평가 작업 생성 (Evaluation Task Creation):
    *   작업 기본 정보: 평가 작업의 `이름` (필수, 시스템 내 고유해야 함) 및 `설명` (선택 사항)을 입력할 수 있어야 합니다.
    *   모델 선택: 시스템에 등록된 `활성` 상태의 모델 구성 목록에서 하나 이상의 모델을 선택할 수 있어야 합니다. 다중 모델 선택을 지원하여 한 번의 실행으로 여러 모델을 비교할 수 있도록 합니다.
    *   데이터셋 및 버전 선택: 시스템에 등록된 데이터셋 목록에서 하나를 선택하고, 해당 데이터셋의 특정 `버전`을 선택할 수 있어야 합니다. 최신 버전이 기본 선택되어야 합니다.
    *   평가 파라미터 설정:
        -   모델 추론 파라미터 오버라이드: 선택된 각 모델 구성에 대해 등록 시 정의된 기본 추론 파라미터 (`temperature`, `top_p`, `max_tokens` 등)를 이 특정 평가 실행에 한해 재정의(override)할 수 있는 옵션을 제공합니다. (선택 사항)
        -   실행 파라미터:
            -   `배치 크기 (Batch Size)`: 모델 API 호출 시 한 번에 처리할 샘플 수. (모델이 배치 추론을 지원하는 경우)
            -   `동시성 (Concurrency)`: 동시에 실행할 모델 API 호출 또는 샘플 처리 수. (전체 실행 또는 모델별로 설정 가능)
            -   `샘플당 제한 시간 (Timeout per Sample)`: 각 샘플 처리 (모델 호출 + 메트릭 계산)에 허용되는 최대 시간.
            -   `재시도 정책 (Retry Policy)`: 모델 호출 또는 메트릭 계산 실패 시 재시도 횟수 및 간격.
        -   메트릭 선택: 평가 실행에 사용할 메트릭 목록을 선택할 수 있어야 합니다. 각 메트릭에 대한 특정 설정 (예: LLM 기반 메트릭의 프롬프트 템플릿)을 구성할 수 있어야 합니다.
    *   예약/즉시 실행: 생성과 동시에 즉시 실행하거나, 나중에 수동으로 시작하도록 `Pending` 상태로 저장할 수 있어야 합니다. (향후 예약 기능 추가 고려)
*   평가 실행 (Evaluation Execution):
    *   사용자의 명시적인 시작 요청 (즉시 실행 또는 수동 시작) 시 평가 작업이 시작됩니다.
    *   시스템은 선택된 데이터셋의 지정된 버전의 모든 샘플을 순회하며, 선택된 각 모델에 대해 다음 과정을 수행합니다.
        1.  모델 호출: 샘플 `입력` 데이터를 사용하여 선택된 모델 API를 호출합니다. 설정된 `배치 크기`, `동시성`, `샘플당 제한 시간`, `재시도 정책`을 적용합니다.
        2.  응답 수집: 모델의 출력(`model_output`)을 수신합니다.
        3.  출력 파싱/정규화: 데이터셋 유형 및 메트릭 요구사항에 맞춰 모델 출력을 파싱하거나 정규화(`processed_output`)합니다.
        4.  메트릭 계산: `model_input`, `model_output` (`processed_output`), `golden_label` (필요시)을 사용하여 선택된 메트릭별 점수를 계산합니다.
        5.  결과 저장: 각 샘플, 각 모델에 대한 `샘플 결과 (SampleResult)` (입력, 출력, 골든 라벨, 메트릭 점수, 상태, 오류 정보 등)를 저장합니다.
    *   모든 샘플 처리가 완료되거나 작업이 중지/취소될 때까지 실행을 계속합니다.
    *   실행 중 오류 발생 시 (`모델 에러`, `메트릭 에러`, `타임아웃` 등) 해당 샘플 결과를 `실패 (Failure)` 상태로 기록하고, 구성된 재시도 정책에 따라 처리한 후 다음 샘플로 진행합니다. 전체 작업 실패 기준 (예: 특정 비율 이상의 샘플 실패)을 설정할 수 있습니다.
*   상태 관리 (State Management):
    *   평가 작업은 다음과 같은 상태를 가집니다:
        -   `Pending`: 생성되었으나 아직 시작되지 않음.
        -   `Running`: 현재 실행 중.
        -   `Completed`: 모든 샘플 처리가 성공적으로 완료됨.
        -   `Failed`: 실행 중 치명적인 오류가 발생하거나, 전체 작업 실패 기준을 초과하여 중단됨.
        -   `Cancelled`: 사용자에 의해 강제로 중지됨.
    *   상태 전이: `Pending` -> `Running`, `Running` -> (`Completed` | `Failed` | `Cancelled`), `Completed`/`Failed` -> `Pending` (재실행 시), `Pending` -> `Cancelled`.
*   모니터링 (Monitoring):
    *   실행 현황 대시보드/목록: `Running` 상태 작업의 현재 진행률 (처리된 샘플 수 / 전체 샘플 수), 완료율 (%), 경과 시간, 예상 완료 시간, 현재 처리 중인 샘플 정보, 발생한 오류 수 등을 실시간으로 확인할 수 있는 요약 정보를 제공합니다.
    *   실행 로그: 평가 실행 중 발생하는 상세 로그 (모델 호출 요청/응답, 메트릭 계산 과정, 오류 메시지 등)를 실시간으로 조회할 수 있는 기능을 제공합니다. 로그 레벨 설정 (Info, Warning, Error 등)을 지원할 수 있습니다.
*   결과 저장 및 조회 (Results Storage and Viewing):
    *   샘플 결과: 각 평가 실행, 각 모델, 각 데이터셋 샘플에 대한 상세 결과 (`EvaluationSampleResult` 객체)를 데이터베이스에 저장합니다. 여기에는 샘플 입력, 모델 원본 출력, 파싱된 출력, 골든 라벨, 메트릭별 샘플 점수, 해당 샘플 처리 상태 및 오류 정보가 포함됩니다.
    *   종합 결과: 평가 실행 완료 시, 선택된 각 모델에 대한 전체 샘플 기반의 종합 메트릭 점수 (평균, 중앙값 등) 및 통계 정보 (처리 시간 분포, 성공/실패 샘플 수 등)를 계산하여 `EvaluationRun` 객체에 저장하거나 연결된 형태로 저장합니다.
    *   결과 조회 인터페이스:
        -   종합 결과 요약: 평가 실행 상세 페이지에서 실행 개요와 함께 종합 메트릭 점수를 모델별로 비교하는 테이블/차트를 제공합니다.
        -   상세 샘플 결과 목록: 평가 실행 상세 페이지에서 개별 샘플 결과 목록을 테이블 형태로 제공합니다. 모델, 샘플 상태 (성공/실패 등), 메트릭 점수 범위 등으로 필터링 및 검색할 수 있어야 합니다. 각 샘플 결과 행 클릭 시 해당 샘플의 상세 정보 (입력, 모델 출력, 골든 라벨, 메트릭별 샘플 점수, 오류 내용)를 모달 또는 별도 페이지에서 확인할 수 있습니다.
*   작업 관리 (Task Management):
    *   시작 (Start): `Pending` 상태의 작업을 `Running` 상태로 전환합니다.
    *   중지/취소 (Stop/Cancel): `Running` 상태의 작업을 강제로 중단하고 `Cancelled` 상태로 전환합니다. 진행 중이던 샘플 처리는 중단하며, 이미 처리된 샘플 결과는 저장됩니다. `Pending` 상태의 작업은 `Cancelled` 상태로 전환합니다.
    *   재실행 (Rerun): `Completed` 또는 `Failed` 상태의 작업을 대상으로 합니다. 새로운 `Pending` 상태의 평가 작업을 생성하되, 기존 작업의 설정 (모델, 데이터셋 버전, 파라미터)을 복사하여 사용합니다.
        -   실패한 샘플만 재실행: 재실행 시, 기존 실행에서 `Failed` 또는 `Cancelled` 상태였던 샘플들만 대상으로 선택하여 실행하는 옵션을 제공합니다. (이 경우 새로운 실행 결과는 기존 실행 결과에 누적되거나, 별도의 새로운 실행으로 관리될 수 있습니다. 후자가 재현성 및 관리 용이성 측면에서 유리하며, "새로운 실행으로 관리"를 기본으로 합니다.)
    *   삭제 (Delete): 평가 작업 및 관련된 모든 샘플 결과 데이터를 시스템에서 제거합니다. `Running` 또는 `Pending` 상태의 작업을 삭제 시도 시 사용자에게 경고를 표시하고 확인을 요청해야 합니다.
*   알림 (Notifications - Optional):
    *   평가 작업 완료 (`Completed`) 또는 실패 (`Failed`) 시, 작업 생성자에게 시스템 알림, 이메일 등의 방식으로 결과를 통지하는 기능을 제공합니다.

4. UI/UX Design Guide

*   화면 레이아웃 (Screen Layout):
    *   평가 실행 목록/대시보드 페이지:
        -   페이지 상단에 제목 ("평가 실행 목록" 또는 "평가 대시보드").
        -   상단에 `Running` 상태 작업의 요약 정보 (총 개수, 진행률 합계 등) 또는 시각화 (예: 진행률 바 목록).
        -   그 아래에 검색 입력 필드 및 필터 드롭다운/버튼 그룹 (`상태`, `모델`, `데이터셋`, `생성 사용자` 등).
        -   주요 영역은 평가 작업 목록을 표시하는 테이블.
        -   테이블 컬럼: `이름`, `상태`, `진행률 (%)`, `경과 시간`, `예상 남은 시간`, `모델 수`, `데이터셋`, `버전`, `생성 일시`, `Actions` (상세 보기, 중지/취소, 재실행, 삭제).
        -   테이블 하단에 페이지네이션 컨트롤.
        -   테이블 상단 또는 하단에 "평가 실행 생성" 버튼.
    *   평가 실행 생성 페이지/모달:
        -   단계별 마법사 형태 또는 단일 폼 페이지. 상단에 제목 ("평가 실행 생성").
        -   Step 1: 기본 정보: 작업 `이름`, `설명` 입력 필드.
        -   Step 2: 데이터셋 선택: 드롭다운 또는 목록에서 데이터셋 선택. 선택된 데이터셋의 `버전` 선택 드롭다운. (데이터셋 미리보기 링크 제공)
        -   Step 3: 모델 선택: 체크박스 또는 목록에서 하나 이상의 `활성` 상태 모델 선택. 선택된 모델 목록 표시 영역. 각 모델 옆에 '설정 오버라이드' 버튼 (클릭 시 파라미터 수정 모달/영역 표시).
        -   Step 4: 실행 파라미터: `배치 크기`, `동시성`, `샘플당 제한 시간`, `재시도 정책` 등 입력 필드.
        -   Step 5: 메트릭 선택: 사용 가능한 메트릭 목록에서 선택 (체크박스). 선택된 각 메트릭 옆에 '설정' 버튼 (클릭 시 메트릭별 설정 모달/영역 표시).
        -   가장 하단에 "저장 (Pending)", "실행", "취소" 버튼. (단계별 마법사 시 "이전", "다음" 버튼 포함)
    *   평가 실행 상세 페이지:
        -   페이지 상단에 평가 작업 이름 및 핵심 정보 요약 (상태, 데이터셋, 버전, 모델 목록, 생성 정보).
        -   진행 중인 작업의 경우, 진행률 바, 처리된 샘플 수, 경과 시간, 예상 완료 시간 등의 실시간 정보 표시 영역.
        -   `Actions` 버튼 그룹 (작업 상태에 따라 "중지", "취소", "재실행", "삭제" 활성화).
        -   하단에 탭 인터페이스 (`개요`, `종합 결과`, `샘플 결과`, `로그`).
        -   `개요` 탭: 작업 설정 정보 (선택된 모델 및 오버라이드 파라미터, 데이터셋 및 버전, 실행 파라미터, 메트릭 설정) 요약.
        -   `종합 결과` 탭: `Completed` 또는 `Failed` 상태 작업의 종합 메트릭 점수 테이블 및 시각화 (바 차트 등). 모델별/메트릭별로 점수를 비교.
        -   `샘플 결과` 탭: 평가된 샘플 결과 목록 테이블. 컬럼: `샘플 ID`, `모델 이름`, `샘플 상태`, `주요 메트릭 점수`, `Actions` (상세 보기). 테이블 상단에 모델, 샘플 상태, 점수 범위 등으로 필터링 및 검색 기능. 테이블 하단에 페이지네이션.
        -   `로그` 탭: 실행 로그를 실시간 또는 완료 후 조회할 수 있는 영역. 필터링(로그 레벨), 검색 기능.
    *   샘플 결과 상세 모달/페이지: 선택된 `샘플 결과`의 모든 정보 표시. `입력`, `모델 원본 출력`, `파싱된 출력`, `골든 라벨`, 각 `메트릭별 점수`, `샘플 상태`, `오류 상세 내용` 등을 구조화하여 표시.

*   사용자 상호작용 흐름 (User Interaction Flow):
    1.  평가 작업 생성 및 실행: 사용자 -> "평가 실행 목록" 페이지 이동 -> "평가 실행 생성" 버튼 클릭 -> "평가 실행 생성" 폼/마법사 단계별 입력 (이름, 데이터셋/버전, 모델 선택, 파라미터, 메트릭) -> "실행" 버튼 클릭 (또는 "저장" 후 목록에서 "시작" 클릭) -> 작업 `Running` 상태로 전환 -> "평가 실행 목록" (또는 대시보드)에서 진행 상황 모니터링.
    2.  실행 모니터링: 사용자 -> "평가 실행 목록" 페이지 -> `Running` 상태 작업의 진행률, 상태 확인 -> 특정 작업 이름 클릭 -> "평가 실행 상세" 페이지 ('개요', 실시간 정보) 이동 -> '로그' 탭에서 상세 로그 확인.
    3.  작업 중지/취소: 사용자 -> "평가 실행 목록" 또는 "상세" 페이지 -> `Running` 또는 `Pending` 상태 작업 옆 또는 상세 페이지 `Actions`에서 "중지"/"취소" 버튼 클릭 -> 확인 메시지 -> 확인 클릭 -> 작업 `Cancelled` 상태로 전환.
    4.  결과 조회: 사용자 -> "평가 실행 목록" 페이지 -> `Completed` 또는 `Failed` 상태 작업 확인 -> 작업 이름 클릭 -> "평가 실행 상세" 페이지 이동 -> '종합 결과' 탭에서 모델별 종합 점수 비교 -> '샘플 결과' 탭 이동 -> 샘플 목록 확인 -> 필터/검색으로 특정 샘플 검색 -> 샘플 행 옆 "상세 보기" 버튼 클릭 -> "샘플 결과 상세" 모달 열림 -> 상세 데이터 확인.
    5.  작업 재실행: 사용자 -> "평가 실행 목록" 또는 "상세" 페이지 -> `Completed` 또는 `Failed` 상태 작업 옆 또는 상세 페이지 `Actions`에서 "재실행" 버튼 클릭 -> 재실행 옵션 (전체/실패 샘플) 선택 모달 -> (필요시 파라미터 수정) -> "재실행" 버튼 클릭 -> 새로운 평가 작업이 `Pending` 또는 `Running` 상태로 생성 및 시작됨.
    6.  작업 삭제: 사용자 -> "평가 실행 목록" 또는 "상세" 페이지 -> 작업 옆 또는 상세 페이지 `Actions`에서 "삭제" 버튼 클릭 -> 확인 메시지 (Running/Pending 시 경고 포함) -> 확인 클릭 -> 작업 및 관련 결과 데이터 삭제 완료.

5. Data Model

평가 실행 및 관리를 위한 데이터 모델은 다음과 같습니다.

```
EvaluationRun {
  "run_id": "uuid",                          // 고유 식별자
  "name": "string",                          // 평가 실행 작업 이름 (필수)
  "description": "string",                   // 설명 (선택 사항)
  "dataset_id": "uuid",                      // 사용된 데이터셋 ID (필수)
  "dataset_version_id": "uuid",              // 사용된 데이터셋 버전 ID (필수) - Dataset.versions[].version_id 참조
  "model_config_ids": ["uuid"],              // 사용된 모델 구성 ID 목록 (필수) - ModelConfiguration.config_id 참조
  "run_parameters": "json",                  // 이 실행에 적용된 실행 파라미터 및 오버라이드 모델 파라미터 (JSONB 또는 유사 유연한 타입)
  "metric_configurations": "json",           // 이 실행에 사용된 메트릭 구성 목록 (JSONB 또는 유사 유연한 타입)
  "status": "string",                        // 상태 (Pending, Running, Completed, Failed, Cancelled)
  "total_samples": "integer",                // 데이터셋 버전의 총 샘플 수
  "processed_samples": "integer",            // 처리 완료된 샘플 수 (Running 상태에서 업데이트)
  "successful_samples": "integer",           // 성공적으로 처리된 샘플 수
  "failed_samples": "integer",               // 처리 중 오류 발생한 샘플 수
  "started_at": "datetime",                  // 실행 시작 일시 (Running 상태 진입 시)
  "completed_at": "datetime",                // 실행 완료/실패/취소 일시 (Terminal 상태 진입 시)
  "created_at": "datetime",                  // 작업 생성 일시
  "created_by": "user_id",                   // 작업 생성 사용자
  "error_details": "string",                 // Failed 상태 시 상세 오류 메시지/요약
  "aggregate_results": "json"                // 종합 메트릭 점수 및 통계 (Completed/Failed 상태 시 계산) - JSONB 또는 유사 타입
}

EvaluationSampleResult {
  "sample_result_id": "uuid",                // 고유 식별자
  "run_id": "uuid",                          // 연결된 평가 실행 ID (필수) - EvaluationRun.run_id 참조
  "dataset_id": "uuid",                      // 사용된 데이터셋 ID (참조용)
  "dataset_version_id": "uuid",              // 사용된 데이터셋 버전 ID (참조용)
  "sample_id": "uuid",                       // 원본 데이터셋 샘플 ID (필수) - DataSample.sample_id 참조
  "model_config_id": "uuid",                 // 결과가 생성된 모델 구성 ID (필수) - ModelConfiguration.config_id 참조
  "model_input": "json",                     // 이 샘플에 대해 모델에 전송된 입력 (snapshot)
  "model_output": "string",                  // 모델의 원본 출력
  "processed_output": "json",                // 파싱/정규화된 모델 출력 (필요시)
  "golden_label": "json",                    // 원본 데이터셋 샘플의 골든 라벨 (snapshot)
  "sample_status": "string",                 // 샘플 처리 상태 (Success, ModelError, MetricError, Timeout, OtherFailure)
  "metric_scores": "json",                   // 이 샘플에 대한 메트릭별 점수 - JSONB 또는 유사 타입
  "error_details": "string",                 // 샘플 처리 중 발생한 상세 오류 메시지
  "processing_time_ms": "integer",           // 이 샘플 처리에 소요된 시간 (모델 호출 + 메트릭 계산)
  "created_at": "datetime"                   // 결과 저장 일시
}
```

Data Model 객체 간의 관계는 다음과 같습니다.
*   `EvaluationRun`은 `run_id`를 통해 `EvaluationSampleResult`와 1:N 관계를 가집니다.
*   `EvaluationRun`은 `model_config_ids` 목록을 통해 `ModelConfiguration`과 N:M 관계를 가집니다.
*   `EvaluationRun`은 `dataset_id` 및 `dataset_version_id`를 통해 `Dataset` 및 `Version` 객체를 참조합니다.
*   `EvaluationSampleResult`는 `sample_id`를 통해 원본 `DataSample` 객체를 참조합니다 (이는 `EvaluationRun`이 참조하는 데이터셋 버전 내에 포함됩니다).
*   `EvaluationSampleResult`는 `model_config_id`를 통해 `ModelConfiguration` 객체를 참조합니다.

6. Acceptance Criteria

*   [ ] `활성` 상태의 모델 구성 목록과 등록된 데이터셋 및 그 버전 목록을 조회할 수 있다.
*   [ ] 평가 작업 생성 시, 하나 이상의 모델과 데이터셋의 특정 버전을 선택할 수 있다.
*   [ ] 평가 작업 생성 시, 작업 이름, 설명, 배치 크기, 동시성, 샘플당 제한 시간, 재시도 정책 등 실행 파라미터를 설정할 수 있다.
*   [ ] 평가 작업 생성 시, 선택된 각 모델에 대해 등록 시 설정된 기본 추론 파라미터를 오버라이드할 수 있다.
*   [ ] 평가 작업 생성 시, 사용할 메트릭을 선택하고 필요한 메트릭별 설정을 구성할 수 있다.
*   [ ] 평가 작업을 생성과 동시에 `Running` 상태로 시작하거나, `Pending` 상태로 저장 후 수동으로 시작할 수 있다.
*   [ ] `Running` 상태 작업의 진행률, 경과 시간, 예상 완료 시간, 처리된 샘플 수, 오류 발생 수 등 모니터링 정보를 실시간으로 확인할 수 있다.
*   [ ] 실행 중인 작업의 상세 로그를 실시간으로 조회할 수 있다.
*   [ ] `Running` 상태의 작업을 사용자의 요청에 의해 `Cancelled` 상태로 중지할 수 있다.
*   [ ] `Pending` 상태의 작업을 사용자의 요청에 의해 `Cancelled` 상태로 취소할 수 있다.
*   [ ] 평가 실행 완료 (`Completed`) 또는 실패 (`Failed`) 시 `EvaluationRun` 객체에 종합 결과(`aggregate_results`)가 계산되어 저장된다.
*   [ ] 평가 실행의 모든 `EvaluationSampleResult`가 데이터베이스에 올바르게 저장되며, 샘플 입력, 모델 출력, 골든 라벨, 메트릭별 샘플 점수, 샘플 상태, 오류 정보가 포함된다.
*   [ ] 평가 실행 상세 페이지에서 종합 결과 요약(모델별 메트릭 점수 비교)을 확인할 수 있다.
*   [ ] 평가 실행 상세 페이지에서 개별 샘플 결과 목록을 테이블 형태로 조회할 수 있다.
*   [ ] 샘플 결과 목록에서 모델, 샘플 상태, 메트릭 점수 등으로 검색 및 필터링 기능이 정상 작동한다.
*   [ ] 개별 샘플 결과 상세 보기 시 모든 저장된 정보(입력, 출력, 점수, 오류 등)를 올바르게 확인할 수 있다.
*   [ ] `Completed` 또는 `Failed` 상태의 작업을 재실행하여 새로운 평가 작업을 생성할 수 있다.
*   [ ] 재실행 시 기존 실행에서 `Failed` 또는 `Cancelled` 상태였던 샘플들만 대상으로 선택하여 실행하는 옵션이 제공된다. (이 경우 새로운 `EvaluationRun` 객체가 생성된다.)
*   [ ] 평가 작업 및 관련된 모든 `EvaluationSampleResult` 데이터를 삭제할 수 있다.
*   [ ] `Running` 또는 `Pending` 상태의 작업을 삭제 시도 시 사용자에게 경고를 표시하고 확인을 요청한다.
*   [ ] Data Model에 정의된 `EvaluationRun` 및 `EvaluationSampleResult` 객체의 필드들이 실제 데이터베이스 스키마에 반영된다.
*   [ ] Data Model 객체 간의 관계(EvaluationRun과 SampleResult, EvaluationRun과 Model/Dataset/Version)가 올바르게 구현된다.
*   [ ] UI/UX 디자인 가이드에 명시된 각 화면(목록/대시보드, 생성, 상세, 샘플 결과 상세)의 주요 컴포넌트가 올바르게 배치된다.
*   [ ] 사용자 상호작용 흐름(생성/실행, 모니터링, 중지/취소, 결과 조회, 재실행, 삭제)이 명시된 단계대로 오류 없이 완료된다.

### 2.4 평가 지표 관리 (Metric Management)

1. Feature: 평가 지표 관리 (Metric Management)

본 기능은 LLM 자동 평가 시스템에서 모델 성능을 측정하는 데 사용되는 다양한 평가 지표(Metrics)를 정의하고 관리합니다. 사용자는 시스템에서 기본 제공하는 표준 지표(예: 정확도, F1-Score, ROUGE, BLEU)를 선택하거나, 특정 도메인이나 태스크에 맞는 커스텀 지표를 직접 구현하여 시스템에 등록할 수 있습니다. 등록된 지표는 '평가 실행 관리' 기능을 통해 특정 평가 작업에 적용되어 모델의 출력을 정량적으로 평가하는 데 사용됩니다.

주요 목적:
- 다양한 평가 기준을 시스템 내에서 중앙 집중식으로 관리합니다.
- 사용자가 필요에 따라 새로운 평가 지표를 쉽게 추가하고 사용할 수 있도록 지원합니다.
- 커스텀 지표 구현을 통해 시스템의 유연성과 확장성을 확보합니다.
- 지표 버전을 관리하여 평가 결과의 재현성과 투명성을 보장합니다.

2. User Stories

*   As an AI Evaluator, I want to select from a list of standard, built-in metrics (like Accuracy, F1, BLEU, ROUGE) when configuring an evaluation run, so that I can use common and well-understood performance measures.
*   As an AI Evaluator, I want to register new custom evaluation metrics by uploading or inputting code (e.g., Python script), so that I can measure model performance using logic specific to my task or domain.
*   As an AI Evaluator, I want to provide metadata and descriptions for each registered metric (both built-in and custom), so that I and other users can understand what the metric measures and how it's calculated.
*   As an AI Evaluator, I want to view a comprehensive list of all available metrics, including their type (built-in/custom) and description, so that I can easily choose which metrics to apply to my evaluation runs.
*   As an AI Evaluator, I want to edit the metadata of custom metrics I registered, so that I can correct descriptions or update information.
*   As an AI Evaluator, I want the system to manage different versions of a custom metric's implementation (e.g., when I update the calculation logic), so that I can ensure reproducibility of past evaluation results and track changes in metric definitions.
*   As an AI Evaluator, I want to select a specific version of a metric when configuring an evaluation run, so that the evaluation uses a fixed, known metric definition.
*   As an AI Evaluator, I want to deactivate or delete custom metrics that are no longer needed, so that I can keep the list of available metrics clean. (Consideration: Prevent deletion if actively used in past runs).
*   As a System Administrator, I want to manage the standard, built-in metrics, including adding new ones or updating their descriptions.

3. Detailed Functional Requirements

*   지표 생성 및 등록 (Metric Creation and Registration):
    *   지표 유형: 시스템은 다음 두 가지 유형의 지표를 지원해야 합니다.
        -   `BUILT_IN`: 시스템에 미리 정의되고 내장된 지표 (예: Exact Match, F1 Score, BLEU, ROUGE, BERTScore 등). 이러한 지표는 사용자가 코드를 제공할 필요 없이 선택하여 사용합니다. 관리자는 새로운 내장 지표를 추가/업데이트할 수 있습니다.
        -   `CUSTOM_SCRIPT`: 사용자가 직접 제공한 코드(현재는 Python 스크립트 기준)로 구현된 지표. 사용자는 스크립트 파일 또는 코드 스니펫을 입력하여 등록합니다.
    *   등록 인터페이스: 사용자는 지표 이름, 설명, 지표 유형을 선택하고 입력하는 인터페이스를 제공받습니다.
    *   `CUSTOM_SCRIPT` 상세 입력:
        -   `스크립트 코드: 지표 계산 로직을 담은 Python 코드를 직접 입력하거나 파일로 업로드할 수 있는 코드 에디터 또는 파일 업로드 필드를 제공합니다.
        -   `함수 명세: 스크립트 내에서 지표 계산을 수행할 특정 함수의 이름과 예상되는 입력/출력 형식에 대한 가이드라인을 명시하고, 사용자가 이를 준수하도록 안내해야 합니다. (예: 함수 시그니처 `calculate(input: Dict, output: str, golden_label: Optional[str] = None) -> Union[float, Dict]`)
        -   `필요 라이브러리/의존성 명시:` 스크립트 실행에 필요한 외부 라이브러리 목록(예: `numpy`, `scikit-learn`, `nltk`, `transformers`)을 명시하도록 요구하거나, 시스템이 제한된 환경에서 실행되도록 안내합니다. (향후 의존성 관리 기능 추가 고려)
    *   필수 입력 필드: 지표 `이름` (필수, 시스템 내 고유해야 함), `지표 유형` (필수).
    *   유효성 검사: 지표 이름의 고유성, 필수 필드 누락 여부, `CUSTOM_SCRIPT` 유형 선택 시 스크립트 코드 입력 여부 등을 검사합니다. `CUSTOM_SCRIPT`의 경우, 기본적인 구문 유효성 검사 또는 더미 데이터를 사용한 테스트 실행 옵션을 제공할 수 있습니다.
*   지표 조회 및 관리 (Metric Viewing and Management):
    *   목록 조회: 등록된 모든 지표 목록을 테이블 형태로 표시합니다. 각 행은 `이름`, `유형`, `설명 요약`, `현재 버전` (커스텀 지표), `등록 일시`, `Actions` (상세 보기, 편집, 비활성화/활성, 삭제)를 포함합니다.
    *   검색 및 필터링: 지표 `이름`, `설명`, `유형` 등으로 검색 및 필터링 기능을 제공합니다.
    *   상세 정보 조회: 특정 지표의 상세 정보 (전체 설명, 유형, 등록 정보, 커스텀 스크립트 코드 스니펫 (읽기 전용), 전체 버전 목록)를 별도 페이지 또는 모달로 제공합니다.
    *   메타데이터 편집: `CUSTOM_SCRIPT` 유형의 지표에 대해 `이름`, `설명` 등을 수정할 수 있는 기능을 제공합니다. (스크립트 코드 자체 수정은 버전 관리를 통해 이루어짐). `BUILT_IN` 지표의 편집 권한은 관리자에게만 부여될 수 있습니다.
    *   상태 관리: 지표를 `활성 (Active)` 또는 `비활성 (Inactive)` 상태로 전환할 수 있습니다. `비활성` 상태의 지표는 새로운 평가 작업 생성 시 메트릭 선택 목록에 나타나지 않습니다.
    *   삭제: 등록된 지표를 시스템에서 제거하는 기능을 제공합니다.
        -   종속성 처리: 삭제하려는 지표가 완료된 평가 실행에서 사용되었다면, 해당 지표 정보(메타데이터 및 사용된 버전 정보)는 삭제되지 않고 "보관(Archived)" 상태로 전환되거나, 메타데이터만 보존하고 새로운 평가에는 사용 불가하도록 처리합니다. 과거 결과 조회 시 필요한 정보는 유지되어야 합니다. `Running` 또는 `Pending` 상태의 평가 작업에서 사용 중이라면 삭제를 제한하거나 경고를 표시해야 합니다. `CUSTOM_SCRIPT` 지표 삭제 시 해당 스크립트 코드는 즉시 삭제되거나 안전하게 보관 후 삭제될 수 있습니다.
*   커스텀 지표 구현 및 실행 (Custom Metric Implementation and Execution):
    *   스크립트 저장: 사용자가 입력한 Python 스크립트 코드는 `MetricVersion` 객체와 함께 안전하게 저장됩니다.
    *   실행 환경: 평가 실행 중 커스텀 지표 계산이 필요할 때, 해당 지표의 특정 버전 스크립트 코드를 격리된 안전한 환경(예: 컨테이너, 샌드박스)에서 동적으로 로드하고 실행합니다.
    *   입력 전달: 스크립트의 계산 함수에는 평가 대상 샘플의 `모델 입력`, `모델 출력`, `골든 라벨` 등 필요한 데이터가 시스템에서 구조화된 형태로 전달되어야 합니다.
    *   결과 수집: 스크립트 함수의 반환값(지표 점수)을 수집하고, `EvaluationSampleResult`에 저장합니다.
    *   오류 처리: 스크립트 실행 중 발생하는 예외(구문 오류, 런타임 오류, 타임아웃 등)를 포착하고, 해당 샘플 결과의 상태를 `MetricError`로 기록하며, 오류 상세 정보를 저장합니다.
    *   성능/보안 고려: 커스텀 스크립트의 무한 루프, 과도한 리소스 사용, 악성 코드 실행 등을 방지하기 위한 시간/메모리 제한, 네트워크 접근 제어 등 보안 및 리소스 관리 메커니즘이 필요합니다. (시스템 설계 수준에서는 요구사항 명시)
*   지표 버전 관리 (Metric Versioning):
    *   버전 생성: `CUSTOM_SCRIPT` 유형의 지표에 대해 사용자가 스크립트 코드를 수정하거나, 명시적으로 새로운 버전을 생성 요청할 때 새로운 `MetricVersion` 객체가 생성됩니다. 각 버전은 순차적인 `버전 번호`, `스크립트 코드`, `생성 일시`, `생성 사용자`, `변경 내용 요약` 등의 정보를 가집니다.
    *   현재 버전: 각 `Metric`은 기본적으로 최신 `MetricVersion`을 "현재 버전"으로 가리킵니다.
    *   버전 목록 및 상세: 지표 상세 페이지에서 해당 지표의 전체 버전 목록을 조회하고, 각 버전의 상세 정보 (스크립트 코드, 변경 요약)를 확인할 수 있습니다.
    *   평가 실행 시 버전 선택: '평가 실행 생성' 시 `CUSTOM_SCRIPT` 유형의 지표를 선택할 때, 해당 지표의 사용 가능한 버전 목록에서 특정 버전을 선택하여 사용할 수 있도록 제공합니다. (최신 버전이 기본값). `BUILT_IN` 지표는 별도의 버전 선택이 필요 없을 수 있으나, 내부적으로는 관리자에 의해 업데이트되는 버전을 가질 수 있습니다.
    *   재현성 보장: 평가 실행 결과는 사용된 지표의 특정 `MetricVersion` ID를 참조함으로써, 해당 평가가 실행되었을 때 사용된 정확한 지표 로직을 추적하고 재현성을 확보합니다.

4. UI/UX Design Guide

*   화면 레이아웃 (Screen Layout):
    *   지표 목록 페이지:
        -   페이지 상단에 제목 ("평가 지표 목록").
        -   그 아래에 검색 입력 필드와 필터 드롭다운 (`유형`, `상태`).
        -   주요 영역은 등록된 지표 목록을 표시하는 테이블.
        -   테이블 컬럼: `이름`, `유형`, `설명 요약`, `현재 버전` (커스텀 지표), `상태`, `등록 일시`, `Actions` (상세 보기, 편집, 상태 변경, 삭제).
        -   테이블 하단에 페이지네이션 컨트롤.
        -   테이블 상단 또는 하단에 "지표 등록" 버튼.
    *   지표 등록/수정 페이지:
        -   별도의 페이지 또는 모달. 상단에 제목 ("지표 등록", "지표 수정").
        -   기본 정보 영역: `이름` (입력 필드), `설명` (텍스트 영역), `지표 유형` (드롭다운 또는 라디오 버튼).
        -   `지표 유형`이 `CUSTOM_SCRIPT`인 경우에만 표시되는 영역:
            -   `스크립트 코드` 입력 영역: 신택스 하이라이팅, 자동 완성 기능이 있는 코드 에디터. 파일 업로드 버튼.
            -   `스크립트 가이드라인/함수 명세` 안내 텍스트 블록.
            -   `(선택 사항)` 의존성 명시 입력 필드.
        -   `(수정 시)` 버전 관리 영역: 현재 버전 정보 표시. "새로운 버전 생성" 버튼. (이 버튼 클릭 시 스크립트 코드 수정 가능 모드로 전환 또는 새 버전 코드 입력 필드 활성화)
        -   가장 하단에 "저장" 및 "취소" 버튼. (등록 시 "등록", 수정 시 "수정")
    *   지표 상세 정보 페이지:
        -   페이지 상단에 지표 이름 및 핵심 정보 요약 (유형, 상태).
        -   그 아래에 지표의 모든 메타데이터 (이름, 설명) 및 상세 설정 정보 (커스텀 스크립트 코드 (읽기 전용), 의존성 등).
        -   `Actions` 버튼 그룹 (상태 변경 토글/버튼, 편집 버튼 (CUSTOM_SCRIPT), 삭제 버튼).
        -   하단에 '버전 히스토리' 섹션 (`CUSTOM_SCRIPT` 유형의 경우): 버전 목록 테이블. 컬럼: `버전 번호`, `생성 일시`, `생성 사용자`, `변경 요약`, `Actions` (`코드 보기`, `이 버전으로 평가` (평가 생성 페이지 링크)). 테이블 상단에 "새로운 버전 생성" 버튼.
        -   `BUILT_IN` 유형의 경우, 버전 히스토리 섹션 대신 내부 구현 로직에 대한 간략한 설명 (관리자만 볼 수 있도록 제한 가능) 또는 참조 문서 링크 제공.
    *   커스텀 스크립트 코드 보기 모달: 특정 버전의 `CUSTOM_SCRIPT` 코드를 신택스 하이라이팅과 함께 표시하는 읽기 전용 모달.

*   사용자 상호작용 흐름 (User Interaction Flow):
    1.  지표 등록: 사용자 -> "지표 목록" 페이지 이동 -> "지표 등록" 버튼 클릭 -> "지표 등록" 페이지/모달 열림 -> 이름, 설명 입력, 유형 선택 (`BUILT_IN` 또는 `CUSTOM_SCRIPT`) -> `CUSTOM_SCRIPT` 선택 시 스크립트 코드 입력/업로드 -> "등록" 버튼 클릭 -> 등록 완료 후 목록 페이지로 돌아가 새로 등록된 지표 확인.
    2.  지표 조회 및 상세 보기: 사용자 -> "지표 목록" 페이지 이동 -> (필요시 검색/필터) -> 지표 목록 확인 -> 특정 지표 이름 클릭 -> "지표 상세" 페이지로 이동 -> 지표의 모든 정보 확인. `CUSTOM_SCRIPT` 유형의 경우 '버전 히스토리' 섹션 확인, 특정 버전 옆 "코드 보기" 클릭하여 스크립트 코드 확인.
    3.  지표 편집: 사용자 -> "지표 상세" 페이지 이동 -> "편집" 버튼 클릭 (CUSTOM_SCRIPT만 해당) -> 정보 수정 모드로 전환 (메타데이터 입력 필드 활성화) -> 메타데이터 수정 -> (코드 수정은 "새로운 버전 생성" 통해) -> "저장" 버튼 클릭 -> 수정 완료 후 읽기 전용 모드로 돌아가서 변경 사항 확인.
    4.  새로운 버전 생성 (CUSTOM_SCRIPT): 사용자 -> "지표 상세" 페이지 ('버전 히스토리' 섹션) 이동 -> "새로운 버전 생성" 버튼 클릭 -> 스크립트 코드 입력/수정 모달/페이지 열림 (기존 코드 로드됨) -> 코드 수정 및 변경 요약 입력 -> "저장" 버튼 클릭 -> 새로운 버전이 생성되고 '버전 히스토리' 목록에 추가됨. 지표의 '현재 버전'이 자동으로 업데이트됨.
    5.  지표 상태 변경: 사용자 -> "지표 목록" 또는 "지표 상세" 페이지 -> 상태 변경 컨트롤(토글 또는 버튼) 클릭 -> 상태 변경 확인 메시지 (필요시) -> 상태 변경 완료.
    6.  지표 삭제: 사용자 -> "지표 목록" 또는 "지표 상세" 페이지 -> "삭제" 버튼 클릭 -> 삭제 확인 메시지 (사용 중인 경우 경고 포함) -> 확인 클릭 -> 지표 삭제 완료 후 목록 페이지로 돌아감.

5. Data Model

평가 지표 관리를 위한 데이터 모델은 다음과 같습니다.

```
Metric {
  "metric_id": "uuid",             // 고유 식별자
  "name": "string",                // 지표 이름 (필수, 시스템 내 고유)
  "description": "string",         // 설명 (선택 사항)
  "metric_type": "string",         // 지표 유형 (BUILT_IN, CUSTOM_SCRIPT, 필수)
  "status": "string",              // 상태 (Active, Inactive, Archived, 필수)
  "created_at": "datetime",        // 등록 일시
  "updated_at": "datetime",        // 마지막 수정 일시 (주로 메타데이터)
  "created_by": "user_id",         // 등록 사용자 (BUILT_IN은 system user 등)
  "current_version_id": "uuid",    // CUSTOM_SCRIPT 유형의 현재 활성 MetricVersion ID (선택 사항)
  // BUILT_IN 유형을 위한 추가 정보 (선택 사항)
  "builtin_config": "json"         // 내장 지표의 고유 설정 (예: ROUGE 종류, BLEU n-gram 등)
}

MetricVersion {
  "version_id": "uuid",            // 고유 식별자
  "metric_id": "uuid",             // 연결된 Metric ID (필수) - Metric.metric_id 참조
  "version_number": "integer",     // Metric 내에서 순차적인 버전 번호 (1, 2, 3...)
  "script_code": "text",           // CUSTOM_SCRIPT 유형의 실제 코드 내용 (Python 코드, 필수 for CUSTOM_SCRIPT)
  "created_at": "datetime",        // 버전 생성 일시
  "created_by": "user_id",         // 버전 생성 사용자
  "changes_summary": "string"      // 이 버전에서 발생한 변경 요약 (선택 사항)
  // BUILT_IN 유형의 경우 script_code 대신 해당 버전의 내부 로직 식별자 또는 설명 등을 가질 수 있음 (관리용)
}
```

*   `EvaluationRun` 객체의 `metric_configurations` 필드는 `Metric` 및 `MetricVersion`을 참조합니다.
*   `EvaluationSampleResult` 객체의 `metric_scores` 필드는 메트릭 ID와 해당 버전 ID 및 점수를 포함합니다.

6. Acceptance Criteria

*   [ ] `BUILT_IN` 및 `CUSTOM_SCRIPT` 두 가지 유형의 지표를 시스템에 등록할 수 있다.
*   [ ] 지표 등록 시 이름, 설명, 유형을 필수로 입력할 수 있다.
*   [ ] `CUSTOM_SCRIPT` 유형 등록 시 Python 스크립트 코드를 입력하거나 파일로 업로드할 수 있는 코드 에디터가 제공된다.
*   [ ] 지표 이름은 시스템 내에서 고유해야 한다는 유효성 검사가 올바르게 작동한다.
*   [ ] 등록된 지표 목록이 테이블 형태로 올바르게 표시되며, 주요 정보(`이름`, `유형`, `상태`, `현재 버전` 등)가 포함된다.
*   [ ] 지표 목록에서 `이름`, `유형`, `상태` 등으로 검색 및 필터링 기능이 정상 작동한다.
*   [ ] 지표 상세 페이지에서 해당 지표의 모든 메타데이터 및 설정 정보(`CUSTOM_SCRIPT`의 코드 포함 - 읽기 전용)를 조회할 수 있다.
*   [ ] `CUSTOM_SCRIPT` 유형의 지표에 대해 메타데이터(이름, 설명)를 편집하고 저장할 수 있다.
*   [ ] 지표의 `상태`(활성/비활성)를 변경할 수 있다.
*   [ ] `비활성` 상태인 지표는 새로운 평가 작업 생성 시 메트릭 선택 목록에 나타나지 않는다.
*   [ ] `CUSTOM_SCRIPT` 유형의 지표에 대해 스크립트 코드를 수정하고 새로운 버전을 생성할 수 있다.
*   [ ] 새로운 버전 생성 시 `버전 번호`가 자동으로 증가하며, 변경된 스크립트 코드와 함께 저장된다.
*   [ ] 지표 상세 페이지의 '버전 히스토리' 섹션에서 해당 지표의 전체 버전 목록을 조회할 수 있다.
*   [ ] 버전 목록에서 특정 버전의 스크립트 코드 내용을 조회할 수 있다.
*   [ ] 평가 실행 생성 시 `CUSTOM_SCRIPT` 유형의 지표를 선택할 때, 해당 지표의 사용 가능한 `MetricVersion` 목록에서 특정 버전을 선택할 수 있다.
*   [ ] 평가 실행 결과(`EvaluationSampleResult.metric_scores`)에 사용된 각 지표의 점수와 함께 해당 지표의 `metric_id` 및 `metric_version_id`가 명시적으로 저장된다.
*   [ ] 등록된 지표를 시스템에서 삭제할 수 있다.
*   [ ] 완료된 평가 실행에서 사용된 지표를 삭제 시도 시, 해당 지표가 `Archived` 상태로 전환되어 과거 결과 조회는 가능하나 새로운 평가에는 사용 불가하도록 처리된다.
*   [ ] Data Model에 정의된 `Metric` 및 `MetricVersion` 객체의 필드들이 실제 데이터베이스 스키마에 반영된다.
*   [ ] Data Model 객체 간의 관계(Metric과 MetricVersion, EvaluationRun과의 참조 관계)가 올바르게 구현된다.
*   [ ] UI/UX 디자인 사양에 명시된 각 화면(목록, 등록/수정, 상세)의 주요 컴포넌트가 올바르게 배치된다.
*   [ ] 사용자 상호작용 흐름(등록, 조회, 편집, 버전 생성, 상태 변경, 삭제)이 명시된 단계대로 오류 없이 완료된다.
*   [ ] (관리자) `BUILT_IN` 지표의 관리 기능(추가, 업데이트)이 구현된다.

### 2.5 평가 결과 분석 및 시각화 (Evaluation Result Analysis & Visualization)

1. Feature: 평가 결과 분석 및 시각화

본 기능은 LLM 자동 평가 시스템을 통해 실행된 평가 작업의 결과를 깊이 있게 분석하고 직관적으로 시각화하는 기능을 제공합니다. 완료된 평가 실행 (`Completed` 또는 `Failed` 상태)의 종합적인 성능 지표, 샘플별 상세 결과, 모델 간 비교, 시간 경과에 따른 성능 추이 등을 다양한 형태로 제공하여 사용자가 모델의 강점과 약점을 파악하고 개선 방향을 도출할 수 있도록 지원합니다.

주요 목적:

- 평가 실행 결과를 다양한 관점에서 탐색하고 분석하여 모델 성능에 대한 깊은 이해를 획득합니다.
- 모델, 데이터셋, 지표별 성능을 비교하여 최적의 조합을 식별합니다.
- 시각화된 형태로 복잡한 데이터를 제공하여 분석 효율성을 높입니다.
- 특정 성능 문제(예: 특정 샘플 실패, 특정 메트릭 점수 저조)의 원인을 파악합니다.
- 평가 결과를 기반으로 의사결정을 지원하고 모델 개선 활동을 가이드합니다.

2. User Stories

*   As an AI Evaluator, I want to view the overall aggregate performance of models from completed evaluation runs, summarized by metric, so that I can quickly understand how different models performed on a dataset.
*   As an AI Evaluator, I want to filter and sort evaluation runs based on parameters like completion date, dataset, models used, or status, so that I can find the specific results I'm interested in.
*   As an AI Evaluator, I want to visualize the distribution of metric scores for each model within an evaluation run (e.g., using histograms or box plots), so that I can understand the variability and consistency of their performance across samples.
*   As an AI Developer, I want to compare the performance of different models side-by-side on the same evaluation run using charts and tables, so that I can identify which model performs best overall or on specific metrics.
*   As an AI Developer, I want to compare the performance of different versions of the same model or the same model configuration across different evaluation runs over time, so that I can track the impact of model improvements.
*   As an AI Evaluator, I want to drill down from aggregate results to view individual sample results for a specific model and metric, especially for samples where the model performed poorly or exceptionally well, so that I can examine the inputs, outputs, and golden labels in detail.
*   As an AI Evaluator, I want to filter sample-level results by model, sample status (Success, various Failure types), individual metric scores (e.g., score < 0.5), or keywords in input/output, so that I can quickly find problematic samples.
*   As an AI Evaluator, I want to visualize the distribution of sample failure types (e.g., Model Error, Metric Error, Timeout) per model, so that I can diagnose the nature of errors.
*   As an AI Evaluator, I want to export evaluation results (aggregate summaries, sample-level data) in formats like CSV or JSON, so that I can perform further analysis or reporting outside the system.
*   As a Stakeholder, I want to view high-level dashboards summarizing the performance of key models on critical datasets over time, so that I can stay informed about model quality trends.

3. Functional Requirements

*   평가 실행 목록 및 요약 조회:
    *   완료 (`Completed`) 또는 실패 (`Failed`) 상태의 평가 실행 목록을 조회합니다.
    *   목록은 실행 이름, 상태, 시작/완료 시간, 사용된 데이터셋/버전, 모델 목록, 총 샘플 수, 성공/실패 샘플 수 등의 요약 정보를 포함합니다.
    *   데이터셋, 모델, 상태, 시간 범위 등으로 목록을 필터링하고, 완료 시간, 이름 등으로 정렬하는 기능을 제공합니다.
*   종합 결과 분석:
    *   특정 평가 실행(`EvaluationRun`)의 종합 결과(`aggregate_results` 필드)를 시각화 및 테이블 형태로 표시합니다.
    *   모델별 메트릭 점수 비교: 선택된 모든 모델에 대해 각 메트릭의 종합 점수(평균, 중앙값 등)를 비교하는 바 차트 또는 테이블을 제공합니다.
    *   메트릭별 모델 점수 비교: 특정 메트릭을 선택했을 때, 해당 메트릭에 대한 모든 모델의 종합 점수를 비교하는 차트를 제공합니다.
    *   샘플 처리 통계: 모델별 성공/실패 샘플 수, 처리 시간(평균, 분포) 등을 요약하여 표시합니다. 실패한 샘플의 경우, 에러 타입(ModelError, MetricError 등)별 분포를 시각화합니다.
*   샘플 결과 상세 분석:
    *   특정 평가 실행의 모든 `EvaluationSampleResult` 목록을 테이블 형태로 표시합니다.
    *   필터링: 모델, 샘플 상태(Success, various Failure types), `DataSample` 메타데이터 (가능한 경우), 개별 메트릭 점수 범위(예: score < 0.5), 입력/출력 텍스트 검색 등으로 샘플 목록을 필터링하는 기능을 제공합니다.
    *   정렬: `sample_id`, `processing_time_ms`, 개별 메트릭 점수 등으로 샘플 목록을 정렬할 수 있습니다.
    *   상세 보기: 특정 샘플 결과를 선택하면 해당 `EvaluationSampleResult`의 전체 상세 정보(원본 `model_input`, `model_output`, `processed_output`, `golden_label`, `metric_scores` JSON 객체의 전체 내용, `sample_status`, `error_details`, `processing_time_ms`)를 구조화하여 표시하는 별도 뷰를 제공합니다.
    *   입력/출력 비교: 샘플 상세 보기 시 `model_input`, `model_output`, `golden_label`을 나란히 표시하여 모델의 응답을 쉽게 검토할 수 있도록 합니다. (`processed_output`도 필요시 포함).
*   모델/실행 비교 분석:
    *   동일 데이터셋/버전으로 실행된 여러 평가 실행을 선택하여 결과를 비교하는 기능을 제공합니다.
    *   모델 비교: 동일 실행 내 여러 모델 또는 다른 실행에서 나온 동일 모델의 종합 메트릭 점수를 나란히 비교하는 테이블 및 차트를 제공합니다.
    *   실행 비교: 서로 다른 시점에 실행된 동일 또는 유사한 구성의 평가 실행 결과를 비교하여 성능 변화를 추적할 수 있도록 지원합니다.
*   시각화 (Charts):
    *   바 차트: 모델/메트릭별 종합 점수 비교.
    *   히스토그램/분포 차트 (Histogram/Distribution Chart): 특정 메트릭에 대한 샘플 점수의 분포를 모델별로 비교. 점수의 밀집도, 이상치 등을 파악합니다.
    *   박스 플롯 (Box Plot): 특정 메트릭 점수 또는 처리 시간의 분포를 모델별로 비교하여 중앙값, 사분위수, 이상치 등을 확인합니다.
    *   파이 차트/도넛 차트: 모델별 샘플 상태(성공/실패) 비율, 실패 샘플의 에러 타입 분포를 표시합니다.
    *   라인 차트 (Trend Chart - Requires multiple runs): 선택된 모델/메트릭의 종합 점수가 시간 경과에 따라 어떻게 변화하는지 보여주는 라인 차트. (여러 평가 실행 결과 데이터를 누적 분석하여 생성)
    *   차트의 툴팁(tooltip) 또는 인터랙션: 차트 요소(예: 바, 점)에 마우스를 올리면 상세 정보(모델 이름, 메트릭, 정확한 점수, 샘플 수 등)를 표시합니다. 특정 차트 요소를 클릭하면 관련 샘플 목록(예: 특정 점수 범위의 샘플)으로 필터링하여 드릴다운할 수 있도록 지원합니다.
*   데이터 내보내기 (Data Export):
    *   종합 결과 내보내기: 특정 평가 실행의 종합 결과 요약 데이터를 CSV 또는 JSON 형식으로 내보낼 수 있습니다.
    *   샘플 결과 내보내기: 현재 필터링된 또는 전체 `EvaluationSampleResult` 목록 데이터를 CSV 또는 JSON 형식으로 내보낼 수 있습니다. 내보내기 데이터에는 `run_id`, `sample_id`, `model_config_id`, `sample_status`, `processing_time_ms`, 그리고 `metric_scores` JSON 필드의 각 개별 메트릭 점수(플랫하게 변환하여) 등이 포함될 수 있습니다.

4. UI/UX Design Guide

*   화면 레이아웃:
    *   평가 결과 대시보드/목록 페이지:
        -   페이지 상단에 제목 ("평가 결과").
        -   상단에 전체 완료/실패 실행 수, 최근 실행 결과 요약 등 고수준 정보 또는 주요 모델/데이터셋 성능 트렌드 차트 위젯 배치 고려 (사용자 맞춤 설정 가능).
        -   필터링 및 검색 영역: 완료 시점, 데이터셋, 모델, 상태 등으로 평가 실행 목록을 필터링/검색하는 컨트롤 배치.
        -   주요 영역은 평가 실행 목록 테이블. 컬럼: 이름, 상태, 완료 일시, 데이터셋, 모델 목록 요약, 총 샘플, 성공/실패 수, Actions (상세 보기, 비교 대상 추가, 내보내기).
        -   목록 테이블 하단에 페이지네이션.
    *   평가 실행 상세 페이지:
        -   페이지 상단에 평가 실행 이름 및 핵심 정보 요약 (상태, 데이터셋, 버전, 모델 목록, 완료 일시).
        -   하단에 탭 인터페이스: `개요`, `종합 결과`, `샘플 결과`, `비교`, `로그`.
        -   `개요` 탭: 해당 실행에 사용된 상세 설정 정보(모델 구성, 데이터셋/버전 정보 링크, 실행 파라미터, 메트릭 구성) 요약 표시.
        -   `종합 결과` 탭:
            -   모델별 종합 메트릭 점수 테이블.
            -   모델별 메트릭 점수 비교 바 차트 (메트릭 선택 드롭다운).
            -   메트릭 점수 분포 시각화 (히스토그램/박스 플롯, 모델/메트릭 선택).
            -   모델별 샘플 상태 비율 파이 차트.
            -   모델별 에러 타입 분포 바 차트 (실패 샘플 있는 경우).
            -   모델별 처리 시간 분포 박스 플롯.
        -   `샘플 결과` 탭:
            -   상단에 샘플 목록 필터링 및 검색 컨트롤 (모델 드롭다운, 상태 선택, 메트릭 점수 슬라이더/입력 필드, 텍스트 검색창).
            -   샘플 목록 테이블. 컬럼: 샘플 ID, 모델 이름, 샘플 상태, 주요 메트릭 점수 요약, Actions (상세 보기).
            -   테이블 하단에 페이지네이션.
        -   `비교` 탭: 다른 평가 실행 또는 모델을 선택하여 현재 실행과 비교하는 인터페이스. 선택된 대상들의 종합 결과(테이블, 차트)를 나란히 표시.
        -   `로그` 탭: 해당 실행의 상세 로그 조회 (Evaluation Run & Management 기능 참조).
        -   페이지 상단에 `Actions` 버튼 (내보내기, (재실행 - Run Management 기능 링크), (삭제 - Run Management 기능 링크)).
    *   샘플 결과 상세 모달/페이지:
        -   선택된 `EvaluationSampleResult`의 전체 정보 표시.
        -   상단에 샘플 ID, 관련 모델 이름, 샘플 상태.
        -   `model_input`, `model_output`, `processed_output`, `golden_label` 필드를 영역을 나누어 표시. 코드 블록 또는 포맷팅된 텍스트로 표시하여 가독성 확보. 멀티턴 대화의 경우 대화 형태로 시각화.
        -   `metric_scores` 영역: 이 샘플에 대한 각 메트릭의 점수를 목록 또는 테이블 형태로 표시. `metric_id`와 `score`를 명확히 보여주고, 메트릭 이름으로 표시 (Metric 관리 기능 참조).
        -   `error_details` 영역: 샘플 처리 실패 시 상세 오류 메시지 표시.
        -   `processing_time_ms` 표시.
        -   관련 `DataSample` 메타데이터 표시 (필요시).
        -   닫기 버튼.

*   사용자 상호작용 흐름:
    1.  종합 결과 조회: 사용자 -> "평가 결과" 대시보드/목록 페이지 -> 완료된 특정 평가 실행 이름 클릭 -> "평가 실행 상세" 페이지 이동 -> '종합 결과' 탭 클릭 -> 모델별/메트릭별 종합 점수 테이블 및 차트 확인 -> 차트에서 특정 요소 클릭 시 관련 샘플 목록으로 드릴다운 (예: 특정 모델의 Exact Match 0점 샘플 목록).
    2.  샘플 상세 조회: 사용자 -> "평가 실행 상세" 페이지 ('샘플 결과' 탭) -> 샘플 목록에서 필터/검색 적용 (예: 특정 모델, Sample Status = `MetricError`, F1 Score < 0.5) -> 필터링된 샘플 목록 확인 -> 특정 샘플 행 옆 "상세 보기" 클릭 -> "샘플 결과 상세" 모달/페이지 열림 -> 샘플 입력/출력, 골든 라벨 비교 및 모든 메트릭 점수 확인.
    3.  모델/실행 비교: 사용자 -> "평가 결과" 대시보드/목록 페이지 -> 비교할 평가 실행들을 선택 (체크박스) -> "비교" 버튼 클릭 -> 비교 뷰에서 선택된 실행들의 종합 결과(테이블, 차트)를 나란히 비교하거나 오버레이하여 확인. (또는 단일 실행 상세 페이지 '비교' 탭에서 비교 대상 추가).
    4.  데이터 내보내기: 사용자 -> "평가 실행 상세" 페이지 또는 "평가 결과" 목록 페이지 -> "내보내기" 버튼 클릭 -> 내보낼 데이터 범위(종합/샘플 전체/필터링된 샘플) 및 형식(CSV/JSON) 선택 -> "내보내기" 실행 -> 파일 다운로드.

5. Data Model

평가 결과 분석 및 시각화 기능은 주로 기존에 정의된 `EvaluationRun` 및 `EvaluationSampleResult` 데이터 모델을 활용하여 분석 및 시각화를 수행합니다. 새로운 테이블 정의는 필요하지 않으며, 기존 모델의 필드와 관계를 사용하여 정보를 집계, 필터링, 조합합니다.

데이터 모델 구조 및 필드 설명은 2.3 평가 실행 및 관리 섹션의 Data Model을 참조하십시오.

데이터 스토리지 고려사항:

*   대규모 평가 실행 시 `EvaluationSampleResult` 레코드 수가 매우 많아질 수 있습니다 (샘플 수 * 모델 수). 분석 및 시각화 성능을 위해 `run_id`, `model_config_id`, `sample_status`, `metric_scores` (JSONB 인덱싱 고려) 필드에 대한 효율적인 데이터베이스 인덱싱이 필수적입니다.
*   시계열 성능 추이 분석을 위해서는 과거 `EvaluationRun`의 `aggregate_results` 데이터가 장기간 보존되어야 합니다.

6. Acceptance Criteria

*   [ ] `Completed` 또는 `Failed` 상태의 평가 실행 목록을 조회할 수 있다.
*   [ ] 평가 실행 목록에서 데이터셋, 모델, 상태, 완료 시간 등으로 필터링 및 정렬 기능이 정상 작동한다.
*   [ ] 특정 평가 실행 상세 페이지에서 해당 실행의 `aggregate_results`를 기반으로 모델별 종합 메트릭 점수 비교 테이블과 차트를 올바르게 표시한다.
*   [ ] 모델별 샘플 성공/실패 수 및 실패 에러 타입 분포를 시각화(파이/바 차트)하여 보여준다.
*   [ ] 모델별 샘플 처리 시간 분포를 시각화(박스 플롯)하여 보여준다.
*   [ ] 특정 평가 실행의 `EvaluationSampleResult` 목록을 테이블 형태로 조회할 수 있다.
*   [ ] 샘플 결과 목록에서 모델, 샘플 상태, 개별 메트릭 점수 범위, 입력/출력 텍스트 등으로 필터링 기능이 정상 작동한다.
*   [ ] 샘플 결과 목록을 메트릭 점수 또는 처리 시간 등으로 정렬할 수 있다.
*   [ ] 샘플 결과 목록에서 특정 샘플 선택 시, 해당 `EvaluationSampleResult`의 상세 정보(`model_input`, `model_output`, `golden_label`, `metric_scores` 전체, `error_details` 등)를 구조화된 형태로 상세 보기 뷰에서 올바르게 표시한다.
*   [ ] 샘플 상세 보기 시 `model_input`, `model_output`, `golden_label`을 나란히 표시하여 비교하기 쉽게 제공한다.
*   [ ] `metric_scores` JSON 내의 각 메트릭 점수가 지표 이름과 함께 명확하게 표시된다.
*   [ ] 동일 데이터셋/버전으로 실행된 여러 평가 실행을 선택하여 종합 결과를 나란히 비교하는 뷰를 제공한다.
*   [ ] (선택 사항) 시간 경과에 따른 모델/메트릭 성능 추이 라인 차트를 표시한다.
*   [ ] 평가 실행의 종합 결과 및 샘플 결과(전체 또는 필터링된)를 CSV 또는 JSON 형식으로 내보낼 수 있다.
*   [ ] `EvaluationRun` 및 `EvaluationSampleResult` 데이터 모델의 필드(특히 `aggregate_results`, `metric_scores`)를 기반으로 위 분석 및 시각화 기능들이 올바르게 구현된다.
*   [ ] 기존 데이터 모델(`ModelConfiguration`, `Metric`, `MetricVersion`, `Dataset`, `Version`, `DataSample`)과의 관계를 활용하여 모델 이름, 지표 이름, 데이터셋/샘플 정보를 정확하게 연결하여 표시한다.
*   [ ] UI/UX 디자인 가이드에 명시된 대시보드/목록, 실행 상세 (탭 포함), 샘플 상세 보기 뷰의 주요 컴포넌트가 올바르게 배치된다.
*   [ ] 시각화 차트(바, 히스토그램/분포, 박스 플롯, 파이/도넛, 라인)가 요구사항에 맞춰 올바른 데이터를 표시하고 기본적인 인터랙션(툴팁, 드릴다운)을 제공한다.

### 2.6 리더보드 관리 (Leaderboard Management)

1. Feature: 리더보드 관리 (Leaderboard Management)

본 기능은 LLM 자동 평가 시스템에서 완료된 하나 이상의 평가 실행 결과를 기반으로, 다양한 모델의 성능을 특정 데이터셋과 평가 지표 기준으로 순위화하여 보여주는 리더보드를 생성, 조회 및 관리합니다. 사용자는 특정 평가 목표에 맞는 리더보드를 구성하고, 모델 간 상대적인 성능을 직관적으로 비교 분석할 수 있습니다.

주요 목적:

- 특정 평가 기준에 따른 모델 성능 순위를 투명하고 쉽게 확인할 수 있도록 합니다.
- 다양한 모델들을 동일한 조건(데이터셋, 지표) 하에서 공정하게 비교할 수 있는 환경을 제공합니다.
- 평가 결과를 요약하여 이해 관계자에게 공유하기 용이한 형태로 제공합니다.
- 모델 개선 노력의 성과를 시계열 리더보드를 통해 추적할 수 있는 기반을 마련합니다.

2. User Stories

*   As an AI Evaluator, I want to create a new leaderboard by selecting a completed evaluation run, so that I can publish the ranking of models based on its results.
*   As an AI Evaluator, I want to specify which metrics from the evaluation run results should be displayed on the leaderboard, so that I can focus on the most relevant performance indicators.
*   As an AI Evaluator, I want to select a specific metric to determine the ranking order on the leaderboard, so that models are ranked according to the performance I care about most.
*   As an AI Evaluator, I want to view a list of existing leaderboards, so that I can access previously created rankings.
*   As an AI Evaluator, I want to see the ranked list of models on a specific leaderboard, including their score for the ranking metric and scores for other selected metrics, so that I can compare their performance.
*   As an AI Evaluator, I want to filter or sort the models displayed on a leaderboard dynamically (e.g., by model type, score range), so that I can explore subsets of the results.
*   As an AI Evaluator, I want to update a leaderboard to reflect the results of a newer evaluation run on the same dataset and models (or similar criteria), so that the leaderboard stays current.
*   As an AI Evaluator, I want to edit the title, description, or displayed metrics of a leaderboard, so that I can refine its presentation.
*   As an AI Evaluator, I want to delete a leaderboard that is no longer needed, so that I can manage the system's content.
*   As a Stakeholder, I want to easily access pre-defined leaderboards to see the performance ranking of key models without needing to run evaluations myself.

3. Detailed Functional Requirements

*   리더보드 생성 (Leaderboard Creation):
    *   기본 정보: 리더보드 `이름` (필수, 시스템 내 고유해야 함) 및 `설명` (선택 사항)을 입력할 수 있어야 합니다.
    *   소스 평가 실행 선택: `Completed` 상태의 평가 실행 목록에서 하나를 선택하여 리더보드의 데이터 소스로 지정해야 합니다. (향후 여러 실행 결과를 통합하거나, 최신 실행을 자동으로 반영하는 기능 추가 고려. 초기에는 단일 Completed Run 선택)
    *   표시 메트릭 선택: 선택된 소스 평가 실행에서 사용된 메트릭 목록(`EvaluationRun.metric_configurations`에 명시된 메트릭들) 중 리더보드 테이블에 컬럼으로 표시할 메트릭들을 하나 이상 선택할 수 있어야 합니다. 각 표시 메트릭에 대해 종합 점수 유형(예: 평균, 중앙값 - 소스 실행의 `aggregate_results`에서 사용 가능한 유형)을 지정할 수 있어야 합니다.
    *   순위 결정 메트릭 선택: 표시 메트릭 중 하나를 선택하여 모델 순위를 결정하는 기준 메트릭으로 지정해야 합니다. 순위는 이 메트릭 점수를 기준으로 내림차순 또는 오름차순(지표 특성에 따라 자동 또는 수동 선택)으로 결정됩니다.
    *   포함 모델 선택 (선택 사항): 소스 평가 실행에 포함된 모든 모델(`EvaluationRun.model_config_ids`)을 기본적으로 리더보드에 포함시키지만, 사용자는 특정 모델만 포함하도록 선택할 수 있어야 합니다.
    *   리더보드 생성: 위 설정을 저장하여 새로운 리더보드를 생성합니다. 생성 시, 선택된 소스 평가 실행의 종합 결과(`aggregate_results`)를 기반으로 초기 순위를 계산하고 저장합니다.
*   리더보드 조회 및 관리 (Leaderboard Viewing and Management):
    *   리더보드 목록: 시스템에 등록된 모든 리더보드 목록을 테이블 형태로 표시합니다. 각 행은 `이름`, `설명 요약`, `소스 평가 실행 (이름)`, `생성 일시`, `Actions` (상세 보기, 편집, 업데이트, 삭제)를 포함합니다.
    *   리더보드 상세 보기: 특정 리더보드를 선택하면 상세 페이지로 이동하여 다음 정보를 표시합니다.
        -   리더보드 이름 및 설명.
        -   소스 평가 실행 정보 (링크 포함).
        -   순위 결정 기준 메트릭 및 정렬 순서.
        -   선택된 표시 메트릭 목록.
        -   모델 순위 테이블:
            -   `순위 (Rank)`: 순위 결정 메트릭 기준 계산된 순위.
            -   `모델 이름 (Model Name)`: `ModelConfiguration.name` (소스 실행에 사용된 모델).
            -   선택된 각 표시 메트릭의 종합 점수 (소스 실행의 `aggregate_results`에서 가져옴).
            -   (선택 사항) 기타 관련 정보 (예: 모델 유형, 데이터셋 샘플 수, 실행 완료 시간).
        -   모델 순위 테이블에 대한 동적 필터링 및 정렬 기능 (예: 모델 이름 검색, 특정 메트릭 점수 범위 필터링, 다른 메트릭으로 임시 정렬).
    *   리더보드 편집: 리더보드의 `이름`, `설명`, `표시 메트릭`, `순위 결정 메트릭` 설정을 수정할 수 있어야 합니다. 소스 평가 실행 자체는 변경할 수 없습니다 (업데이트 기능을 사용).
    *   리더보드 업데이트 (Update):
        -   기존 리더보드의 소스 평가 실행을 동일한 데이터셋 및 모델 조합으로 완료된 새로운 평가 실행으로 변경하는 기능을 제공합니다.
        -   업데이트 시, 새로운 소스 실행의 `aggregate_results`를 가져와 순위를 다시 계산하고 표시 데이터를 갱신합니다.
        -   이를 통해 시간이 지남에 따라 모델 성능이 어떻게 변화했는지 보여주는 (수동 업데이트 방식의) 시계열 리더보드 역할을 할 수 있습니다.
    *   리더보드 삭제: 등록된 리더보드를 시스템에서 제거합니다. 삭제 시, 리더보드 설정 정보만 삭제하며, 소스 평가 실행 결과 데이터(`EvaluationRun`, `EvaluationSampleResult`)는 그대로 유지합니다.

*   랭킹 계산 로직 (Ranking Calculation Logic):
    *   리더보드 생성 및 업데이트 시 실행됩니다.
    *   선택된 소스 `EvaluationRun`의 `aggregate_results` 필드를 사용하여 모델별 메트릭 종합 점수를 가져옵니다.
    *   지정된 `순위 결정 메트릭`의 점수를 기준으로 모델 목록을 정렬합니다. 동점일 경우 처리 기준을 명시해야 합니다 (예: 모델 이름 순, 등록일 순).
    *   계산된 순위를 모델별로 할당합니다.

4. UI/UX Design Guide

*   화면 레이아웃:
    *   리더보드 목록 페이지:
        -   페이지 상단에 제목 ("리더보드").
        -   그 아래에 검색 입력 필드와 필터 드롭다운 (예: 소스 데이터셋).
        -   주요 영역은 등록된 리더보드 목록을 표시하는 테이블.
        -   테이블 컬럼: `리더보드 이름`, `설명`, `소스 평가 실행`, `생성 일시`, `Actions` (상세 보기, 편집, 업데이트, 삭제).
        -   테이블 하단에 페이지네이션 컨트롤.
        -   테이블 상단 또는 하단에 "리더보드 생성" 버튼.
    *   리더보드 생성/편집 페이지/모달:
        -   상단에 제목 ("리더보드 생성", "리더보드 편집").
        -   기본 정보 영역: `리더보드 이름` (입력 필드), `설명` (텍스트 영역).
        -   소스 설정 영역: `소스 평가 실행` 선택 드롭다운 또는 검색 기능 (완료된 실행 목록 필터링 가능). 선택된 실행의 간략 정보 표시 (데이터셋, 모델 목록, 완료일시). (편집 시 소스 실행 변경 불가 - 업데이트 기능 안내).
        -   표시 메트릭 선택 영역: 선택된 소스 실행에서 사용된 메트릭 목록 표시 (체크박스 또는 멀티셀렉트). 각 선택된 메트릭 옆에 (필요시) 종합 점수 유형 선택 드롭다운.
        -   순위 결정 메트릭 선택 영역: 선택된 표시 메트릭 중 하나를 선택하는 드롭다운 또는 라디오 버튼. 정렬 순서 (내림차순/오름차순) 선택.
        -   포함 모델 선택 영역 (선택 사항): 소스 실행의 모델 목록 표시 (체크박스).
        -   하단에 "생성" (또는 "저장"), "취소" 버튼.
    *   리더보드 상세 페이지:
        -   페이지 상단에 리더보드 이름 및 설명.
        -   소스 평가 실행 정보 요약 (링크 포함) 및 순위 결정 기준 메트릭 정보.
        -   주요 영역: 모델 순위 테이블.
            -   첫 번째 컬럼은 순위 (숫자).
            -   두 번째 컬럼은 모델 이름 (링크).
            -   이후 컬럼은 선택된 표시 메트릭별 점수. 메트릭 이름은 컬럼 헤더로 표시. 순위 결정 메트릭 컬럼은 강조 표시.
            -   테이블 상단에 모델 이름 검색, 메트릭 점수 범위 슬라이더/필드 등 동적 필터링/정렬 컨트롤 배치.
        -   테이블 하단에 (필요시) 페이지네이션 (모델 수가 많을 경우).
        -   페이지 상단에 `Actions` 버튼 그룹 (편집, 업데이트, 삭제).

*   사용자 상호작용 흐름:
    1.  리더보드 생성: 사용자 -> "리더보드 목록" 페이지 이동 -> "리더보드 생성" 버튼 클릭 -> "리더보드 생성" 폼/모달 열림 -> 이름, 설명 입력 -> `소스 평가 실행` 선택 -> `표시 메트릭` 선택 -> `순위 결정 메트릭` 선택 -> (선택 사항) `포함 모델` 조정 -> "생성" 버튼 클릭 -> 생성 완료 후 리더보드 목록 또는 상세 페이지로 이동하여 확인.
    2.  리더보드 조회: 사용자 -> "리더보드 목록" 페이지 이동 -> (필요시 검색/필터) -> 리더보드 목록 확인 -> 특정 리더보드 이름 클릭 -> "리더보드 상세" 페이지 이동 -> 모델 순위 테이블 및 상세 정보 확인 -> (필요시) 필터링/정렬 컨트롤 사용하여 테이블 뷰 동적 조정.
    3.  리더보드 편집: 사용자 -> "리더보드 상세" 페이지 이동 -> "편집" 버튼 클릭 -> "리더보드 편집" 폼/모달 열림 (기존 정보 로드) -> 이름, 설명, 표시 메트릭, 순위 결정 메트릭 수정 -> "저장" 버튼 클릭 -> 수정 완료 후 상세 페이지로 돌아가서 변경 사항 확인.
    4.  리더보드 업데이트: 사용자 -> "리더보드 상세" 또는 목록 페이지 -> "업데이트" 버튼 클릭 -> 동일 데이터셋 및 모델 조합으로 완료된 최신 평가 실행 목록 표시 (또는 선택 인터페이스) -> 업데이트에 사용할 새로운 실행 선택 -> 확인 -> 리더보드의 소스 실행 및 표시 데이터 갱신.
    5.  리더보드 삭제: 사용자 -> "리더보드 목록" 또는 "리더보드 상세" 페이지 -> "삭제" 버튼 클릭 -> 삭제 확인 메시지 -> 확인 클릭 -> 리더보드 삭제 완료 후 목록 페이지로 돌아감.

5. Data Model

리더보드 관리를 위한 데이터 모델은 다음과 같습니다.

```
Leaderboard {
  "leaderboard_id": "uuid",                // 고유 식별자
  "name": "string",                      // 리더보드 이름 (필수, 시스템 내 고유)
  "description": "string",               // 설명 (선택 사항)
  "source_run_id": "uuid",               // 이 리더보드가 기반으로 하는 특정 EvaluationRun ID (필수) - EvaluationRun.run_id 참조
  "display_metric_ids": ["string"],      // 리더보드 테이블에 표시할 메트릭 ID 목록 (필수) - Metric.metric_id 참조
  "sorting_metric_id": "string",         // 순위 결정 기준이 되는 메트릭 ID (필수) - display_metric_ids 중 하나
  "sorting_order": "string",             // 순위 정렬 순서 (desc/asc)
  "included_model_config_ids": ["uuid"], // 리더보드에 포함할 모델 구성 ID 목록 (선택 사항, source_run_id의 model_config_ids의 부분집합 또는 전체) - ModelConfiguration.config_id 참조
  "created_at": "datetime",              // 생성 일시
  "updated_at": "datetime",              // 마지막 수정 일시 (업데이트 시 갱신)
  "created_by": "user_id"                // 생성 사용자
}
```

*   *참고: `Leaderboard` 데이터 모델은 순위 결과 자체를 저장하지 않고, 어떤 평가 실행 결과를 어떤 메트릭 기준으로 어떻게 보여줄지에 대한 설정만을 저장합니다. 실제 순위 및 점수는 `source_run_id`가 가리키는 `EvaluationRun`의 `aggregate_results`에서 조회 시점에 동적으로 가져옵니다.*

리더보드 기능은 기존의 `EvaluationRun`, `ModelConfiguration`, `Metric` 데이터 모델을 참조하여 동작합니다.

6. Acceptance Criteria

*   [ ] `Completed` 상태의 평가 실행 목록을 선택하여 새로운 리더보드를 생성할 수 있다.
*   [ ] 리더보드 생성 시 이름, 설명, 소스 평가 실행을 필수로 입력할 수 있다.
*   [ ] 소스 평가 실행에서 사용된 메트릭 목록 중 리더보드 테이블에 표시할 메트릭들을 선택할 수 있다.
*   [ ] 표시 메트릭 중 하나를 선택하여 모델 순위를 결정하는 기준 메트릭으로 지정할 수 있다.
*   [ ] 생성된 리더보드 목록이 테이블 형태로 올바르게 표시된다.
*   [ ] 리더보드 상세 페이지에서 리더보드 이름, 설명, 소스 실행 정보, 설정된 메트릭 목록이 올바르게 표시된다.
*   [ ] 리더보드 상세 페이지의 테이블에 소스 실행 결과 기반 모델 순위, 순위 결정 메트릭 점수, 선택된 표시 메트릭 점수가 올바르게 표시된다.
*   [ ] 모델 순위 테이블은 설정된 순위 결정 메트릭 기준으로 올바르게 정렬되어 표시된다.
*   [ ] 모델 순위 테이블에서 모델 이름 검색, 메트릭 점수 범위 필터링, 다른 메트릭으로의 동적 정렬 기능이 정상 작동한다.
*   [ ] 리더보드의 이름, 설명, 표시 메트릭, 순위 결정 메트릭 설정을 편집하고 저장할 수 있다.
*   [ ] 동일한 데이터셋 및 모델 조합으로 완료된 새로운 평가 실행을 선택하여 리더보드의 소스 실행을 업데이트할 수 있다.
*   [ ] 리더보드 업데이트 시 새로운 소스 실행의 결과가 반영되어 순위 및 점수가 갱신된다.
*   [ ] 등록된 리더보드를 시스템에서 삭제할 수 있다.
*   [ ] 리더보드 삭제 시 소스 평가 실행 결과 데이터는 삭제되지 않고 유지된다.
*   [ ] Data Model에 정의된 `Leaderboard` 객체의 필드들이 실제 데이터베이스 스키마에 반영된다.
*   [ ] `Leaderboard` 객체가 `EvaluationRun`, `ModelConfiguration`, `Metric` 객체를 올바르게 참조하고, 이를 활용하여 순위 및 점수 데이터를 조회한다.
*   [ ] UI/UX 디자인 가이드에 명시된 각 화면(목록, 생성/편집, 상세)의 주요 컴포넌트가 올바르게 배치된다.
*   [ ] 사용자 상호작용 흐름(생성, 조회, 편집, 업데이트, 삭제)이 명시된 단계대로 오류 없이 완료된다.