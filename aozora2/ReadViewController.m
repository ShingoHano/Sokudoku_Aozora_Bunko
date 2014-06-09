//
//  ReadViewController.m
//  aozora2
//
//  Created by 羽野 真悟 on 13/05/02.
//  Copyright (c) 2013年 羽野 真悟. All rights reserved.
//

#import "ReadViewController.h"
#import "TSMessage.h"

@interface ReadViewController ()

@end

@implementation ReadViewController

/*******************************************************************
 関数名　　initWithStyle
 概要    UITableViewのスタイル設定処理
 引数	(UITableViewStyle)style         :テーブルスタイル
 戻り値	(id)                            :スタイル
 *******************************************************************/
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*******************************************************************
 関数名　　viewDidLoad
 概要		viewが呼び出された時の初期処理　各種変数の初期化など
 引数		なし
 戻り値	なし
 *******************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wall2.png"]];
    self.tableView.backgroundView=imageView;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithImage:[UIImage imageNamed:@"view_fit_window3.png"] style:UIBarButtonItemStylePlain target:self action:@selector(webChange)];
/*                            initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                            target:self action:@selector(webChange)];
    [btn setImage:[UIImage imageNamed:@"Icon"]];*/
    
    self.navigationItem.rightBarButtonItem = btn;
}

/*******************************************************************
 関数名　　webChange
 概要	 webViewの表示形式変更
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)webChange
{
    if(!web)
    {
        web=[[UIWebView alloc]init];
    }
    
    if([web scalesPageToFit])
    {
        web.scalesPageToFit=false;
    }
    else
    {
        web.scalesPageToFit=true;
    }
    [web reload];
}

/*******************************************************************
 関数名　 webRead
 概要	書籍URLの表示
 引数	:(NSString*)url 書籍URL
 戻り値	なし
 *******************************************************************/
- (void)webRead:(NSString*)url
{
    //書籍表示用Webviewの生成
    if(!web)
    {
        web=[[UIWebView alloc]init];
    }
    web.delegate=self;
//    [web sizeToFit];
    /*
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wall2.png"]];
    self.tableView.backgroundView=imageView;*/
    
    
    
    
    web.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall2.png"]];
    [web setOpaque:NO];

    
    //URLの生成とリクエスト処理
    NSURL *sakuhinUrl=[NSURL URLWithString:url];
    NSURLRequest *req = [NSURLRequest requestWithURL:sakuhinUrl];
    [web loadRequest:req];
    
//    NSLog(@"%@",url);
    
    if([url rangeOfString:@"files"].location==NSNotFound)
    {
        web.scalesPageToFit = YES;
    }
    else
    {    web.scalesPageToFit = NO;
    }
    
    [self.view addSubview:web];
    
    
    //画面サイズの取得
    int screenW = [[UIScreen mainScreen] applicationFrame].size.width;
    int screenH = [[UIScreen mainScreen] applicationFrame].size.height;

    //iPadの場合
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        web.frame=CGRectMake(0, 0,screenW, screenH);
    }
    //iPhoneの場合
    else
    {
        //iPhone5
        if(screenH==548)
        {
            web.frame=CGRectMake(0, 0,320,508);
        }
        //それ以外
        else
        {
            web.frame=CGRectMake(0, 0,320,420);
        }
    }
}

/*******************************************************************
 関数名　 willAnimateRotationToInterfaceOrientation
 概要	画面回転時の処理
 引数	:(UIInterfaceOrientation)interfaceOrientation   :方向
        :(NSTimeInterval)duration                       :間隔
 戻り値	なし
 *******************************************************************/
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    //iPad以外
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        int screenH = [[UIScreen mainScreen] applicationFrame].size.height;
        //iPhone5
        if(screenH==548)
        {
            if(interfaceOrientation == UIInterfaceOrientationPortrait){
                web.frame=CGRectMake(0, 0, 320, 508);
            }
            else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
                web.frame=CGRectMake(0, 0, 320, 508);
            }
            else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                web.frame=CGRectMake(0, 0, 568, 280);
            }
            else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
                web.frame=CGRectMake(0, 0, 568, 280);
            }
        }
        //iPhone4
        else
        {
            if(interfaceOrientation == UIInterfaceOrientationPortrait){
                web.frame=CGRectMake(0, 0, 320, 440);
            }
            else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
                web.frame=CGRectMake(0, 0, 320, 440);
            }
            else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                web.frame=CGRectMake(0, 0, 480, 280);
            }
            else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
                web.frame=CGRectMake(0, 0, 480, 280);
            }
        }
    }
}

/*******************************************************************
 関数名　 shouldAutorotateToInterfaceOrientation
 概要	画面回転の可否
 引数	:(UIInterfaceOrientation)interfaceOrientation   :方向
 戻り値	(BOOL) 画面回転の可否
 *******************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Table view data source

/*******************************************************************
 関数名　　tableView cellForRowAtIndexPath
 概要	 テーブルビューのセルの表示を行う
 引数　　　:(UITableView *)tableView　テーブルビュー
 :(NSIndexPath *)indexPath　インデックスパス
 戻り値   (UITableViewCell *)テーブルビューのセル
 *******************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

/*******************************************************************
 関数名　　tableView didSelectRowAtIndexPath
 概要	 テーブルビューのセルが選択された際の処理
 引数　　　:(UITableView *)tableView　テーブルビュー
 :(NSIndexPath *)indexPath　インデックスパス
 戻り値   なし
 *******************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - WebView delegate

/*******************************************************************
 関数名　　webViewDidStartLoad
 概要	 ウェブビューのロード開始時の処理
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/*******************************************************************
 関数名　　webViewDidFinishLoad
 概要	 ウェブビューのロード終了時の処理
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/*******************************************************************
 関数名  webViewdidFailLoadWithError
 概要	webViewのHTML取得失敗時に呼ばれる
 引数	(UIWebView*)webView  - webView
 戻り値	なし
 *******************************************************************/
- (void)webView:(UIWebView*)webView
didFailLoadWithError:(NSError*)error {
    //インジケーターの非表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSInteger err_code = [error code];
    if (err_code == NSURLErrorCancelled) { // 読み込みストップの場合は何もしない
        return;
    }
    
    //通信エラーのアラートを表示
    [TSMessage showNotificationInViewController:self withTitle:@"通信エラー" withMessage:@"インターネットの接続を確認できません。本アプリの利用にはインターネットの接続が必要です。" withType:TSMessageNotificationTypeWarning withDuration:15];
    
    /*
     UIAlertView *alert =
     [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通信エラー",nil) message:NSLocalizedString(@"インターネットの接続を確認できません。本アプリの利用にはインターネットの利用が必要です。",nil)
     delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil];
     [alert show];*/
}

/*******************************************************************
 関数名　　didReceiveMemoryWarning
 概要	 メモリ警告時の処理
 引数　　　なし
 戻り値   なし
 *******************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
