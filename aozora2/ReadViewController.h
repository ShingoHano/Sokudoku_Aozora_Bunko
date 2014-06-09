//
//  ReadViewController.h
//  aozora2
//
//  Created by 羽野 真悟 on 13/05/02.
//  Copyright (c) 2013年 羽野 真悟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadViewController : UITableViewController<UIWebViewDelegate>
{
    UIWebView *web;                 //書籍表示用のWebView
}

- (void)webRead:(NSString*)url;     //他クラスで利用するため外部宣言

@end
