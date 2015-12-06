//
//  defines.h
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 12..
//  Copyright © 2015년 gclee. All rights reserved.
//

#ifndef defines_h
#define defines_h

//NSString *url = @"https://vntst.shinhanglobal.com/sunny/index3.jsp";
//NSString *url = @"https://vntst.shinhanglobal.com/sunny/faq_test2.jsp";
//NSString *url = @"https://vntst.shinhanglobal.com/sunny/faq_test.jsp";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//#define TEST_SERVER_DEFINE



#ifdef TEST_SERVER_DEFINE

#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#endif

static NSString *MW_DOMAIN = @"vntst.shinhanglobal.com/sunny";
static NSString* CODEGUARD_SERVER_URL = @"https://dev-sbank2013.shinhan.com";
static NSString *API_VERSION_INOF_URL = @"https://dev-sbank2013.shinhan.com/common/smt/jsp/callSmtStartService.jsp?";
static NSString *SUNNY_CLUB_URL     = @"https://vntst.shinhanglobal.com/sunny/sunnyclub/index.jsp?locale=%@";  //클럽메인
static NSString *SUNNY_BANK_URL     = @"https://vntst.shinhanglobal.com/sunny/bank/main.jsp?locale=%@";        //뱅크메인
static NSString *NEW_NEWS_URL       = @"https://vntst.shinhanglobal.com/sunny/set/newstory_list.jsp?locale=%@";//새소식
static NSString *HELP_LIST_URL      = @"https://vntst.shinhanglobal.com/sunny/set/help_list.jsp?locale=%@";    //도움말
static NSString *SHINHAN_ZONE_URL   = @"https://vntst.shinhanglobal.com/sunny/bank/shinhanzone.jsp";    //신한존
static NSString *SHINHAN_EVENT_URL   = @"https://vntst.shinhanglobal.com/sunny/set/event_view.jsp?seqno=1&board_d=1";
static NSString *API_URL            = @"https://vntst.shinhanglobal.com/sunny/jsp/callSunnyJsonTaskService.jsp";
static NSString *TASK_USR           = @"sfg.sunny.task.user.UserTask";

#else     //REAL SERVER

#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#endif

static NSString *MW_DOMAIN = @"online.shinhan.com.vin/sunny";
static NSString* CODEGUARD_SERVER_URL = @"https://sbk.shinhan.com";
static NSString *API_VERSION_INOF_URL = @"https://sbk.shinhan.com/common/smt/jsp/callSmtStartService.jsp?";
static NSString *SUNNY_CLUB_URL     = @"https://online.shinhan.com.vn/sunny/sunnyclub/index.jsp?locale=%@";  //클럽메인
static NSString *SUNNY_BANK_URL     = @"https://online.shinhan.com.vn/sunny/bank/main.jsp?locale=%@";        //뱅크메인
static NSString *NEW_NEWS_URL       = @"https://online.shinhan.com.vn/sunny/set/newstory_list.jsp?locale=%@";//새소식
static NSString *HELP_LIST_URL      = @"https://online.shinhan.com.vn/sunny/set/help_list.jsp?locale=%@";    //도움말
static NSString *SHINHAN_ZONE_URL   = @"https://online.shinhan.com.vn/sunny/bank/shinhanzone.jsp";    //신한존
static NSString *SHINHAN_EVENT_URL   = @"https://online.shinhan.com.vn/sunny/set/event_view.jsp?seqno=1&board_d=1";    //신한존
static NSString *API_URL            = @"https://online.shinhan.com.vn/sunny/jsp/callSunnyJsonTaskService.jsp";
static NSString *TASK_USR           = @"sfg.sunny.task.user.UserTask";

#endif
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static NSString * const kUUID              = @"currentUUID";        // UUID
static NSString * const kUserDeviceToken   = @"userDeviceToken";    // 디바이스 토큰
static NSString * const klang       = @"currentLang";         // language
static NSString * const kAutoLogin       = @"autoLogin";
static NSString * const kId       = @"kId";
static NSString * const kPwd       = @"kPwd";//
static NSString * const kUserNm       = @"kUserNm";//
static NSString * const kEmail       = @"kEmail";//
static NSString * const kEmail_id       = @"kEmail_id";//
static NSString * const kLoginY       = @"loginY";         //로그인성공여부
static NSString * const kCardCode       = @"cardCode";         //
static NSString * const kAgreeOk       = @"agreeOk";
static NSString * const kPushY       = @"pushY";         // language
static NSString * const kYYYYMMDD       = @"kYYYYMMDD";         // language
static NSString * const kGNBHide       = @"kGNBHide";
static NSString * const kCurrentVersion       = @"kCurrentVersion";
static NSString * const kUpdateVersion       = @"kUpdateVersion";
static NSString * const kUpdateUri       = @"kUpdateUri";
static NSString * const kTutoY       = @"kTutoY";
static NSString * const kFirstExecY       = @"kFirstExecY";

