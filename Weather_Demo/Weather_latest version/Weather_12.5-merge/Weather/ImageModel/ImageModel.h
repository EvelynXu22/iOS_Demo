//
//  ImageModel.h
//  Weather
//
//  Created by 徐艺文 on 9/8/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject
+(ImageModel*)sharedInstance;
+(ImageModel*)bgsharedInstance;

-(NSArray*) imageNames;
-(NSArray*) bgimageNames;


-(UIImage*)getImageWithName:(NSString*)name;
-(UIImage*)getbackgroundImageWithName:(NSString*)name;

-(UIImage*)getImageWithIndex:(NSInteger)index;
-(UIImage*)getbgImageWithIndex:(NSInteger)index;

-(NSInteger)numberOfImages;
-(NSInteger)numberOfbgImages;

-(NSString*)getImageNameForIndex:(NSInteger)index;
-(NSString*)getbgImageNameForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
