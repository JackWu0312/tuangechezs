#import "TalkingDataAppAnalyticsPlugin.h"
#import "TalkingData.h"

@implementation TalkingDataAppAnalyticsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"TalkingData_AppAnalytics"
            binaryMessenger:[registrar messenger]];
    TalkingDataAppAnalyticsPlugin* instance = [[TalkingDataAppAnalyticsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


+(void)pluginSessionStart:(NSString*)session withChannelId:(NSString*)channelID
{
    [TalkingData sessionStarted:session withChannelId:channelID];
}


-(id)checkArgument:(NSDictionary*)argument forKey:(NSString*)key ofType:(Class)clazz
{
    if (key == nil || argument == nil || clazz == nil  ) {
        return nil;
    }
    id arg = [argument objectForKey:key];
    if (arg == nil) {
        return nil;
    }
    if (![arg isKindOfClass:clazz]) {
        return nil;
    }
    return arg;
}


-(TDAccountType)accountTypeConvert:(NSString*)accTypeStr
{
    if ([accTypeStr isEqualToString:@"ANONYMOUS"]) {
        return TDAccountTypeAnonymous;
    }else if ([accTypeStr isEqualToString:@"REGISTERED"]){
        return TDAccountTypeRegistered;
    }else if ([accTypeStr isEqualToString:@"SINA_WEIBO"]){
        return TDAccountTypeSinaWeibo;
    }else if ([accTypeStr isEqualToString:@"QQ"]){
        return TDAccountTypeQQ;
    }else if ([accTypeStr isEqualToString:@"QQ_WEIBO"]){
        return TDAccountTypeTencentWeibo;
    }else if ([accTypeStr isEqualToString:@"ND91"]){
        return TDAccountTypeND91;
    }else if ([accTypeStr isEqualToString:@"WEIXIN"]){
        return TDAccountTypeWeiXin;
    }else if ([accTypeStr isEqualToString:@"TYPE1"]){
        return TDAccountTypeType1;
    }else if ([accTypeStr isEqualToString:@"TYPE2"]){
        return TDAccountTypeType2;
    }else if ([accTypeStr isEqualToString:@"TYPE3"]){
        return TDAccountTypeType3;
    }else if ([accTypeStr isEqualToString:@"TYPE4"]){
        return TDAccountTypeType4;
    }else if ([accTypeStr isEqualToString:@"TYPE5"]){
        return TDAccountTypeType5;
    }else if ([accTypeStr isEqualToString:@"TYPE6"]){
        return TDAccountTypeType6;
    }else if ([accTypeStr isEqualToString:@"TYPE7"]){
        return TDAccountTypeType7;
    }else if ([accTypeStr isEqualToString:@"TYPE8"]){
        return TDAccountTypeType8;
    }else if ([accTypeStr isEqualToString:@"TYPE9"]){
        return TDAccountTypeType9;
    }else if ([accTypeStr isEqualToString:@"TYPE10"]){
        return TDAccountTypeType10;
    }
    return TDAccountTypeAnonymous;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"onPageStart" isEqualToString:call.method]){
        NSString * pageName = [self checkArgument:call.arguments forKey:@"pageName" ofType:[NSString class]];
        if (pageName) {
            [TalkingData trackPageBegin:pageName];
        }
    } else if ([@"onPageEnd" isEqualToString:call.method]){
        NSString * pageName = [self checkArgument:call.arguments forKey:@"pageName" ofType:[NSString class]];
        if (pageName) {
            [TalkingData trackPageEnd:pageName];
        }
    } else  if ([@"onRegister" isEqualToString:call.method]){
        NSString * accountID = [self checkArgument:call.arguments forKey:@"accountID" ofType:[NSString class]];
        NSString * accountType = [self checkArgument:call.arguments forKey:@"accountType" ofType:[NSString class]];
        NSString * name = [self checkArgument:call.arguments forKey:@"name" ofType:[NSString class]];
        if (accountID && accountType && name) {
            TDAccountType acctype = [self accountTypeConvert:accountType];
            [TalkingData onRegister:accountID type:acctype name:name];
        }
    } else if ([@"onLogin" isEqualToString:call.method]){
        NSString * accountID = [self checkArgument:call.arguments forKey:@"accountID" ofType:[NSString class]];
        NSString * accountType = [self checkArgument:call.arguments forKey:@"accountType" ofType:[NSString class]];
        NSString * name = [self checkArgument:call.arguments forKey:@"name" ofType:[NSString class]];
        if (accountID && accountType && name) {
            TDAccountType acctype = [self accountTypeConvert:accountType];
            [TalkingData onLogin:accountID type:acctype name:name];
        }
    } else if ([@"onEvent" isEqualToString:call.method]){
        NSString * eventID = [self checkArgument:call.arguments forKey:@"eventID" ofType:[NSString class]];
        NSString * eventLabel = [self checkArgument:call.arguments forKey:@"eventLabel" ofType:[NSString class]];
        NSDictionary * params = [self checkArgument:call.arguments forKey:@"params" ofType:[NSDictionary class]];
        if (eventID) {
            [TalkingData trackEvent:eventID label:eventLabel parameters:params];
        }
    } else if ([@"onViewItem" isEqualToString:call.method]){
        NSString* category = [self checkArgument:call.arguments forKey:@"category" ofType:[NSString class]];
        NSString* itemID = [self checkArgument:call.arguments forKey:@"itemID" ofType:[NSString class]];
        NSString* name = [self checkArgument:call.arguments forKey:@"name" ofType:[NSString class]];
        NSNumber* unitPrice = [self checkArgument:call.arguments forKey:@"unitPrice" ofType:[NSNumber class]];
        [TalkingData onViewItem:itemID category:category name:name unitPrice:unitPrice.intValue];
        
    } else if ([@"onAddItemToShoppingCart" isEqualToString:call.method]){
        NSNumber * amount = [self checkArgument:call.arguments forKey:@"amount" ofType:[NSNumber class]];
        NSString * category = [self checkArgument:call.arguments forKey:@"category" ofType:[NSString class]];
        NSString * itemID = [self checkArgument:call.arguments forKey:@"itemID" ofType:[NSString class]];
        NSString * name = [self checkArgument:call.arguments forKey:@"name" ofType:[NSString class]];
        NSNumber * uniprice = [self checkArgument:call.arguments forKey:@"unitPrice" ofType:[NSNumber class]];
        [TalkingData onAddItemToShoppingCart:itemID category:category name:name unitPrice:uniprice.intValue amount:amount.intValue];
    } else if ([@"onViewShoppingCart" isEqualToString:call.method]){
        NSArray * shoppingCartDetails = [self checkArgument:call.arguments forKey:@"shoppingCartDetails" ofType:[NSArray class]];
        TalkingDataShoppingCart * sc = [TalkingDataShoppingCart createShoppingCart];
        for (NSDictionary* each in shoppingCartDetails) {
            NSNumber * amount = [self checkArgument:each forKey:@"amount" ofType:[NSNumber class]];
            NSString * category = [self checkArgument:each forKey:@"category" ofType:[NSString class]];
            NSString * itemID = [self checkArgument:each forKey:@"itemID" ofType:[NSString class]];
            NSString * name = [self checkArgument:each forKey:@"name" ofType:[NSString class]];
            NSNumber * uniprice = [self checkArgument:each forKey:@"unitPrice" ofType:[NSNumber class]];
            [sc addItem:itemID category:category name:name unitPrice:uniprice.intValue amount:amount.intValue];
        }
        [TalkingData onViewShoppingCart:sc];
    } else if ([@"onPlaceOrder" isEqualToString:call.method]){
        NSString * accountID = [self checkArgument:call.arguments forKey:@"accountID" ofType:[NSString class]];
        NSString * currencyType = [self checkArgument:call.arguments forKey:@"currencyType" ofType:[NSString class]];
        NSArray * orderDetails = [self checkArgument:call.arguments forKey:@"orderDetails" ofType:[NSArray class]];
        NSString * orderID = [self checkArgument:call.arguments forKey:@"orderID" ofType:[NSString class]];
        NSNumber * totalPrice = [self checkArgument:call.arguments forKey:@"totalPrice" ofType:[NSNumber class]];
        
        TalkingDataOrder * order = [TalkingDataOrder createOrder:orderID total:totalPrice.intValue currencyType:currencyType];
        
        for (NSDictionary * each in orderDetails) {
            NSNumber * amount = [self checkArgument:each forKey:@"amount" ofType:[NSNumber class]];
            NSString * category = [self checkArgument:each forKey:@"category" ofType:[NSString class]];
            NSString * itemID = [self checkArgument:each forKey:@"itemID" ofType:[NSString class]];
            NSString * name = [self checkArgument:each forKey:@"name" ofType:[NSString class]];
            NSNumber * uniprice = [self checkArgument:each forKey:@"unitPrice" ofType:[NSNumber class]];
            [order addItem:itemID category:category name:name unitPrice:uniprice.intValue amount:amount.intValue];
        }
        [TalkingData onPlaceOrder:accountID order:order];
        
    } else if ([@"onOrderPaySucc" isEqualToString:call.method]){
        NSString * accountID = [self checkArgument:call.arguments forKey:@"accountID" ofType:[NSString class]];
        NSString * currencyType = [self checkArgument:call.arguments forKey:@"currencyType" ofType:[NSString class]];
        NSArray * orderDetails = [self checkArgument:call.arguments forKey:@"orderDetails" ofType:[NSArray class]];
        NSString * orderID = [self checkArgument:call.arguments forKey:@"orderID" ofType:[NSString class]];
        NSString * payType = [self checkArgument:call.arguments forKey:@"payType" ofType:[NSString class]];
        NSNumber * totalPrice = [self checkArgument:call.arguments forKey:@"totalPrice" ofType:[NSNumber class]];
        
        TalkingDataOrder * order = [TalkingDataOrder createOrder:orderID total:totalPrice.intValue currencyType:currencyType];
        
        for (NSDictionary * each in orderDetails) {
            NSNumber * amount = [self checkArgument:each forKey:@"amount" ofType:[NSNumber class]];
            NSString * category = [self checkArgument:each forKey:@"category" ofType:[NSString class]];
            NSString * itemID = [self checkArgument:each forKey:@"itemID" ofType:[NSString class]];
            NSString * name = [self checkArgument:each forKey:@"name" ofType:[NSString class]];
            NSNumber * uniprice = [self checkArgument:each forKey:@"unitPrice" ofType:[NSNumber class]];
            [order addItem:itemID category:category name:name unitPrice:uniprice.intValue amount:amount.intValue];
        }
        [TalkingData onOrderPaySucc:accountID payType:payType order:order];
    }else if ([@"setGlobalKV" isEqualToString:call.method]) {
        NSString * key = [self checkArgument:call.arguments forKey:@"key" ofType:[NSString class]];
        id value = call.arguments[@"value"];
        if (value) {
            [TalkingData setGlobalKV:key value:value];
        }
    }else if ([@"removeGlobalKV" isEqualToString:call.method]){
        NSString * key = [self checkArgument:call.arguments forKey:@"key" ofType:[NSString class]];
        [TalkingData removeGlobalKV:key];
    }else if ([@"getDeviceID" isEqualToString:call.method]){
        NSString * deviceid = [TalkingData getDeviceID];
        result(deviceid);
    } else {
        result(FlutterMethodNotImplemented);
    }
}


@end
