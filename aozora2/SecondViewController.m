//
//  SecondViewController.m
//  aozora2
//
//  Created by 羽野 真悟 on 13/04/29.
//  Copyright (c) 2013年 羽野 真悟. All rights reserved.
//

#import "SecondViewController.h"
#import "ListViewController.h"
#import "HTMLParser.h"
#import "ODRefreshControl.h"
#import "TSMessage.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

ListViewController *list;                       //作品名表示用のコントローラー

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
 関数名　　initWithNibName
 概要    UIViewControllerクラスの初期処理　他Viewからの画面遷移に必要
 引数	(NSString *)nibNameOrNil :xib
 (NSBundle *)nibBundleOrNil      :Bundle
 戻り値	(id)                     :xib
 *******************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"速読青空文庫", @"Master");
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

    //配列の初期化
    [self initArray];
    [self webRequest];
    
    //変数の初期化
    section0=0;
    section1=0;
    section2=0;
    section3=0;
    section4=0;
    section5=0;
    section6=0;
    section7=0;
    section8=0;
    section9=0;
    
    sectionFlag0=1;
    sectionFlag1=1;
    sectionFlag2=1;
    sectionFlag3=1;
    sectionFlag4=1;
    sectionFlag5=1;
    sectionFlag6=1;
    sectionFlag7=1;
    sectionFlag8=1;
    sectionFlag9=1;

    //テーブルビューのセルの高さ
    self.tableView.rowHeight=40;
    
    
        /*
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithImage:[UIImage imageNamed:@"gnome_view_refresh.png"] style:UIBarButtonItemStylePlain target:self action:@selector(reloadAlert)];

    self.navigationItem.rightBarButtonItem = btn;*/
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 14.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.99];
    label.textAlignment =NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [@"" stringByAppendingString:self.title];
    
    self.navigationItem.titleView=label;

    
    //スタイルの設定
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wall2.png"]];
    self.tableView.backgroundView=imageView;
    
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}


- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
        [self webRequest];
        [TSMessage showNotificationInViewController:self withTitle:@"更新成功" withMessage:@"データの再読み込みを完了しました。" withType:TSMessageNotificationTypeMessage];
    });
}



/*******************************************************************
 関数名　　webRequest
 概要	 作者名一覧のと作者ページリンクの取得処理
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)webRequest
{
    authorArray=[[NSMutableArray alloc]initWithObjects:nil];
    linkArray=[[NSMutableArray alloc]initWithObjects:nil];
    sakuhinArray=[[NSMutableArray alloc]initWithObjects:nil];
    sakuhinLinkArray=[[NSMutableArray alloc]initWithObjects:nil];

    //WebViewのインスタンス生成
    wv=[[UIWebView alloc]init];
    wv.delegate = self;
    wv.tag=0;
    
    //WebViewのリクエスト処理
    url = [NSURL URLWithString:@"http://www.aozora.gr.jp/index_pages/person_all.html"];
    req = [NSURLRequest requestWithURL:url];
    [wv loadRequest:req];
}


/*******************************************************************
 関数名　　reloadAlert
 概要	 更新確認アラート
 引数	なし
 戻り値	なし
 *******************************************************************/
- (void)reloadAlert
{
    //通信エラーのアラートを表示
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"作者名一覧",nil) message:NSLocalizedString(@"再読み込みを行いますか？",nil)
                              delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい",nil];
    [alert show];
}


/*******************************************************************
 関数名　　alertView clickedButtonAtIndex
 概要	 アラートボタンクリック時の処理
 引数	:(UIAlertView*)alertView　アラートビュー
 戻り値	なし
 *******************************************************************/
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            break;
        case 1:
            [self webRequest];
            break;
    }
}

/*******************************************************************
 関数名　　initArray
 概要	 各種配列の初期化処理
 引数     なし
 戻り値    なし
 *******************************************************************/
- (void)initArray
{
    if(!authorArray)
    authorArray=[[NSMutableArray alloc]init];
    if(!linkArray)
    linkArray=[[NSMutableArray alloc]init];
    if(!sakuhinArray)
    sakuhinArray=[[NSMutableArray alloc]init];
    if(!sakuhinLinkArray)
    sakuhinLinkArray=[[NSMutableArray alloc]init];    
}