static NSString * const kLoginData       = @"kLoginData";
static NSString * const kForceUpdateY       = @"kForceUpdateY"; //강제업데이트 여부
static NSString * const kUpdateY       = @"kUpdateY"; //업데이트 여부

static NSString * const kForceMemberViewY       = @"kForceMemberViewY"; //member force view




//korea
static NSString * SEND_PWD_MAIL_KO = @"회원님의 등록된 메일 주소로\n임시 비밀번호 메일을 전송 하였습니다.";

//vi
static NSString * SEND_PWD_MAIL_VI = @"Mật khẩu tạm thời đã được gửi đến địa chỉ email bạn đăng ký.";

//korea
static NSString *NOT_EXIT_ID_KO = @"계정정보가 존재하지 않습니다.";
static NSString *CHANGE_MAIL_KO = @"이메일 변경이 완료 되었습니다.";
//vi
static NSString *NOT_EXIT_ID_VI = @"Thông tin tài khoản này không tồn tại";
static NSString *CHANGE_MAIL_VI = @"Hoàn tất thay đổi email";


//korea
static NSString *COMPLETE_TITLE_KO     = @"회원가입 완료";
static NSString *COMPLETE_TITLE_VI     = @"Hoàn tất đăng ký thành viên";

//korea
static NSString *JAILBREAK_CHK_KO  = @"루팅된 단말입니다. 개인정보 유출의 위험성이 있으므로 써니클럽을 종료합니다.";
static NSString *JAILBREAK_CHK_VI  = @"Jsơ đồ Liên kết  tới hệ thống. Sunny club  sẽ ngừng ngay lập tức khi thấy  nguy hiểm là bị  mất thông tin cá nhân của quý khách .";
static NSString *NOT_NOMAL_APP_KO = @"정식등록된 앱이 아닙니다. 앱을 새로 다운로드 받아 설치하신 후 다시 이용해주십시요.";
static NSString *NOT_NOMAL_APP_VI = @"Không phải là app chính . Chỉ cần tải app về là sử dụng đựợc.";
static NSString *USE_PROXY_KO = @"비정상적인 접속(프록시)으로 인해 서비스를 종료합니다. 고객센터로 문의하여 주시기 바랍니다. (문의:고객센터 1800-1560)";
static NSString *USE_PROXY_VI = @"Dừng sử dụng dịch vụ khi thấy đăng nhập có vấn đề bất thường . Hãy gọi điện ngay đến trung tâm  chăm sóc khách hàng để được hỗ trợ.(  trung tâm chăm sóc khách hàng 1800-1560)";

//korea
static NSString *PERSON_TITLE_KO     = @"개인정보 변경";
static NSString *PERSON_ID_KO     = @"아이디";
static NSString *PERSON_MAIL_KO     = @"이메일변경";
static NSString *PERSON_CHANGE_KO     = @"적용";
static NSString *PERSON_PWD_CHANGE_KO     = @"비밀번호 변경";
static NSString *PERSON_MEMBER_OUT_KO     = @"회원탈퇴";
static NSString *PERSON_MEMBER_LEVEL_KO     = @"멤버십 등급";
static NSString *PERSON_NOMAL_KO     = @"일반";

//korea
static NSString *MEM_OUT_TITLE_KO     = @"회원탈퇴 안내사항";
static NSString *MEM_OUT_DESC_KO     = @"1. 회원정보가 삭제되며, 복구는 불가능합니다. \n 2.멤버십 등급 및 포인트가 삭제되며 복구는 불가능 합니다.";
static NSString *MEM_PWD_TITLE_KO     = @"비밀번호 입력";
static NSString *MEM_PWD_DESC_KO     = @"회원탈퇴 처리를 위해 다시한번 비밀번호를 입력하시기 바랍니다.";
static NSString *MEM_OUT_KO = @"탈퇴하기";

