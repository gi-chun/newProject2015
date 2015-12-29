//
//  WebView.h
//
//  Created by gclee on 2015. 10. 27..
//  Copyright (c) gclee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewDelegate;

@interface WebView : UIView

@property (nonatomic, weak) id<WebViewDelegate> delegate;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *zoomInButton;
@property (nonatomic, strong) UIButton *zoomOutButton;
@property (nonatomic, strong) UIButton *zoomViewerButton;
@property (nonatomic) BOOL isProductDidLoad;
@property (nonatomic) BOOL isExistsSubWebView;
@property (nonatomic) BOOL isScrolling;
@property (nonatomic) NSInteger maxSubWebViewIndx;
@property (nonatomic) NSInteger currentSubWebViewIndx;
@property (nonatomic, strong) NSMutableArray *subWebViewArray;

- (id)initWithFrame:(CGRect)frame isSub:(BOOL)isSub;
- (void)destroyWebView;
- (void)didReceiveMemoryWarning;

- (void)redrawADImage;
- (void)updateFrame;
- (void)updateFrameSunny:(NSInteger)gnbType; //0: sunny 3: bank
- (void)updateFrameSunnyForStatusHide;
- (void)setForwardButton:(BOOL)enable;
- (void)open:(NSString *)url;
- (NSString *)execute:(NSString *)script;
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadMutableRequest:(NSMutableURLRequest *)request;
- (void)setZoomBtnVisible:(NSInteger)isShow; //0: hide, 1: show

//- (BOOL)toggleButtonHiddenStatus;
- (void)setHiddenToolBarView:(BOOL)isHidden;
- (void)setHiddenpreButton:(BOOL)isHidden;

- (NSString *)url;
- (void)reload;
- (void)stop;
- (void)goTopWithAnimated:(BOOL)animated;
- (void)myGoBack;
- (void)stackAllDel;
- (void)goFoward;
- (NSInteger)isGoBack;

//scheme controls
- (void)actionTop;
- (void)actionBackWord;
- (void)actionForward;
- (void)actionReload;

//ProductOption
- (void)makeProductOption;
- (void)closeProductOption;
- (void)destoryProductOption;

- (void)setViewId:(NSInteger)viewId;

- (void)setHiddenPopover:(BOOL)hidden;

- (void)reCreateToolbar;
- (void)setUrl:(NSString *)url;

@end

@protocol WebViewDelegate <NSObject>
@optional

//WebView
- (BOOL)webView:(WebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request;
- (BOOL)webView:(WebView *)webView shouldStartLoadForProduct:(NSURLRequest *)request;
- (void)webViewDidFinishLoad:(WebView *)aWebView;
- (void)webView:(WebView *)webView didFailLoadWithError:(NSError *)error;
- (BOOL)webView:(WebView *)webView openUrlScheme:(NSString *)urlScheme;
- (void)webViewGoBack;

//Button in WebView
- (void)didTouchZoomViewerButton;

//ToolBar
- (void)didTouchToolBarButton:(UIButton *)button;

//PopOverView
- (void)didTouchPopOverButton:(UIButton *)button buttonInfo:(NSDictionary *)buttonInfo;

//SnapshotPopOverView
- (void)didTouchSnapshotPopOverButton:(UIButton *)button buttonInfo:(NSDictionary *)buttonInfo;

//Navigation Bar
- (void)initNavigation:(NSInteger)navigationType;

- (void)gotoPrev:(NSString*)callUrl;

@end