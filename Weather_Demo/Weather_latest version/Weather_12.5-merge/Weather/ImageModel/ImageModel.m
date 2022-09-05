//
//  ImageModel.m
//  Weather
//
//  Created by 徐艺文 on 9/8/21.
//

#import "ImageModel.h"

@interface ImageModel()
@property (strong, nonatomic) NSArray* bgImageNames;
@property(strong,nonatomic) NSDictionary* bgImageDictionary;

@property (strong, nonatomic) NSArray* developerImageNames;
@property(strong,nonatomic) NSDictionary* developerImageDictionary;
@end

@implementation ImageModel

@synthesize developerImageNames = _developerimageNames;
@synthesize developerImageDictionary = _developerImageDictionary;

@synthesize bgImageNames = _bgimageNames;
@synthesize bgImageDictionary = _bgImageDictionary;

+(ImageModel*)sharedInstance{
    static ImageModel* _sharedInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _sharedInstance = [[ImageModel alloc] init];
    } );
    return _sharedInstance;
}

+(ImageModel*)bgsharedInstance{
    static ImageModel* _sharedInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _sharedInstance = [[ImageModel alloc] init];
    } );
    return _sharedInstance;
}

-(NSArray*) imageNames{
    if(!_developerimageNames)
        _developerimageNames = @[@"YiwenXu",@"ShuangLiang",@"YinzeCui",@"YuanchunZhao",@"Teamwork1",@"Teamwork2",@"Teamwork3"];
    NSLog(@"imageNames");
    
    return _developerimageNames;
}

-(NSArray*) bgimageNames{
    if(!_bgimageNames)
        _bgimageNames = @[@"dallas_cityscape",@"shanghai_cityscape"];
    NSLog(@"imageNames");
    
    return _bgimageNames;
}

-(NSDictionary*) imageDictionary{
    if(!_developerImageDictionary)
        _developerImageDictionary = @{@"YiwenXu":[UIImage imageNamed:@"YiwenXu"],@"ShuangLiang":[UIImage imageNamed:@"ShuangLiang"],@"YinzeCui":[UIImage imageNamed:@"YinzeCui"],@"YuanchunZhao":[UIImage imageNamed:@"YuanchunZhao"],@"Teamwork1":[UIImage imageNamed:@"Teamwork1"],@"Teamwork2":[UIImage imageNamed:@"Teamwork2"],@"Teamwork3":[UIImage imageNamed:@"Teamwork3"]};
    
//    [_imageDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//
//         NSLog(@"%@ --> %@",key,obj);
//
//     }];
    
    return _developerImageDictionary;
}

-(NSDictionary*) bgImageDictionary{
    if(!_bgImageDictionary)
        _bgImageDictionary = @{@"dallas_cityscape":[UIImage imageNamed:@"dallas_cityscape"],@"shanghai_cityscape":[UIImage imageNamed:@"shanghai_cityscape"]};


    return _bgImageDictionary;
}

-(UIImage*)getImageWithName:(NSString*)name{
    UIImage* image = nil;
    image = [self.imageDictionary objectForKey:name];
    
    return image;
}

-(UIImage*)getbackgroundImageWithName:(NSString*)name{
    UIImage* image = nil;
    image = [self.bgImageDictionary objectForKey:name];
    
    return image;
}


-(UIImage*)getImageWithIndex:(NSInteger)index{
    UIImage* image = nil;
    image = [self.developerImageDictionary objectForKey:[self.developerImageNames objectAtIndex:index]];
    return image;
}

-(UIImage*)getbgImageWithIndex:(NSInteger)index{
    UIImage* image = nil;
    image = [self.bgImageDictionary objectForKey:[self.bgImageNames objectAtIndex:index]];
    return image;
}

-(NSInteger)numberOfImages{

    return self.imageNames.count;
}

-(NSInteger)numberOfbgImages{

    return self.bgimageNames.count;
}

-(NSString*)getImageNameForIndex:(NSInteger)index{
    NSString* name = nil;
    name = [self.developerImageNames objectAtIndex:index];
//    NSLog(@"name is %@",name);
    return name;
}

-(NSString*)getbgImageNameForIndex:(NSInteger)index{
    NSString* name = nil;
    name = [self.bgImageNames objectAtIndex:index];
    return name;
}

@end