//vi
static NSString *MEM_OUT_TITLE_VI     = @"Hướng dẫn về hủy thành viên";
static NSString *MEM_OUT_DESC_VI     = @"1.Thông tin thành viên bị hủy, không thể phục hồi \n 2.Thứ hạng và điểm của thành viên bị hủy, không thể phục hồi";
static NSString *MEM_PWD_TITLE_VI     = @"Nhập mật khẩu";
static NSString *MEM_PWD_DESC_VI     = @"Vui lòng nhập mật khẩu lại để hủy thành viên";
static NSString *MEM_OUT_VI = @"Hủy thành viên";


//vi
static NSString *PERSON_TITLE_VI     = @"Thay đổi thông tin cá nhân";
static NSString *PERSON_ID_VI     = @"ID";
static NSString *PERSON_MAIL_VI     = @"Thay đổi địa chỉ email";
static NSString *PERSON_CHANGE_VI     = @"Áp dụng";
static NSString *PERSON_PWD_CHANGE_VI     = @"Thay đổi mật khẩu";
static NSString *PERSON_MEMBER_OUT_VI     = @"Hủy thành viên";
static NSString *PERSON_MEMBER_LEVEL_VI     = @"Thứ hạng hội viên";
static NSString *PERSON_NOMAL_VI      = @"Chung";

//korea
static NSString *LEFT_DES_KO     = @"로그인을 하시면 Sunny Club의 다양한 서비스를 이용하실 수 있습니다.";
static NSString *LEFT_LOGIN_KO     = @"로그인";
static NSString *LEFT_LOGIN_NOTI_KO     = @"Event / 공지";
static NSString *LEFT_CONFIG_KO     = @"설정";

static NSString *BOTTOM_BANNER_KO = @"bottom_banner.png";

//vi
static NSString *LEFT_DES_VI     = @"Vui lòng đăng nhập để sử dụng các dịch vụ của Sunny Club.";
static NSString *LEFT_LOGIN_VI     = @"Đăng nhập";
static NSString *LEFT_LOGIN_NOTI_VI     = @"Event / Thông báo";
static NSString *LEFT_CONFIG_VI     = @"Cài đặt";

static NSString *BOTTOM_BANNER_VI = @"bottom_banner_viet.png";

//korea
static NSString *PW_SEARCH_TITLE_KO     = @"비밀번호 찾기";
static NSString *PW_SEARCH_ID_KO     = @"아이디";
static NSString *PW_SEARCH_NAME_KO     = @"이름";
static NSString *PW_SEARCH_YYYY_KO     = @"생년월일";
static NSString *PW_SEARCH_KO     = @"조회하기";
static NSString *ID_RESULT_HEAD_KO     = @"조회하신 아이디는";
static NSString *ID_RESULT_TAIL_KO     = @"입니다.";

//vi
static NSString *PW_SEARCH_TITLE_VI     = @"Tìm mật khẩu";
static NSString *PW_SEARCH_ID_VI     = @"ID";
static NSString *PW_SEARCH_NAME_VI     = @"Tên";
static NSString *PW_SEARCH_YYYY_VI     = @"Sinh nhật";
static NSString *PW_SEARCH_VI     = @"truy vấn";
static NSString *ID_RESULT_HEAD_VI     = @"ID bạn đang truy vấn là:";
static NSString *ID_RESULT_TAIL_VI     = @"này.";

//korea
static NSString *IDSEARCH_TITLE_KO     = @"아이디 찾기";
static NSString *IDSEARCH_NAME_KO     = @"이름";
static NSString *IDSEARCH_YYYY_KO     = @"생년월일";
static NSString *IDSEARCH_SEARCH_KO     = @"조회하기";

//korea
static NSString *PW_CURRENT_KO = @"현재 비밀번호 입력";
static NSString *PW_NEW_KO = @"새 비밀번호 입력";
static NSString *PW_CONFIRM_KO = @"새 비밀번호 확인";
static NSString *PW_NO_EQUAL_KO = @"새 비밀번호가 맞지 않습니다.";

//vi
static NSString *PW_CURRENT_VI = @"Mật khẩu hiện tại";
static NSString *PW_NEW_VI = @"Mật khẩu mới";
static NSString *PW_CONFIRM_VI = @"Xác nhận mật khẩu";

//vi
static NSString *IDSEARCH_TITLE_VI     = @"Tìm ID";
static NSString *IDSEARCH_NAME_VI     = @"Tên";
static NSString *IDSEARCH_YYYY_VI     = @"Sinh nhật";
static NSString *IDSEARCH_SEARCH_VI     = @"Truy vấn";
static NSString *PW_NO_EQUAL_VI = @"Mật khẩu mới nhập không đúng";

