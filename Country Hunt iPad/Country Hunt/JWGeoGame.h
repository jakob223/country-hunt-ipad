//
//  JWGeoGame.h
//  Country Hunt
//
//  Created by Weisblat Jakob 2014 on 9/5/13.
//  Copyright (c) 2013 University School. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "JWCountry.h"
@interface JWGeoGame : NSObject
@property (nonatomic) JWCountry *hidden,*last,*prev;
@property (nonatomic) BOOL hinted;
-(void)newGame;
+(void) parseJson;
-(NSInteger)makeGuess:(JWCountry*) guess;
+(JWCountry*) getGuess:(NSString*) input;
-(NSArray*)giveUp;
-(void)newGameWithContinent:(NSString*) continent;
-(void)newGameWithCountry:(JWCountry*) country;
+(float)compareString:(NSString *)originalString withString:(NSString *)comparisonString;
+(NSInteger)smallestOf:(NSInteger)a andOf:(NSInteger)b andOf:(NSInteger)c;
+(NSInteger)smallestOf:(NSInteger)a andOf:(NSInteger)b;
@end
