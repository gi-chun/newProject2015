//
//  SafeOnPushClient.h
//  SafeOnPushClient
//  
//  Created by micesoft on 12. 1. 13..
//  Copyright 2012 micesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PushClient          [SafeOnPushClient shraredInstance]

#define kSOServerUrl        @"http://pushdev.shinhanglobal.com:8897/spns"
#define kSOAppNo            @"22"

#define kSOMessageId        @"messageId"        /*메시지 고유번호*/
#define kSOType             @"type"             /*메시지유형 0:단순 TEXT, 1: WEB URL*/

#define kSOAlert            @"alert"            /*메시지*/
#define kSOCustomData       @"customData"       /*커스텀 데이터*/
#define kSOSound            @"sound"            /*알림소리*/
#define kSOBadge            @"badge"            /*알림 뱃지*/
#define kSOTableKey         @"tablekey"         /*테이블 키*/
#define kSODetail           @"detail"           /*메시지 상세*/

#define kSOMenuId           @"MENU_ID"          /*메뉴이동ID*/
#define kSOWebUrl           @"WEB_URL"          /*웹 URL*//
#define kSOImgUrl           @"IMG_URL"          /*팝업 이미지 URL*/
#define kSOMessageSeq       @"MSG_SEQ"          /*메시지 고유번호 messageId*/
#define kSOContent          @"CNTS"             /*내용 alert*/
#define kSOTitle            @"TITLE"            /*제목*/
#define kSOMessageType      @"MSG_TYPE"         /*메시지유형 type*/

#define kSOMemberNo         @"memberNo"         
#define kSOPushToken        @"pushToken"
#define kSOAppVer           @"applicationVer"
#define kSOOsVer            @"osVer"
#define kSOUUID             @"uuid"


typedef NS_ENUM(NSInteger, SOInterfaceId) {
    SOInterfaceIdDefault,
    SOInterfaceIdRegisterPushService,
    SOInterfaceIdAllowNotification,
    SOInterfaceIdReceiveNotification,
    SOInterfaceIdOpenNotification,
    SOInterfaceIdRegisterEvent
};

@protocol SafeOnPushClientDelegate;

@interface SafeOnPushClient : NSObject

@property (nonatomic, assign) id /*<SafeOnPushClientDelegate>*/ delegate;
@property (nonatomic, retain) NSString *serverUrl;
@property (nonatomic, retain) NSString *appNo;
@property (nonatomic, retain) NSString *memberNo;
@property (nonatomic, assign) SOInterfaceId interfaceId;
@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, assign)BOOL hiddenActivityView;


+ (SafeOnPushClient *)sharedInstance;


- (void)setDeviceToken:(NSData *)deviceToken;
- (NSString *)deviceToken;
- (void)setBundleIdentifier:(NSString *)bundleIdentifier;

//push notification
- (void)registerPushServiceWithMemberNo:(NSString *)memberNo uuid:(NSString *)uuid delegate:(id)delegate;
- (void)allowNotifications:(BOOL)allow notifiStatus:(NSInteger)status delegate:(id)delegate;
- (void)allowNotifications:(BOOL)allow notiType:(NSString *)type delegate:(id)delegate;
- (void)receiveNotification:(NSDictionary *)notification delegate:(id)delegate;
- (void)openNotification:(NSString *)messageId delegate:(id)delegate;
- (void)registerEventWithMessageId:(NSString *)messageId eventStatus:(NSString *)eventStatus delegate:(id)delegate;
- (NSDictionary *)notificationForKey:(NSString *)messageId;

//local notification
- (void)regLocalNotificationForKey:(NSString *)key alertBody:(NSString *)alertBody fireDate:(NSDate *)date secondsBefore:(double)seconds weekDay:(NSInteger )weekDay;
- (NSMutableArray *)localNotificationsForKey:(NSString *)key;
- (NSString *)localNotificationDescForKey:(NSString *)key;
- (void)cancelLocalNotificationForKey:(NSString *)key;
- (void)cancelAllLocalNotifications;
- (void)validateLocalNotiContainKey:(NSString *)key;
@end

@protocol SafeOnPushClientDelegate <NSObject>
@optional
- (void)pushClient:(SafeOnPushClient *)pushClient didFinishWithResult:(NSDictionary *)result;
- (void)pushClient:(SafeOnPushClient *)pushClient didFailWithError:(NSError *)error;
@end
