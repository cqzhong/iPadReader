//
//  AppDelegate.m
//  iPadReader
//
//  Created by cqz on 2019/3/13.
//  Copyright © 2019 ChangDao. All rights reserved.
//

#import "AppDelegate.h"

#import "BaseNavigationController.h"
#import "CDBookcaseViewController.h"
#import "QMUIConfigurationTemplate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ///避免多个按钮同时点击
    [[UIButton appearance] setExclusiveTouch:true];
    ///设置缓存
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [self configurationQMUITemplate];

    
    self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[CDBookcaseViewController new]];
    [self.window makeKeyAndVisible];
    return true;
}

//MARK: configurationQMUITemplate
- (void)configurationQMUITemplate {
    
    [QDThemeManager sharedInstance].currentTheme = [QMUIConfigurationTemplate new];
    //    [QMUIHelper renderStatusBarStyleDark];
    /*
     //    [QDThemeManager sharedInstance].currentTheme.themeTintColor;
     //    可以设置多张配置表，这里只写一个。
     //    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromClass(self.themes[themeIndex].class) forKey:QDSelectedThemeClassName];
     */
}



@end
