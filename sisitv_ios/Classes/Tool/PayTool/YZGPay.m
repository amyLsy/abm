//
//  YZGPay.m
//  sisitv
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGPay.h"
#import "HttpTool.h"
#import "CostModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+Base64.h"
#import "Account.h"
#import <StoreKit/StoreKit.h>
#import "YZGAppSetting.h"
#import "YZGShareUtilits.h"
NSString *const kBuyProductEnd = @"payForProductEnded";

@interface YZGPay ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic , copy) NSString *needBuyProductId;
@property (nonatomic , strong) SKProduct *needBuyProduct;
@end

@implementation YZGPay

+(instancetype)shareInstance{
    static YZGPay *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YZGPay alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:instance];
    });
    return instance;
}

-(void)payWithPlatForm:(PayPlatForm)platForm withParam:(PayParam *)param{
    
    switch (platForm) {
        case WeChatPayPlat:
        {
            [self requestWithUrlFlag:HttpRequsetUrlFlagBegin_wxpay param:param success:^(BOOL successGetInfo, id responseObject) {
                //调起微信支付
                if (successGetInfo) {
                    [self doWxPayRequestWithDictionary:responseObject[@"request"]];
                }else{
                    [self buyProductErrorWithResultString:responseObject];
                }
            }];
        }
            break;
        case AliPayPlat:
        {
            [self requestWithUrlFlag:HttpRequsetUrlFlagBegin_alipay param:param success:^(BOOL successGetInfo, id responseObject) {
                if (successGetInfo) {
                    //调起支付宝支付
                    [self doAlipayPayWithJsonString:responseObject[@"request"]];
                }else{
                    [self buyProductErrorWithResultString:responseObject];
                }
            }];
        }
            break;
        case ApplePayPlat:
        {
            //调起Apple
            [self sendIAPRequestWithProductId:param.item_id];
        }
            break;
    }
}


//调起微信支付和微信支付完成回调
-(void)doWxPayRequestWithDictionary:(NSDictionary *)result{
     /** appid */
    NSString *appid = result[@"appid"];
    /** 商家向财付通申请的商家id */
    NSString *partnerId = result[@"partnerid"];
    /** 预支付订单 */
    NSString *prepayId = result[@"prepayid"];
    /** 随机串，防重发 */
    NSString *nonceStr = result[@"noncestr"];
    /** 时间戳，防重发 */
    NSString *timeStamp = result[@"timestamp"];
    /** 商家根据财付通文档填写的数据和签名 */
    NSString *package = result[@"package"];
    //把=转化为%3D
    package = [package stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    /** 商家根据微信开放平台文档对数据做的签名 */
    NSString *sign  = result[@"sign"];
    //生成URLscheme
    NSString *str = [NSString stringWithFormat:@"weixin://app/%@/pay/?nonceStr=%@&package=%@&partnerId=%@&prepayId=%@&timeStamp=%@&sign=%@&signType=SHA1",appid,nonceStr,package,partnerId,prepayId,[NSString stringWithFormat:@"%d",[timeStamp intValue] ],sign];
    
    if (kYZGiOS10OrLater) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:nil];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
#pragma clang diagnostic pop
    }
}

//选中商品调用支付宝极简支付(及网页版的回调)
- (void)doAlipayPayWithJsonString:(NSString *)result
{
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:result fromScheme:@"longchengLivePay" callback:^(NSDictionary *resultDic) {
        if([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
            [self buyProductSuccessWithResultString:@"支付成功"];
        }else{
            [self buyProductErrorWithResultString:@"支付失败"];
        }
    }];
}

//微信支付处理和支付宝支付回调
-(BOOL)handleOpenURL:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
                [self buyProductSuccessWithResultString:@"支付成功"];
            }else{
                [self buyProductErrorWithResultString:@"支付失败"];
            }
        }];
        return YES;
    }else if([url.scheme isEqualToString:YZGShareWeChatAppId]){
        NSString *urlString = [url absoluteString];
        if ([urlString containsString:@"pay"]) {
            NSArray *array = [urlString componentsSeparatedByString:@"?"];
            NSString *resultCode = [array lastObject];
            array = [resultCode componentsSeparatedByString:@"&"];
            NSString *ret = [array lastObject];
//            NSString *returnKey = [array firstObject];
//            id returnKeyVaule = [[returnKey componentsSeparatedByString:@"="] lastObject];
            int retCode = [[[ret componentsSeparatedByString:@"="] lastObject] intValue];
            if (retCode == 0) {
                [self buyProductSuccessWithResultString:@"支付成功"];
            }else{
                [self buyProductErrorWithResultString:@"支付失败"];
            }
        }
        return YES;
    }else{
        return NO;
    }
}