//korea
static NSString *LOGIN_TITLE_KO     = @"로그인";
static NSString *LOGIN_KO     = @"로그인";
static NSString *LOGIN_ID_KO     = @"아이디";
static NSString *LOGIN_PWD_KO     = @"비밀번호";
static NSString *LOGIN_AUTO_KO     = @"자동로그인";
static NSString *LOGIN_ID_FIND_KO     = @"아이디 찾기";
static NSString *LOGIN_PWD_FIND_KO     = @"비밀번호 찾기";
static NSString *LOGIN_BTN_KO     = @"로그인";
static NSString *LOGIN_NOTI_KO     = @"회원이 아니신가요? 지금 가입하고 다양한 서비스를 자유롭게 이용하세요.";
static NSString *LOGIN_SUMMIT_KO     = @"회원가입";
static NSString *EMAIL_CHECK_KO      = @"이메일 형식의 아이디를 입력하세요.";
static NSString *ID_CHECK_KO         = @"아이디를 입력하세요.";
static NSString *PWD_CHECK_KO = @"비밀번호를 입력하세요.";
static NSString *NEW_PWD_CHECK_KO = @"새 비밀번호를 입력하세요.";
static NSString *PWD_LENGTH_CHECK_KO = @"비밀번호가 너무 짧습니다.";
static NSString *LOGIN_SUCCESS_KO = @"로그인 성공";
static NSString *LOGIN_FAIL_KO = @"로그인 실패";
static NSString *LOGIN_OUT_SUCCESS_KO = @"로그아웃 성공";
static NSString *LOGIN_OUT_ASK_KO = @"로그아웃 하시겠습니까?";
static NSString *SAVE_KO = @"저장하기";
static NSString *NAME_CHECK_KO = @"이름을 입력하세요.";
static NSString *BIRTH_CHECK_KO = @"생년월일을 입력하세요.";

//vi
static NSString *NEW_PWD_CHECK_VI = @"Mật khẩu mới";
static NSString *LOGIN_TITLE_VI     = @"Đăng nhập";
static NSString *LOGIN_VI     = @"Đăng nhập";
static NSString *LOGIN_ID_VI     = @"ID";
static NSString *LOGIN_PWD_VI     = @"mật khẩu";
static NSString *LOGIN_AUTO_VI     = @"Tự động đăng nhập";
static NSString *LOGIN_ID_FIND_VI     = @"ID của bạn";
static NSString *LOGIN_PWD_FIND_VI     = @"Tìm mật khẩu của bạn";
static NSString *LOGIN_BTN_VI     = @"Đăng nhập";
static NSString *LOGIN_NOTI_VI     = @"Bạn có phải là hội viên? Hãy đăng nhập và sử dụng dịch vụ của chúng tôi.";
static NSString *LOGIN_SUMMIT_VI     = @"Đăng ký";
static NSString *EMAIL_CHECK_VI      = @"Đăng nhập ID  theo hình thức email.";
static NSString *ID_CHECK_VI         = @"Xin vui lòng nhập ID";
static NSString *PWD_CHECK_VI = @"Vui lòng nhập mật khẩu";
static NSString *PWD_LENGTH_CHECK_VI = @"Mật khẩu quá ngắn";
static NSString *LOGIN_SUCCESS_VI = @"Đăng nhập";
static NSString *LOGIN_FAIL_VI = @"Đăng nhập FAIL";
static NSString *LOGIN_OUT_SUCCESS_VI = @"Đăng nhập Success";
static NSString *LOGIN_OUT_ASK_VI = @"Bạn có muốn thoát?";
static NSString *SAVE_VI = @"Lưu lại";
static NSString *NAME_CHECK_VI = @"Xin vui lòng nhập tên";
static NSString *BIRTH_CHECK_VI = @"Xin vui lòng nhập ngày tháng năm sinh";
static NSString *NO_SAME_PWD_VI = @"Mật khẩu nhập không chính xác";
static NSString *NO_SAME_PWD_KO = @"비밀번호가 맞지 않습니다.";
static NSString *PWD_CHANGE_COMPLEATE_KO = @"비밀번호 변경이 완료되었습니다.";
static NSString *PWD_CHANGE_COMPLEATE_VI = @"Mật khẩu đã thay đổi xong";



