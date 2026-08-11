/// 더미 데이터 한 곳 모음.
///
/// 연구 원칙: 실거래·실제 금융정보 0 (`README.md`).
/// 근거 캡처에는 실명·실계좌·실잔액이 찍혀 있으나 전부 여기 값으로 치환한다.
/// 계좌번호는 실제 계좌로 오인되지 않도록 0 패턴을 쓴다.
class ShDummy {
  // ---- 본인 (더미) ----
  static const myName = '홍길동';

  /// 출금계좌(상품명은 개인정보가 아니라 충실도를 위해 캡처 그대로 둔다).
  static const myAccountName = '[금융거래한도계좌2]신한 주거래 우대통장';
  static const myAccountType = '(저축예금)';
  static const myBank = '신한';
  static const myAccountNo = '110-000-000000';

  /// 이체 금액 화면의 출금가능금액. 명백한 더미 값(라운드 넘버).
  static const balance = 1000000;
  static const balanceText = '1,000,000원';

  // ---- 공과금 납부 더미 (캡처의 실정보 전부 치환) ----
  static const billTitle = '전기요금 납부';
  static const billCustomerName = '홍길동'; // 고객명 (캡처: 실명 → 더미)
  static const billEnoNo = '1700000000'; // 전자납부번호(고객번호)
  static const billMonth = '202607'; // 청구연월
  static const billDesignatedAcc = '31500000000000'; // 고객전용지정 계좌번호(더미)
  static const billAddress = '○○동 ●●●-●'; // 고객주소(마스킹)
  static const billAmount = 2160;
  static const billAmountText = '2,160원';
  static const billAvailableText = '1,000,000'; // 출금가능금액(더미)
  static const billPaidAt = '2026.08.07 10:11'; // 납부일(더미 고정)

  /// 과제 대상 상대의 예금주명(더미). 계좌·은행은 진입 화면에서 직접 입력.
  static const taskPayee =
      ShPayee(name: '김철수', bank: '신한', accountNo: '110-000-000000');

  // ---- 이체 과제 정답 판정 ----
  //
  // 정답: 신한은행 + 아래 계좌번호(- 없이 숫자만). 실험에서도 이 값을 정답으로 사용.
  // 순차 숫자라 명백히 더미. 판정은 확인 화면 [보내기]에서 수행한다.
  static const correctBank = '신한';
  static const correctAccount = '110234567890';

  /// 백도어: 계좌번호를 '0' 한 글자로 입력하면 은행과 무관하게 통과(실험자 편의).
  static bool isBackdoorAccount(String acc) => acc == '0';

  /// 계좌번호 자체가 유효한지(은행 무관). 진입 [다음]에서 검사 →
  /// 아니면 ELB00016. 백도어이거나 정답 계좌면 통과.
  static bool isAccountValid(String acc) =>
      isBackdoorAccount(acc) || acc == correctAccount;

  /// 이체 정답 판정. 확인 화면 [보내기]에서 사용.
  ///  - ok: 정답(신한+정답계좌) 또는 백도어
  ///  - wrongBank: 계좌는 맞지만 은행이 신한이 아님 → ETA00325
  ///  - wrongAccount: 계좌번호 자체가 틀림 → ELB00016
  static TransferCheck checkTransfer(String acc, String? bank) {
    if (isBackdoorAccount(acc)) return TransferCheck.ok;
    if (acc == correctAccount) {
      return bank == correctBank ? TransferCheck.ok : TransferCheck.wrongBank;
    }
    return TransferCheck.wrongAccount;
  }

  // ---- 하위호환(휴면 화면 참조) ----
  static const payeeName = '김철수';
  static const payeeBank = '카카오뱅크';
  static const payeeBankFull = '카카오뱅크';
  static const payeeAccountNo = '3333-00-0000000';
  static const payeeAccountNoPlain = '333300000000';
}

/// 이체 정답 판정 결과.
enum TransferCheck { ok, wrongBank, wrongAccount }

/// 이체 상대 한 명. 진입 → 금액 → 확인 → 완료로 그대로 전달된다.
class ShPayee {
  final String name;
  final String bank;
  final String accountNo; // 하이픈 표기
  final bool favorite;

  const ShPayee({
    required this.name,
    required this.bank,
    required this.accountNo,
    this.favorite = false,
  });
}
