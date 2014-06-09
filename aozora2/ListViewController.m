//
//  ListViewController.m
//  aozora2
//
//  Created by 羽野 真悟 on 13/04/30.
//  Copyright (c) 2013年 羽野 真悟. All rights reserved.
//

#import "ListViewController.h"
#import "HTMLParser.h"
#import "ReadViewController.h"
#import "TSMessage.h"

@interface ListViewController ()

@end

@implementation ListViewController

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
    
    //配列初期化
    [self initArray];
    
    //変数の初期化
    index=0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wall2.png"]];
    self.tableView.backgroundView=imageView;
    
    
    btn= [[UIBarButtonItem alloc]
          initWithTitle:@"wiki" style:UIBarButtonItemStyleBordered target:self action:@selector(wikiShow)];
    
    self.navigationItem.rightBarButtonItem = btn;
}

/*******************************************************************
 関数名　　initArray
 概要	 各種配列の初期化処理
 引数     なし
 戻り値    なし
 *******************************************************************/
- (void)initArray
{
    if(!tempArray)
    tempArray=[[NSMutableArray alloc]initWithObjects:nil];
    if(!linkArray)
    linkArray=[[NSMutableArray alloc]initWithObjects:nil];
    if(!xmlArray)
    xmlArray =[[NSMutableArray alloc]initWithObjects:nil];
}

/*******************************************************************
 関数名　　tableData
 概要	 作品リストと作品URLリストの受け取り
 引数     :(NSArray*)array  　作品リスト
         :(NSArray*)array2　　作品URLリスト
 戻り値    なし
 *******************************************************************/
-(void)tableData:(NSArray*)array et:(NSArray*)array2
{
    //繰り返し利用するために初期化処理
    tempArray=[[NSMutableArray alloc]initWithObjects:nil];
    linkArray=[[NSMutableArray alloc]initWithObjects:nil];
    
    for(int i=0;i<array.count;i++)
    {
        [tempArray addObject:[array objectAtIndex:i]];
        [linkArray addObject:[array2 objectAtIndex:i]];
    }
    
    [self.tableView reloadData];    
}

-(void)wikiData:(NSArray*)array
{
    wikiArray=[[NSMutableArray alloc]initWithObjects:nil];
    
    for(int i=0l;i<array.count;i++)
    {
        [wikiArray addObject:[array objectAtIndex:i]];
    }
    
    if([[wikiArray objectAtIndex:0]isEqualToString:@"temp"])
    {
        btn.enabled=false;
    }
    else
    {
        btn.enabled=true;
    }
}

/*******************************************************************
 関数名　　download
 概要	 作品リストと作品URLリストの受け取り
 引数     :(NSArray*)array  　作品リスト
 :(NSArray*)array2　　作品URLリスト
 戻り値    なし
 *******************************************************************/
- (void)download
{
    //webViewのインスタンス生成
    if(!wv)
    {
        wv=[[UIWebView alloc]init];
    }
    wv.frame=CGRectMake(0, 0, 320, 320);
    wv.delegate = self;
    wv.tag=0;
    
    //URLを整形してリクエストする
    NSString *baseURL=@"http://www.aozora.gr.jp/index_pages/";
    NSString *catURL=[baseURL stringByAppendingString:[linkArray objectAtIndex:index]];
    url = [NSURL URLWithString:catURL];
    req = [NSURLRequest requestWithURL:url];
    [wv loadRequest:req];
    
    //書籍ページのURL取得に利用
    regURL=[catURL stringByAppendingString:@"/."];
}


-(void)wikiShow
{
    ReadViewController *readview = [[ReadViewController alloc]
                                    initWithNibName:@"ReadViewController"
                                    bundle:[NSBundle mainBundle]];
    readview.title=self.title;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 14.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.99];
    label.textAlignment =NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [@"Wikipedia - " stringByAppendingString:self.title];
    
    readview.navigationItem.titleView=label;

    
    [self.navigationController pushViewController:readview animated:YES];
    
    [readview webRead:[wikiArray objectAtIndex:0]];
    
}


