//
//  SNRoundedCell.m
//  snRoundCorner
//
//  Created by 周文超 on 2017/8/29.
//  Copyright © 2017年 超超. All rights reserved.
//

#import "SNRoundedCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "UIView+SNRoundCorner.h"

@interface SNRoundedCell()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSMutableArray *circles;


@end

@implementation SNRoundedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.sn_roundCornerColor = [UIColor whiteColor];
    self.avatarImageView.sn_roundCornerRadius = 40.f;
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(25.f);
        make.width.height.equalTo(@60.f);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-25.f);
        make.bottom.equalTo(self.contentView).offset(-5.f);
    }];
    
    _circles = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i ++) {
        UIView *littleCircle = [UIView new];
        littleCircle.layer.opaque = YES;
        littleCircle.backgroundColor = [UIColor orangeColor];
        littleCircle.bounds = CGRectMake(0, 0, 15, 15);
        littleCircle.center = CGPointMake(110 + 7.5 + 20 * i, 30);
        littleCircle.sn_roundCornerColor = [UIColor whiteColor];
        littleCircle.sn_roundCornerRadius = 7.5f;
        [self.contentView addSubview:littleCircle];
        [_circles addObject:littleCircle];
    }
}

- (void)reloadDataWithUrl:(NSString *)imageUrl name:(NSString *)name {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.nameLabel.text = name;
}

@end
