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

#define TEST_SERVER_DEFINE

#ifdef TEST_SERVER_DEFINE
static NSString* CODEGUARD_SERVER_URL = @"https://dev-sbank2013.shinhan.com";

static NSString *API_VERSION_INOF_URL            = @"https://dev-sbank2013.shinhan.com/common/smt/jsp/callSmtStartService.jsp?";
static NSString *SUNNY_CLUB_URL     = @"https://vntst.shinhanglobal.com/sunny/sunnyclub/index.jsp?locale=%@";  //클럽메인
static NSString *SUNNY_BANK_URL     = @"https://vntst.shinhanglobal.com/sunny/bank/main.jsp?locale=%@";        //뱅크메인
static NSString *NEW_NEWS_URL       = @"https://vntst.shinhanglobal.com/sunny/set/newstory_list.jsp?locale=%@";//새소식
static NSString *HELP_LIST_URL      = @"https://vntst.shinhanglobal.com/sunny/set/helpl_ist.jsp?locale=%@";    //도움말

static NSString *SHINHAN_ZONE_URL   = @"https://vntst.shinhanglobal.com/sunny/bank/shinhanzone.jsp";    //신한존
static NSString *SETTING_URL        = @"https://vntst.shinhanglobal.com/sunny/faq_test.jsp";

static NSString *API_URL            = @"https://vntst.shinhanglobal.com/sunny/jsp/callSunnyJsonTaskService.jsp";

static NSString *TASK_USR           = @"sfg.sunny.task.user.UserTask";

#else     //REAL SERVER

static NSString* CODEGUARD_SERVER_URL = @"https://sbk.shinhan.com";
static NSString *API_VERSION_INOF_URL            = @"https://dev-sbank2013.shinhan.com/common/smt/jsp/callSmtStartService.jsp?";
//Codeguard
static NSString *SUNNY_CLUB_URL     = @"https://vntst.shinhanglobal.com/sunny/sunnyclub/index.jsp?locale=%@";  //클럽메인
static NSString *SUNNY_BANK_URL     = @"https://vntst.shinhanglobal.com/sunny/bank/main.jsp?locale=%@";        //뱅크메인
static NSString *NEW_NEWS_URL       = @"https://vntst.shinhanglobal.com/sunny/set/newstory_list.jsp?locale=%@";//새소식
static NSString *HELP_LIST_URL      = @"https://vntst.shinhanglobal.com/sunny/set/helpl_ist.jsp?locale=%@";    //도움말

static NSString *SHINHAN_ZONE_URL   = @"https://vntst.shinhanglobal.com/sunny/bank/shinhanzone.jsp";    //신한존
static NSString *SETTING_URL        = @"https://vntst.shinhanglobal.com/sunny/faq_test.jsp";

static NSString *API_URL            = @"https://vntst.shinhanglobal.com/sunny/jsp/callSunnyJsonTaskService.jsp";

static NSString *TASK_USR           = @"sfg.sunny.task.user.UserTask";


#endif

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

static NSString * const kLoginData       = @"kLoginData";
static NSString * const kForceUpdateY       = @"kForceUpdateY"; //강제업데이트 여부
static NSString * const kUpdateY       = @"kUpdateY"; //업데이트 여부

static NSString * const kForceMemberViewY       = @"kForceMemberViewY"; //member force view




//korea
static NSString *COMPLETE_TITLE_KO     = @"회원가입 완료";

