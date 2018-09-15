//
//  YXYCollectionViewFlowLayout.m
//  HJTest
//
//  Created by yxy on 2018/9/14.
//  Copyright © 2018年 Test. All rights reserved.
//

#import "YXYCollectionViewFlowLayout.h"


@interface YXYCollectionViewFlowLayout()


/** 布局属性数组*/
@property (nonatomic,strong) NSMutableArray *attrsArray;

/** 存放所有列的当前高度*/
@property (nonatomic,strong) NSMutableArray *columnHeights;

@end

@implementation YXYCollectionViewFlowLayout

/**  初始化*/
- (void)prepareLayout
{
    [super prepareLayout];
    //处理默认值
    self.columCount = self.columCount == 0 ? 1 : self.columCount;
    self.columMargin = self.columMargin == 0 ? 10 : self.columMargin;
    self.rowMargin  = self.rowMargin == 0 ? 10 : self.rowMargin;
    self.defaultEdgeInsets = UIEdgeInsetsEqualToEdgeInsets(self.defaultEdgeInsets, UIEdgeInsetsZero) ? UIEdgeInsetsMake(10, 10, 10, 10) : self.defaultEdgeInsets;
    
    //如果刷新布局就会重新调用prepareLayout这个方法,所以要先把高度数组清空
    [self.columnHeights removeAllObjects];
    for (int i = 0; i < self.columCount; i++) {
        [self.columnHeights addObject:@(self.defaultEdgeInsets.top)];
    }
    
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //获取indexPath 对应cell 的布局属性
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attr];
    }
}

-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //只有一列的时候
    if (self.columCount==1) {
        CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
        
        CGFloat w = (self.collectionView.frame.size.width - self.defaultEdgeInsets.left - self.defaultEdgeInsets.right - (self.columCount - 1) * self.columMargin )/self.columCount;
        
        //(使用代理在外部决定cell 的高度,下面会介绍)
        CGFloat h = [self.delegate waterFlowLayout:self heightForRowAtIndex:indexPath.item itemWidth:w];
        
        CGFloat x = self.defaultEdgeInsets.left;
        CGFloat y = minColumnHeight ;
        
        if (y != self.defaultEdgeInsets.top) {
            y += self.rowMargin;
        }
        attr.frame = CGRectMake(x,y,w,h);
        self.columnHeights[0] =  @(y+ h);
        
        return attr;
    }else{
        //>=2列的时候
        ///>每列第一个cell高度不同
        if (indexPath.item<self.columCount && self.isNoAlignment) {
            CGFloat w = (self.collectionView.frame.size.width - self.defaultEdgeInsets.left - self.defaultEdgeInsets.right - (self.columCount - 1) * self.columMargin )/self.columCount;
            CGFloat x = self.defaultEdgeInsets.left + indexPath.item*(w + self.columMargin);
            CGFloat y = [self.columnHeights[indexPath.item] doubleValue]; ;
            
            CGFloat h = 60 + indexPath.item * 10;
            attr.frame = CGRectMake(x,y,w,h);
            self.columnHeights[indexPath.item] =  @(y+ h);
            return attr;
        }else{
            //使用for循环,找出高度最短的那一列
            //最短高度的列
            NSInteger destColumn = 0;
            CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
            for (NSInteger i = 1; i < self.columCount; i++) {
                CGFloat columnHeight  =[self.columnHeights[i] doubleValue];
                if (minColumnHeight > columnHeight) {
                    minColumnHeight = columnHeight;
                    destColumn = i;
                }
            }
            CGFloat w = (self.collectionView.frame.size.width - self.defaultEdgeInsets.left - self.defaultEdgeInsets.right - (self.columCount - 1) * self.columMargin )/self.columCount;
            //(使用代理在外部决定cell 的高度,下面会介绍)
            CGFloat h = [self.delegate waterFlowLayout:self heightForRowAtIndex:indexPath.item itemWidth:w];
            CGFloat x = self.defaultEdgeInsets.left + destColumn*(w + self.columMargin);
            CGFloat y = minColumnHeight ;
            if (y != self.defaultEdgeInsets.top) {
                y += self.rowMargin;
            }
            attr.frame = CGRectMake(x,y,w,h);
            self.columnHeights[destColumn] =  @(y+ h);
            return attr;
        }
    }
    return attr;
}
/**
 *  决定cell 的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
- (CGSize)collectionViewContentSize
{
    CGFloat maxHeight = [self.columnHeights[0] doubleValue];
    for (int i = 1; i < self.columCount; i++) {
        CGFloat value = [self.columnHeights[i] doubleValue];
        if (maxHeight < value) {
            maxHeight = value;
        }
    }
    return CGSizeMake(0, maxHeight+self.defaultEdgeInsets.bottom);
}

#pragma mark =geter=
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

@end