//korea
static NSString *CONFIG_KO     = @"설정";
static NSString *NEED_KO     = @"개인정보변경";
static NSString *NEED_LOGIN_KO     = @"로그인이 필요 합니다.";
static NSString *HELP_KO     = @"도움말";
static NSString *TUTO_KO     = @"튜토리얼 보기";
static NSString *NEWS_KO     = @"새소식";
static NSString *ALRAM_SET_KO     = @"서비스 알림 설정";
static NSString *ALRAM_ALLOW_KO     = @"서비스 알림 수신 허용";
static NSString *ALRAM_DES_KO     = @"Push 알림을 ON으로 설정하시면, Sunny Club에서 제공하는 다양한 정보 및 알림을 받으실 수 있습니다.";
static NSString *PROGRAM_INFO_KO     = @"프로그램 정보";
static NSString *LANG_INFO_KO     = @"언어 정보";
static NSString *APP_INFO_KO     = @"APP 정보";
static NSString *CURR_VER_KO     = @"현재버전";
static NSString *NEW_VER_KO     = @"최신버전";
static NSString *LAST_VER_KO     = @"최신버전 입니다.";
static NSString *LAST_VER_UP_KO     = @"최신버전 업데이트";
static NSString *SUNNY_DES_KO     = @"테마별 다양한 콘텐츠로 구성된 Sunny Club! 스마트한 웹진형태의 유니크한 콘텐츠를 만나 보세요.";

////vi
static NSString *CONFIG_VI     = @"Cài đặt";
static NSString *NEED_VI     = @"Thay đổi thông tin cá nhân";
static NSString *NEED_LOGIN_VI     = @"Cài đặt";
static NSString *HELP_VI     = @"Hỗ trợ";
static NSString *TUTO_VI     = @"Xem hướng dẫn";
static NSString *NEWS_VI     = @"Sự kiện mới";
static NSString *ALRAM_SET_VI     = @"Dịch vụ Cài đặt thông báo";
static NSString *ALRAM_ALLOW_VI     = @"Dịch vụ cho phép nhận thông báo";
static NSString *ALRAM_DES_VI     = @"Nếu bạn cài đặt Thông báo Push sang chế độ ON, bạn sẽ nhận được nhiều thông tin hữu ích từ Sunny Club.";
static NSString *PROGRAM_INFO_VI     = @"Thông tin chương trình";
static NSString *LANG_INFO_VI     = @"Ngôn ngữ";
static NSString *APP_INFO_VI     = @"Thông tin ứng dụng";
static NSString *CURR_VER_VI     = @"version";
static NSString *NEW_VER_VI     = @"new";
static NSString *LAST_VER_VI     = @"Đây là phiên bản mới nhất";
static NSString *LAST_VER_UP_VI     = @"Cập nhật các phiên bản mới nhất";
static NSString *SUNNY_DES_VI     = @"Sunny Club được thiết kế với nội dung đa dạng theo từng chủ đề\nHãy trải nghiệm những nội dung độc đáo của Sunny Club dưới dạng tạp chí thông minh.";

//korea
static NSString* NEED_AGREE_KO = @"이용약관에 동의해 주세요.";
static NSString* NEED_ID_CHECK_KO = @"아이디 중복 확인을 해주세요.";
static NSString* ID_NOTUSE_KO = @"아이디 중복 확인을 해주세요.";
static NSString* NOT_USE_EMAIL_KO = @"이미 가입된 이메일입니다.";
static NSString* NOT_USE_EMAIL_VI = @"Email này đã được đăng ký";
//vi
static NSString* NEED_AGREE_VI = @"Xin hãy đồng ý điều khoản sử dụng";
static NSString* NEED_ID_CHECK_VI = @"Xin vui lòng kiểm tra trùng lặp ID.";

