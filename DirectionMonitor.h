


/**
    监听设备方向变化
*/


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DeviceDirection) {
    DirectionUnkown,
    DirectionPortrait, //home键在下
    DirectionDown,     //home键在上
    DirectionRight,    //home键在左
    Directionleft,     //home键在右
};

@protocol DirectionMonitorDelegate <NSObject>

/**
    方向改变,回调
*/
- (void)deviceDirectionDidChanged:(DeviceDirection)direction;

@end
@interface DirectionMonitor : NSObject

@property(nonatomic,strong)id<DirectionMonitorDelegate>delegate;


+ (instancetype)sharedInstance;

/**
 开启监听
 */
- (void)startMonitorWithDelegate:(id<DirectionMonitorDelegate>)delegate;

/**
 结束监听
 */
-(void)stopMonitor;

@end
