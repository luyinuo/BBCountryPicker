//
//  BBCountryPickerViewController.h
//  
//
//  Created by kevinlu on 2018/5/2.
//  Copyright © 2018年 BOBBY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCountryModel.h"
@protocol BBCountryPickerViewDelegate <NSObject>
- (void) didSelectedCountry:(BBCountryModel *)country;
@end
@interface BBCountryPickerViewController : UIViewController
@property (nonatomic, weak) id<BBCountryPickerViewDelegate> delegate;
@end
