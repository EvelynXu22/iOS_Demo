//
//  ImageModel.m
//  UserInterfaceExample
//
//  Created by Eric Larson on 9/2/20.
//  Copyright © 2020 Eric Larson. All rights reserved.
//

#import "ImageModel.h"

@interface ImageModel()
@property (strong, nonatomic) NSArray* imageNames;
@property(strong,nonatomic) NSDictionary* imageDictionary;
@end


@implementation ImageModel


@synthesize imageNames = _imageNames;
@synthesize imageDictionary = _imageDictionary;



+(ImageModel*)sharedInstance{
    static ImageModel* _sharedInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _sharedInstance = [[ImageModel alloc] init];
    } );
    return _sharedInstance;
}

-(NSArray*) imageNames{
    if(!_imageNames)
        _imageNames = @[@"Bill",@"Eric",@"Jeff",@"Mouse",@"Dog",@"Cat"];
    NSLog(@"imageNames");
    
    return _imageNames;
}

-(NSDictionary*) imageDictionary{
    if(!_imageDictionary)
        _imageDictionary = @{@"Bill":[UIImage imageNamed:@"Bill"],@"Eric":[UIImage imageNamed:@"Eric"],@"Jeff":[UIImage imageNamed:@"Jeff"],@"Mouse":[UIImage imageNamed:@"Mouse"],@"Dog":[UIImage imageNamed:@"Dog"],@"Cat":[UIImage imageNamed:@"Cat"]};
    
    [_imageDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
         
         NSLog(@"%@ --> %@",key,obj);
         
     }];
    
    return _imageDictionary;
}


-(UIImage*)getImageWithName:(NSString*)name{
    UIImage* image = nil;
    image = [self.imageDictionary objectForKey:name];
    
    return image;
}

-(UIImage*)getImageWithIndex:(NSInteger)index{
    UIImage* image = nil;
    image = [self.imageDictionary objectForKey:[self.imageNames objectAtIndex:index]];
    return image;
}
-(NSInteger)numberOfImages{

    return self.imageNames.count;
}
-(NSString*)getImageNameForIndex:(NSInteger)index{
    NSString* name = nil;
    name = [self.imageNames objectAtIndex:index];
//    NSLog(@"name is %@",name);
    return name;
}



@end