- (NSArray *)sectionIndexTitlesForTableView:
(UITableView *)tableView
{
    NSArray *indexTitleArray;
    indexTitleArray = [NSArray
                       arrayWithObjects:@"あ", @"か", @"さ", @"た", @"な", @"は",@"ま", @"や", @"ら",@"わ",nil];
    return indexTitleArray;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    if([title isEqualToString:@"あ"])
    {
        index=0;
    }
    if([title isEqualToString:@"か"])
    {
        index=1;
    }
    if([title isEqualToString:@"さ"])
    {
        index=2;
    }
    if([title isEqualToString:@"た"])
    {
        index=3;
    }
    if([title isEqualToString:@"な"])
    {
        index=4;
    }
    if([title isEqualToString:@"は"])
    {
        index=5;
    }
    if([title isEqualToString:@"ま"])
    {
        index=6;
    }
    if([title isEqualToString:@"や"])
    {
        index=7;
    }
    if([title isEqualToString:@"ら"])
    {
        index=8;
    }
    if([title isEqualToString:@"わ"])
    {
        index=9;
    }

    
    return index;
}

/*******************************************************************
 関数名　　section0
 概要	 ア行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section0
{
    sectionFlag0=sectionFlag0?0:1;
    [self.tableView reloadData];
}

/*******************************************************************
 関数名　　section1
 概要	 カ行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section1
{
    sectionFlag1=sectionFlag1?0:1;
    [self.tableView reloadData];
}

/*******************************************************************
 関数名　　section2
 概要	 サ行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section2
{
    sectionFlag2=sectionFlag2?0:1;
    [self.tableView reloadData];
}

/*******************************************************************
 関数名　　section3
 概要	 タ行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section3
{
    sectionFlag3=sectionFlag3?0:1;
    [self.tableView reloadData];
}

/*******************************************************************
 関数名　　section4
 概要	 ナ行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section4
{
    sectionFlag4=sectionFlag4?0:1;
    [self.tableView reloadData];
}

/*******************************************************************
 関数名　　section5
 概要	 ハ行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section5
{
    sectionFlag5=sectionFlag5?0:1;
    [self.tableView reloadData];
}

/*******************************************************************
 関数名　　section6
 概要	 マ行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section6
{
    sectionFlag6=sectionFlag6?0:1;
    [self.tableView reloadData];
}

/*******************************************************************
 関数名　　section7
 概要	 ヤ行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section7
{
    sectionFlag7=sectionFlag7?0:1;
    [self.tableView reloadData];
}

/*******************************************************************
 関数名　　section8
 概要	 ラ行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section8
{
    sectionFlag8=sectionFlag8?0:1;
    [self.tableView reloadData];
}

/*******************************************************************
 関数名　　section9
 概要	 ワ行の表示/非表示
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)section9
{
    sectionFlag9=sectionFlag9?0:1;
    [self.tableView reloadData];
}

#pragma webviewDelegate

/*******************************************************************
 関数名　　webViewDidStartLoad
 概要	 ウェブビューのロード開始時の処理
 引数     なし
 戻り値    なし
 *******************************************************************/
