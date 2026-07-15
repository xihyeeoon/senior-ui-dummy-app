/// 더미 데이터 한 곳 모음.
///
/// 연구 원칙: 실거래·실제 금융정보 0 (`README.md`).
/// 근거 캡처에는 실명·실계좌·실잔액이 찍혀 있으나 전부 여기 값으로 치환한다.
/// 계좌번호는 실제 계좌로 오인되지 않도록 0 패턴을 쓴다.
class KbDummy {
  // ---- 본인 ----
  static const myName = '홍길동';
  static const myAccountName = 'KB마이핏통장';
  static const myBank = 'KB국민';
  static const myAccountNo = '000000-00-000000';

  /// A1 기본 홈의 잔액과 일치시킨다.
  static const balance = 12500;
  static const balanceText = '12,500원';

  // ---- 이체 상대 ----
  static const payeeName = '김철수';
  static const payeeBank = '신한';
  static const payeeBankFull = '신한은행';
  static const payeeAccountNo = '110-000-000000';

  /// 하이픈 없는 표기 (이체 상세·금액 화면에서 이 형태로 나온다).
  static const payeeAccountNoPlain = '110000000000';
}