//korea
static NSString *JAILBREAK_CHK_KO  = @"루팅된 단말입니다. 개인정보 유출의 위험성이 있으므로 써니클럽을 종료합니다.";
static NSString *JAILBREAK_CHK_VI  = @"Jsơ đồ Liên kết  tới hệ thống. Sunny club  sẽ ngừng ngay lập tức khi thấy  nguy hiểm là bị  mất thông tin cá nhân của quý khách .";
static NSString *NOT_NOMAL_APP_KO = @"정식등록된 앱이 아닙니다. 앱을 새로 다운로드 받아 설치하신 후 다시 이용해주십시요.";
static NSString *NOT_NOMAL_APP_VI = @"Không phải là app chính . Chỉ cần tải app về là sử dụng đựợc.";
static NSString *USE_PROXY_KO = @"비정상적인 접속(프록시)으로 인해 서비스를 종료합니다. 고객센터로 문의하여 주시기 바랍니다. (문의:고객센터 1800-1560)";
static NSString *USE_PROXY_VI = @"Dừng sử dụng dịch vụ khi thấy đăng nhập có vấn đề bất thường . Hãy gọi điện ngay đến trung tâm  chăm sóc khách hàng để được hỗ trợ.(  trung tâm chăm sóc khách hàng 1800-1560)";

//korea
static NSString *PERSON_TITLE_KO     = @"개인정보 변경";
static NSString *PERSON_ID_KO     = @"ID";
static NSString *PERSON_MAIL_KO     = @"메일변경";
static NSString *PERSON_CHANGE_KO     = @"적용";
static NSString *PERSON_PWD_CHANGE_KO     = @"비밀번호 변경";
static NSString *PERSON_MEMBER_OUT_KO     = @"회원탈퇴";
static NSString *PERSON_MEMBER_LEVEL_KO     = @"멤버십 등금";
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
static NSString *PERSON_MAIL_VI     = @"change Mail";
static NSString *PERSON_CHANGE_VI     = @"Summit";
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
static NSString *LEFT_DES_VI     = @"Bạn có thể sử dụng các dịch vụ khác nhau trong Sunny Club sau khi đăng nhập.";
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
static NSString *PW_SEARCH_TITLE_VI     = @"Tìm mật khẩu của bạn";
static NSString *PW_SEARCH_ID_VI     = @"ID";
static NSString *PW_SEARCH_NAME_VI     = @"Tên";
static NSString *PW_SEARCH_YYYY_VI     = @"Sinh nhật";
static NSString *PW_SEARCH_VI     = @"Tìm ID của bạn";
static NSString *ID_RESULT_HEAD_VI     = @"ID bạn đang truy vấn là:";
static NSString *ID_RESULT_TAIL_VI     = @"này.";

//korea
static NSString *IDSEARCH_TITLE_KO     = @"아이디 찾기";
static NSString *IDSEARCH_NAME_KO     = @"이름";
static NSString *IDSEARCH_YYYY_KO     = @"생년월일";
static NSString *IDSEARCH_SEARCH_KO     = @"조회하기";

//korea
static NSString *PW_CURRENT_KO = @"현재 비밀번호";
static NSString *PW_NEW_KO = @"새 비밀번호";
static NSString *PW_CONFIRM_KO = @"새 비밀번호 확인";
static NSString *PW_NO_EQUAL_KO = @"새 비밀번호가 맞지 않습니다.";

//vi
static NSString *PW_CURRENT_VI = @"Mật khẩu hiện tại";
static NSString *PW_NEW_VI = @"Mật khẩu mới";
static NSString *PW_CONFIRM_VI = @"Xác nhận mật khẩu";

//vi
static NSString *IDSEARCH_TITLE_VI     = @"Tìm ID của bạn";
static NSString *IDSEARCH_NAME_VI     = @"Tên";
static NSString *IDSEARCH_YYYY_VI     = @"Sinh nhật";
static NSString *IDSEARCH_SEARCH_VI     = @"Tìm ID của bạn";
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
static NSString *LOGIN_SUMMIT_VI     = @"Đăng ký thành viên";
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