//korea
static NSString *SETINFO_TITLE_KO    = @"정보입력";
static NSString *SETINFO_TEXT_KO     = @"조항 1 : 정의\n\
이 계약 조건을 이해하기 위해\n\
• \"우리\", \"우리의\", 혹은 \"은행\"은 써니 뱅크를 가리킨다. (이후로는 은행이라고 부른다)\n\
• \"당신\", \"당신의\", 혹은 \"고객\"은 이 서비스에 가입한 각 사람을 지칭한다.\n\
• 서비스\"에는 계약 조건 내의 아래에 언급된 조항 2를 포함한 은행이 고객에게 제공하는 다양한 범위의 서비스가 포함된다. \"사용자 ID\"는 당신이 은행에 등록한 ID이다.\n\
• \"비밀번호\"란 개인적인 신원 번호로 당신이 써니 뱅크에 접근할 권한을 준 사용자들에게 배정한 것이다.\n\
• \"영업일\"이란 영업의 장소에서 정상적인 영업을 위해 은행이 활동하는 날을 가리킨다.\n\
\n\
조항 2 : 서비스의 범위\n\
은행이 고객에게 제공하는 서비스는 다음의 다양한 것들이다.\n\
• 콘텐츠 서비스 : 사회 지역에 대한 콘텐츠로 문화, 음식, 패션 기타 등등이다.\n\
• 은행 서비스 : 은행 상품(대출, 카드)에 오직 가입하기 위함이다.\n\
\n\
조항 3 : 고객의 권리와 의무\n\
• 은행과 동의한 범위 내에서 모바일 은행 서비스를 사용해야한다.\n\
• 은행의 정책을 준수하면서, 은행에게 기계적인 문제로 인해 보안장치를 바꿔달라고 요구하고 은행에게 업데이트 그리고/혹은 당신의 (사용자 ID, PIN 번호 그리고 다른 정보를 포함하여) 사용자 정보를 바꿔달라고 요구해야한다.\n\
• 당신이 당신의 ID나 핀번호의 보안이나 익명성이 위반되었다고 믿을 만한 상황이 있을 때 즉시 우리에게 알려라. 그리고 은행은 당신이 은행에게 그러한 경고를 제공하는데 실패해서 결과된 손실이나 피해 혹은 그러한 경고를 제공함으로써 방지될 수 있는 손실이나 피해에 대해 책임을 지지 않는다.\n\
• 당신이 비밀번호의 익명성이 어떻게든 위태롭게 되었다는 것을 알거나 의심한다면 즉각적으로 비밀번호를 바꿔야한다.\n\
• 당신이 우리에게 서비스와 관련해서 제공하는 서류들이 참이고, 완전하고, 최신의 것임을 보증해야한다.\n\
• 그러나, 서비스를 제공하는 것과 관련한 우리 직원의 사기나 태만, 서비스를 제공해왔던 시스템을 포함한 우리 시스템에서 일어난 잘못(잘못이 경고나 메시지를 통해 공지되거나 명백하지 않는다면), 그리고 당신이 사용자 이름/당신의 ID, 비밀번호를 만들기 전에 일어난 승인되지 않은 거래에 의한 손실에 있어선 당신은 책임이 없다.\n\
\n\
조항 4 : 위임\n\
은행은 언제라도 그 권리와 의무를 이 계약 조건 하에 은행에 의해 소유되고 통제되는 계열사나 모회사 혹은 그 어떤 이해관계가 있는 계승자에게 배정하거나 위임할 수 있다. 은행은 또한 이 계약 조건 하에 특정한 우리의 권리 혹은 의무를 독립적인 계약자나 다른 제3자에게 배정하거나 위임할 수 있다. 당신은 이 계약조건 하에 당신의 권리나 의무를 그 어떤 사람이나 단체에게도 배정하거나 위임할 수 없다.\n\
\n\
조항 5 : 수정\n\
은행은 이 계약 조건을 때때로 은행의 웹사이트에 공고를 알림으로써 수정할 수 있다. 고객들은 그 혹은 그녀가 그러한 변화에 동의하지 않으면 계약을 종료시킬 수 있다. 그리고 고객은 그 혹은 그녀가 그 서비스를 이용하는 걸 유지한다면 그러한 변화에 동의했다고 간주될 수 있다. 은행에 의해 새로운 인터넷 뱅킹의 특성이 부가되거나 고객에 의해 사용된다면, 계약 조건은 은행과 고객 모두를 구속할 것을 유지할 것이다.\n\
\n\
조항 6 : 종료\n\
수기로 된 당신의 서비스 종료에 대한 요청을 은행이 받아들인 후, 당신은 서비스의 사용을 언제든 종료시킬 수 있다. 우리는 (다음과 같을 때) 서비스를 즉각적이고 사전 고지 없이 종료시킬 수 있는데, (a) 당신이 우리와의 동의를 파기시켰을 때 (b) 당신의 비밀번호가 위험에 처해졌을 때이다. 심지어 서비스가 없어지거나 종료될 때에도, 서비스의 사용기간 동안의 권리와 의무에 있어서 만큼은 당신은 이 계약조건에 여전히 구속받는다.";

