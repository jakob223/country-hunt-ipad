//
//  JWCountry.m
//  Country Hunt
//
//  Created by Weisblat Jakob 2014 on 9/5/13.
//  Copyright (c) 2013 University School. All rights reserved.
//

#import "JWCountry.h"

@implementation JWCountry
@synthesize index;
@synthesize coordinates;
@synthesize name;
@synthesize longName;
@synthesize continent;
@synthesize multigon;
-(double)distanceTo:(JWCountry *)other{
    double min1 = 1E200;
    if (![self multigon] && ![other multigon])
        for (NSArray *pair in [[self coordinates] objectAtIndex:0])
            for (NSArray *pair2 in [[other coordinates] objectAtIndex:0]) {
                double result = [JWCountry distanceFrom:pair to: pair2];
                if (result < min1)
                    min1 = result;
            }
    else if ([self multigon] && ![other multigon])
        for (NSArray* array in [self coordinates])
            for (NSArray *pair in [array objectAtIndex:0])
                for (NSArray *pair2 in [[other coordinates] objectAtIndex:0]) {
                    double result = [JWCountry distanceFrom:pair to: pair2];
                    if (result < min1)
                        min1 = result;
                }
    else if ([self multigon] && [other multigon])
        for (NSArray* array in [self coordinates])
            for (NSArray* array2 in [other coordinates])
                for (NSArray *pair in [array objectAtIndex:0])
                    for (NSArray *pair2 in [array2 objectAtIndex:0]){
                        double result = [JWCountry distanceFrom:pair to: pair2];
                        if (result < min1)
                            min1 = result;
                    }
    else
        return [other distanceTo:self];
    return min1;
}
-(NSString*)populationEstimate
{
    double pop1=self.population;
    pop1/=3;
    pop1+=arc4random_uniform((int)self.population*2/3);
    double pop2=self.population;
    pop2+=arc4random_uniform((int)self.population*2);
    return [NSString stringWithFormat:@"Population is between %d and %d",(int)pop1,(int)pop2];
    
}
+(double)distanceFrom:(NSArray*) pair to: (NSArray*) pair2
{
    double R = 6371; // km
    return acos(sin([((NSNumber*)[pair objectAtIndex:0]) doubleValue] * M_PI / 180)
                * sin([((NSNumber*)[pair2 objectAtIndex:0]) doubleValue] * M_PI / 180)
                + cos([((NSNumber*)[pair objectAtIndex:0]) doubleValue] * M_PI / 180)
                * cos([((NSNumber*)[pair2 objectAtIndex:0]) doubleValue] * M_PI / 180)
                * cos(([((NSNumber*)[pair objectAtIndex:1]) doubleValue] - [((NSNumber*)[pair2 objectAtIndex:1]) doubleValue]) * M_PI / 180))
    * R;
}
-(id)initWithType:(NSString*)multi andName:(NSString*)name1 andLongName:(NSString*)longName1  andContinent:(NSString*)cont andPopulation:(double)pop andIndex:(NSInteger)index1
{
    if(self=[super init]){
        self.name=name1;
        self.longName=longName1;
        self.continent=cont;
        self.index=index1;
        multigon=[multi isEqual:@"MultiPolygon"];
        self.population=pop;
    }
    return self;
}
@end
