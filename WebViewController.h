//
//  WebViewController.h
//
//  Created by gclee on 2015. 10. 28..
//  Copyright (c) 2015년 gclee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebView;

typedef enum {
    CPWebviewControllerFullScreenModeNone,
    CPWebviewControllerFullScreenModeOn,
    CPWebviewControllerFullScreenModeOff
} CPWebviewControllerFullScreenMode;

@protocol WebViewControllerDelegate;

@interface WebViewController : UIViewController

@property (nonatomic, strong) WebView *webView;
@property (nonatomic, weak) id <WebViewControllerDelegate> delegate;

- (id)initWithUrl:(NSString *)url;
- (id)initWithUrl:(NSString *)url isPop:(BOOL)isPop;
- (id)initWithUrl:(NSString *)url isPop:(BOOL)isPop isIgnore:(BOOL)ignore;
- (id)initWithUrl:(NSString *)url isPop:(BOOL)isPop isIgnore:(BOOL)ignore isProduct:(BOOL)product;
- (id)initWithRequest:(NSURLRequest *)request;
- (void)setUrl:(NSString *)url;
- (void)resetADImage;
- (void)webViewReload;
- (void)gotoPushUrl:(NSString *)url;
- (void)setViewAlpha:(NSInteger)alphaValue;


@end

@protocol WebViewControllerDelegate <NSObject>
@optional
- (void)didTouchMenuItem:(NSInteger)menuType;
- (void)didTouchCloseBtn;
- (void)didTouchLogOutBtn;
- (void)didTouchLogInBtn;
- (void)didTouchSummitBtn;
- (void)didTouchAD;
- (void)didTouchBackButton;
- (void)didTouchGoSunny;
- (void)didTouchNewButton;
- (void)didTouchHelpButton;
- (void)didTouchLetterBtn;
//ToolBar
- (void)didTouchToolBarButton:(UIButton *)button;
@end

