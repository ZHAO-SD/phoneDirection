





#import "DirectionMonitor.h"
#import <CoreMotion/CoreMotion.h>

@interface DirectionMonitor () {
    
    CMMotionManager *_motionManager;
    DeviceDirection _direction;
    
}
@end
//sensitive 灵敏度
static const float sensitive = 0.77;

@implementation DirectionMonitor

+ (instancetype)sharedInstance{
    // 保存在静态存储区
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)startMonitor {
    
    [self start];
}

- (void)stop {
    
    [_motionManager stopDeviceMotionUpdates];
    self.delegate = nil;
}


//陀螺仪 每隔一个间隔做轮询
- (void)start{
    
    if (_motionManager == nil) {
        
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/40.f;
    if (_motionManager.deviceMotionAvailable) {
        
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
            [self performSelectorOnMainThread:@selector(deviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }
}
- (void)deviceMotion:(CMDeviceMotion *)motion{
    
    double x = motion.gravity.x;
    double y = motion.gravity.y;
    if (y < 0 ) {
        if (fabs(y) > sensitive) {
            if (_direction != DirectionPortrait) {
                _direction = DirectionPortrait;
                if ([self.delegate respondsToSelector:@selector(deviceDirectionDidChanged:)]) {
                    [self.delegate deviceDirectionDidChanged:_direction];
                }
            }
        }
    }else {
        if (y > sensitive) {
            if (_direction != DirectionDown) {
                _direction = DirectionDown;
                if ([self.delegate respondsToSelector:@selector(deviceDirectionDidChanged:)]) {
                    [self.delegate deviceDirectionDidChanged:_direction];
                }
            }
        }
    }
    if (x < 0 ) {
        if (fabs(x) > sensitive) {
            if (_direction != Directionleft) {
                _direction = Directionleft;
                if ([self.delegate respondsToSelector:@selector(deviceDirectionDidChanged:)]) {
                    [self.delegate deviceDirectionDidChanged:_direction];
                }
            }
        }
    }else {
        if (x > sensitive) {
            if (_direction != DirectionRight) {
                _direction = DirectionRight;
                if ([self.delegate respondsToSelector:@selector(deviceDirectionDidChanged:)]) {
                    [self.delegate deviceDirectionDidChanged:_direction];
                }
            }
        }
    }
}

-(void)startMonitorWithDelegate:(id<DirectionMonitorDelegate>)delegate{
    DirectionMonitor *device = [DirectionMonitor sharedInstance];
    device.delegate = delegate;
    [device start];
}

-(void)stopMonitor{
    
    [[DirectionMonitor sharedInstance] stop];
}

@end
