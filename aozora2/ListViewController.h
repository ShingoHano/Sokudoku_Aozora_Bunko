//
//  ListViewController.h
//  aozora2
//
//  Created by 羽野 真悟 on 13/04/30.
//  Copyright (c) 2013年 羽野 真悟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController<UIWebViewDelegate>
{
    UIWebView *wv;              //HTMLパース用ウェブビュー

    NSMutableArray *tempArray;  //作品リストを受け取る
    NSMutableArray *linkArray;  //作品ページURLを受け取る
    NSMutableArray *xmlArray;   //書籍のURLを格納する
    NSMutableArray *wikiArray;
    
    NSInteger index;            //クリックされたセルのインデックス
    NSString *html;             //htmlパース用変数
    NSString *regURL;           //書籍ページのURL
    NSURL *url;                 //URL
    NSURLRequest *req;          //リクエスト
    UIBarButtonItem *btn;
    
//    UIButton *addButton;
//    NSInteger downlodFlag;
//    UIWebView *wv;
//    NSURL *authorURL;
    
}

-(void)tableData:(NSArray*)array et:(NSArray*)array2;   //他クラスで利用するためヘッダー宣言
-(void)wikiData:(NSArray*)array;

@end
