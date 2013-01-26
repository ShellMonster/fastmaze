//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/21/12
//

#import "GameScene.h"
#import "MazeGenerator.h"
#import "GameLayer.h"
#import "GuiLayer.h"

@implementation GameScene
- (id)init
{
    self = [super init];
    GameLayer* gameLayer=[[[GameLayer alloc] init] autorelease];
    [self addChild:gameLayer];
    [self addChild:[[[GuiLayer alloc] initWithGameLayer:gameLayer] autorelease]];
    return self;
}
@end