//korea
static NSString *CONFIG_KO     = @"설정";
static NSString *NEED_KO     = @"개인정보변경";
static NSString *NEED_LOGIN_KO     = @"로그인 필요";
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
static NSString *NEED_LOGIN_VI     = @"Cần đăng nhập";
static NSString *HELP_VI     = @"Hỗ trợ";
static NSString *TUTO_VI     = @"Xem hướng dẫn";
static NSString *NEWS_VI     = @"Sự kiện mới";
static NSString *ALRAM_SET_VI     = @"Dịch vụ Cài đặt thông báo";
static NSString *ALRAM_ALLOW_VI     = @"Dịch vụ cho phép nhận thông báo";
static NSString *ALRAM_DES_VI     = @"Nếu bạn cài đặt Thông báo Push sang chế độ ON, bạn sẽ nhận được nhiều thông tin hữu ích từ Sunny Club.";
static NSString *PROGRAM_INFO_VI     = @"Thông tin chương trình";
static NSString *LANG_INFO_VI     = @"Thông tin ngôn ngữ";
static NSString *APP_INFO_VI     = @"Thông tin ứng dụng";
static NSString *CURR_VER_VI     = @"Phiên bản hiện tại";
static NSString *NEW_VER_VI     = @"Phiên bản cập nhật";
static NSString *LAST_VER_VI     = @"Cập nhật các phiên bản mới nhất";
static NSString *LAST_VER_UP_VI     = @"Cập nhật các phiên bản mới nhất";
static NSString *SUNNY_DES_VI     = @"Sunny Club được thiết kế với nội dung đa dạng theo từng chủ đề..";

//korea
static NSString *SETINFO_TITLE_KO    = @"정보입력";
static NSString *SETINFO_TEXT_KO     = @"써니뱅크는 신한은행 베트남의 특화된 모바일 마케팅 플랫폼 어플입니다.써니뱅크는 간단한 회원가입 절차를 통해 가입이 가능합니다. 써니뱅크 회원이 되시면 써니클럽 영역을 통해 제공되는 유익하고 다양한 전문 컨텐츠를 이용하실 수 있으며 써니뱅크 영역을 통해 신한은행 베트남의 금융상품 신청 및 신한은행 베트남의 금융상품을 찾아보실 수 있습니다.";
static NSString *SETINFO_AGREE_KO    = @"이용약관에 동의함";
static NSString *SETINFO_ID_KO    = @"아이디";
static NSString *SETINFO_NAME_KO    = @"이름";
static NSString *SETINFO_YEAR_KO    = @"생년월일";
static NSString *SETINFO_PWD_KO    = @"비밀번호";
static NSString *SETINFO_PWDCON_KO    = @"비밀번호확인";
static NSString *SETINFO_SUMMIT_KO    = @"가입하기";
static NSString *SETINFO_CONFIRM_KO    = @"중복확인";

//vi
static NSString *SETINFO_TITLE_VI    = @"INPUT DATA";
static NSString *SETINFO_TEXT_VI     = @"Ngân hàng Sunny là một ứng dụng cung cấp nền tảng marketing di động dành riêng cho Việt Nam tạo bởi Ngân hàng Shinhan.Bạn cũng có thể tìm thấy và đăng ký trải nghiệm những sản phẩm tài chính của Ngân hàng Shinhan Việt Nam. Shinhan Zone là chương trình ưu đãi đặc biệt dành riêng cho chủ thẻ VISA của Ngân hàng Shinhan Việt Nam.";
static NSString *SETINFO_AGREE_VI    = @"Consent terms and conditions";
static NSString *SETINFO_ID_VI    = @"ID";
static NSString *SETINFO_NAME_VI    = @"Tên";
static NSString *SETINFO_YEAR_VI    = @"Sinh nhật";
static NSString *SETINFO_PWD_VI    = @"Nhập mật khẩu";
static NSString *SETINFO_PWDCON_VI    = @"Kiểm tra mật khẩu mới	";
static NSString *SETINFO_SUMMIT_VI    = @"Bạn chưa có tài khoản của trang web này?";
static NSString *SETINFO_CONFIRM_VI    = @"ID check";







#define PWD_MAX_LENGTH             4


#endif /* defines_h */
