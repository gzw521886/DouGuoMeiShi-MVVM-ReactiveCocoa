//
//  WeekHomeModel.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/27.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 首页头部分类
 */

@interface WeekHomeTopClassifyModel : NSObject
@property (nonatomic , copy) NSString              * i;
@property (nonatomic , copy) NSString              * u;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * t;
@end



/**
 *   首页头部banner——用户
 */
@interface WHomebannerUser :NSObject

/**
 用户ID
 */
@property (nonatomic , copy) NSString              * id;
/**
 用户昵称
 */
@property (nonatomic , copy) NSString              * n;
/**
 用户头像
 */
@property (nonatomic , copy) NSString              * p;
@property (nonatomic , assign) NSInteger              v;
@property (nonatomic , assign) NSInteger              lv;

@end


/**
 *   首页头部banner--内容
 */
@interface WHomebannerContent :NSObject
@property (nonatomic , copy) NSString              * d;
/**
 类型
 */
@property (nonatomic , copy) NSString              * id;
/**
 banner图片地址
 */
@property (nonatomic , copy) NSString              * i;
@property (nonatomic , assign) NSInteger              ch;
/**
 banner跳转地址
 */
@property (nonatomic , copy) NSString              * url;
/**
 banner标题
 */
@property (nonatomic , copy) NSString              * t;
@end


/**
 *   首页头部banner
 */
@interface WHomebanner :NSObject
/**
 banner分类 0：含用户消息   1：不含用户消息
 */
@property (nonatomic , assign) NSInteger             h;
/**
 banner用户模型
 */
@property (nonatomic , strong) WHomebannerUser     * u;
/**
 banner内容模型
 */
@property (nonatomic , strong) WHomebannerContent  * d;

@end




/**
 *  首页三餐推荐模型
 */
@interface WHomemeals :NSObject
@property (nonatomic , strong) NSArray<NSString *>              * tian;

/**
 标题
 */
@property (nonatomic , copy) NSString              * t;
/**
 人数记录
 */
@property (nonatomic , copy) NSString              * c;
/**
 右侧两张小图片地址
 */
@property (nonatomic , strong) NSArray<NSString *>              * is;
/**
 跳转地址
 */
@property (nonatomic , copy) NSString              * u;
/**
 背景图片
 */
@property (nonatomic , copy) NSString              * i;
/**
 活动ID
 */
@property (nonatomic , copy) NSString              * huodong_id;
/**
 三餐标记 0  1  2
 */
@property (nonatomic , assign) NSInteger              s;

@end



/**
 *  TA_Cell模型  type=8
 */
@interface WHomeTaCellModel :NSObject
@property (nonatomic , assign) NSInteger             vc;
@property (nonatomic , copy) NSString              * id;    //ID
@property (nonatomic , copy) NSString              * i;     //图片地址
@property (nonatomic , copy) NSString              * u;     //跳转地址
@property (nonatomic , copy) NSString              * c;     //描述
@property (nonatomic , copy) NSString              * t;     //标题
@end


/**
 *  M_Cell模型   type=3
 */
@interface WHomeMCellModel :NSObject
@property (nonatomic , assign) NSInteger             id;
@property (nonatomic , copy) NSString              * b;    //图片地址
@property (nonatomic , copy) NSString              * c;    //菜品数量
@property (nonatomic , strong) WHomebannerUser     * a;
@property (nonatomic , copy) NSString              * t;    //图片标题

@end




/**
 *  ADV_Cell(广告)模型  type=100
 */
@interface WHomeADVCellModel :NSObject
@property (nonatomic , copy) NSString              * url;       //跳转的web地址
@property (nonatomic , copy) NSString              * t;         //广告标题
@property (nonatomic , copy) NSString              * id;        //id
@property (nonatomic , copy) NSString              * d;         //广告描述
@property (nonatomic , copy) NSString              * query;
@property (nonatomic , copy) NSString              * i;         //广告图片地址
@property (nonatomic , assign) NSInteger             req_min_i;
@property (nonatomic , assign) NSInteger             ch;
@property (nonatomic , copy) NSString              * cap;       //广告标注
@property (nonatomic , copy) NSString              * pid;
@property (nonatomic,copy)    NSString             * client_ip; //IP

@end



/**
 *  R_Cell模型    type=2
 */
@interface WHomeRCellModel :NSObject
@property (nonatomic , copy) NSString              * p;                 //cell图片地址大
@property (nonatomic , copy) NSString              * an;                //作者昵称
@property (nonatomic , assign) NSInteger              sti;
@property (nonatomic , copy) NSString              * img;               //cell图片地址小
@property (nonatomic , copy) NSString              * cook_difficulty;
@property (nonatomic , assign) NSInteger              fc;               //关注数
@property (nonatomic , assign) NSInteger              ecs;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * cook_time;
@property (nonatomic , assign) NSInteger              dc;
@property (nonatomic , assign) NSInteger              hq;
@property (nonatomic , copy) NSString              * n;                 //标题
@property (nonatomic , copy) NSString              * cookstory;         //简介内容
@property (nonatomic , assign) NSInteger              stc;
@property (nonatomic , strong) WHomebannerUser     * a;
@property (nonatomic , assign) NSInteger              vc;               //浏览人数

@end



/**
 *  首页Cell模型
 */
@interface WHomeCellModel :NSObject
@property (nonatomic , copy) NSString               * id;
@property (nonatomic , strong) WHomeTaCellModel     * ta;
@property (nonatomic , strong) WHomeMCellModel      * m;
@property (nonatomic , strong) WHomeADVCellModel    * dsp;
@property (nonatomic , strong) WHomeRCellModel      * r;
@property (nonatomic , copy) NSString               * type;  //类型
@property (nonatomic , copy) NSString               * tc;
@property (nonatomic , assign) NSInteger              h;
//@property (nonatomic , assign) CGFloat               cellH;

@end











