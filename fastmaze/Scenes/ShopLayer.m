//
//  ShopLayer.m
//  fastmaze
//
//  Created by Eric on 13-2-27.
//
//

#import "ShopLayer.h"
#import "MenuLayer.h"
#import "DialogUtil.h"

#define IAP_REMOVE_AD @"fastmaze.removead"

enum{
    tRemoveAd=100,
};
enum  {
    tBought = 200,
    tRestore ,
    };

@implementation ShopLayer {
}


+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    ShopLayer *layer = [ShopLayer node];
    [scene addChild: layer];
    return scene;
}
-(id)init{
    if(self=[super init]){
        if (IS_IPHONE_5) {
            [self setBg:@"bg-568h@2x.jpg"];
        }else{
            [self setBg:@"bg.png"];
        }

        CCSprite* removeAdIcon=[CCSprite spriteWithFile:@"removead_icon.png"];
        removeAdIcon.position=ccp(250,400);
        [self addChild:removeAdIcon];
        
        CCLabelTTF *removeAdTitle = [CCLabelTTF labelWithString: @"Remove Ad"
                                                     dimensions: CGSizeMake(900, 200)
                                                     hAlignment: UITextAlignmentCenter
                                                       fontName:@"Arial" fontSize:40];
        removeAdTitle.position=CGPointMake(550,450);
        removeAdTitle.color=ccBLACK;
        [self addChild:removeAdTitle];
        
        CCLabelTTF *removeAdLable = [CCLabelTTF labelWithString: @"Remove All Banner Ad Permanently"
                                                     dimensions: CGSizeMake(900, 200)
                                                     hAlignment: UITextAlignmentCenter
                                                       fontName:@"Arial" fontSize:28];
        removeAdLable.position=CGPointMake(580,400);
        removeAdLable.color=ccBLACK;
        [self addChild:removeAdLable];
        
        BOOL showAd=[[NSUserDefaults standardUserDefaults]boolForKey:UFK_SHOW_AD];
        CCNode* removeAdButton=nil;
        if (showAd) {
            removeAdButton= [SpriteUtil createMenuWithImg:@"removead_bt.png" pressedColor:ccYELLOW target:self selector:@selector(showShopAlert)];
        }else{
           removeAdButton= [CCSprite spriteWithFile:@"removed_bt.png"];
        }
        [self addChild:removeAdButton z:1 tag:tRemoveAd];
        removeAdButton.position=ccp(550,400);
        
        CCMenu* menuBack= [SpriteUtil createMenuWithImg:@"button_previous.png" pressedColor:ccYELLOW target:self selector:@selector(goBack:)];
        [self addChild:menuBack];
        menuBack.position=ccp(150,winSize.height-100);
        //----observer transaction
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
-(void) goBack: (id) sender
{
	[AudioUtil displayAudioButtonClick];
	[[CCDirector sharedDirector] replaceScene:  [CCTransitionSplitRows transitionWithDuration:1.0f scene:[MenuLayer scene]]];
}

-(void)showShopAlert{
    UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:nil message:@"$0.99 can remove all Ad.\n If you have bought on other devices, click 'I've Bought'"  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy It Now",@"I've Bought", nil]autorelease];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            CCLOG(@"---cancel");
            break;
        case 1:
            [self removeAd:tBought];
            break;
        case 2:
            [self removeAd:tRestore];
            break;
    }
}



-(void)removeAd:(int)type{
    iapId=IAP_REMOVE_AD;
    if ([SKPaymentQueue canMakePayments]) {
        switch (type) {
            case tBought:
                [self RequestProductData];
                break;
            case tRestore:
                [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
                break;
        }
        [MobClick event:@"removead"];
        [[DialogUtil share]showLoading:[[CCDirector sharedDirector]view]];
        NSLog(@"---allow In-App Purchase");
    }
    else
    {
        NSLog(@"--not allow In-App Purchas");
        UIAlertView *alerView =  [[[UIAlertView alloc] initWithTitle:nil message:@"Your device doesn't allow  In-App Purchase" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
        [alerView show];
        
    }
}
#pragma mark request product
-(void)RequestProductData
{
    CCLOG(@"---------RequestProductData");
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject:iapId]];
    request.delegate=self;
    [request start];
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------productsRequest:didReceiveResponse");
    NSArray *myProduct = response.products;
    NSLog(@"Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"Product count: %d", [myProduct count]);
    // populate UI
    SKProduct* productToBuy=nil;
    for(SKProduct *product in myProduct){
        NSLog(@"---product info-------");
        NSLog(@"SKProduct description%@", [product description]);
        NSLog(@"title %@" , product.localizedTitle);
        NSLog(@"localizedDescription: %@" , product.localizedDescription);
        NSLog(@"price: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        if ([product.productIdentifier isEqualToString:iapId]) {
            productToBuy=product;
        }
    }
    SKPayment *payment = [SKPayment paymentWithProduct:productToBuy];
     CCLOG(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}
- (void)requestProUpgradeProductData
{
    CCLOG(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    CCLOG(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil]autorelease];
    [alerView show];
    [self doRemoveAd:NO];
}

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------反馈信息结束--------------");
    
}
-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    CCLOG(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
    [transactions release];
}
#pragma mark observer transaction
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    CCLOG(@"-----paymentQueue:updatedTransactions---transactions:%@",transactions);
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                [self completeTransaction:transaction];
                CCLOG(@"Purchase Success --------");
               
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                CCLOG(@"Purchase Failed --------");
               break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                CCLOG(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                CCLOG(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    CCLOG(@"completeTransaction--------");
    UIAlertView *alerView =  [[[UIAlertView alloc] initWithTitle:nil
                                                         message:@"Purchase Succesfully"
                                                        delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil]autorelease];
    
    [alerView show];
    [self doRemoveAd:YES];
    [self recordTransaction:transaction];
     [self provideContent:transaction.payment.productIdentifier];

    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"failedTransaction------!!! error.code:%d",transaction.error.code);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alerView2 =  [[[UIAlertView alloc] initWithTitle:nil
                                                              message:@"Purchase Failed"
                                                             delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil]autorelease];
        
        [alerView2 show];
    }
    [self doRemoveAd:NO];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
//移除广告
-(void)doRemoveAd:(BOOL)success{
    CCLOG(@"doRemoveAd-------");
    if (success) {
#ifndef  DEBUG
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UFK_SHOW_AD];
        [[[CCDirector sharedDirector].view viewWithTag:kTAG_Ad_VIEW]removeFromSuperview];
        CCNode* removeAdButton=[self getChildByTag:tRemoveAd];
        CCSprite* removed= [CCSprite spriteWithFile:@"removed_bt.png"];
        removed.position=removeAdButton.position;
        [self addChild:removed];
        [removeAdButton removeFromParentAndCleanup:YES];
#endif
        
    }
    [[DialogUtil share]unshowLoading];
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-------restoreTransaction");
    UIAlertView *alerView =  [[[UIAlertView alloc] initWithTitle:nil
                                                         message:@"Restore Succesfully"
                                                        delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil]autorelease];
    
    [alerView show];
    [self doRemoveAd:YES];
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
-(void)recordTransaction:(SKPaymentTransaction *)product{
    CCLOG(@"recordTransaction-----product:%@",product);
}

-(void)provideContent:(NSString *)product{
    CCLOG(@"provideContent--------product:%@",product);
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}



-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    CCLOG(@"-------restoreCompletedTransactionsFailedWithError----error:%d",error.code);
    if (error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alerView2 =  [[[UIAlertView alloc] initWithTitle:nil
                                                              message:@"Restore Failed"
                                                             delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil]autorelease];
        
        [alerView2 show];
    }
    [self doRemoveAd:NO];
}

#pragma mark connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
       
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}    
-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    [super dealloc];
}
@end