-(void)sendIAPRequestWithProductId:(NSString *)productId{
    if ([SKPaymentQueue canMakePayments])//是否允许应用内付费
    {
        NSInteger ids = productId.integerValue;//3271763843@qq.com 235689qQ
        if (ids==61)
            productId=productId_6;
        else if (ids==62)
            productId=productId_30;
        else if (ids==63)
            productId=productId_98;
        else if (ids==64)
            productId=productId_298;
        else if (ids==65)
            productId=productId_588;
        else if (ids==66)
            productId=productId_1598;
//        else if (ids==67)
//            productId=productId_1998;
//        else if (ids==68)
//            productId=productId_2298;
//        else if (ids==69)
//            productId=productId_2998;
        
        self.needBuyProductId = productId;
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
        request.delegate = self;
        [request start];
    }else{
        [self buyProductErrorWithResultString:@"您已经禁止应用内付费,请在设置中打开"];
    }
}
// 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
//    NSLog(@"-----------收到产品反馈信息--------------");
//    NSArray *myProduct = response.products;
//    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
//    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
//    
//    // populate UI
//    for(SKProduct *product in myProduct){
//        NSLog(@"product info");
//        NSLog(@"SKProduct 描述信息%@", [product description]);
//        NSLog(@"产品标题 %@" , product.localizedTitle);
//        NSLog(@"产品描述信息: %@" , product.localizedDescription);
//        NSLog(@"价格: %@" , product.price);
//        NSLog(@"Product id: %@" , product.productIdentifier);
//    }
    
    //这里菊花消失
    NSArray *products = response.products;
    if (products.count != 0) {
        for (SKProduct *product in products) {
            if ([product.productIdentifier isEqualToString:self.needBuyProductId]) {
                self.needBuyProduct = product;
                break;
            }
        }
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:self.needBuyProduct];
        //lzc 改 payment.applicationUsername = @(1000000).stringValue;//充值用户的id,也就是uid.
        [[SKPaymentQueue defaultQueue] addPayment:payment];//发起购买
     }else{
         [self buyProductErrorWithResultString:@"无法获取商品"];
    }
}

//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self buyProductErrorWithResultString:[error localizedDescription]];
    YZGLog(@"请求苹果服务器失败%@",[error localizedDescription]);
}

//监听购买结果,每个状态下都要结束订单,否则就坑爹了
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {//当用户购买的操作有结果时，就会触发下面的回调函数，
    //菊花消失
    YZGLog(@"来监听购买结果吧");
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased://交易成功
                
                [self checkIapBuyWithTransaction:transaction];//验证
                //如果用户在这中间退出,咋办??会自动把transaction存到[SKPaymentQueue defaultQueue]中,下次启动app,会来到这里验证,坑坑坑都是坑
                YZGLog(@"结束订单了");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];//验证成功与否,咱们都注销交易,否则会出现虚假凭证信息一直验证不通过..每次进程序都得输入苹果账号的情况
                break;
                
            case SKPaymentTransactionStateFailed:
                YZGLog(@"交易失败:=%@",transaction.error.localizedDescription);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self buyProductErrorWithResultString:transaction.error.localizedDescription];
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];//消耗型不支持恢复
                break;
            case SKPaymentTransactionStatePurchasing:
                YZGLog(@"已经在商品列表中");//菊花
                break;
            case SKPaymentTransactionStateDeferred:
                YZGLog(@"最终状态未确定 ");
                break;
            default:
                break;
        }
    }
}

////交易结束
//- (void)completeTransaction:(SKPaymentTransaction *)transaction{
//    NSLog(@"交易结束");
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//}

-(void)checkIapBuyWithTransaction:(SKPaymentTransaction *)trans{
    PayParam *param = [self congifParamForReceipt];
    [self requestWithUrlFlag:HttpRequsetUrlFlagBegin_applepay param:param success:^(BOOL successGetInfo, id responseObject) {
//        NSLog(@"456===%@",responseObject);
        if (successGetInfo) {
            [self buyProductSuccessWithResultString:responseObject[@"descrp"]];
        }else{
            [self buyProductErrorWithResultString:responseObject];
        }
    }];
}

-(void)requestWithUrlFlag:(HttpRequsetUrlFlag)flag param:(PayParam *)param success:(void(^)(BOOL successGetInfo, id responseObject))success{
    [HttpTool requestWithUrlFlag:flag param:param.mj_keyValues success:^(id responseObject) {
//        NSLog(@"123===%@",responseObject);
        if ([responseObject[@"code"] isEqual:@200]){
            success(YES,responseObject);
        }else{
            success(NO,responseObject[@"descrp"]);
        }
    } faile:nil];
}
-(void)buyProductErrorWithResultString:(NSString *)resultString{
//    NSLog(@"1===%@",resultString);
    [self buyProductEndedWithResult:@{@"status":@"0",@"descrp":resultString}];
}
-(void)buyProductSuccessWithResultString:(NSString *)resultString{
//    NSLog(@"2===%@",resultString);
    [self buyProductEndedWithResult:@{@"status":@"1",@"descrp":resultString}];
}
-(void)buyProductEndedWithResult:(NSDictionary *)result{
//    NSLog(@"3===%@",result);
    [[NSNotificationCenter defaultCenter] postNotificationName:kBuyProductEnd object:nil userInfo:result];
}

-(PayParam *)congifParamForReceipt{
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *transactionReceipt=[NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptBase64 = [NSString base64StringFromData:transactionReceipt length:[transactionReceipt length]];
    PayParam *param = [[PayParam alloc]init];
    param.token = [Account shareInstance].token;
    param.receipt = receiptBase64;
    return param;
}


@end
