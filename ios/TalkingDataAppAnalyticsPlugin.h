#import <Flutter/Flutter.h>

@interface TalkingDataAppAnalyticsPlugin : NSObject<FlutterPlugin>

/// SDK初始化
/// @param appKey 应用的唯一标识，统计后台注册得到
/// @param channelID 渠道名，如“app store”（可选）
+(void)pluginSessionStart:(NSString*)appKey withChannelId:(NSString*)channelID;

@end
