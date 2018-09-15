//
//  YXYCollectionViewFlowLayout.h
//  HJTest
//
//  Created by yxy on 2018/9/14.
//  Copyright © 2018年 Test. All rights reserved.
//
/**
 注意，此layout暂时只能设置一个区section，如果大于1个section将会崩溃
 
 **/
#import <UIKit/UIKit.h>

@class YXYCollectionViewFlowLayout;

@protocol YXYCollectionViewFlowLayoutDelegate

@optional

-(CGFloat)waterFlowLayout:(YXYCollectionViewFlowLayout*)layout heightForRowAtIndex:(NSInteger)item itemWidth:(CGFloat)width;

@end


@interface YXYCollectionViewFlowLayout : UICollectionViewFlowLayout

@property(nonatomic,assign)CGFloat columCount;///< 列数
@property(nonatomic,assign)CGFloat columMargin;///<列之间的间隔
@property(nonatomic,assign)CGFloat rowMargin;///<行之间的间隔
@property(nonatomic,assign)UIEdgeInsets defaultEdgeInsets;///<edge
/**
 如果isAlignment = yes ；当列数columCount大于1时，设置每列第一个Cell高度值不同，呈现高度层次感；
 第一个cell高度值将50 + i * 10递增设置，也可以自己去更改；
 第二个cell的高度将按照-(CGFloat)waterFlowLayout:...这个代理返回的值设定。
 注意：当columCount=1时，设置此值无效；
 */
@property(nonatomic,assign)BOOL isNoAlignment;

@property(nonatomic,weak) id<YXYCollectionViewFlowLayoutDelegate> delegate;


@end