static NSString *SETINFO_TEXT_VI = @"ĐIỀU 1: ĐỊNH NGHĨA\n\
Nhằm hiểu rõ các Điều khoản và điều kiện này, các định nghĩa sau được áp dụng:\n\
• “ Chúng tôi”, “Ngân hàng” được hiểu là Ngân hàng Sunny (dưới đây được ghi tắt là Ngân hàng).\n \
• “Quý khách”, “khách hàng” được hiểu là khách hàng có đăng ký sử dụng dịch vụ này.\n\
• “ Dịch vụ ” được hiểu là dịch vụ do Ngân hàng cung cấp theo phạm vi dịch vụ tại Điều 2 của Điều khoản và Điều kiện này; “ Tên đăng nhập ” được hiểu là tên người sử dụng do Quý khách đăng ký với Ngân hàng;\n\
• “ PIN ” hoặc “ mật khẩu ” là mã số bí mật của người sử dụng được Quý khách cấp thẩm quyền sử dụng dịch vụ Ngân hàng Sunny;\n\
• “Ngày làm việc” là ngày mà Ngân hàng mở cửa hoạt động chính thức tại các địa điểm giao dịch của mình.\n\
\n\
\n\
Điều 2: Phạm vi dịch vụ\n\
Ngân hàng cung cấp đến khách hàng những dịch vụ sau:\n\
• Dịch vụ nội dung: nội dung về văn hóa xã hội như văn hóa, ẩm thực, thời trang…\n\
• Dịch vụ ngân hàng: đăng ký các sản phẩm ngân hàng (cho vay, thẻ)\n\
\n\
\n\
ĐIỀU 3: QUYỀN VÀ NGHĨA VỤ CỦA QUÝ KHÁCH\n\
• Sử dụng dịch vụ ngân hàng trực tuyến trong phạm vi dịch vụ đã thỏa thuận với Ngân hàng\n\
• Yêu cầu Ngân hàng thay đổi thiết bị bảo mật do sự cố kỹ thuật, cập nhật và hoặc thay đổi thông tin đăng nhập (bao gồm Tên đăng nhập, Mật mã, và các thông tin khác) theo quy định của Ngân hàng.\n\
• Thông báo ngay cho Ngân hàng khi Quý khách có lý do để tin rằng tên đăng nhập, Mật khẩu, và OTP/ Thẻ bảo mật của mình đã bị lộ hoặc tính bảo mật không còn nữa; Ngân hàng không chịu trách nhiệm đối với các tổn thất, thiệt hại xảy ra do lỗi của Quý khách không thông báo cho Ngân hàng hoặc các tổn thất, thiệt hại đáng lẽ có thể ngăn chặn được nếu có thông báo cho Ngân hàng.\n\
• Lập tức thay đổi Mật khẩu nếu Khách hàng biết được hoặc nghi ngờ tính bảo mật của Mật khẩu đã bị vi phạm dưới bất kỳ hình thức nào.\n\
Trường hợp chúng tôi nhận được chỉ thị chuyển khoản (hoặc yêu cầu hủy chỉ thị chuyển khoản) được xem là do Quý khách gửi tới thì các chỉ thị như vậy sẽ được coi là chỉ thị của Quý khách và Quý khách phải chịu trách nhiệm đối với các khoản tiền nói trên, kể cả khi những chỉ thị đó, trên thực tế, không phải do Quý khách thực hiện hoặc ủy quyền thực hiện. Quý khách chịu mọi trách nhiệm đối với những tổn thất, mất mát phát sinh do việc tiết lộ, mất cắp, sử dụng sai mục đích tên đăng nhập, mật khẩu, và OTP/ Thẻ bảo mật với bất cứ lý do nào, trừ khi Khách hàng chứng minh được việc tiết lộ xảy ra là do lỗi của Ngân hàng;\n\
\n\
ĐIỀU 4: CHUYỂN NHƯỢNG\n\
\n\
Ngân hàng, vào bất kỳ thời điểm nào, có quyền chuyển nhượng hoặc phân cấp thực hiện quyền và nghĩa vụ của mình theo quy định tại các Điều khoản và điều kiện này cho bất kỳ đơn vị nào thuộc quyền sở hữu hoặc quản lý của Ngân hàng, ngân hàng mẹ, hoặc một đơn vị tiếp quản quyền lợi bất kỳ. Ngân hàng cũng có thể chuyển nhượng hoặc phân cấp một số quyền hoặc nghĩa vụ của mình theo quy định của các Điều khoản và điều kiện này cho các nhà thầu độc lập hoặc một bên thứ ba. Khách hàng không có quyền chuyển nhượng các quyền và nghĩa vụ của mình theo các Điều khoản và điều kiện này cho bất kỳ một tổ chức hoặc cá nhân nào khác.\n\
\n\
ĐIỀU5: ĐIỀU CHỈNH\n\
\n\
Ngân hàng tùy từng thời điểm có quyền điều chỉnh các Điều khoản và điều kiện này bằng cách thông báo trên website. Khách hàng có quyền lựa chọn chấm dứt hợp đồng nếu không đồng ý với những thay đổi đó; Việc khách hàng tiếp tục sử dụng dịch vụ ngân hàng trực tuyến SHBVN sau thời điểm thay đổi diễn ra đồng nghĩa với việc Khách hàng đồng ý với những thay đổi này. Trường hợp Ngân hàng thêm một (số) tiện ích mới vào dịch vụ ngân hàng trực tuyến và Khách hàng sử dụng các tiện ích mới này, đồng nghĩa với việc các Điều khoản và điều kiện này tiếp tục có hiệu lực ràng buộc các bên. \n\
\n\
ĐIỀU 6: CHẤM DỨT HOẶC TẠM NGƯNG HỢP ĐỒNG\n\
\n\
Quý khách có thể chấm dứt việc sử dụng dịch vụ ngân hàng trực tuyến SHBVN vào bất kỳ thời điểm nào bằng cách gửi cho Ngân hàng yêu cầu ngừng cung cấp dịch vụ bằng văn bản. Chúng tôi có thể lập tức ngưng cung cấp dịch vụ mà không cần thông báo trước trong những trường hợp sau: (a) Quý khách vi phạm cam kết đã ký với Ngân hàng; (b) thẻ bảo mật của Quý khách bị lộ; Ngay cả khi dịch vụ ngân hàng trực tuyến đã được tạm ngưng hoặc chấm dứt, Quý khách vẫn chịu ràng buộc bởi các Điều khoản và điều kiện này trong phạm vi quyền và nghĩa vụ của Khách hàng phát sinh trong thời gian Quý khách sử dụng dịch vụ.";

