//
//  WKConfig.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/18.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#ifndef WKConfig_h
#define WKConfig_h

#define WK_LJZ(object,assignment) (object = object ?: assignment)


#define SetColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define SetAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define WKSetFont(fontName,font)  [UIFont fontWithName:(fontName) size:(font)]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MainScreenRect       [UIScreen mainScreen].bounds

#define WK_APPDelegate  ((AppDelegate*)[UIApplication sharedApplication].delegate)


//(*_*)\\

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


//FontSize\\

#define WKFONTSMALL   [UIFont systemFontOfSize:13]
#define WKFONTMID     [UIFont systemFontOfSize:14]
#define WKFONTBOLDMID [UIFont boldSystemFontOfSize:14]
#define WKFONTBIG     [UIFont systemFontOfSize:16]
#define WKFONTBIGBIG  [UIFont systemFontOfSize:18]
#define WKFONTBOLDBIGBIG  [UIFont boldSystemFontOfSize:20]
#endif