-(void)webViewDidStartLoad:(UIWebView*)webView
{
    //インジケータ表示
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
    //インジケータ非表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //HTMLパースにより、作者名と作者ごとのURLを配列に格納する
    if(webView.tag==0)
    {
        NSError *error = nil;
        html = [wv stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
        
        int j=0;
        
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        HTMLNode *bodyNode = [parser body];
        NSArray *inputNodes = [bodyNode findChildTags:@"a"];
        
        //authorArrayとインデックスを対応させるため戦闘要素にtempを代入
        [linkArray addObject:@"temp"];
        
        //a要素をパース
        for (HTMLNode *inputNode in inputNodes)
        {
            //ページ上部のリンクは判定不要
            j++;
            if(j>18)
            {
                if([inputNode getAttributeNamed:@"href"] ==nil)
                {
                }
                //href要素が"#topの場合は作者ページへのリンクではないのでtempを格納する
                else if([[inputNode getAttributeNamed:@"href"] isEqualToString:@"#top"])
                {
                    [linkArray addObject:@"temp"];
                }
                //href要素がそれ以外の場合は作者ページへのリンクなのでlinkArrayに格納する
                else
                {
                    [linkArray addObject: [inputNode getAttributeNamed:@"href"]];
                }
            }
        }
        
        NSArray *spanNodes = [bodyNode findChildTags:@"a"];
        int i=0;
        
        //a要素をパース
        for (HTMLNode *spanNode in spanNodes)
        {
            i++;
            if(i>18)
            {
                //トップページへのリンク文字は格納しない
                if([[spanNode contents] isEqualToString:@"▲"])
                {
                }
                //行頭文字と作者名を格納する
                else
                {
                    [authorArray addObject:[spanNode contents]];
                        //                    NSLog(@"%@", [spanNode contents]); //Answer to second question
                }
            }
        }
        
//        NSString *compString;
        //配列の要素を最後尾から確認
        for(int i=authorArray.count-1;i>=0;i--)
        {
            //temp要素はそのまま
            if([[linkArray objectAtIndex:i]isEqualToString:@"temp"])
            {                
            }
            //temp以外
            else
            {
//                compString=[linkArray objectAtIndex:i];
                //URLに"sakuhin"が含まれていない場合は作者ページ以外へのリンクなので、リンクと対応する作者名を配列から削除する
                NSRange searchResult = [[linkArray objectAtIndex:i] rangeOfString:@"sakuhin"];                
                if(searchResult.location == NSNotFound)
                {
                    [authorArray removeObjectAtIndex:i];
                    [linkArray removeObjectAtIndex:i];
                }
            }
        }

        //作者名用配列内のカ、サ、タ、ナ、ハ、マ、ヤ、ラ、ワ、その他のインデックス番号を格納
        for(int i=0;i<authorArray.count;i++)
        {
            if([[authorArray objectAtIndex:i] isEqualToString:@"カ"])
            {
                section0=i;
            }
            else if([[authorArray objectAtIndex:i] isEqualToString:@"サ"])
            {
                section1=i;
            }
            else if([[authorArray objectAtIndex:i] isEqualToString:@"タ"])
            {
                section2=i;
            }
            else if([[authorArray objectAtIndex:i] isEqualToString:@"ナ"])
            {
                section3=i;
            }
            else if([[authorArray objectAtIndex:i] isEqualToString:@"ハ"])
            {
                section4=i;
            }
            else if([[authorArray objectAtIndex:i] isEqualToString:@"マ"])
            {
                section5=i;
            }
            else if([[authorArray objectAtIndex:i] isEqualToString:@"ヤ"])
            {
                section6=i;
            }
            else if([[authorArray objectAtIndex:i] isEqualToString:@"ラ"])
            {
                section7=i;
            }
            else if([[authorArray objectAtIndex:i] isEqualToString:@"ワ"])
            {
                section8=i;
            }
            else if([[authorArray objectAtIndex:i] isEqualToString:@"その他"])
            {
                section9=i;
            }
        }
        
        //テーブルデータの更新を行う
        [self.tableView reloadData];
    }
    
    //作品名と作品ごとのリンクを取得する
    if(webView.tag==1)
    {
        //繰り返し利用するためnil初期化
        sakuhinArray=[[NSMutableArray alloc]initWithObjects:nil];
        sakuhinLinkArray=[[NSMutableArray alloc]initWithObjects:nil];

        //HTMLパース
        html = [wv stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
     
        HTMLNode *bodyNode = [parser body];
        NSArray *spanNodes = [bodyNode findChildTags:@"a"];
     
        int i=0;
        int flag=0;
        int count=0;
        int wikiFlag=0;
        authorWikiArray=[[NSMutableArray alloc]initWithObjects:nil];
     
        //a要素をパース
        for (HTMLNode *spanNode in spanNodes)
        {
            i++;
            
            /*
            if(wikiFlag==1)
            {
                wikiFlag=0;
                NSLog(@"%@",[spanNode getAttributeNamed:@"href"]);
            }*/
            
            if([[spanNode getAttributeNamed:@"href"]hasPrefix:@"http://ja.wikipedia.org/"])
            {
                if(wikiFlag==0)
                {
                    wikiFlag=1;
                }
                else if(wikiFlag==1)
                {
                    [authorWikiArray addObject:[spanNode getAttributeNamed:@"href"]];
                    wikiFlag=0;
                }
            }
            
            if([[spanNode contents] isEqualToString:@"作業中の作品"])
            {
                flag=0;
            }
            //作業中の作品〜公開中の作品の間の要素を配列に格納
            if(flag==1)
            {
                count++;
                //作品のURLを格納
                [sakuhinLinkArray addObject:[spanNode getAttributeNamed:@"href"]];
                //作品のタイトルを格納
                [sakuhinArray addObject:[spanNode contents]];
//                         NSLog(@"%@",[spanNode contents]);
            }
            if([[spanNode contents] isEqualToString:@"公開中の作品"])
            {
                flag=1;
            }
        }
     
        //格納した要素を最後尾から確認
        for(int i=sakuhinArray.count-1;i>=0;i--)
        {
//            NSLog(@"%@=%@",[sakuhinArray objectAtIndex:i],[sakuhinLinkArray objectAtIndex:i]);
            //リンクに..がない場合は、作品ページへのリンクでないため、作品名と作品リンクを削除する
            if(![[sakuhinLinkArray objectAtIndex:i]hasPrefix:@".."])
            {
                [sakuhinArray removeObjectAtIndex:i];
                [sakuhinLinkArray removeObjectAtIndex:i];
            }
        }
        
        if(authorWikiArray.count==0)
        {
            [authorWikiArray addObject:@"temp"];
        }
        
        //デバッグ用
/*        for(int i=sakuhinArray.count-1;i>=0;i--)
        {
            NSLog(@"%@=%@",[sakuhinArray objectAtIndex:i],[sakuhinLinkArray objectAtIndex:i]);
        }*/

        //作品リスト表示用のビューコントローラーの生成
        /*if(!list)
        {
            list = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:[NSBundle mainBundle]];
        }*/
        //作品タイトルと作品リンクをlistの配列をコピーする
        [list tableData:sakuhinArray et:sakuhinLinkArray];
        [list wikiData:authorWikiArray];
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


#pragma mark - Table view data source

/*******************************************************************
 関数名　　numberOfSectionsInTableView
 概要	 テーブルビューのセクション数を返す
 引数　　　:(UITableView *)tableView　テーブルビュー
 戻り値   (NSInteger) :　セクション数
 *******************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 10;
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
    if(section==0)
    {
        return sectionFlag0?section0-1:0;
    }
    else if(section==1)
    {
        return sectionFlag1?section1-section0-1:0;
    }
    else if(section==2)
    {
        return sectionFlag2?section2-section1-1:0;
    }
    else if(section==3)
    {
        return sectionFlag3?section3-section2-1:0;
    }
    else if(section==4)
    {
        return sectionFlag4?section4-section3-1:0;
    }
    else if(section==5)
    {
        return sectionFlag5?section5-section4-1:0;
    }
    else if(section==6)
    {
        return sectionFlag6?section6-section5-1:0;
    }
    else if(section==7)
    {
        return sectionFlag7?section7-section6-1:0;
    }
    else if(section==8)
    {
        return sectionFlag8?section8-section7-1:0;
    }
    else if(section==9)
    {
        return sectionFlag9?section9-section8-1:0;
    }
    else
    {
        return 0;
    }
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
    wv=[[UIWebView alloc]init];
    wv.frame=CGRectMake(0, 0, 320, 320);
    wv.delegate = self;
    wv.tag=1;
    NSString *baseString=@"http://www.aozora.gr.jp/index_pages/";
    NSString *tempString=nil;
    
    if(!list)
        list = [[ListViewController alloc]
                initWithNibName:@"ListViewController"
                bundle:[NSBundle mainBundle]];
    
    NSArray *tempArray=[[NSArray alloc]initWithObjects:nil];
    [list tableData:tempArray et:tempArray];

    if(indexPath.section==0)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1];
    }
    else if(indexPath.section==1)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1+section0];
    }
    else if(indexPath.section==2)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1+section1];
    }
    else if(indexPath.section==3)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1+section2];
    }
    else if(indexPath.section==4)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1+section3];
    }
    else if(indexPath.section==5)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1+section4];
    }
    else if(indexPath.section==6)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1+section5];
    }
    else if(indexPath.section==7)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1+section6];
    }
    else if(indexPath.section==8)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1+section7];
    }
    else if(indexPath.section==9)
    {
        tempString=[linkArray objectAtIndex:indexPath.row+1+section8];
    }

    tempString=[baseString stringByAppendingString:tempString];
    
    url = [NSURL URLWithString:tempString];
    req = [NSURLRequest requestWithURL:url];
    [wv loadRequest:req];
    
    if(indexPath.section==0)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+1];
    }
    else if(indexPath.section==1)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+section0+1];
    }
    else if(indexPath.section==2)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+section1+1];
    }
    else if(indexPath.section==3)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+section2+1];
    }
    else if(indexPath.section==4)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+section3+1];
    }
    else if(indexPath.section==5)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+section4+1];
    }
    else if(indexPath.section==6)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+section5+1];
    }
    else if(indexPath.section==7)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+section6+1];
    }
    else if(indexPath.section==8)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+section7+1];
    }
    else if(indexPath.section==9)
    {
        list.title=[authorArray objectAtIndex:indexPath.row+section8+1];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 12.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.99];
    label.textAlignment =NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = list.title;
    
    list.navigationItem.titleView=label;


    [self.navigationController pushViewController:list animated:YES];
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
    
    cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    cell.accessoryType=UITableViewCellAccessoryNone;
//    cell.textLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"image3"]];
//    cell.textLabel.textColor=[UIColor whiteColor];
    
    if(indexPath.section==0)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+1]];
    }
    else if(indexPath.section==1)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+section0+1]];
    }
    else if(indexPath.section==2)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+section1+1]];
    }
    else if(indexPath.section==3)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+section2+1]];
    }
    else if(indexPath.section==4)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+section3+1]];
    }
    else if(indexPath.section==5)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+section4+1]];
    }
    else if(indexPath.section==6)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+section5+1]];
    }
    else if(indexPath.section==7)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+section6+1]];
    }
    else if(indexPath.section==8)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+section7+1]];
    }
    else if(indexPath.section==9)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[authorArray objectAtIndex:indexPath.row+section8+1]];
    }
    else
    {
        cell.textLabel.text=@"";
    }
    // Configure the cell...
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
            
        case 0: // 1個目のセクションの場合
            return @"ア行";
            break;
        case 1: // 2個目のセクションの場合
            return @"カ行";
            break;
        case 2: // 2個目のセクションの場合
            return @"サ行";
            break;
        case 3: // 2個目のセクションの場合
            return @"タ行";
            break;
        case 4: // 2個目のセクションの場合
            return @"ナ行";
            break;
        case 5: // 2個目のセクションの場合
            return @"ハ行";
            break;
        case 6: // 2個目のセクションの場合
            return @"マ行";
            break;
        case 7: // 2個目のセクションの場合
            return @"ヤ行";
            break;
        case 8: // 2個目のセクションの場合
            return @"ラ行";
            break;
        case 9: // 2個目のセクションの場合
            return @"ワ行";
            break;
            
    }
    return nil; //ビルド警告回避用
}

/*******************************************************************
 関数名　　tableView viewForHeaderInSection
 概要	 セクションヘッダー用のViewを返す
 引数　　　:(UITableView *)tableView　テーブルビュー
 :(NSInteger)section セクション番号
 戻り値   (UIView *)　セクションヘッダー用のView
 *******************************************************************/
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 2048, 40)];
//    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wall"] highlightedImage:nil];
//    image.frame=CGRectMake(10, 10, 20, 20);
    //      [btn setBackgroundImage:[UIImage imageNamed:@"wall"] forState:UIControlStateNormal];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2048, 40)];
//    lbl.textColor=[UIColor whiteColor];
//    lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"black_wall"]];
    lbl.textColor=[UIColor colorWithHue:0.1 saturation:0.26 brightness:0.15 alpha:0.87];
    lbl.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
//    [btn addSubview:image];
              
    //    lbl.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"wall"]];
    //        lbl.textColor = [UIColor whiteColor];
    
    if(section==0)
    {
        lbl.text = NSLocalizedString(@"  ■ あ",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section0) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section==1)
    {
        lbl.text = NSLocalizedString(@"  ■ か",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section1) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section==2)
    {
        lbl.text = NSLocalizedString(@"  ■ さ",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section2) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section==3)
    {
        lbl.text = NSLocalizedString(@"  ■ た",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section3) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section==4)
    {
        lbl.text = NSLocalizedString(@"  ■ な",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section4) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section==5)
    {
        lbl.text = NSLocalizedString(@"  ■ は",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section5) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section==6)
    {
        lbl.text = NSLocalizedString(@"  ■ ま",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section6) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section==7)
    {
        lbl.text = NSLocalizedString(@"  ■ や",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section7) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section==8)
    {
        lbl.text = NSLocalizedString(@"  ■ ら",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section8) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section==9)
    {
        lbl.text = NSLocalizedString(@"  ■ わ",nil);
        lbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
//        [btn addTarget:self action:@selector(section9) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [btn addSubview:lbl];
    [view addSubview:btn];
    
    return view;
}

/*******************************************************************
 関数名　　tableView heightForHeaderInSection
 概要	 テーブルビューのセクションヘッダーの高さを返す
 引数　　　:(UITableView *)tableView　テーブルビュー
         :(NSInteger)section セクション番号
 戻り値   CGFloat :　高さ
 *******************************************************************/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