#pragma mark - Table view data source

/*******************************************************************
 関数名　　numberOfSectionsInTableView
 概要	 テーブルビューのセクション数を返す
 引数　　　:(UITableView *)tableView　テーブルビュー
 戻り値   (NSInteger) :　セクション数
 *******************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*******************************************************************
 関数名　　tableView numberOfRowsInSection
 概要	 テーブルビューのセクションのセル数を返す
 引数　　　:(UITableView *)tableView　テーブルビュー
 :(NSInteger)section　セクション番号
 戻り値   (NSInteger) セクションのセル数
 *******************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tempArray.count;
}

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
    //作品名の表示
    cell.textLabel.text=[tempArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
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
    //クリックされた列を格納
    index=indexPath.row;

    //HTMLパース処理
    [self download];
    
    return;
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

    //作品ページのHTMLをパースする
    if(webView.tag==0)
    {
        ReadViewController *readview = [[ReadViewController alloc]
                                        initWithNibName:@"ReadViewController"
                                        bundle:[NSBundle mainBundle]];
        readview.title=[tempArray objectAtIndex:index];
        
        html = [wv stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSError *error = nil;
        
        //繰り返し利用するためnil初期化
        xmlArray=[[NSMutableArray alloc]initWithObjects:nil];
    
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
        if (error) {
        NSLog(@"Error: %@", error);
        return;
        }
    
        HTMLNode *bodyNode = [parser body];
        NSArray *spanNodes = [bodyNode findChildTags:@"a"];
    
        int count=0;
        int fileCount=0;
    
        //a要素でパース
        for (HTMLNode *spanNode in spanNodes)
        {
            //ファイルのダウンロード文字列までの数をカウントする
            count++;
            if([[spanNode contents] isEqualToString:@"ファイルのダウンロード"])
            {
                fileCount++;
                if(fileCount>=2)
                {
                    break;
                }
            }
        }
        
        NSArray *inputNodes = [bodyNode findChildTags:@"a"];
        int j=0;
        NSString *element=nil;
        
        //a要素でパース
        for (HTMLNode *inputNode in inputNodes)
        {        
            j++;
            if(j>count)
            {
//                NSLog(@"%@",[inputNode getAttributeNamed:@"href"]);
                element=[inputNode getAttributeNamed:@"href"];
                //hrefがhttp://から始まっている場合は外部サーバーなのでそのまま格納する
                if([element hasPrefix:@"http://"])
                {
                    if([element rangeOfString:@"zip"].location == NSNotFound)
                    {
                        [xmlArray addObject:element];
                        [readview webRead:[xmlArray objectAtIndex:0]];
                    }
//                    NSLog(@"%@",[inputNode getAttributeNamed:@"href"]);
                }
                //hrefにhtmlを含んでいる場合
                else if([element rangeOfString:@"html"].location != NSNotFound)
                {
                    //hrefにfilesを含まない場合はそのまま格納する
                    if([element rangeOfString:@"files"].location == NSNotFound)
                    {
                        [xmlArray addObject:element];
                        [readview webRead:[xmlArray objectAtIndex:0]];
                    }
                    //hrefにfilesが含まれている場合は相対パスのため、ベースURLと連結して格納する
                    else
                    {
                        [xmlArray addObject:[regURL stringByAppendingString:element]];
                        [readview webRead:[xmlArray objectAtIndex:0]];
                    }
                    break;
                }
            }
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.font = [UIFont boldSystemFontOfSize: 14.0f];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.99];
        label.textAlignment =NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = readview.title;
        
        readview.navigationItem.titleView=label;
        
        [self.navigationController pushViewController:readview animated:YES];
        //書籍URLデータを引数にする
    }
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
    //    [activityIndicator stopAnimating];
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
