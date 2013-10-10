//
//  JWCountry.h
//  Country Hunt
//
//  Created by Weisblat Jakob 2014 on 9/5/13.
//  Copyright (c) 2013 University School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCountry : NSObject
@property BOOL multigon;
@property NSString *name,*longName,*continent;
@property NSInteger index;
@property NSArray *coordinates;
@property double population;
-(double)distanceTo:(JWCountry*)other;
-(NSString*)populationEstimate;
-(id)initWithType:(NSString*)multi andName:(NSString*)name1 andLongName:(NSString*)longName1  andContinent:(NSString*)cont andPopulation:(double)pop andIndex:(NSInteger)index1;
@end
static const NSInteger FOUND = 10;
static const NSInteger REFERENCE = -1;
static const NSInteger CLOSER = 1;
static const NSInteger EQUAL = 2;
static const NSInteger FARTHER = 0;
