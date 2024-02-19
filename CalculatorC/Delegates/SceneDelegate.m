#import "SceneDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = [[UIWindowScene alloc] initWithSession:session connectionOptions:connectionOptions];
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];

    window.rootViewController = ViewController.new;

    [window makeKeyAndVisible];

    self.window = window;
}

@end