static NSString *SETINFO_AGREE_KO    = @"이용약관에 동의함";
static NSString *SETINFO_ID_KO    = @"아이디";
static NSString *SETINFO_NAME_KO    = @"이름";
static NSString *SETINFO_YEAR_KO    = @"생년월일";
static NSString *SETINFO_PWD_KO    = @"비밀번호";
static NSString *SETINFO_PWDCON_KO    = @"비밀번호확인";
static NSString *SETINFO_SUMMIT_KO    = @"가입하기";
static NSString *SETINFO_CONFIRM_KO    = @"중복확인";

//vi
static NSString *SETINFO_TITLE_VI    = @"Nhập thông tin";
static NSString *SETINFO_AGREE_VI    = @"Đồng ý với điều khoản sử dụng";
static NSString *SETINFO_ID_VI    = @"ID";
static NSString *SETINFO_NAME_VI    = @"Tên";
static NSString *SETINFO_YEAR_VI    = @"Sinh nhật";
static NSString *SETINFO_PWD_VI    = @"Nhập mật khẩu";
static NSString *SETINFO_PWDCON_VI    = @"Kiểm tra mật khẩu mới	";
static NSString *SETINFO_SUMMIT_VI    = @"Bạn chưa có tài khoản của trang web này?";
static NSString *SETINFO_CONFIRM_VI    = @"Kiểm tra\n trùng lặp";

//korea
static NSString *ENABLE_EMAIL_ID_KO = @"사용 가능한 이메일입니다.";
static NSString *ENABLE_EMAIL_ID_VI = @"Email này có thể sử dụng";
static NSString *DIABLE_EMAIL_ID_KO = @"이미 가입된 이메일입니다.";
static NSString *DIABLE_EMAIL_ID_VI = @"Email này đã được đăng ký";

static NSString *WELCOM_DESC_KO = @"반갑습니다.\
써니클럽의 가족이 되신 것을 환영합니다\
써니클럽의 서비스를 자유롭게 이용 하실 수 있습니다.";
static NSString *WELCOM_DESC_VI = @"Chào mừng bạn!\
Chúc mừng bạn là thành viên của Sunny Club. Hãy trải nghiệm ngay tất cả dịch vụ của chúng tôi!";
static NSString *SERVICE_GO_KO = @"서비스 이용하러 가기";
static NSString *SERVICE_GO_VI = @"Sử dụng dịch vụ";

static NSString *NET_WORK_CHECK_KO = @"네트워크에 접속할 수 없습니다. \n 연결상태를 확인해 주세요.";
static NSString *NET_WORK_CHECK_VI = @"Chúng tôi không thể kết nối mạng. \n Vui lòng kiểm tra lại trạng thái kết nối.";
static NSString *NET_WORK_RELOAD_KO = @"재시도";
static NSString *NET_WORK_RELOAD_VI = @"Thử lại";






#define PWD_MAX_LENGTH             4


#endif /* defines_h */
