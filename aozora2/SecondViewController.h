//
//  SecondViewController.h
//  aozora2
//
//  Created by 羽野 真悟 on 13/04/29.
//  Copyright (c) 2013年 羽野 真悟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UITableViewController<UIWebViewDelegate>
{
    UIWebView *wv;  //HTMLを取得するウェブビュー
    
    NSMutableArray *authorArray;        //作者名を格納する配列
    NSMutableArray *linkArray;          //作者のリンクを格納する配列
    NSMutableArray *sakuhinArray;       //作品名を格納する配列
    NSMutableArray *sakuhinLinkArray;   //作品のリンクを格納する配列
    NSMutableArray *authorWikiArray;
    
    NSString *html;                     //HTMLを格納
    NSURL *url;                         //ウェブビューのリクエストURL
    NSURLRequest *req;                  //ウェブビューのリクエスト
    
    NSInteger section0;                 //配列中の”カ”のインデックス
    NSInteger section1;                 //配列中の"サ"のインデックス
    NSInteger section2;                 //配列中の"タ"のインデックス
    NSInteger section3;                 //配列中の"ナ"のインデックス
    NSInteger section4;                 //配列中の"ハ"のインデックス
    NSInteger section5;                 //配列中の"マ"のインデックス
    NSInteger section6;                 //配列中の"ヤ"のインデックス
    NSInteger section7;                 //配列中の"ラ"のインデックス
    NSInteger section8;                 //配列中の"ワ"のインデックス
    NSInteger section9;                 //配列中の"その他"のインデックス
    
    NSInteger sectionFlag0;             //ア行の表示/非表示判定フラグ
    NSInteger sectionFlag1;             //カ行の表示/非表示判定フラグ
    NSInteger sectionFlag2;             //サ行の表示/非表示判定フラグ
    NSInteger sectionFlag3;             //タ行の表示/非表示判定フラグ
    NSInteger sectionFlag4;             //ナ行の表示/非表示判定フラグ
    NSInteger sectionFlag5;             //ハ行の表示/非表示判定フラグ
    NSInteger sectionFlag6;             //マ行の表示/非表示判定フラグ
    NSInteger sectionFlag7;             //ヤ行の表示/非表示判定フラグ
    NSInteger sectionFlag8;             //ラ行の表示/非表示判定フラグ
    NSInteger sectionFlag9;             //ワ行の表示/非表示判定フラグ
}

@end
