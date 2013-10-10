//
//  JWGeoGame.m
//  Country Hunt
//
//  Created by Weisblat Jakob 2014 on 9/5/13.
//  Copyright (c) 2013 University School. All rights reserved.
//


static NSArray *countryData = nil;


#import "JWGeoGame.h"
#import <stdlib.h>
@implementation JWGeoGame
@synthesize hidden=hidden;
@synthesize last=last;
@synthesize prev=prev;
@synthesize hinted;

/**
 * Chooses a random country to play with
 */
-(void)newGame {
    NSInteger rand = arc4random_uniform([countryData count]);
    while (rand == self.hidden.index)
        rand = arc4random_uniform([countryData count]);
    self.hidden = [countryData objectAtIndex: rand];
    self.prev=nil;
    self.last=nil;
    self.hinted=NO;
}
-(void)newGameWithPopulationAtLeast:(NSInteger)min {
    NSInteger rand = arc4random_uniform([countryData count]);
    while (rand == self.hidden.index || [(JWCountry*)[countryData objectAtIndex:rand] population]<min)
        rand = arc4random_uniform([countryData count]);
    self.hidden = [countryData objectAtIndex: rand];
    self.prev=nil;
    self.last=nil;
    self.hinted=NO;
}

/**
 * Guesses a country
 *
 * @param guess
 *            the country we're guessing
 * @return result of guess - FOUND,CLOSER,EQUAL,FARTHER
 */
-(NSInteger) makeGuess:(JWCountry*) guess {
    if (guess == self.hidden)
        return FOUND;
    self.prev = self.last;
    self.last = guess;
    if (self.prev == nil)
        return REFERENCE;
    double a=[last distanceTo:hidden];
    double b=[prev distanceTo:hidden];
    if(a<b)
        return CLOSER;
    else if(a==b)
        return EQUAL;
    else
        return FARTHER;
}

/**
 * Gets the country we think the user means
 *
 * @param input
 *            a string provided by the user
 * @returns the closest country to that string
 */
+(JWCountry*)getGuess:(NSString*)input1 {
    if([[input1 uppercaseString] isEqualToString:@"US"])
        input1=@"USA";
    else if([[input1 uppercaseString] isEqualToString:@"KOREA"])
            input1=@"South Korea";
    double best = .3*[input1 length];
    JWCountry *best1 = nil;
    double a = 0;
    for (JWCountry *c in countryData) {
        if ((a = [JWGeoGame compareString:c.name withString:input1]) < best) {
            best = a;
            best1 = c;
        }
        if ((a = [JWGeoGame compareString:c.longName withString:input1]) < best) {
            best = a;
            best1 = c;
        }
    }
    return best1;
}

/**
 * Gets a set of 6 random countries (including the answer) to show the user
 * upon giving up.
 *
 * @return an array of those 6 countries
 */
-(NSArray*) giveUp {
    NSInteger i = arc4random_uniform(6);
    NSMutableArray *cs =[[NSMutableArray alloc] initWithCapacity:6];
    for (NSInteger j = 0; j < 6; j++)
        [cs setObject: countryData[arc4random_uniform([countryData count])] atIndexedSubscript:j] ;
    [cs setObject:self.hidden atIndexedSubscript:i];
    return cs;
}

-(void)newGameWithContinent:(NSString *)continent {
    NSInteger rand1 = arc4random_uniform([countryData count]);
    while (hidden.index==rand1
           ||
           !
           [((JWCountry*)[countryData objectAtIndex:rand1]).continent isEqual:
            continent])
        rand1 = arc4random_uniform([countryData count]);
    [self newGameWithCountry:[countryData objectAtIndex:rand1]];
    
}

-(void)newGameWithCountry:(JWCountry *)country {
    [self newGame];
    self.hidden = country;
}


+(float)compareString:(NSString *)originalString withString:(NSString *)comparisonString
{
	// Normalize strings
	[originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[comparisonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	originalString = [originalString lowercaseString];
	comparisonString = [comparisonString lowercaseString];
    
	// Step 1 (Steps follow description at http://www.merriampark.com/ld.htm)
	NSInteger k, i, j, cost, * d, distance;
    
	NSInteger n = [originalString length];
	NSInteger m = [comparisonString length];
    
	if( n++ != 0 && m++ != 0 ) {
        
		d = malloc( sizeof(NSInteger) * m * n );
        
		// Step 2
		for( k = 0; k < n; k++)
			d[k] = k;
        
		for( k = 0; k < m; k++)
			d[ k * n ] = k;
        
		// Step 3 and 4
		for( i = 1; i < n; i++ )
			for( j = 1; j < m; j++ ) {
                
				// Step 5
				if( [originalString characterAtIndex: i-1] ==
				   [comparisonString characterAtIndex: j-1] )
					cost = 0;
				else
					cost = 1;
                
				// Step 6
				d[ j * n + i ] = [self smallestOf: d [ (j - 1) * n + i ] + 1
                                            andOf: d[ j * n + i - 1 ] +  1
                                            andOf: d[ (j - 1) * n + i - 1 ] + cost ];
                
				// This conditional adds Damerau transposition to Levenshtein distance
				if( i>1 && j>1 && [originalString characterAtIndex: i-1] ==
                   [comparisonString characterAtIndex: j-2] &&
                   [originalString characterAtIndex: i-2] ==
                   [comparisonString characterAtIndex: j-1] )
				{
					d[ j * n + i] = [self smallestOf: d[ j * n + i ]
                                               andOf: d[ (j - 2) * n + i - 2 ] + cost ];
				}
			}
        
		distance = d[ n * m - 1 ];
        
		free( d );
        
		return distance;
	}
	return 0.0;
}

// Return the minimum of a, b and c - used by compareString:withString:
+(NSInteger)smallestOf:(NSInteger)a andOf:(NSInteger)b andOf:(NSInteger)c
{
	NSInteger min = a;
	if ( b < min )
		min = b;
    
	if( c < min )
		min = c;
    
	return min;
}

+(NSInteger)smallestOf:(NSInteger)a andOf:(NSInteger)b
{
	NSInteger min=a;
	if (b < min)
		min=b;
    
	return min;
}

+ (void) parseJson
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"geo1" ofType:@"json"];
    NSData *returnedData = [NSData dataWithContentsOfFile:path];
    
    
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:returnedData
                 options:0
                 error:&error];
    
    
    NSDictionary *results = object;
    NSArray *features = [results objectForKey:@"features"];
    countryData=[[NSMutableArray alloc] initWithCapacity:[features count]];
    for(int i=0;i<[features count];i++)
    {
        NSDictionary *feature=[features objectAtIndex:i];
        NSDictionary *geom=[feature objectForKey:@"geometry"];
        NSDictionary *prop=[feature objectForKey:@"properties"];
        JWCountry *country=[[JWCountry alloc] initWithType:[geom objectForKey:@"type"] andName:[prop objectForKey:@"name"] andLongName:[prop objectForKey:@"name_long"] andContinent:[prop objectForKey:@"continent"] andPopulation: [(NSNumber*)[prop objectForKey:@"pop_est"] doubleValue] andIndex:i];
        [country setCoordinates:[geom objectForKey:@"coordinates"]];
        [(NSMutableArray*)countryData setObject:country atIndexedSubscript:i];
        
    }
}



@end
