//
//  TrainlineOperation.m
//  Swiss Trains
//
//  Created by Alain on 22.01.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "TrainlineOperation.h"

@implementation TrainlineOperation

- (id)initWithConresultAndDetaillevelAndConnections:(ConResult *)conresult detaillevel:(NSUInteger)detaillevel connections:(Connections *)connections {
    
    self = [super init];
    if (self) {
        if (detaillevel <=4) {
            self.detaillevel = detaillevel;
        } else {
            self.detaillevel = 2;
        }
        _conresult = conresult;
        _connections = connections;
        self.routeleadsawaysfromdestinationtolerance = 3;
    }
    return self;
}

- (id)initWithConsectionAndDetaillevelAndConnections:(ConSection *)consection detaillevel:(NSUInteger)detaillevel connections:(Connections *)connections {
    
    self = [super init];
    if (self) {
        if (detaillevel <=4) {
            self.detaillevel = detaillevel;
        } else {
            self.detaillevel = 2;
        }
        _consection = consection;
        _connections = connections;
        self.routeleadsawaysfromdestinationtolerance = 3;
    }
    return self;
}

- (id)initWithJourneyAndDetaillevelAndStationboardresults:(Journey *)journey detaillevel:(NSUInteger)detaillevel stationboardresults:(StationboardResults *)stationboardresults {
    
    self = [super init];
    if (self) {
        if (detaillevel <=4) {
            self.detaillevel = detaillevel;
        } else {
            self.detaillevel = 2;
        }
        _journey = journey;
        _stationboardresults = stationboardresults;
        self.routeleadsawaysfromdestinationtolerance = 3;
    }
    return self;
}

- (void)setCompletionBlockWithSuccess:(TrainlineOperationCompletionSuccessBlock)successblock
                              failure:(TrainlineOperationCompletionFailureBlock)failureblock
{
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Warc-retain-cycles"
    //__weak __typeof(&*self)weakSelf = self;
    
    if (successblock) {
        
        self.trainlineOperationCompletionSuccessBlock = ^(NSArray *routes){
            dispatch_async(dispatch_get_main_queue(), ^{
                successblock(routes);
            });
        };
    }
    
    if (failureblock) {
        self.trainlineOperationCompletionFailureBlock = ^(NSUInteger errorcode){
            dispatch_async(dispatch_get_main_queue(), ^{
                failureblock(errorcode);
            });
        };
    }
    
    //#pragma clang diagnostic pop
}

- (void)setConresultPrecheckedBlock:(TrainlineOperationConresultPrecheckedBlock)conresprecheckedblock
{
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Warc-retain-cycles"
    //__weak __typeof(&*self)weakSelf = self;
    
    if (conresprecheckedblock) {
        
        self.trainlineOperationConresultPrecheckedBlock = ^(NSArray *checkedconsectionflags, ConResult *checkedconresult){
            dispatch_async(dispatch_get_main_queue(), ^{
                conresprecheckedblock(checkedconsectionflags, checkedconresult);
            });
        };
    }
    
    //#pragma clang diagnostic pop
}

- (void)setConsectionPrecheckedBlock:(TrainlineOperationConsectionPrecheckedBlock)consecprecheckedblock {
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Warc-retain-cycles"
    //__weak __typeof(&*self)weakSelf = self;
    
    if (consecprecheckedblock) {
        
        self.trainlineOperationConsectionPrecheckedBlock = ^(BOOL availableflag, ConSection *checkedconsection){
            dispatch_async(dispatch_get_main_queue(), ^{
                consecprecheckedblock(availableflag, checkedconsection);
            });
        };
    }
    
    //#pragma clang diagnostic pop
}

- (void)setJourneyPrecheckedBlock:(TrainlineOperationJourneyPrecheckedBlock)journeyprecheckedblock {
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Warc-retain-cycles"
    //__weak __typeof(&*self)weakSelf = self;
    
    if (journeyprecheckedblock) {
        
        self.trainlineOperationJourneyPrecheckedBlock = ^(BOOL availableflag, Journey *checkedjourney){
            dispatch_async(dispatch_get_main_queue(), ^{
                journeyprecheckedblock(availableflag, checkedjourney);
            });
        };
    }
    
    //#pragma clang diagnostic pop
}

- (void)setRouteleadsawaysfromdestinationtolerancelevel:(NSUInteger)tolerancelevel {
    if (tolerancelevel == 0) {
        self.routeleadsawaysfromdestinationtolerance = 999;
        return;
    }
    if (tolerancelevel <=3) {
        if (tolerancelevel == 1) {
            self.routeleadsawaysfromdestinationtolerance = 3;
            return;
        }
        if (tolerancelevel == 2) {
            self.routeleadsawaysfromdestinationtolerance = 7;
            return;
        }
        if (tolerancelevel == 3) {
            self.routeleadsawaysfromdestinationtolerance = 11;
            return;
        }
    }
}

// --------------------------------------------------------------------------------------------

-  (Station *) getStationForBasicStop:(BasicStop *)basicStop {
    if (basicStop) {
        if ([basicStop isKindOfClass: [BasicStop class]]) {
            return [basicStop station];
        }
    }
    return nil;
}

- (NSArray *) getBasicStopsForConsection:(ConSection *)conSection {
    NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity:2];
    if ([conSection conSectionType] == walkType) {
        BasicStop *departureStation = [[BasicStop alloc] init];
        BasicStop *arrivalStation = [[BasicStop alloc] init];
        
        departureStation.arr = [[conSection arrival] arr];
        departureStation.dep = [[conSection departure] dep];
        departureStation.station = [[conSection departure] station];
        departureStation.basicStopType = departureType;
        departureStation.platform = [[conSection departure] platform];
        
        arrivalStation.arr = [[conSection arrival] arr];
        arrivalStation.dep = [[conSection departure] dep];
        arrivalStation.station = [[conSection arrival] station];
        arrivalStation.basicStopType = arrivalType;
        arrivalStation.platform = [[conSection arrival] platform];
        
        [stationsArray addObject: departureStation];
        [stationsArray addObject: arrivalStation];
        return stationsArray;
    } else if ([conSection conSectionType] == journeyType) {
        NSArray *passlist = [[conSection journey] passList];
        for (int i = 0;  i < [passlist count];  i++) {
            BasicStop *currentBasicStop = (BasicStop *)[passlist objectAtIndex: i];
            [stationsArray addObject: currentBasicStop];
        }
        return stationsArray;
    }
    return nil;
}

- (NSArray *) getBasicStopsForStationboardJourneyRequestResult:(Journey *)journey {
    NSMutableArray *stationsArray = [NSMutableArray arrayWithCapacity:2];
    if (journey) {
        NSArray *passlist = [journey passList];
        for (int i = 0;  i < [passlist count];  i++) {
            BasicStop *currentBasicStop = (BasicStop *)[passlist objectAtIndex: i];
            [stationsArray addObject: currentBasicStop];
        }
        return stationsArray;
    }
    return nil;
}

- (NSString *) getTransportNameWithStationboardJourney:(Journey *)journey {
    NSString *transportName = [journey journeyName];
    
    //NSLog(@"SBBAPIController getTransportNameWithConsection:%@.", transportName);
    
    NSString *categoryCodeString = [journey journeyCategoryCode];
    NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
    //NSString *transportCategoryName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    //NSLog(@"Journey name codes: %@, %@", categoryCode, transportCategoryName);
    
    if ([categoryCode integerValue] == 6 || [categoryCode integerValue] == 9) {
        if (transportName && [transportName length] >= 2) {
            NSArray *splitname = [transportName componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if (splitname && splitname.count > 1) {
                NSString *shortname = [splitname objectAtIndex: 0];
                if ([shortname isEqualToString: @"T"]) {
                    shortname = @"Tram";
                }
                if ([shortname isEqualToString: @"NFT"]) {
                    shortname = @"Tram";
                }
                if ([shortname isEqualToString: @"TRO"]) {
                    shortname = @"Bus";
                }
                if ([shortname isEqualToString: @"NFB"]) {
                    shortname = @"Bus";
                }
                if ([shortname isEqualToString: @"NFO"]) {
                    shortname = @"Bus";
                }
                NSString *transportnamenew = [NSString stringWithFormat:@"%@ %@", shortname, [splitname objectAtIndex: 1]];
                return transportnamenew;
            }
        }
    }
    
    // T, NFT, NFB, NFO, TRO,
    // Tram, Niederflurtram, Niederflurbus, X, Trolley
    
    
    
    return transportName;
}

- (NSString *) getSimplifiedTransportNameWithStationboardJourney:(Journey *)journey {
    //NSString *transportName = [[journey journeyName] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *transportName = [[self getTransportNameWithStationboardJourney: journey] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (transportName && [transportName length] >= 2) {
        NSArray *splitname = [transportName componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        if (splitname && splitname.count > 1) {
            return [splitname objectAtIndex: 0];
        }
        return [transportName substringToIndex: 2];
    }
    
    return transportName;
}

- (NSString *) getTransportNameWithConsection:(ConSection *)conSection {
    NSString *transportName = nil;
    if ([conSection conSectionType] == walkType) {
        transportName = @"WALK";
        
        //NSLog(@"SBBAPIController getTransportNameWithConsection: WALKTYPE");
        
        return transportName;
    } else if ([conSection conSectionType] == journeyType) {
        Journey *journey = [conSection journey];
        NSString *transportName = [journey journeyName];
        
        NSString *categoryCodeString = [journey journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        //NSString *transportCategoryName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        //NSLog(@"Journey name codes: %@, %@", categoryCode, transportCategoryName);
        
        if ([categoryCode integerValue] == 6 || [categoryCode integerValue] == 9) {
            if (transportName && [transportName length] >= 2) {
                NSArray *splitname = [transportName componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if (splitname && splitname.count > 1) {
                    NSString *shortname = [splitname objectAtIndex: 0];
                    if ([shortname isEqualToString: @"T"]) {
                        shortname = @"Tram";
                    }
                    if ([shortname isEqualToString: @"NFT"]) {
                        shortname = @"Tram";
                    }
                    if ([shortname isEqualToString: @"TRO"]) {
                        shortname = @"Bus";
                    }
                    if ([shortname isEqualToString: @"NFB"]) {
                        shortname = @"Bus";
                    }
                    if ([shortname isEqualToString: @"NFO"]) {
                        shortname = @"Bus";
                    }
                    NSString *transportnamenew = [NSString stringWithFormat:@"%@ %@", shortname, [splitname objectAtIndex: 1]];
                    return transportnamenew;
                }
            }
        }
        
        // T, NFT, NFB, NFO, TRO,
        // Tram, Niederflurtram, Niederflurbus, X, Trolley
        
        
        //NSLog(@"SBBAPIController getTransportNameWithConsection:%@.", transportName);
        
        return transportName;
    }
    return nil;
}

- (NSString *) getSimplifiedTransportNameWithConsection:(ConSection *)conSection {
    NSString *transportName = nil;
    if ([conSection conSectionType] == walkType) {
        transportName = @"WALK";
        
        //NSLog(@"SBBAPIController getTransportNameWithConsection: WALKTYPE");
        
        return transportName;
    } else if ([conSection conSectionType] == journeyType) {
        //Journey *journey = [conSection journey];
        //NSString *transportName = [[journey journeyName] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *transportName = [[self getTransportNameWithConsection: conSection] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        //NSLog(@"SBBAPIController getTransportNameWithConsection:%@.", transportName);
        
        if (transportName && [transportName length] >= 2) {
            NSArray *splitname = [transportName componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if (splitname && splitname.count > 1) {
                return [splitname objectAtIndex: 0];
            }
            return [transportName substringToIndex: 2];
        }
        return transportName;
    }
    return nil;
}

- (NSUInteger) getTransportTypeCodeForTransportCategoryType:(NSString *)transportCategoryType {
    if ([transportCategoryType isEqualToString: @"IR"]) {           // Fast trains...
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"ICE"]) {
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"IC"]) {
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"ICN"]) {
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"EC"]) {
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"RJ"]) {
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"TGV"]) {
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"EN"]) {
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"CNL"]) {
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"EXT"]) {   // Extra train
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"ARZ"]) {   // ???
        return trainlineTransportFastTrain;
    } else if ([transportCategoryType isEqualToString: @"S"]) {
        return trainlineTransportSlowTrain;
    } else if ([transportCategoryType isEqualToString: @"RE"]) {    // Regional trains...
        return trainlineTransportSlowTrain;
    } else if ([transportCategoryType isEqualToString: @"R"]) {
        return trainlineTransportSlowTrain;
    } else if ([transportCategoryType isEqualToString: @"BAT"]) {   // Ship...
        return trainlineTransportShip;
    } else if ([transportCategoryType isEqualToString: @"BUS"]) {   // Bus...
        return trainlineTransportBus;
    } else if ([transportCategoryType isEqualToString: @"TRAM"]) {  // Tram...
        return trainlineTransportTram;
    } else if ([transportCategoryType isEqualToString: @"FUN"]) {   //Funiculaire...
        return trainlineTransportFuni;
    } else if ([transportCategoryType isEqualToString: @"TRO"]) {   //Trolley
        return trainlineTransportBus;
    } else if ([transportCategoryType isEqualToString: @"MET"]) {   //Metro
        return trainlineTransportTram;
    }
    return trainlineTransportUnknown;
}
/*
- (UIColor *) colorForSBBTransportCategoryType:(NSString *)transportCategoryType {
    NSUInteger transportType = [self getTransportTypeCodeForTransportCategoryType: transportCategoryType];
    if (transportType == trainlineTransportUnknown) {
        return [UIColor darkGrayColor];
    } else if (transportType == trainlineTransportFastTrain) {
        return [UIColor colorWithHexString: @"EE1D23"];
    } else if (transportType == trainlineTransportSlowTrain) {
        return [UIColor whiteColor];
    } else if (transportType == trainlineTransportTram) {
        return [UIColor whiteColor];
    } else if (transportType == trainlineTransportBus) {
        return [UIColor whiteColor];
    } else if (transportType == trainlineTransportShip) {
        return [UIColor whiteColor];
    }
    return [UIColor darkGrayColor];
}
*/
- (UIColor *) colorForSBBTransportCategoryType:(NSString *)transportCategoryType {
    NSUInteger transportType = [self getTransportTypeCodeForTransportCategoryType: transportCategoryType];
    if (transportType == trainlineTransportUnknown) {
        return [UIColor darkGrayColor];
    } else if (transportType == trainlineTransportFastTrain) {
        return [UIColor colorWithHexString: @"EE1D23"];
    } else if (transportType == trainlineTransportSlowTrain) {
        return [UIColor darkGrayColor];
    } else if (transportType == trainlineTransportTram) {
        return [UIColor darkGrayColor];
    } else if (transportType == trainlineTransportBus) {
        return [UIColor darkGrayColor];
    } else if (transportType == trainlineTransportShip) {
        return [UIColor darkGrayColor];
    } else if (transportType == trainlineTransportFuni) {
        return [UIColor darkGrayColor];
    }
    return [UIColor darkGrayColor];
}

- (UIColor *) colorForBVBLineNumber:(NSUInteger)lineNumber {
    NSString *hexColorCode = @"C7C8CA";
    switch (lineNumber) {
        case 2:
            hexColorCode = @"A68352";
            break;
        case 3:
            hexColorCode = @"344EA1";
            break;
        case 6:
            hexColorCode = @"0072BC";
            break;
        case 8:
            hexColorCode = @"F172AC";
            break;
        case 10:
            hexColorCode = @"FECA0A";
            break;
        case 11:
            hexColorCode = @"EE1D23";
            break;
        case 14:
            hexColorCode = @"F58220";
            break;
        case 15:
            hexColorCode = @"00A54F";
            break;
        case 16:
            hexColorCode = @"A6CE39";
            break;
        case 17:
            hexColorCode = @"00AEEF";
            break;
        case 21:
            hexColorCode = @"00AE9D";
            break;
        case 1:
            hexColorCode = @"835237";
            break;
        default:
            hexColorCode = @"C7C8CA";
    }
    
    return [UIColor colorWithHexString:hexColorCode];
}

- (UIColor *) colorForVBLLineNumber:(NSUInteger)lineNumber {
    NSString *hexColorCode = @"C8D1DC";
    switch (lineNumber) {
        case 6:
        case 10:
        case 16:
            hexColorCode = @"C95632";
            break;
        case 8:
        case 11:
        case 19:
            hexColorCode = @"FDCA31";
            break;
        case 20:
        case 21:
        case 22:
        case 23:
        case 24:
            hexColorCode = @"679ACF";
            break;
        case 2:
        case 7:
        case 18:
        case 25:
        case 26:
            hexColorCode = @"EB212D";
            break;
        case 1:
        case 4:
        case 9:
        case 12:
        case 14:
        case 15:
        case 27:
        case 31:
            hexColorCode = @"17A453";
            break;
        default:
            hexColorCode = @"ACCADD";
    }
    
    return [UIColor colorWithHexString:hexColorCode];
}

- (UIColor *) colorForBLTLineNumber:(NSUInteger)lineNumber {
    return [UIColor whiteColor];
}

- (UIColor *) colorForVBZLineNumber:(NSUInteger)lineNumber {
    NSString *hexColorCode = @"ACCADD";
    switch (lineNumber) {
        case 5:
            hexColorCode = @"946237";
            break;
        case 6:
            hexColorCode = @"D99E4E";
            break;
        case 7:
            hexColorCode = @"231F20";
            break;
        case 8:
            hexColorCode = @"A6CE39";
            break;
        case 4:
        case 9:
            hexColorCode = @"48479D";
            break;
        case 10:
            hexColorCode = @"D04186";
            break;
        case 3:
        case 11:
            hexColorCode = @"00AB4D";
            break;
        case 12:
            hexColorCode = @"78D0E2";
            break;
        case 13:
            hexColorCode = @"FED304";
            break;
        case 14:
            hexColorCode = @"00AEEF";
            break;
        case 17:
            hexColorCode = @"A1276F";
            break;
        case 2:
        case 15:
            hexColorCode = @"EE1D23";
            break;
        default:
            hexColorCode = @"ACCADD";
    }
    
    return [UIColor colorWithHexString:hexColorCode];
}

- (NSString *)getTransportOperatorForConsection:(ConSection *)conSection {
    
    if ([conSection conSectionType] == journeyType) {
        Journey *journey = [conSection journey];
        NSString *transportOperator = [[[journey journeyOperator] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        if (transportOperator && [transportOperator length] > 0) {
            return transportOperator;
        } else {
            NSString *transportAdministration = [[[journey journeyAdministration] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if (transportAdministration && [transportAdministration length] > 0) {
                if ([transportAdministration isEqualToString:@"000849"] || [transportAdministration isEqualToString:@"000773"]) {
                    return @"VBZ";
                }
                if ([transportAdministration isEqualToString:@"000820"] || [transportAdministration isEqualToString:@"000812"] || [transportAdministration isEqualToString:@"000819"]) {
                    return @"VBL";
                }
                if ([transportAdministration isEqualToString:@"000823"] || [transportAdministration isEqualToString:@"000037"]) {
                    return @"BVB";
                }
                /*
                if ([transportAdministration isEqualToString:@"000011"]) {
                    return @"SBB";
                }
                */ 
            }
            
        }
    }
    return nil;
}

- (UIColor *) getTransportColorWithConsection:(ConSection *)conSection {
    
    NSString *stringColorCode = nil;
    if ([conSection conSectionType] == walkType) {
        stringColorCode = @"Walking.png";
        return [UIColor lightGrayColor];
    } else if ([conSection conSectionType] == journeyType) {
        Journey *journey = [conSection journey];
        NSString *transportCategoryName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        //NSString *transportOperator = [[[journey journeyOperator] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *transportOperator = [self getTransportOperatorForConsection: conSection];
        
        NSString *transportNumber = [[[journey journeyNumber] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        if (transportOperator) {
            if ([transportOperator isEqualToString: @"VBZ"]) {
                if (transportNumber) {
                    NSUInteger lineNumber = [transportNumber integerValue];
                    if (lineNumber > 0) {
                        UIColor *vbzColor = [self colorForVBZLineNumber: lineNumber];
                        return vbzColor;
                    }
                }
            } else if ([transportOperator isEqualToString: @"VBL"]) {
                if (transportNumber) {
                    NSUInteger lineNumber = [transportNumber integerValue];
                    if (lineNumber > 0) {
                        UIColor *vblColor = [self colorForVBLLineNumber: lineNumber];
                        return vblColor;
                    }
                }
            } else if ([transportOperator isEqualToString: @"BVB"]) {
                if (transportNumber) {
                    NSUInteger lineNumber = [transportNumber integerValue];
                    if (lineNumber > 0) {
                        UIColor *bvbColor = [self colorForBVBLineNumber: lineNumber];
                        return bvbColor;
                    }
                }
            }
        } else {
            if (transportCategoryName) {
                return [self colorForSBBTransportCategoryType: transportCategoryName];
            }
        }
    }
    
    //NSLog(@"Color: %@", [[UIColor blueColor] hexStringFromColor]);
    
    return [UIColor darkGrayColor];
}

- (BOOL) stringContainsObjectFromStringArray:(NSString *)string stringarray:(NSArray *)stringarray {
    
    __block NSString *result = nil;
    [stringarray indexOfObjectWithOptions:NSEnumerationConcurrent
                              passingTest:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         if ([string rangeOfString:obj].location != NSNotFound)
         {
             result = obj;
             *stop = YES;
             return YES;
         }
         return NO;
     }];
    if (!result) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)getTransportOperatorForJourney:(Journey *)journey {
    
    NSString *transportOperator = [[[journey journeyOperator] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (transportOperator && [transportOperator length] > 0) {
        return transportOperator;
    } else {
        NSString *transportAdministration = [[[journey journeyAdministration] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        if (transportAdministration && [transportAdministration length] > 0) {
            if ([transportAdministration isEqualToString:@"000849"] || [transportAdministration isEqualToString:@"000773"]) {      // 000773
                return @"VBZ";
            }
            if ([transportAdministration isEqualToString:@"000820"] || [transportAdministration isEqualToString:@"000812"] || [transportAdministration isEqualToString:@"000819"]) {  // 000812, 000819
                return @"VBL";
            }
            if ([transportAdministration isEqualToString:@"000823"] || [transportAdministration isEqualToString:@"000037"]) {      // 000037
                return @"BVB";
            }
            /*
            if ([transportAdministration isEqualToString:@"000011"]) {
                return @"SBB";
            */ 
        } else {
            NSString *journeydirection = [[journey journeyDirection] uppercaseString];
            NSString *categoryCodeString = [journey journeyCategoryCode];
            NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
            //NSString *transportName = [[[journey journeyName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            
            if ([categoryCode integerValue] == 6 || [categoryCode integerValue] == 9) {
                if ([self stringContainsObjectFromStringArray: journeydirection stringarray:@[@"ZÜRICH", @"STETTBACH",
                     @"SCHLIEREN", @"ITSCHNACH",
                     @"REGENSDORF", @"GLATTBRUGG",
                     @"WALLISELLEN", @"DÜBENDORF",
                     @"KÜSNACHT", @"ZOLLIKERBERG",
                     @"OPFIKON", @"ALTSTETTEN",
                     @"RÜMLANG", @"UITIKON"]]) {
                    return @"VBZ";
                }
                
                if ([self stringContainsObjectFromStringArray: journeydirection stringarray:@[@"BASEL", @"BINNINGEN",
                     @"AESCH BL", @"ETTINGEN",
                     @"FLÜH", @"ETTINGEN",
                     @"RODERSDORF", @"BIRSFELDEN",
                     @"PRATTELN", @"RIEHEN",
                     @"ALLSCHWIL", @"BOTTMINGEN",
                     @"SCHÖNENBUCH", @"NEUWEG, PARC SOLEIL",
                     @"DORNACH-ARLESHEIM", @"ST-LOUIS"]]) {
                    return @"BVB";
                }
                
                if ([self stringContainsObjectFromStringArray: journeydirection stringarray:@[@"LUZERN", @"EMMENBRÜCKE",
                     @"LITTAU", @"OBERNAU",
                     @"GISIKON-ROOT", @"MEGGEN",
                     @"KRIENS", @"INWIL",
                     @"MENZIKEN", @"ROTKREUZ",
                     @"EIGENTHAL", @"NEUENKIRCH",
                     @"EMMEN", @"ETTISWIL",
                     @"RICKENBACK LU", @"UDLIGENSWIL",
                     @"ADLIGENSWIL", @"UDLIGENSWIL",
                     @"EBIKON", @"ROTHENBURG",
                     @"PERLEN", @"HORW"]]) {
                    return @"VBL";
                }
                
            }
            
        }
        
    }
    return nil;
}

- (UIColor *) getTransportColorWithStationboardJourney:(Journey *)journey {
    NSString *transportCategoryName = [[[journey journeyCategoryName] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    //NSString *transportOperator = [[[journey journeyOperator] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *transportOperator = [self getTransportOperatorForJourney: journey];
    
    NSString *transportNumber = [[[journey journeyNumber] uppercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (transportOperator) {
        if ([transportOperator isEqualToString: @"VBZ"]) {
            if (transportNumber) {
                NSUInteger lineNumber = [transportNumber integerValue];
                if (lineNumber > 0) {
                    UIColor *vbzColor = [self colorForVBZLineNumber: lineNumber];
                    return vbzColor;
                }
            }
        } else if ([transportOperator isEqualToString: @"VBL"]) {
            if (transportNumber) {
                NSUInteger lineNumber = [transportNumber integerValue];
                if (lineNumber > 0) {
                    UIColor *vblColor = [self colorForVBLLineNumber: lineNumber];
                    return vblColor;
                }
            }
        } else if ([transportOperator isEqualToString: @"BVB"]) {
            if (transportNumber) {
                NSUInteger lineNumber = [transportNumber integerValue];
                if (lineNumber > 0) {
                    UIColor *bvbColor = [self colorForBVBLineNumber: lineNumber];
                    return bvbColor;
                }
            }
        }
    } else {
        if (transportCategoryName) {
            return [self colorForSBBTransportCategoryType: transportCategoryName];
        }
    }
    
    //NSLog(@"Color: %@", [[UIColor blueColor] hexStringFromColor]);
    
    return [UIColor darkGrayColor];
}

- (BOOL) isTrainportTypeEqualToTrainForConsection:(ConSection *)conSection {
    
    //NSArray *fastTrainArray = [NSArray arrayWithObjects:  @"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //NSArray *regioTrainArray = [NSArray arrayWithObjects:  @"S", @"RE", @"R" , nil];
    //NSArray *otherTransportArray = [NSArray arrayWithObjects:  @"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    
    //@"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //  1       2      0       1       1       0     0       0      0
    //0-2
    
    //@"S", @"RE", @"R" , nil];
    //  5      3     5
    //3-5
    
    //@"BAT", @"FUN", @"BUS", @"TRO", @"ARZ/EXT" ,@"TRAM", @"MET" , nil];
    //           7       6      6      8              9      9
    //> 5
    
    if (conSection) {
        if ([conSection conSectionType] == walkType) {
            return NO;
        }
        
        Journey *journey = [conSection journey];
        NSString *categoryCodeString = [journey journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        
        if ([categoryCode integerValue] <= 5 || [categoryCode integerValue] == 8) {
            return YES;
        }
        
    }
    return NO;
}

- (BOOL) isTrainportTypeEqualToTrainForStationboardJourney:(Journey *)journey {
    
    //NSArray *fastTrainArray = [NSArray arrayWithObjects:  @"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //NSArray *regioTrainArray = [NSArray arrayWithObjects:  @"S", @"RE", @"R" , nil];
    //NSArray *otherTransportArray = [NSArray arrayWithObjects:  @"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    
    //@"IC", @"IR", @"ICE", @"ICN", @"EC", @"RJ", @"TGV", @"EN", @"CNL" , nil];
    //  1       2      0       1       1       0     0       0      0
    //0-2
    
    //@"S", @"RE", @"R" , nil];
    //  5      3     5
    //3-5
    
    //@"BAT", @"FUN", @"BUS", @"TRO", @"TRAM", @"MET" , nil];
    //           7       6      6          9      9
    //> 5
    
    if (journey) {
        NSString *categoryCodeString = [journey journeyCategoryCode];
        NSNumber *categoryCode = [NSNumber numberWithInt: [categoryCodeString integerValue]];
        
        if ([categoryCode integerValue] <= 5 || [categoryCode integerValue] == 8) {
            return YES;
        }
        
    }
    return NO;
}

// --------------------------------------------------------------------------------------------

- (void) logTimeStampWithText:(NSString *)text {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss:SS yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate: [NSDate date]];
    NSLog(@"%@, %@", text, dateString);
}

- (void) logTimeDifferenceWithTextAndDate:(NSString *)text date:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss:SS"];
    //NSString *dateString = [dateFormatter stringFromDate: [NSDate date]];
    NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:date];
    
    NSLog(@"%@, %.4f", text, diff);
}

- (float) calculateDistance: (CLLocationCoordinate2D) aPoint bPoint:(CLLocationCoordinate2D)bPoint {
	CLLocation *startpoint = [[CLLocation alloc] initWithLatitude:aPoint.latitude longitude:aPoint.longitude];
	CLLocation *endPoint = [[CLLocation alloc] initWithLatitude:bPoint.latitude longitude:bPoint.longitude];
	CLLocationDistance calculatedDistance;
	calculatedDistance = [startpoint distanceFromLocation:endPoint];
	return ((float)calculatedDistance);
}


- (CLLocationCoordinate2D)getIntermediatePointOnLineWithStartEndpointsForPoint:(CLLocationCoordinate2D)linestartpoint lineendpoint:(CLLocationCoordinate2D)lineendpoint coordinate:(CLLocationCoordinate2D)coordinate {
    NSUInteger starttopoint = [self calculateDistance: coordinate bPoint: linestartpoint];
    //NSUInteger endtopoint = [self calculateDistance: coordinate bPoint: lineendpoint];
    NSUInteger linedistance = [self calculateDistance:linestartpoint bPoint: lineendpoint];
    
    CGFloat verticalcheck = lineendpoint.latitude - linestartpoint.latitude;
    CGFloat horizontalcheck = lineendpoint.longitude - linestartpoint.longitude;
    
    //NSLog(@"Checks: %.6f, %.6f", verticalcheck, horizontalcheck);
    
    if (verticalcheck == 0) {
        CGFloat factor = starttopoint / linedistance;
        CGFloat lat = linestartpoint.latitude;
        CGFloat lng = lineendpoint.longitude + factor * horizontalcheck;
        CLLocationCoordinate2D middlepoint = CLLocationCoordinate2DMake(lat, lng);
        return middlepoint;
        
    } else if (horizontalcheck == 0) {
        CGFloat factor = starttopoint / linedistance;
        CGFloat lat = linestartpoint.latitude + factor * verticalcheck;
        CGFloat lng = linestartpoint.longitude;
        CLLocationCoordinate2D middlepoint = CLLocationCoordinate2DMake(lat, lng);
        return middlepoint;
        
        
    }
    
    double factor = (double)starttopoint / (double)linedistance;
    
    //NSLog(@"Factor: %d, %d / %.6f", starttopoint, linedistance, factor);
    
    CGFloat lat = linestartpoint.latitude + factor * verticalcheck;
    CGFloat lng = linestartpoint.longitude + factor * horizontalcheck;
    CLLocationCoordinate2D middlepoint = CLLocationCoordinate2DMake(lat, lng);
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"Middle point: %.6f, %.6f", middlepoint.latitude, middlepoint.longitude);
    #endif
    
    return middlepoint;
}

/*
- (CLLocationCoordinate2D)getIntermediatePointOnLineForPoint:(TrainlinesLine *)line coordinate:(CLLocationCoordinate2D)coordinate {
    NSUInteger starttopoint = [self calculateDistance: coordinate bPoint: [line getEndpointWithoutReverseorderflag]];
    //NSUInteger endtopoint = [self calculateDistance: coordinate bPoint: lineendpoint];
    NSUInteger linedistance = line.linedistance;
    
    CGFloat verticalcheck = [line getEndpointWithoutReverseorderflag].latitude - [line getStartpointWithoutReverseorderflag].latitude;
    CGFloat horizontalcheck = [line getEndpointWithoutReverseorderflag].longitude - [line getStartpointWithoutReverseorderflag].longitude;
    
    if (verticalcheck == 0) {
        CGFloat factor = starttopoint / linedistance;
        CGFloat lat = [line getStartpointWithoutReverseorderflag].latitude;
        CGFloat lng = [line getStartpointWithoutReverseorderflag].longitude + factor * horizontalcheck;
        CLLocationCoordinate2D middlepoint = CLLocationCoordinate2DMake(lat, lng);
        return middlepoint;
        
    } else if (horizontalcheck == 0) {
        CGFloat factor = starttopoint / linedistance;
        CGFloat lat = [line getStartpointWithoutReverseorderflag].latitude + factor * verticalcheck;
        CGFloat lng = [line getStartpointWithoutReverseorderflag].longitude;
        CLLocationCoordinate2D middlepoint = CLLocationCoordinate2DMake(lat, lng);
        return middlepoint;
        
        
    }
    
    double factor = (double)starttopoint / (double)linedistance;
    CGFloat lat = [line getStartpointWithoutReverseorderflag].latitude + factor * verticalcheck;
    CGFloat lng = [line getStartpointWithoutReverseorderflag].longitude + factor * horizontalcheck;
    CLLocationCoordinate2D middlepoint = CLLocationCoordinate2DMake(lat, lng);
    NSLog(@"Line: %d / %.6f, %.6f / %.6f, %.6f", line.lineId, [line getStartpointWithoutReverseorderflag].latitude, [line getStartpointWithoutReverseorderflag].longitude, [line getEndpointWithoutReverseorderflag].latitude , [line getEndpointWithoutReverseorderflag].longitude);
    NSLog(@"Coordinate: %.6f, %.6f", coordinate.latitude, coordinate.longitude);
    NSLog(@"Middle point: %.6f, %.6f", middlepoint.latitude, middlepoint.longitude);
    NSLog(@"Distances: %d, %d", starttopoint, linedistance);
    
    return middlepoint;
}

- (BOOL)isPointBetweenLinesegmentStartEndpoint:(TrainlinesLine *)line coordinate:(CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D linestartpoint = [line getStartpointWithoutReverseorderflag];
    CLLocationCoordinate2D lineendpoint = [line getEndpointWithoutReverseorderflag];
    
    NSUInteger starttopoint = [self calculateDistance: coordinate bPoint: linestartpoint];
    NSUInteger endtopoint = [self calculateDistance: coordinate bPoint: lineendpoint];
    
    if (starttopoint < line.linedistance && endtopoint < line.linedistance) {
        NSLog(@"isPointBetweenLinesegmentStartEndpoint: Distances: %d, %d / Dev: %d", starttopoint, endtopoint, (starttopoint + endtopoint - line.linedistance));
        return YES;
    }
    return NO;
}
*/

- (void) setTrainlinesControllerDetaillevel:(NSUInteger)detaillevel {
    if (detaillevel <= 4) {
        self.detaillevel = detaillevel;
    }
}

- (NSString *)getSimpleExternalid:(NSString *)externalid {
    if (externalid) {
        NSArray *splitarray = [externalid componentsSeparatedByString: @"#"];
        if (splitarray && splitarray.count == 2) {
            //NSString *clean_id = [NSString stringWithFormat:@"%d", [[splitarray objectAtIndex: 0] intValue]];
            
            return [splitarray objectAtIndex: 0];
        }
    }
    
    return externalid;
}

// --------------------------------------------------------------------------------------------

- (NSArray *)getLinesByRouteId:(NSNumber *)routeid detaillevel:(NSUInteger)detaillevel {
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *dbpath = [bundlePath stringByAppendingPathComponent:ROUTELINEDB];
    FMDatabase *database = [FMDatabase databaseWithPath:dbpath];
    
    if (![database open]) {
        NSLog(@"Could not open trainline database");
        return nil;
    }

    //NSString *queryString = [NSString stringWithFormat: @"select tracklines.trackline_id, tracklines.line_geom_dt%d from tracklines, trainroutes_tracklines where trainroutes_tracklines.trainroute_id = %@ and tracklines.trackline_id = trainroutes_tracklines.trackline_id", detaillevel, routeid];
    NSString *queryString = [NSString stringWithFormat: @"select tracklines.trackline_id, tracklines.line_geometry from tracklines, trainroutes_tracklines where trainroutes_tracklines.trainroute_id = %@ and tracklines.trackline_id = trainroutes_tracklines.trackline_id",routeid];
    FMResultSet *s = [database executeQuery:queryString];
    
    NSMutableArray *lines = [NSMutableArray arrayWithCapacity: 1];
    while ([s next]) {
        NSUInteger lineid = [s intForColumnIndex: 0];
        NSData *geometrydata = [s dataForColumnIndex: 1];
        
        #ifdef TrainlineLogLevelFull
        NSUInteger geomlength = [geometrydata length];
        NSUInteger geomlenwoheader = geomlength - 2;
        CGFloat geomblock = geomlenwoheader / 8;
        NSLog(@"Line: %d, len: %d, lenwoheader: %d, blocks: %.2f", lineid, geomlength, geomlenwoheader, geomblock);
        #endif
        
        TrainlinesLine *line = [[TrainlinesLine alloc] initWithIdAndGeometrydata: lineid geometrydata: geometrydata];
        [lines addObject: line];
    }
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"TrainlinesController. Got number of lines : %d", [lines count]);
    #endif
    
    [database close];
    return lines;
}

- (NSArray *) getStationsByRouteid:(NSNumber *)routeid {
    if (routeid) {
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *dbpath = [bundlePath stringByAppendingPathComponent:ROUTELINEDB];
        FMDatabase *database = [FMDatabase databaseWithPath:dbpath];
        
        if (![database open]) {
            NSLog(@"Could not open trainline database");
            return nil;
        }
        
        NSString *queryString = [NSString stringWithFormat: @"select distinct a.trainstation_id, a.trainstation_name, a.trainstation_lng, a.trainstation_lat, a.trainstation_extid from trainstations a, trainroutes_trainstations b where a.trainstation_id = b.trainstation_id and b.trainroute_id = %@ order by b.trainstation_order", routeid];
        FMResultSet *s = [database executeQuery:queryString];
        
        NSMutableArray *stations = [NSMutableArray array];
        
        TrainlinesStation *trainlineStation = nil;
        while ([s next]) {
            NSUInteger stationid = [s intForColumnIndex: 0];
            NSString *stationname = [s stringForColumnIndex: 1];
            double longitude = [s doubleForColumnIndex: 2];
            double latitude = [s doubleForColumnIndex: 3];
            NSString *externalid = [s stringForColumnIndex: 4];
                        
            trainlineStation = [[TrainlinesStation alloc] initWithId:stationid name:stationname externalid:externalid latitude:latitude longitude:longitude];
            
            [stations addObject: trainlineStation];
        }
        
        [database close];
        return stations;
        
    }
    return nil;
}

- (void)logPasslist:(NSArray *)passlist {
    if (passlist && passlist.count > 0) {
        for (BasicStop *currenstop in passlist) {
            Station *currentstation = [self getStationForBasicStop: currenstop];
            NSLog(@"Passlist station: %@, %@, %.6f, %.6f", currentstation.stationName, currentstation.stationId, [currentstation.latitude doubleValue], [currentstation.longitude doubleValue]);
        }
    }
}

- (void)logStationsByRouteId:(NSNumber *)routeid {
    NSArray *stations = [self getStationsByRouteid: routeid];
    if (stations && stations.count > 0) {
        for (TrainlinesStation *currentstation in stations) {
            NSLog(@"LogStationsByRouterNumber: %@", currentstation.stationname);
        }
    }
}

- (void)logCommonRouteIds:(NSArray *)routeids {
    if (routeids && routeids.count > 0) {
        for (NSString *currentrouteid in routeids) {
            NSLog(@"LogCommonRouteIds: %@", currentrouteid);
        }
    }
}

- (void)logRouteIdsOfRoutesegment:(NSArray *)routesegments {
    if (routesegments && routesegments.count > 0) {
        for (RouteSegment *currentroutesegment in routesegments) {
            NSLog(@"LogRouteidOfRoutesegment: %@", currentroutesegment.routeid);
        }
    }
}

- (void)logRouteIdsAndDistanceOfRoutesegment:(NSArray *)routesegments {
    if (routesegments && routesegments.count > 0) {
        for (RouteSegment *currentroutesegment in routesegments) {
            NSLog(@"LogRouteidOfRoutesegment: %@, %d", currentroutesegment.routeid, currentroutesegment.routedistance);
        }
    }
}

- (void)logLineidsForRoutesegment:(RouteSegment *)routesegment {
    if (routesegment) {
        NSUInteger numberoflines = [routesegment getNumbersOfRouteLines];
        for (int i = 0; i < numberoflines; i++) {
            TrainlinesLine *currentline = [routesegment.routelines objectAtIndex: i];
            NSNumber *reverseflagnum = [routesegment.routelinesreversegeomflags objectAtIndex: i];
            BOOL reverseflag = [reverseflagnum integerValue] == 1;
            //NSLog(@"LogLineidsForRoutesegment: %d. Geom turned: %@ / Geom flag: %@", currentline.lineId, currentline.readGeometryDataInReverseOrder?@"Y":@"N", reverseflag?@"Y":@"N");
            NSLog(@"LogLineidsForRoutesegment: %d. Geom flag: %@", currentline.lineId, reverseflag?@"Y":@"N");
        }
    }
}

- (void)logWaypointsForRoutesegment:(RouteSegment *)routesegment {
    if (routesegment && routesegment.waypoints && routesegment.waypoints.count > 0) {
        NSLog(@"Current route: %@, waypoints: %d", routesegment.routeid, routesegment.waypoints.count);
        for (int i = 0; i < routesegment.waypoints.count; i++) {
            MTDWaypoint *currentpoint = [routesegment.waypoints objectAtIndex: i];
            NSLog(@"Current waypoint: %d, %.6f, %.6f", i, currentpoint.coordinate.latitude, currentpoint.coordinate.longitude);
        }
    }
}

- (void)logPointsForRoutesegment:(RouteSegment *)routesegment {
    if (routesegment) {
        if (routesegment.endedwithrouteend) {
            NSLog(@"Route ended with end");
        }
        if (routesegment.endedwithstation) {
            NSLog(@"Route ended with station");
        }
        if (routesegment.startcutblock) {
            if (routesegment.startcutblock.pointmatch) {
                NSLog(@"Route has startcutblock: pointmatch: %d, %.6f, %.6f", routesegment.startcutblock.pointmatchpointindex, routesegment.startcutblock.pointmatchcoordinate.latitude, routesegment.startcutblock.pointmatchcoordinate.longitude);
            } else {
                NSLog(@"Route has startcutblock: middlepoint: %d, %d, %.6f, %.6f", routesegment.startcutblock.nopointmatchstartpointindex, routesegment.startcutblock.nopointmatchendpointindex, routesegment.startcutblock.nopointmatchmiddlecoordinate.latitude, routesegment.startcutblock.nopointmatchmiddlecoordinate.longitude);
            }
        }
        if (routesegment.endcutblock) {
            if (routesegment.endcutblock.pointmatch) {
                NSLog(@"Route has endcutblock: pointmatch: %d, %.6f, %.6f", routesegment.endcutblock.pointmatchpointindex, routesegment.endcutblock.pointmatchcoordinate.latitude, routesegment.endcutblock.pointmatchcoordinate.longitude);
            } else {
                NSLog(@"Route has endcutblock: middlepoint: %d, %d, %.6f, %.6f", routesegment.endcutblock.nopointmatchstartpointindex, routesegment.endcutblock.nopointmatchendpointindex, routesegment.endcutblock.nopointmatchmiddlecoordinate.latitude, routesegment.endcutblock.nopointmatchmiddlecoordinate.longitude);
            }
        }
        
        
        NSUInteger numberoflines = [routesegment getNumbersOfRouteLines];
        for (int i = 0; i < numberoflines; i++) {
            TrainlinesLine *currentline = [routesegment.routelines objectAtIndex: i];
            NSNumber *reverseflagnum = [routesegment.routelinesreversegeomflags objectAtIndex: i];
            BOOL reverseflag = [reverseflagnum integerValue] == 1;
            //NSLog(@"LogLineidsForRoutesegment: %d. Geom turned: %@ / Geom flag: %@", currentline.lineId, currentline.readGeometryDataInReverseOrder?@"Y":@"N", reverseflag?@"Y":@"N");
            NSLog(@"LogLineidsForRoutesegment: %d. Geom flag: %@", currentline.lineId, reverseflag?@"Y":@"N");
            NSUInteger numberofpoints = [currentline getNumberOfPoints];
            for (int z = 0; z < numberofpoints; z++) {
                CLLocationCoordinate2D coordinate = [currentline getPointAtIndexWithReverseorderflag: z reverseorder: reverseflag];
                NSLog(@"Current line points: %.6f, %.6f", coordinate.latitude, coordinate.longitude);
            }
        }
    }
}

- (NSArray *) getCommonRouteIdsForStations:(Station *)startstation endstation:(Station *)endstation {
    if (startstation && endstation && startstation.stationId && endstation.stationId) {
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *dbpath = [bundlePath stringByAppendingPathComponent:ROUTELINEDB];
        FMDatabase *database = [FMDatabase databaseWithPath:dbpath];
        
        if (![database open]) {
            NSLog(@"Could not open trainline database");
            return nil;
        }
        
        NSString *simpleexternalidstartstation = [self getSimpleExternalid: startstation.stationId];
        NSString *simpleexternalidendstation = [self getSimpleExternalid: endstation.stationId];
        
        NSString *queryString = [NSString stringWithFormat: @"select distinct trainroute_id from trainroutes_trainstations where trainstation_id in (select distinct trainstation_id from trainstations where trainstation_extid = '%@') and trainroute_id in (select distinct trainroute_id from trainroutes_trainstations, trainstations where trainroutes_trainstations.trainstation_id = trainstations.trainstation_id AND trainstations.trainstation_extid = '%@');", simpleexternalidstartstation, simpleexternalidendstation];
        FMResultSet *s = [database executeQuery:queryString];
        
        NSMutableArray *routenumbers = [NSMutableArray arrayWithCapacity: 1];
        while ([s next]) {
            NSNumber *routeid = [NSNumber numberWithInt: [s intForColumnIndex: 0]];
            [routenumbers addObject: routeid];
        }
        
        [database close];
        return routenumbers;
    }
    return nil;
}

- (BOOL) areStationsOnCommonRoute:(Station *)startstation endstation:(Station *)endstation {
    
    if (startstation && endstation && startstation.stationId && endstation.stationId) {
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *dbpath = [bundlePath stringByAppendingPathComponent:ROUTELINEDB];
        FMDatabase *database = [FMDatabase databaseWithPath:dbpath];
        
        if (![database open]) {
            NSLog(@"Could not open trainline database");
            return NO;
        }
        
        NSString *simpleexternalidstartstation = [self getSimpleExternalid: startstation.stationId];
        NSString *simpleexternalidendstation = [self getSimpleExternalid: endstation.stationId];
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"AreStationsOnCommonRoute: %@, %@, / %@, %@", startstation.stationName, simpleexternalidstartstation, endstation.stationName, simpleexternalidendstation);
        #endif
        
        NSString *queryString = [NSString stringWithFormat: @"select distinct trainroute_id from trainroutes_trainstations where trainstation_id in (select distinct trainstation_id from trainstations where trainstation_extid = '%@') and trainroute_id in (select distinct trainroute_id from trainroutes_trainstations, trainstations where trainroutes_trainstations.trainstation_id = trainstations.trainstation_id AND trainstations.trainstation_extid = '%@');", simpleexternalidstartstation, simpleexternalidendstation];
        
        FMResultSet *s = [database executeQuery:queryString];
        
        NSUInteger routecount = 0;
        
        while ([s next]) {
            routecount++;
        }
        
        [database close];
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"AreStationsOnCommonRoute (to): %@", (routecount>0)?@"Y":@"N");
        #endif
        
        return (routecount > 0);
    }
    return NO;
}

// --------------------------------------------------------------------------------------------


- (double)orthogonalDistanceWithPoint:(CLLocationCoordinate2D)point lineStart:(CLLocationCoordinate2D)lineStart lineEnd:(CLLocationCoordinate2D)lineEnd
{
    double area = 0.0, bottom = 0.0, height = 0.0;
    area = ABS(
               (
                lineStart.latitude * lineEnd.longitude
                + lineEnd.latitude * point.longitude
                + point.latitude * lineStart.longitude
                - lineEnd.latitude * lineStart.longitude
                - point.latitude * lineEnd.longitude
                - lineStart.latitude * point.longitude
                ) / 2.0);
    
    bottom = sqrt(pow(lineStart.latitude - lineEnd.latitude, 2) +
                  pow(lineStart.longitude - lineEnd.longitude, 2));
    
    height = area / bottom * 2.0;
    
    return height;
}

- (BOOL)isClosestCoordinateStartcoordinateOfLine:(TrainlinesLine *)line coordinate:(CLLocationCoordinate2D)coordinate {
    if (line) {
        NSUInteger startpointdistance = [self calculateDistance: coordinate bPoint: [line getStartpointWithoutReverseorderflag]];
        NSUInteger endpointdistance = [self calculateDistance: coordinate bPoint: [line getEndpointWithoutReverseorderflag]];
        if (startpointdistance < endpointdistance) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isEndpointReachedWithRoutesegmentWithLineForEndstation:(RouteSegment *)routesegment line:(TrainlinesLine *)line station:(Station *)station reverseorder:(BOOL)reverseorder  lineindex:(NSUInteger)lineindex {
    if (routesegment && line && station) {
        CLLocationCoordinate2D stationcoordindate = CLLocationCoordinate2DMake([station.latitude doubleValue], [station.longitude doubleValue]);
        NSUInteger startpointdistance = [self calculateDistance: stationcoordindate bPoint: [line getStartpointWithoutReverseorderflag]];
        NSUInteger endpointdistance = [self calculateDistance: stationcoordindate bPoint: [line getEndpointWithoutReverseorderflag]];
        NSUInteger linedistance = line.linedistance;
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"Check end point is reached for route. Check with line: %d %d, %d", line.lineId, reverseorder, lineindex);
        #endif
        
        if (startpointdistance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT || endpointdistance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"End point is reached for route. Start/End point proximity. Distance : %d, %d", startpointdistance, endpointdistance);
            #endif
            
            return YES;
        } else {
            if (startpointdistance < linedistance && endpointdistance < linedistance) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"End point is reached for route. Station potentially on line");
                #endif
                
                NSUInteger numberofpoints = [line getNumberOfPoints];
                
                NSUInteger minindex = 0;
                if (([routesegment getNumbersOfRouteLines] == 1 && routesegment.startcutblock)) {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"End point is reached for route. Station potentially on line. Route is first line and has startcutblock");
                    #endif
                    
                    NSUInteger minindextest = 0;
                    if (routesegment.startcutblock.pointmatch) {
                        minindextest = routesegment.startcutblock.pointmatchpointindex;
                    } else {
                        minindextest = routesegment.startcutblock.nopointmatchendpointindex;
                    }
                    if (numberofpoints >= minindextest) {
                        minindex = minindextest;
                    }
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"End point is reached for route. Station potentially on line. Route is first line and has startcutblock. Start with point: %d", minindex);
                    #endif
                
                }
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"Check for point on line with number of points: %d, minindex: %d", numberofpoints, minindex);
                #endif
                
                
                for (int i = minindex; i < numberofpoints - 1; i++) {
                    CLLocationCoordinate2D linepointstart = [line getPointAtIndexWithReverseorderflag: i reverseorder: reverseorder];
                    CLLocationCoordinate2D linepointend = [line getPointAtIndexWithReverseorderflag: i + 1 reverseorder: reverseorder];
                    
                    NSUInteger linesegmentstartpointdistance = [self calculateDistance: stationcoordindate bPoint: linepointstart];
                    NSUInteger linesegmentendpointdistance = [self calculateDistance: stationcoordindate bPoint: linepointend];
                    NSUInteger linesegmentdistance = [self calculateDistance: linepointstart bPoint: linepointend];
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Line point start: %d, %.6f, %.6f", i,linepointstart.latitude, linepointstart.longitude);
                    NSLog(@"Line point end: %d, %.6f, %.6f", i+1, linepointend.latitude, linepointend.longitude);
                    NSLog(@"Distances: %d, %d, %d", linesegmentdistance, linesegmentstartpointdistance, linesegmentendpointdistance);
                    #endif
                    
                    if (linesegmentstartpointdistance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT || linesegmentendpointdistance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                        if (linesegmentstartpointdistance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                           
                           #ifdef TrainlineLogLevelFull 
                            NSLog(@"End point is reached for route. Station on start point at index: %d / %.6f, %.6f", i, linepointstart.latitude, linepointend.longitude);
                            #endif
                            
                            RouteLineCutBlock *cutblock = [[RouteLineCutBlock alloc] init];
                            cutblock.lineid = line.lineId;
                            cutblock.lineindex = lineindex;
                            cutblock.pointmatch = YES;
                            cutblock.pointmatchpointindex = i;
                            cutblock.pointmatchcoordinate = linepointstart;
                            routesegment.endcutblock = cutblock;
                            return YES;
                        } else {
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"End point is reached for route. Station on end point at index: %d / %.6f, %.6f", i + 1, linepointend.latitude, linepointend.longitude);
                            #endif
                            
                            RouteLineCutBlock *cutblock = [[RouteLineCutBlock alloc] init];
                            cutblock.lineid = line.lineId;
                            cutblock.lineindex = lineindex;
                            cutblock.pointmatch = YES;
                            cutblock.pointmatchpointindex = i + 1;
                            cutblock.pointmatchcoordinate = linepointend;
                            routesegment.endcutblock = cutblock;
                            return YES;
                        }
                    } else if (linesegmentstartpointdistance < linesegmentdistance && linesegmentendpointdistance < linesegmentdistance){
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"End point is reached for route. Station potentially on line segment within line. Indexes: %d, %d", i, i+1);
                        #endif
                        
                        double mindistancepointtoline = [self orthogonalDistanceWithPoint:stationcoordindate lineStart:linepointstart lineEnd:linepointend];
                        double mindistanceapproxkms = mindistancepointtoline * 111000;
                        
                        BOOL pointbetweenstartend = linesegmentstartpointdistance < linesegmentdistance && linesegmentendpointdistance < linesegmentdistance;
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Distance of station to line: %@ / %.6f, %.1f",  pointbetweenstartend?@"Y":@"N", mindistancepointtoline, mindistanceapproxkms);
                        #endif
                        
                        if (pointbetweenstartend && mindistanceapproxkms <= 200) {
                            CLLocationCoordinate2D middlepoint = [self getIntermediatePointOnLineWithStartEndpointsForPoint: linepointstart lineendpoint: linepointend coordinate:stationcoordindate];
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"End point is reached for route. Station potentially on line segment within line: %d, %d / %.6f, %.6f", i, i + 1, middlepoint.latitude, middlepoint.longitude);
                            #endif
                            
                            RouteLineCutBlock *cutblock = [[RouteLineCutBlock alloc] init];
                            cutblock.lineid = line.lineId;
                            cutblock.lineindex = lineindex;
                            cutblock.pointmatch = NO;
                            cutblock.nopointmatchstartpointindex = i;
                            cutblock.nopointmatchendpointindex = i + 1;
                            cutblock.nopointmatchmiddlecoordinate = middlepoint;
                            routesegment.endcutblock = cutblock;
                            return YES;
                        }
                    }
                }
                
            } else {
                return NO;
            }
        }
    }
    return NO;
}

- (NSMutableArray *)getInitialStartRoutesegmentForStartstationcoordinateWithlines:(NSArray *)lines coordinate:(CLLocationCoordinate2D)coordinate routeid:(NSNumber *)routeid endstation:(Station *)endstation {
    if (lines && lines.count > 0) {
        
        NSMutableArray *initialstartroutesegments = [NSMutableArray array];
        CLLocationCoordinate2D endstationcoordinate = CLLocationCoordinate2DMake([endstation.latitude doubleValue], [endstation.longitude doubleValue]);
        
        for (TrainlinesLine *currentline in lines) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. Processing line: %d", currentline.lineId);
            #endif
            
            NSUInteger startpointdistance = [self calculateDistance: coordinate bPoint: [currentline getStartpointWithoutReverseorderflag]];
            NSUInteger endpointdistance = [self calculateDistance: coordinate bPoint: [currentline getEndpointWithoutReverseorderflag]];
            NSUInteger linedistance = currentline.linedistance;
            
            NSUInteger endpointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: [currentline getEndpointWithoutReverseorderflag]];
            NSUInteger startpointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: [currentline getStartpointWithoutReverseorderflag]];
            
            if (startpointdistance <= TRAINSTATIONMAXRANGETOLINESTARTENDPOINT || endpointdistance <= TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. Line %d matched with start / endpoint. Distances: %d, %d", currentline.lineId, startpointdistance, endpointdistance);
                #endif
                
                if (startpointdistance <= TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. Line matched with startpoint. Distance: %d", startpointdistance);
                    #endif
                    
                    RouteSegment *routesegment = [[RouteSegment alloc] init];
                    routesegment.routedistance += currentline.linedistance;
                    routesegment.linesegments = [NSMutableArray arrayWithArray: lines];
                    routesegment.routeid = routeid;
                    [routesegment removeLineByLineFromRoutesegmentlines: currentline];
                    [routesegment.routelines addObject: currentline];
                    [routesegment.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 0]];
                    routesegment.routestartlocation = coordinate;
                    routesegment.routeendlocation = endstationcoordinate;
                    
                    if (startpointtoendstationdistance < endpointtoendstationdistance) {
                        routesegment.leadsawaysfromdestinationpoints++;
                    }
                    
                    if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: routesegment line: currentline station: endstation reverseorder: NO lineindex: 0]) {
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. Line matched with startpoint. End point already reached");
                        #endif
                        
                        routesegment.ended = YES;
                        routesegment.endedwithstation = YES;
                    }
                    
                    [initialstartroutesegments addObject: routesegment];
                } else {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. Line matched with endpoint. Distance: %d", endpointdistance);
                    #endif
                    
                    RouteSegment *routesegment = [[RouteSegment alloc] init];
                    routesegment.routedistance += currentline.linedistance;
                    routesegment.linesegments = [NSMutableArray arrayWithArray: lines];
                    routesegment.routeid = routeid;
                    [routesegment removeLineByLineFromRoutesegmentlines: currentline];
                    [routesegment.routelines addObject: currentline];
                    [routesegment.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 1]];
                    routesegment.routestartlocation = coordinate;
                    routesegment.routeendlocation = endstationcoordinate;
                    
                    if (startpointtoendstationdistance > endpointtoendstationdistance) {
                        routesegment.leadsawaysfromdestinationpoints++;
                    }
                    
                    if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: routesegment line: currentline station: endstation reverseorder: YES lineindex: 0]) {
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. Line matched with endpoint. End point already reached");
                        #endif
                        
                        routesegment.ended = YES;
                        routesegment.endedwithstation = YES;
                    }
                    
                    [initialstartroutesegments addObject: routesegment];
                }
            } else if (startpointdistance < linedistance && endpointdistance < linedistance) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. Start point potentially on line %d. Distances: %d, %d / %d", currentline.lineId, startpointdistance, endpointdistance, linedistance);
                NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. Start point: %.6f, %.6f", [currentline getStartpointWithoutReverseorderflag].latitude, [currentline getStartpointWithoutReverseorderflag].longitude);
                NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. End point: %.6f, %.6f", [currentline getEndpointWithoutReverseorderflag].latitude, [currentline getEndpointWithoutReverseorderflag].longitude);
                #endif
                
                NSUInteger numberofpoints = [currentline getNumberOfPoints];
                for (int i = 0; i < numberofpoints - 1; i++) {
                    CLLocationCoordinate2D linepointstart = [currentline getPointAtIndexWithReverseorderflag: i reverseorder: NO];
                    CLLocationCoordinate2D linepointend = [currentline getPointAtIndexWithReverseorderflag: i + 1 reverseorder: NO];
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Check line start point: %d, %.6f, %.6f", i, linepointstart.latitude, linepointstart.longitude);
                    NSLog(@"Check line end point: %d, %.6f, %.6f", i+1, linepointend.latitude, linepointend.longitude);
                    #endif
                    
                    NSUInteger linesegmentstartpointdistance = [self calculateDistance: coordinate bPoint: linepointstart];
                    NSUInteger linesegmentendpointdistance = [self calculateDistance: coordinate bPoint: linepointend];
                    NSUInteger linesegmentdistance = [self calculateDistance: linepointstart bPoint: linepointend];
                    
                    //double mindistancepointtoline = [self orthogonalDistanceWithPoint:coordinate lineStart:linepointstart lineEnd:linepointend];
                    //double mindistanceapproxkms = mindistancepointtoline * 111000;
                    
                    //BOOL pointbetweenstartend = linesegmentstartpointdistance < linesegmentdistance && linesegmentendpointdistance < linesegmentdistance;
                    //NSLog(@"Distance of station to line: %@ / %.6f, %.1f",  pointbetweenstartend?@"Y":@"N", mindistancepointtoline, mindistanceapproxkms);
                    
                    if (linesegmentstartpointdistance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT || linesegmentendpointdistance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                        NSUInteger NoReverseStartindex = i;
                        NSUInteger NoReverseEndIndex = i + 1;
                        NSUInteger ReverseStartIndex = numberofpoints - i - 2;
                        NSUInteger ReverseEndIndex = numberofpoints - i - 1;
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"getInitialStartRoutesegmentForStartstationcoordinateWithlines. Start point potentially on line %d, within linesegment: %d, %d. Max range: %.1f, distance: %d, %d", currentline.lineId, NoReverseStartindex, NoReverseEndIndex, TRAINSTATIONMAXRANGETOLINESTARTENDPOINT, linesegmentstartpointdistance, linesegmentendpointdistance);
                        #endif
                        
                        RouteSegment *routesegment = [[RouteSegment alloc] init];
                        routesegment.routedistance += currentline.linedistance;
                        routesegment.linesegments = [NSMutableArray arrayWithArray: lines];
                        routesegment.routeid = routeid;
                        [routesegment removeLineByLineFromRoutesegmentlines: currentline];
                        [routesegment.routelines addObject: currentline];
                        [routesegment.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 0]];
                        routesegment.routestartlocation = coordinate;
                        routesegment.routeendlocation = endstationcoordinate;
                        
                        RouteSegment *routesegmentreversed = [[RouteSegment alloc] init];
                        routesegmentreversed.routedistance += currentline.linedistance;
                        routesegmentreversed.linesegments = [NSMutableArray arrayWithArray: lines];
                        routesegmentreversed.routeid = routeid;
                        [routesegmentreversed removeLineByLineFromRoutesegmentlines: currentline];
                        [routesegmentreversed.routelines addObject: currentline];
                        [routesegmentreversed.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 1]];
                        routesegmentreversed.routestartlocation = coordinate;
                        routesegmentreversed.routeendlocation = endstationcoordinate;
                        
                        if (linesegmentstartpointdistance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Start point is reached for initial route 1. Station on start point at index: %d / %.6f, %.6f", i, linepointstart.latitude, linepointend.longitude);
                            #endif
                            
                            RouteLineCutBlock *cutblock = [[RouteLineCutBlock alloc] init];
                            cutblock.lineid = currentline.lineId;
                            cutblock.lineindex = 0;
                            cutblock.pointmatch = YES;
                            cutblock.pointmatchpointindex = NoReverseStartindex;
                            cutblock.pointmatchcoordinate = linepointstart;
                            routesegment.startcutblock = cutblock;
                            
                            RouteLineCutBlock *cutblockreversed = [[RouteLineCutBlock alloc] init];
                            cutblockreversed.lineid = currentline.lineId;
                            cutblockreversed.lineindex = 0;
                            cutblockreversed.pointmatch = YES;
                            cutblockreversed.pointmatchpointindex = ReverseEndIndex;
                            cutblockreversed.pointmatchcoordinate = linepointstart;
                            routesegmentreversed.startcutblock = cutblockreversed;
                            
                            NSUInteger linestartpointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: linepointstart];
                            if (linestartpointtoendstationdistance < endpointtoendstationdistance) {
                                routesegment.leadsawaysfromdestinationpoints++;
                            }
                            if (linestartpointtoendstationdistance < startpointtoendstationdistance) {
                                routesegmentreversed.leadsawaysfromdestinationpoints++;
                            }
                            
                            
                            if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: routesegment line: currentline station: endstation reverseorder: NO lineindex: 0]) {
                                routesegment.ended = YES;
                                routesegment.endedwithstation = YES;
                            }
                            
                            if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: routesegmentreversed line: currentline station: endstation reverseorder: YES lineindex: 0]) {
                                routesegmentreversed.ended = YES;
                                routesegmentreversed.endedwithstation = YES;
                            }
                            
                            [initialstartroutesegments addObject: routesegment];
                            [initialstartroutesegments addObject: routesegmentreversed];
                            
                        } else {
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Start point is reached for initial route 2. Station on end point at index: %d / %.6f, %.6f", i + 1, linepointend.latitude, linepointend.longitude);
                            #endif
                            
                            RouteLineCutBlock *cutblock = [[RouteLineCutBlock alloc] init];
                            cutblock.lineid = currentline.lineId;
                            cutblock.lineindex = 0;
                            cutblock.pointmatch = YES;
                            cutblock.pointmatchpointindex = NoReverseEndIndex;
                            cutblock.pointmatchcoordinate = linepointend;
                            routesegment.startcutblock = cutblock;
                            
                            RouteLineCutBlock *cutblockreversed = [[RouteLineCutBlock alloc] init];
                            cutblockreversed.lineid = currentline.lineId;
                            cutblockreversed.lineindex = 0;
                            cutblockreversed.pointmatch = YES;
                            cutblockreversed.pointmatchpointindex = ReverseStartIndex;
                            cutblockreversed.pointmatchcoordinate = linepointend;
                            routesegmentreversed.startcutblock = cutblockreversed;
                            
                            NSUInteger lineendpointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: linepointend];
                            if (lineendpointtoendstationdistance < endpointtoendstationdistance) {
                                routesegment.leadsawaysfromdestinationpoints++;
                            }
                            if (lineendpointtoendstationdistance < startpointtoendstationdistance) {
                                routesegmentreversed.leadsawaysfromdestinationpoints++;
                            }
                            
                            
                            if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: routesegment line: currentline station: endstation reverseorder: NO lineindex: 0]) {
                                routesegment.ended = YES;
                                routesegment.endedwithstation = YES;
                            }
                            
                            if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: routesegmentreversed line: currentline station: endstation reverseorder: YES lineindex: 0]) {
                                routesegmentreversed.ended = YES;
                                routesegmentreversed.endedwithstation = YES;
                            }
                            
                            [initialstartroutesegments addObject: routesegment];
                            [initialstartroutesegments addObject: routesegmentreversed];
                        }
                    } else if (linesegmentstartpointdistance < linesegmentdistance && linesegmentendpointdistance < linesegmentdistance){
                        
                        BOOL pointbetweenstartend = linesegmentstartpointdistance < linesegmentdistance && linesegmentendpointdistance < linesegmentdistance;
                        double mindistancepointtoline = [self orthogonalDistanceWithPoint:coordinate lineStart:linepointstart lineEnd:linepointend];
                        double mindistanceapproxkms = mindistancepointtoline * 111000;
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Start point is reached for initial route 3. Station potentially on line segment within line: %d, %d", i, i + 1);
                        NSLog(@"Distance of station to line: %@ / %.6f, %.1f",  pointbetweenstartend?@"Y":@"N", mindistancepointtoline, mindistanceapproxkms);
                        #endif
                        
                        if (pointbetweenstartend && mindistanceapproxkms <= 200) {
                            CLLocationCoordinate2D middlepoint = [self getIntermediatePointOnLineWithStartEndpointsForPoint: linepointstart lineendpoint: linepointend coordinate:coordinate];
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Start point is reached for initial route 4. Station potentially on line segment within line: %d, %d / %.6f, %.6f", i, i + 1, middlepoint.latitude, middlepoint.longitude);
                            #endif
                            
                            NSUInteger NoReverseStartindex = i;
                            NSUInteger NoReverseEndIndex = i + 1;
                            NSUInteger ReverseStartIndex = numberofpoints - i - 2;
                            NSUInteger ReverseEndIndex = numberofpoints - i - 1;
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Start point is reached for initial route 5. Station potentially on line segment within line. Points: %d, i: %d", numberofpoints, i);
                            
                            NSLog(@"Start point is reached for initial route 6. Station potentially on line segment within line. Indexes: %d, %d, %d, %d", NoReverseStartindex, NoReverseEndIndex, ReverseStartIndex, ReverseEndIndex);
                            #endif
                            
                            RouteSegment *routesegment = [[RouteSegment alloc] init];
                            routesegment.routedistance += currentline.linedistance;
                            routesegment.linesegments = [NSMutableArray arrayWithArray: lines];
                            routesegment.routeid = routeid;
                            [routesegment removeLineByLineFromRoutesegmentlines: currentline];
                            [routesegment.routelines addObject: currentline];
                            [routesegment.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 0]];
                            routesegment.routestartlocation = coordinate;
                            routesegment.routeendlocation = endstationcoordinate;
                            
                            RouteSegment *routesegmentreversed = [[RouteSegment alloc] init];
                            routesegmentreversed.routedistance += currentline.linedistance;
                            routesegmentreversed.linesegments = [NSMutableArray arrayWithArray: lines];
                            routesegmentreversed.routeid = routeid;
                            [routesegmentreversed removeLineByLineFromRoutesegmentlines: currentline];
                            [routesegmentreversed.routelines addObject: currentline];
                            [routesegmentreversed.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 1]];
                            routesegmentreversed.routestartlocation = coordinate;
                            routesegmentreversed.routeendlocation = endstationcoordinate;
                            
                            RouteLineCutBlock *cutblock = [[RouteLineCutBlock alloc] init];
                            cutblock.lineid = currentline.lineId;
                            cutblock.lineindex = 0;
                            cutblock.pointmatch = NO;
                            cutblock.nopointmatchstartpointindex = NoReverseStartindex;
                            cutblock.nopointmatchendpointindex = NoReverseEndIndex;
                            cutblock.nopointmatchmiddlecoordinate = middlepoint;
                            routesegment.startcutblock = cutblock;
                            
                            RouteLineCutBlock *cutblockreversed = [[RouteLineCutBlock alloc] init];
                            cutblockreversed.lineid = currentline.lineId;
                            cutblockreversed.lineindex = 0;
                            cutblockreversed.pointmatch = NO;
                            cutblockreversed.nopointmatchstartpointindex = ReverseStartIndex;
                            cutblockreversed.nopointmatchendpointindex = ReverseEndIndex;
                            cutblockreversed.nopointmatchmiddlecoordinate = middlepoint;
                            routesegmentreversed.startcutblock = cutblockreversed;
                            
                            
                            NSUInteger linemiddlepointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: middlepoint];
                            if (linemiddlepointtoendstationdistance < endpointtoendstationdistance) {
                                routesegment.leadsawaysfromdestinationpoints++;
                            }
                            if (linemiddlepointtoendstationdistance < startpointtoendstationdistance) {
                                routesegmentreversed.leadsawaysfromdestinationpoints++;
                            }
                            
                            if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: routesegment line: currentline station: endstation reverseorder: NO lineindex: 0]) {
                                routesegment.ended = YES;
                                routesegment.endedwithstation = YES;
                            }
                            
                            if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: routesegmentreversed line: currentline station: endstation reverseorder: YES lineindex: 0]) {
                                routesegmentreversed.ended = YES;
                                routesegmentreversed.endedwithstation = YES;
                            }
                            
                            [initialstartroutesegments addObject: routesegment];
                            [initialstartroutesegments addObject: routesegmentreversed];

                        }
                    }
                }
            }
        }
        return initialstartroutesegments;
    }
    
    return nil;
}

- (NSArray *)getClosestLinesFromRoutesegmentForCoordinateWithinRange:(RouteSegment *)routesegment coordinate:(CLLocationCoordinate2D)coordinate {
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"GetClosestLinesFromRoutesegmentForCoordinateWithinRange: Coordinate: %.6f, %.6f", coordinate.latitude, coordinate.longitude);
    #endif
    
    if (routesegment && [routesegment.linesegments count] > 0) {
        
        #ifdef TrainlineLogLevelFull
        NSDate *saveDate = [NSDate date];
        #endif
        
        NSMutableArray *closestlines = [NSMutableArray array];
        for (TrainlinesLine *currentline in routesegment.linesegments) {
            NSUInteger startpointdistance = [self calculateDistance: coordinate bPoint: [currentline getStartpointWithoutReverseorderflag]];
            NSUInteger endpointdistance = [self calculateDistance: coordinate bPoint: [currentline getEndpointWithoutReverseorderflag]];
            
            //NSLog(@"GetClosestLinesForCoordinateWithinRange: %d, %d", startpointdistance, endpointdistance);
            
            
            //NSUInteger distancepointtoline = [self calculateShortestDistanceBetweenLineAndPoint: currentline coordinate: coordinate];
            //NSLog(@"GetClosestLinesFromRoutesegmentForCoordinateWithinRange. Test Distance point to line: %d", distancepointtoline);
            
            
            // To implement: exclude lines with angles going backwards or at least with the highest chance, the line goes the wrong way or not leading to destination
            
            if (startpointdistance <= LINETOLINEPOINTMAXRANGE || endpointdistance <= LINETOLINEPOINTMAXRANGE) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"GetClosestLinesFromRoutesegmentForCoordinateWithinRange. Line choosen by distance: %d, %.6f, %.6f / %.6f, %.6f", currentline.lineId, [currentline getStartpointWithoutReverseorderflag].latitude, [currentline getStartpointWithoutReverseorderflag].longitude, [currentline getEndpointWithoutReverseorderflag].latitude, [currentline getEndpointWithoutReverseorderflag].longitude);
                #endif
                
                [closestlines addObject: currentline];
            } else if ([routesegment.linesegments count] == 1) {
                // To implement if only one line segment left and segment does not match with start / endpoint, try to modify point so that it matches
                
                if (startpointdistance <= LINETOLINEPOINTMAXRANGEONLYONELINELEFT || endpointdistance <= LINETOLINEPOINTMAXRANGEONLYONELINELEFT) {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"GetClosestLinesFromRoutesegmentForCoordinateWithinRange. Line choosen by one left only: %d, %.6f, %.6f / %.6f, %.6f / Distances: %d, %d", currentline.lineId, [currentline getStartpointWithoutReverseorderflag].latitude, [currentline getStartpointWithoutReverseorderflag].longitude, [currentline getEndpointWithoutReverseorderflag].latitude, [currentline getEndpointWithoutReverseorderflag].longitude, startpointdistance, endpointdistance);
                    #endif
                    
                    
                    [closestlines addObject: currentline];
                }
                
            } else {
                // To implement if no segment is within distance, try to take the closest
                
            }
        }
        
        #ifdef TrainlineLogLevelFull
        [self logTimeDifferenceWithTextAndDate: @"GetClosestLinesFromRoutesegmentForCoordinateWithinRange" date: saveDate];
        #endif
        
        return closestlines;
        
    }
    return nil;
}

- (NSArray *)getRoutesArrayByExtendingWithAdditionalLineSegmentsFromLinesTerminatingByEndstation:(NSArray *)routesarray endstation:(Station *)endstation {
    if (routesarray) {
        NSMutableArray *additionalroutesarray = [NSMutableArray array];
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"GetRoutesArrayByExtendingWithAdditionalLineSegmentsFromLines. Current number of routes: %d", routesarray.count);
        #endif
        
        NSUInteger currentrouteindex = 0;
        for (RouteSegment *currentroutesegment in routesarray) {
            
            #ifdef TrainlineLogLevelFull
            NSDate *saveDate = [NSDate date];
            #endif
            
            if (currentroutesegment.ended) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"Current route has already ended: %d, %@",  currentrouteindex, currentroutesegment.routeid);
                #endif
                //continue;
                
                currentrouteindex++;
                
                #ifdef TrainlineLogLevelFull
                [self logTimeDifferenceWithTextAndDate: @"GetRoutesArrayByExtendingWithAdditionalLineSegmentsFromLines. Finished route" date: saveDate];
                #endif
                
            } else {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"GetRoutesArrayByExtendingWithAdditionalLineSegmentsFromLines. Processing route: %d, %@", currentrouteindex, currentroutesegment.routeid);
                #endif
                
                CLLocationCoordinate2D endpoint = [currentroutesegment getRouteendpoint];
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"Current route end point: %.6f, %.6f", endpoint.latitude, endpoint.longitude);
                NSDate *saveDateGetNextLines = [NSDate date];
                #endif
                
                NSArray *nextlinesegments = [self getClosestLinesFromRoutesegmentForCoordinateWithinRange: currentroutesegment coordinate: endpoint];
                
                #ifdef TrainlineLogLevelFull
                [self logTimeDifferenceWithTextAndDate: @"GetRoutesArrayByExtendingWithAdditionalLineSegmentsFromLines. Got next lines." date: saveDateGetNextLines];
                
                NSLog(@"Route got next lines. Count: %d of resting lines: %d", nextlinesegments.count, currentroutesegment.linesegments.count);
                #endif
                
                if (nextlinesegments && nextlinesegments.count > 0) {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Route got next lines. Process first line");
                    #endif
                    
                    TrainlinesLine *nextlinesegment = [nextlinesegments objectAtIndex: 0];
                                        
                    RouteSegment *currentroutesegmentcopy = [currentroutesegment copy];
                    
                    CLLocationCoordinate2D endstationcoordinate = CLLocationCoordinate2DMake([endstation.latitude doubleValue], [endstation.longitude doubleValue]);
                    NSUInteger routeendpointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: endpoint];
                    NSUInteger nexlinestartpointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: [nextlinesegment getStartpointWithoutReverseorderflag]];
                    NSUInteger nexlineendpointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: [nextlinesegment getEndpointWithoutReverseorderflag]];
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Lines in copied route segment");
                    //[self logLineidsForRoutesegment: currentroutesegmentcopy];
                    #endif
                    
                    currentroutesegment.routedistance += nextlinesegment.linedistance;
                    [currentroutesegment removeLineByLineFromRoutesegmentlines: nextlinesegment];
                    
                    BOOL currentreverseorderflag = NO;
                    if (![self isClosestCoordinateStartcoordinateOfLine: nextlinesegment coordinate: endpoint]) {
                        
                        #ifdef TrainlineLogLevelFull
                        NSDate *saveDateTurnGeomData = [NSDate date];
                        NSLog(@"Route got next lines. Process first line. Turn geometrydata");
                        #endif
                        
                        //[nextlinesegment reverseGeometryData];
                        //[nextlinesegment setReadGeometryInReverseOrderFlag: YES];
                        
                        [currentroutesegment.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 1]];
                        currentreverseorderflag = YES;
                        
                        if (routeendpointtoendstationdistance < nexlinestartpointtoendstationdistance) {
                            currentroutesegment.leadsawaysfromdestinationpoints++;
                        }
                        
                        #ifdef TrainlineLogLevelFull
                        [self logTimeDifferenceWithTextAndDate: @"Route got next lines. Process first line. Turn geometrydata"  date:saveDateTurnGeomData];
                        #endif
                        
                    } else {
                        [currentroutesegment.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 0]];
                        currentreverseorderflag = NO;
                        
                        if (routeendpointtoendstationdistance < nexlineendpointtoendstationdistance) {
                            currentroutesegment.leadsawaysfromdestinationpoints++;
                        }
                    }
                    
                    [currentroutesegment.routelines addObject: nextlinesegment];
                    NSUInteger currentaddedlineindex = [currentroutesegment getNumbersOfRouteLines] - 1;
                    
                    if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: currentroutesegment line: nextlinesegment station: endstation reverseorder: currentreverseorderflag lineindex: currentaddedlineindex]) {
                        currentroutesegment.ended = YES;
                        currentroutesegment.endedwithstation = YES;
                    }
                    
                    if (currentroutesegment.leadsawaysfromdestinationpoints >= self.routeleadsawaysfromdestinationtolerance) {
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Route leads away from destination: %d, %.6f, %.6f", currentroutesegment.leadsawaysfromdestinationpoints, endpoint.latitude, endpoint.longitude);
                        #endif
                        
                        currentroutesegment.ended = YES;
                        currentroutesegment.endedwithrouteend = YES;
                    }
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"New lines in routesegment 1");
                    //[self logLineidsForRoutesegment: currentroutesegment];
                    #endif
                    
                    if (nextlinesegments.count > 1) {
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Route got next lines. Process additional lines: %d", nextlinesegments.count - 1);
                        #endif
                        
                        for (int i = 1; i < nextlinesegments.count; i++) {
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Route got next lines. Process additional line: %d", i);
                            #endif
                            
                            TrainlinesLine *nextlinesegmentother = [nextlinesegments objectAtIndex: i];
                            
                            RouteSegment *newroutesegment = [currentroutesegmentcopy copy];
                            //[newroutesegment removeLineByLineFromRoutesegmentlines: nextlinesegment];
                            
                            NSUInteger nexlineotherstartpointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: [nextlinesegmentother getStartpointWithoutReverseorderflag]];
                            NSUInteger nexlineotherendpointtoendstationdistance = [self calculateDistance: endstationcoordinate bPoint: [nextlinesegmentother getEndpointWithoutReverseorderflag]];
                            
                            newroutesegment.routedistance += nextlinesegmentother.linedistance;
                            [newroutesegment removeLineByLineFromRoutesegmentlines: nextlinesegmentother];
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Lines in re-copied route segment");
                            //[self logLineidsForRoutesegment: newroutesegment];
                            #endif
                            
                            BOOL currentreverseorderflagadditional = NO;
                            if (![self isClosestCoordinateStartcoordinateOfLine: nextlinesegmentother coordinate: endpoint]) {
                                
                                #ifdef TrainlineLogLevelFull
                                NSLog(@"Route got next lines. Process additional line: %d. Turn geometrydata", i);
                                #endif
                                
                                //[nextlinesegment reverseGeometryData];
                                //[nextlinesegmentother setReadGeometryInReverseOrderFlag: YES];
                                
                                [newroutesegment.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 1]];
                                currentreverseorderflagadditional = YES;
                                
                                if (routeendpointtoendstationdistance < nexlineotherstartpointtoendstationdistance) {
                                    newroutesegment.leadsawaysfromdestinationpoints++;
                                }
                                
                            } else {
                                [newroutesegment.routelinesreversegeomflags addObject: [NSNumber numberWithInt: 0]];
                                currentreverseorderflagadditional = NO;
                                
                                if (routeendpointtoendstationdistance < nexlineotherendpointtoendstationdistance) {
                                    newroutesegment.leadsawaysfromdestinationpoints++;
                                }
                            }
                            
                            [newroutesegment.routelines addObject: nextlinesegmentother];
                            NSUInteger currentaddedlineindexadditional = [newroutesegment getNumbersOfRouteLines] - 1;
                            
                            if ([self isEndpointReachedWithRoutesegmentWithLineForEndstation: newroutesegment line: nextlinesegmentother station: endstation reverseorder: currentreverseorderflagadditional lineindex: currentaddedlineindexadditional]) {
                                newroutesegment.ended = YES;
                                newroutesegment.endedwithstation = YES;
                            }
                            
                            if (newroutesegment.leadsawaysfromdestinationpoints >= self.routeleadsawaysfromdestinationtolerance) {
                                
                                #ifdef TrainlineLogLevelFull
                                NSLog(@"Route leads away from destination: %d, %.6f, %.6f", newroutesegment.leadsawaysfromdestinationpoints, endpoint.latitude, endpoint.longitude);
                                #endif
                                
                                newroutesegment.ended = YES;
                                newroutesegment.endedwithrouteend = YES;
                            }
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"New lines in routesegment %d", i);
                            //[self logLineidsForRoutesegment: newroutesegment];
                            #endif
                            
                            
                            [additionalroutesarray addObject: newroutesegment];
                        }
                    }
                } else {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Route ended: %d", currentrouteindex);
                    #endif
                    
                    currentroutesegment.ended = YES;
                    currentroutesegment.endedwithrouteend = YES;
                }
                currentrouteindex++;
                
                #ifdef TrainlineLogLevelFull
                [self logTimeDifferenceWithTextAndDate: @"GetRoutesArrayByExtendingWithAdditionalLineSegmentsFromLines. Finished route" date: saveDate];
                #endif
            }
        }
        NSMutableArray *newroutesarray = [NSMutableArray arrayWithArray: routesarray];
        [newroutesarray addObjectsFromArray: additionalroutesarray];
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"New number of routes: %d", newroutesarray.count);
        #endif
        
        return newroutesarray;
    }
    return nil;
}

- (NSArray *)getRouteSegmentsStartingFromStationForRouteWithEndstation:(Station *)station routeid:(NSNumber *)routeid endstation:(Station *)endstation {
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"getRouteSegmentsStartingFromStationForRouteWithEndstation: %@, %@, %@, %@, %@", station.stationName, station.stationId, station.latitude, station.longitude, routeid);
    NSDate *savedate = [NSDate date];
    #endif
    
    if (self.isCancelled) {
        #ifdef TrainlineLogLevelFull
        NSLog(@"Trainline operation is cancelled");
        #endif
        return nil;
    }
    
    if (station && station.stationName && station.stationId && station.latitude && station.longitude && routeid) {
        CLLocationCoordinate2D stationCoordinate = CLLocationCoordinate2DMake([station.latitude doubleValue], [station.longitude doubleValue]);
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"Train lines detail level used: %d", self.detaillevel);
        NSDate *saveDateStartRouteSegments = [NSDate date];
        #endif
        
        NSArray *lines = [self getLinesByRouteId:routeid detaillevel:self.detaillevel];

        NSMutableArray *routesarray = [self getInitialStartRoutesegmentForStartstationcoordinateWithlines: lines coordinate: stationCoordinate routeid: routeid endstation: endstation];
        
        if (routesarray && routesarray.count > 0) {
            
            #ifdef TrainlineLogLevelFull
            [self logTimeDifferenceWithTextAndDate: @"GetRouteSegmentStartingFromStationForRoute. Got start route segments" date: saveDateStartRouteSegments];
            
            NSLog(@"------------------------------------------");
            for (RouteSegment *currentroutesegment in routesarray) {
                NSLog(@"Route: %@, lines: %d, first line: %d", currentroutesegment.routeid, currentroutesegment.routelines.count, [[currentroutesegment.routelines objectAtIndex: 0] lineId]);
            }
            NSLog(@"------------------------------------------");
            #endif
            
            BOOL cancelGetRouteSegment = NO;
            
            while (!cancelGetRouteSegment) {
                
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    break;
                }
                
                #ifdef TrainlineLogLevelFull
                NSDate *savedatextendingroutes = [NSDate date];
                #endif
                
                NSArray *extendedArray = [self getRoutesArrayByExtendingWithAdditionalLineSegmentsFromLinesTerminatingByEndstation: routesarray endstation: endstation];
                if (!extendedArray || extendedArray.count == 0) {
                    return nil;
                }
                BOOL routesAreAtEnd = YES;
                for (RouteSegment *currentroutesegmentforcheck in extendedArray) {
                    if (!currentroutesegmentforcheck.ended) {
                        routesAreAtEnd = NO;
                    }
                }
                
                [routesarray removeAllObjects];
                [routesarray addObjectsFromArray: extendedArray];
                
                if (routesAreAtEnd) {
                    cancelGetRouteSegment = YES;
                }
                
                #ifdef TrainlineLogLevelFull
                [self logTimeDifferenceWithTextAndDate: @"GetRouteSegmentStartingFromStationForRoute. Extended routes" date: savedatextendingroutes];
                NSLog(@"------------------------------------------");
                #endif
            }
            
            if (!self.isCancelled) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"------------------------------------------");
                NSLog(@"Routes created: %d", routesarray.count);
                #endif
                
                #ifdef TrainlineLogLevelPoints
                for (int routeindex = 0; routeindex < routesarray.count; routeindex++) {
                    RouteSegment *routesegment = [routesarray objectAtIndex: routeindex];
                    NSLog(@"Route: %d, number of lines: %d, distance: %d", routeindex, routesegment.routelines.count, routesegment.routedistance);
                    [self logPointsForRoutesegment: routesegment];
                }
                #endif
                
                #ifdef TrainlineLogLevelFull
                NSDate *routeeliminationdate = [NSDate date];
                NSLog(@"------------------------------------------");
                NSLog(@"Routes before elimination: %d", routesarray.count);
                #endif
                
                NSMutableArray *routeswhichleadtoendstation = [NSMutableArray array];
                for (RouteSegment *currentroutesegment in routesarray) {
                    //TrainlinesLine *endline = [currentroutesegment.routelines lastObject];
                    //CLLocationCoordinate2D endlinecoordinate = [endline getEndpoint];
                    
                    if (currentroutesegment.endedwithstation) {
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Route added during elimination by route ended with station flag: %@, %d", currentroutesegment.routeid, currentroutesegment.routedistance);
                        #endif
                        
                        [routeswhichleadtoendstation addObject: currentroutesegment];
                        continue;
                    }
                }
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"Routes after elimination: %d", routeswhichleadtoendstation.count);
                NSLog(@"------------------------------------------");
                
                [self logTimeDifferenceWithTextAndDate: @"GetRouteSegmentStartingFromStationForRoute. Route elimination ended." date:routeeliminationdate];
                
                [self logTimeDifferenceWithTextAndDate: @"GetRouteSegmentStartingFromStationForRoute. Ended" date: savedate];
                #endif
                
                return routeswhichleadtoendstation;
            }
        }
    }
    
    return nil;
}

/*
- (NSArray *)evaluateRoutesWithPasslist:(NSArray *)routesegments passlist:(NSArray *)passlist {
    if (routesegments && routesegments.count > 0) {
        if (passlist && passlist.count > 0) {
            for (RouteSegment *currentroutesegment in routesegments) {
                NSUInteger numberoflines = [currentroutesegment getNumbersOfRouteLines];
                for (int z = 0; z < numberoflines; z++) {
                    TrainlinesLine *currenttrainline = [currentroutesegment.routelines objectAtIndex: z];
                    BOOL reverseorder  = [currentroutesegment getReverseorderflagForRoutelineWithIndex: z];
                    CLLocationCoordinate2D linecoordinate = [currenttrainline getEndpointWithReverseorderflag:reverseorder];
                    for (BasicStop *currentbasicstop in passlist) {
                        Station *currentstation = [currentbasicstop station];
                        CLLocationCoordinate2D stationcoordinate = CLLocationCoordinate2DMake([currentstation.latitude doubleValue] , [currentstation.longitude doubleValue]);
                        NSUInteger distance = [self calculateDistance: stationcoordinate bPoint: linecoordinate];
                        if (distance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                            
                            NSLog(@"Match found on station with passlist. Route: %@, station: %@", currentroutesegment.routeid, currentstation.stationName);
                            
                            currentroutesegment.passlistpoints +=1;
                        }
                    }
                }
            }
            
            NSInteger maxpasslistpointindex = -1;
            NSUInteger maxpoints = 0;
            for (int i = 0; i < routesegments.count; i++) {
                RouteSegment *currentroutesegment = [routesegments objectAtIndex: i];
                if (currentroutesegment.passlistpoints > maxpoints) {
                    maxpoints = currentroutesegment.passlistpoints;
                    maxpasslistpointindex = i;logr
 
                }
            }
            
            if (maxpasslistpointindex >= 0 && maxpoints > 0) {
                NSMutableArray *routewithmaxpoints = [NSMutableArray array];
                for (int i = 0; i < routesegments.count; i++) {
                    RouteSegment *currentroutesegment = [routesegments objectAtIndex: i];
                    if (currentroutesegment.passlistpoints == maxpoints) {
                        [routewithmaxpoints addObject: currentroutesegment];
                    }
                }
                return routewithmaxpoints;
            }
        }
    }
    return routesegments;
}
*/

- (NSArray *)filterrouteswithnostartorendstationmatch:(NSArray *)routesegments startstation:(Station *)startstation endstation:(Station *)endstation{
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"filterrouteswithnostartorendstationmatch: before: %d", routesegments.count);
    #endif
    
    if (routesegments && routesegments.count > 0) {
        NSMutableArray *routesok = [NSMutableArray array];
        CLLocationCoordinate2D startstationcoordinate = CLLocationCoordinate2DMake([startstation.latitude doubleValue], [startstation.longitude doubleValue]);
        CLLocationCoordinate2D endstationcoordinate = CLLocationCoordinate2DMake([endstation.latitude doubleValue], [endstation.longitude doubleValue]);
        
        for (RouteSegment *currentsegment in routesegments) {
            if (currentsegment.waypoints && currentsegment.waypoints.count >=2) {
                MTDWaypoint *startpoint = [currentsegment.waypoints objectAtIndex: 0];
                MTDWaypoint *endpoint = [currentsegment.waypoints lastObject];
                
                CLLocationCoordinate2D startroutecoordinate = startpoint.coordinate;
                CLLocationCoordinate2D endroutecoordinate = endpoint.coordinate;
                
                NSUInteger s1_e1 = [self calculateDistance: startstationcoordinate bPoint: startroutecoordinate];
                NSUInteger s1_e2 = [self calculateDistance: startstationcoordinate bPoint: endroutecoordinate];
                NSUInteger s2_e1 = [self calculateDistance: endstationcoordinate bPoint: startroutecoordinate];
                NSUInteger s2_e2 = [self calculateDistance: endstationcoordinate bPoint: endroutecoordinate];
                
                if ((s1_e1 < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT && s2_e2 < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) || (s1_e2 < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT && s2_e1 < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT)) {
                    [routesok addObject: currentsegment];
                }
                
            }
        }
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"filterrouteswithnostartorendstationmatch: after: %d", routesok.count);
        #endif
        
        return routesok;
    }
    #ifdef TrainlineLogLevelFull
    NSLog(@"filterrouteswithnostartorendstationmatch: after: %d", 0);
    #endif
    
    return nil;
}

- (NSArray *)evaluateRoutesWithPasslist:(NSArray *)routesegments passlist:(NSArray *)passlist {
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"evaluateRoutesWithPasslist: %@", passlist);
    #endif
    
    if (routesegments && routesegments.count > 0) {
        if (passlist && passlist.count > 0) {
            for (RouteSegment *currentroutesegment in routesegments) {
                NSMutableArray *stationscheckedKeys = [NSMutableArray array];
                for (int i = 0; i < currentroutesegment.waypoints.count - 1; i++) {
                //for (MTDWaypoint *currentwaypoint in currentroutesegment.waypoints) {
                    MTDWaypoint *currentstartwaypoint = [currentroutesegment.waypoints objectAtIndex: i];
                    MTDWaypoint *currentendwaypoint = [currentroutesegment.waypoints objectAtIndex: i + 1];
                    for (BasicStop *currentbasicstop in passlist) {
                        Station *currentstation = [currentbasicstop station];
                        
                        CLLocationCoordinate2D stationcoordinate = CLLocationCoordinate2DMake([currentstation.latitude doubleValue] , [currentstation.longitude doubleValue]);
                        NSUInteger distancestart = [self calculateDistance: stationcoordinate bPoint: currentstartwaypoint.coordinate];
                        NSUInteger distanceend = [self calculateDistance: stationcoordinate bPoint: currentendwaypoint.coordinate];
                        NSUInteger distanceline = [self calculateDistance: currentstartwaypoint.coordinate bPoint: currentendwaypoint.coordinate];
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Current station name: %@, %@, %@ / %d, %d, %.6f, %.6f / %.6f, %.6f", currentstation.stationName, currentstation.latitude, currentstation.longitude, distancestart, distanceend, currentstartwaypoint.coordinate.latitude, currentstartwaypoint.coordinate.longitude, currentendwaypoint.coordinate.latitude, currentendwaypoint.coordinate.longitude);
                        #endif
                        
                        if (distancestart < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT || distanceend < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Match found on station with passlist. Station close to start end coordinate. Start / End: %@", (distancestart < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT)?@"Y":@"N");
                            #endif
                            
                            NSString *currentStationKey = currentstation.stationId;
                            NSUInteger indexofcurrentstationkey = [stationscheckedKeys indexOfObject: currentStationKey];
                            if (indexofcurrentstationkey == NSNotFound) {
                                
                                #ifdef TrainlineLogLevelFull
                                NSLog(@"Match found on station with passlist. Route: %@, station: %@", currentroutesegment.routeid, currentstation.stationName);
                                #endif
                                
                                [stationscheckedKeys addObject: currentStationKey];
                                currentroutesegment.passlistpoints++;
                            }
                            #ifdef TrainlineLogLevelFull
                            else  {
                                NSLog(@"Match found on station with passlist but station double. Route: %@, station: %@", currentroutesegment.routeid, currentstation.stationName);
                            }
                            #endif
                        } else if (distancestart < distanceline && distanceend < distanceline) {
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Match found on station with passlist. Station potentially on line, %d, %d, %d / %.6f, %.6f / %.6f, %.6f", distanceline, distancestart, distanceend, currentstartwaypoint.coordinate.latitude, currentstartwaypoint.coordinate.longitude, currentendwaypoint.coordinate.latitude, currentendwaypoint.coordinate.longitude );
                            #endif
                            
                            double mindistancepointtoline = [self orthogonalDistanceWithPoint:stationcoordinate lineStart:currentstartwaypoint.coordinate lineEnd:currentendwaypoint.coordinate];
                            double mindistanceapproxkms = mindistancepointtoline * 111000;
                            
                            BOOL pointbetweenstartend = distancestart < distanceline && distanceend < distanceline;
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Distance of station to line: %@ / %.6f, %.1f",  pointbetweenstartend?@"Y":@"N", mindistancepointtoline, mindistanceapproxkms);
                            #endif
                            
                            if (pointbetweenstartend && mindistanceapproxkms <= 200) {
                                
                                NSString *currentStationKey = currentstation.stationId;
                                NSUInteger indexofcurrentstationkey = [stationscheckedKeys indexOfObject: currentStationKey];
                                if (indexofcurrentstationkey == NSNotFound) {
                                    
                                    #ifdef TrainlineLogLevelFull
                                    NSLog(@"Match found on station with passlist. Station on line. Route: %@, station: %@", currentroutesegment.routeid, currentstation.stationName);
                                    #endif
                                    
                                    [stationscheckedKeys addObject: currentStationKey];
                                    currentroutesegment.passlistpoints++;
                                }
                                #ifdef TrainlineLogLevelFull
                                else  {
                                    NSLog(@"Match found on station with passlist. Station on line. But station double. Route: %@, station: %@", currentroutesegment.routeid, currentstation.stationName);
                                }
                                #endif
                            }
                        }
                    }
                }
            }
            
            NSInteger maxpasslistpointindex = -1;
            NSUInteger maxpoints = 0;
            for (int i = 0; i < routesegments.count; i++) {
                RouteSegment *currentroutesegment = [routesegments objectAtIndex: i];
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"Current segment passlist points: %d vs max: %d", currentroutesegment.passlistpoints, maxpoints);
                #endif
                
                if (currentroutesegment.passlistpoints > maxpoints) {
                    maxpoints = currentroutesegment.passlistpoints;
                    maxpasslistpointindex = i;
                }
            }
            
            if (maxpasslistpointindex >= 0 && maxpoints > 0) {
                NSMutableArray *routewithmaxpoints = [NSMutableArray array];
                for (int i = 0; i < routesegments.count; i++) {
                    RouteSegment *currentroutesegment = [routesegments objectAtIndex: i];
                    if (currentroutesegment.passlistpoints == maxpoints) {
                        [routewithmaxpoints addObject: currentroutesegment];
                    }
                }
                return routewithmaxpoints;
            }
        }
    }
    return routesegments;
}

/*
- (NSArray *)evaluateRoutesWithPasslist:(NSArray *)routesegments passlist:(NSArray *)passlist {
    NSLog(@"evaluateRoutesWithPasslist: %@", passlist);
    
    if (routesegments && routesegments.count > 0) {
        if (passlist && passlist.count > 0) {
            for (RouteSegment *currentroutesegment in routesegments) {
                NSMutableArray *stationscheckedKeys = [NSMutableArray array];
                for (MTDWaypoint *currentwaypoint in currentroutesegment.waypoints) {
                    for (BasicStop *currentbasicstop in passlist) {
                        Station *currentstation = [currentbasicstop station];
                        
                        CLLocationCoordinate2D stationcoordinate = CLLocationCoordinate2DMake([currentstation.latitude doubleValue] , [currentstation.longitude doubleValue]);
                        NSUInteger distance = [self calculateDistance: stationcoordinate bPoint: currentwaypoint.coordinate];
                        
                        NSLog(@"Current station name: %@, %@, %@ / %d, %.6f, %.6f", currentstation.stationName, currentstation.latitude, currentstation.longitude, distance, currentwaypoint.coordinate.latitude, currentwaypoint.coordinate.longitude);
                        
                        if (distance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT*1.5) {
                            NSString *currentStationKey = currentstation.stationId;
                            NSUInteger indexofcurrentstationkey = [stationscheckedKeys indexOfObject: currentStationKey];
                            if (indexofcurrentstationkey == NSNotFound) {
                                NSLog(@"Match found on station with passlist. Route: %@, station: %@", currentroutesegment.routeid, currentstation.stationName);
                                [stationscheckedKeys addObject: currentStationKey];
                                currentroutesegment.passlistpoints++;
                            } else  {
                                NSLog(@"Match found on station with passlist but station double. Route: %@, station: %@", currentroutesegment.routeid, currentstation.stationName);
                            }
                        }
                    }
                }
            }
            
            NSInteger maxpasslistpointindex = -1;
            NSUInteger maxpoints = 0;
            for (int i = 0; i < routesegments.count; i++) {
                RouteSegment *currentroutesegment = [routesegments objectAtIndex: i];
                NSLog(@"Current segment passlist points: %d vs max: %d", currentroutesegment.passlistpoints, maxpoints);
                if (currentroutesegment.passlistpoints > maxpoints) {
                    maxpoints = currentroutesegment.passlistpoints;
                    maxpasslistpointindex = i;
                }
            }
            
            if (maxpasslistpointindex >= 0 && maxpoints > 0) {
                NSMutableArray *routewithmaxpoints = [NSMutableArray array];
                for (int i = 0; i < routesegments.count; i++) {
                    RouteSegment *currentroutesegment = [routesegments objectAtIndex: i];
                    if (currentroutesegment.passlistpoints == maxpoints) {
                        [routewithmaxpoints addObject: currentroutesegment];
                    }
                }
                return routewithmaxpoints;
            }
        }
    }
    return routesegments;
}
*/

- (NSArray *)evaluateInitialRoutesWithPasslist:(NSArray *)routesegments passlist:(NSArray *)passlist {
    if (routesegments && routesegments.count > 0) {
        if (passlist && passlist.count > 0) {
            for (RouteSegment *currentroutesegment in routesegments) {
                NSUInteger numberoflines = [currentroutesegment.linesegments count];
                for (int z = 0; z < numberoflines; z++) {
                    TrainlinesLine *currenttrainline = [currentroutesegment.linesegments objectAtIndex: z];
                    CLLocationCoordinate2D linecoordinate = [currenttrainline getEndpointWithoutReverseorderflag];
                    for (BasicStop *currentbasicstop in passlist) {
                        Station *currentstation = [currentbasicstop station];
                        CLLocationCoordinate2D stationcoordinate = CLLocationCoordinate2DMake([currentstation.latitude doubleValue] , [currentstation.longitude doubleValue]);
                        NSUInteger distance = [self calculateDistance: stationcoordinate bPoint: linecoordinate];
                        if (distance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Initial Match found on station with passlist. Route: %@, station: %@", currentroutesegment.routeid, currentstation.stationName);
                            #endif
                            
                            currentroutesegment.passlistpoints +=1;
                        }
                    }
                }
            }
            
            NSMutableIndexSet *maxpointindexset = [NSMutableIndexSet indexSet];
            NSMutableIndexSet *allpointindexset = [NSMutableIndexSet indexSet];
            
            NSInteger maxpasslistpointindex = -1;
            NSUInteger maxpoints = 0;
            for (int i = 0; i < routesegments.count; i++) {
                RouteSegment *currentroutesegment = [routesegments objectAtIndex: i];
                if (currentroutesegment.passlistpoints > maxpoints) {
                    maxpoints = currentroutesegment.passlistpoints;
                    maxpasslistpointindex = i;
                }
            }
            
            if (maxpasslistpointindex >= 0 && maxpoints > 0) {
                NSMutableArray *routewithmaxpoints = [NSMutableArray array];
                for (int i = 0; i < routesegments.count; i++) {
                    RouteSegment *currentroutesegment = [routesegments objectAtIndex: i];
                    [allpointindexset addIndex: i];
                    if (currentroutesegment.passlistpoints == maxpoints) {
                        [maxpointindexset addIndex: i];
                        currentroutesegment.passlistpoints = 0;
                    }
                }
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"All indexes: %@", allpointindexset);
                NSLog(@"Max indexes: %@", maxpointindexset);
                #endif
                
                if (maxpointindexset && [maxpointindexset count] > 0) {
                    routewithmaxpoints = [routesegments mutableCopy];
                    [allpointindexset removeIndexes: maxpointindexset];
                    [routewithmaxpoints removeObjectsAtIndexes:allpointindexset];
                    
                }
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"Diff indexes: %@", allpointindexset);
                #endif
                
                return routewithmaxpoints;
            }
        }
    }
    return routesegments;
}

- (NSArray *)evaluateRoutesWithMinDistance:(NSArray *)routesegments {
    if (routesegments && routesegments.count > 0) {
        NSUInteger mindistance = 999999;
        NSInteger mindistanceindex = -1;
        for (int i = 0;  i < routesegments.count; i++) {
            RouteSegment *currentroutesegment = [routesegments objectAtIndex: i];
            if (currentroutesegment.routedistance < mindistance) {
                mindistance = currentroutesegment.routedistance;
                mindistanceindex = i;
            }
        }
        if (mindistance < 999999 && mindistanceindex >= 0) {
            
            RouteSegment *foundsegment = [routesegments objectAtIndex: mindistanceindex];
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"Routes found with min distance: %@, %d", foundsegment.routeid, mindistance);
            #endif
            
            NSArray *routewithmindistance = [NSArray arrayWithObject: foundsegment];
            return routewithmindistance;
        }
    }
    
    return routesegments;
}

- (NSArray *)evaluateRoutenamesTransportname:(NSArray *)routeids transportname:(NSString *)transportname {
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"EvaluateRoutenamesTransportname: %@", transportname);
    //NSLog(@"Test: %@", [@"S12456" substringToIndex: 2]);
    #endif
    
    if (routeids && routeids.count > 0 && transportname && [transportname length] >= 2) {
        NSMutableArray *filteredrouteids = [NSMutableArray array];
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *dbpath = [bundlePath stringByAppendingPathComponent:ROUTELINEDB];
        FMDatabase *database = [FMDatabase databaseWithPath:dbpath];
        
        if (![database open]) {
            NSLog(@"Could not open trainline database");
            return nil;
        }
        
        NSMutableArray *idsstring = [NSMutableArray array];
        for (NSNumber *currentid in routeids) {
            [idsstring addObject: [NSString stringWithFormat: @"%d", [currentid integerValue]]];
        }
        
        NSString *idarraystring = [idsstring componentsJoinedByString: @", "];
        NSString *queryString = [NSString stringWithFormat: @"select distinct route_id, route_name from route_station where route_id in (%@)", idarraystring];
        FMResultSet *s = [database executeQuery:queryString];
        
        NSMutableArray *routeids = [NSMutableArray arrayWithCapacity: 1];
        NSMutableArray *routenames = [NSMutableArray arrayWithCapacity: 1];
        while ([s next]) {
            NSNumber *routeid = [NSNumber numberWithInt: [s intForColumnIndex: 0]];
            [routeids addObject: routeid];
            NSString *routename = [s stringForColumnIndex: 1];
            [routenames addObject: routename];
        }
        [database close];
        
        for (int i = 0;  i < routeids.count; i++) {
            NSNumber *currentrouteid = [routeids objectAtIndex: i];
            NSString *currentroutename = [routenames objectAtIndex: i];
            
            if (!([currentroutename rangeOfString:transportname].location == NSNotFound)) {
                [filteredrouteids addObject: currentrouteid];
            }
        }
        
        if (filteredrouteids && filteredrouteids.count > 0) {
            return filteredrouteids;
        }
    }
    return routeids;
}

- (NSArray *)getRouteForStartEndstationEvaluateWithPasslistAndDistance:(Station *)startstation endstation:(Station *)endstation passlist:(NSArray *)passlist transportname:(NSString *)transportname {
    
    #ifdef TrainlineLogLevelFull
    NSDate *getRoutesDate = [NSDate date];
    #endif
    
    if (self.isCancelled) {
        #ifdef TrainlineLogLevelFull
        NSLog(@"Trainline operation is cancelled");
        #endif
        return nil;
    }
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"Passlist:--------------------------");
    [self logPasslist: passlist];
    NSLog(@"-----------------------------------");
    #endif
    
    if (startstation && endstation) {
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"GetRouteForStartEndstationEvaluateWithPasslistAndDistance: %@, %@", startstation.stationName, endstation.stationName);
        #endif
        
        NSArray *commonrouteids = [self getCommonRouteIdsForStations: startstation endstation: endstation];
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Common route numbers before filtering. %d", commonrouteids.count);
        [self logCommonRouteIds: commonrouteids];
        #endif
        
        if (self.isCancelled) {
            #ifdef TrainlineLogLevelFull
            NSLog(@"Trainline operation is cancelled");
            #endif
            return nil;
        }
        
        NSArray *filteredcommonrouteids = nil;
        if (transportname && [transportname length] >= 2) {
            filteredcommonrouteids = [self evaluateRoutenamesTransportname: commonrouteids transportname: transportname];
        } else {
            filteredcommonrouteids = commonrouteids;
        }
        
        if (self.isCancelled) {
            #ifdef TrainlineLogLevelFull
            NSLog(@"Trainline operation is cancelled");
            #endif
            return nil;
        }
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Common route numbers after filtering: %d", filteredcommonrouteids.count);
        [self logCommonRouteIds:filteredcommonrouteids];
        #endif
        
        NSArray *filteredcommonrouteidsSecondStep = nil;
        if (filteredcommonrouteidsSecondStep.count > 1 && passlist && passlist.count > 1) {
            filteredcommonrouteidsSecondStep = [self evaluateInitialRoutesWithPasslist: filteredcommonrouteids passlist: passlist];
            if (!filteredcommonrouteidsSecondStep || filteredcommonrouteidsSecondStep.count == 0) {
                filteredcommonrouteidsSecondStep = filteredcommonrouteids;
            }
            
        } else {
            filteredcommonrouteidsSecondStep = filteredcommonrouteids;
        }
        
        if (self.isCancelled) {
            #ifdef TrainlineLogLevelFull
            NSLog(@"Trainline operation is cancelled");
            #endif
            return nil;
        }
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Common route numbers after filtering - second: %d", filteredcommonrouteidsSecondStep.count);
        [self logCommonRouteIds: filteredcommonrouteidsSecondStep];
        #endif
        
        if (filteredcommonrouteidsSecondStep && filteredcommonrouteidsSecondStep.count > 0) {
            NSMutableArray *routestoevaluate = [NSMutableArray array];
            for (NSNumber *commonrouteid in filteredcommonrouteidsSecondStep) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Processing common route number: %@", commonrouteid);
                [self logStationsByRouteId:commonrouteid];
                #endif
                
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    return nil;
                }
                
                NSArray *routesegments = [self getRouteSegmentsStartingFromStationForRouteWithEndstation: startstation routeid: commonrouteid endstation:endstation];
                
                if (routesegments && routesegments.count > 0) {
                    [routestoevaluate addObjectsFromArray: routesegments];
                }
            }
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"Got routes to evaluate: %d", routestoevaluate.count);
            [self logTimeDifferenceWithTextAndDate: @"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Got all routesegments" date: getRoutesDate];
            #endif
            
            if (routestoevaluate && routestoevaluate.count > 0) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"------------------------------------------");
                NSLog(@"Routes before extracting waypoints: %d", routestoevaluate.count);
                #endif
                
                #ifdef TrainlineLogLevelPoints
                for (RouteSegment *currentsegment in routestoevaluate) {
                    [self logPointsForRoutesegment: currentsegment];
                }
                #endif
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"---------------------");
                //[self logRouteIdsOfRoutesegment: routestoevaluate];
                [self logRouteIdsAndDistanceOfRoutesegment: routestoevaluate];
                NSLog(@"---------------------");
                #endif
                
                for (RouteSegment *currentsegment in routestoevaluate) {
                    [currentsegment extractWaypointsByCuttingStartAndEndpoint];
                }
                
                #ifdef TrainlineLogLevelPoints
                for (RouteSegment *currentsegment in routestoevaluate) {
                    [self logWaypointsForRoutesegment: currentsegment];
                }

                NSLog(@"------------------------------------------");
                #endif
                
                NSArray *routestoevaluatefiltered = [self filterrouteswithnostartorendstationmatch: routestoevaluate startstation: startstation endstation: endstation];
                
                if (routestoevaluatefiltered.count == 1) {
                    //NSArray *waypointsarray = [self getWaypointsArrayForRoutesegment: [routestoevaluate objectAtIndex: 0]];
                    
                    #ifdef TrainlineLogLevelFull
                    [self logLineidsForRoutesegment: [routestoevaluatefiltered objectAtIndex: 0]];
                    #endif
                    
                    if (self.isCancelled) {
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Trainline operation is cancelled");
                        #endif
                        return nil;
                    }
                    
                    RouteSegment *currentsegment = [routestoevaluatefiltered objectAtIndex: 0];
                    NSArray *waypointsarray = [currentsegment getWaypoints];
                    
                    #ifdef TrainlineLogLevelFull
                    [self logTimeDifferenceWithTextAndDate: @"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Only one route. Got waypoints" date:getRoutesDate];
                    #endif
                    
                    return waypointsarray;
                } else {
                    
                    #ifdef TrainlineLogLevelFull
                    NSDate *evalpasslistdate = [NSDate date];
                    #endif
                    
                    if (self.isCancelled) {
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Trainline operation is cancelled");
                        #endif
                        return nil;
                    }
                    
                    NSArray *routesevaluatedwithpasslist = [self evaluateRoutesWithPasslist: routestoevaluatefiltered passlist: passlist];
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Routes after evaluation with passlist: %d", routesevaluatedwithpasslist.count);
                    [self logTimeDifferenceWithTextAndDate: @"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Evaluated with passlist" date:evalpasslistdate];
                    //[self logRouteIdsOfRoutesegment:routesevaluatedwithpasslist];
                    [self logRouteIdsAndDistanceOfRoutesegment: routesevaluatedwithpasslist];
                    #endif
                    
                    if (routesevaluatedwithpasslist && routesevaluatedwithpasslist.count == 1) {
                        //NSArray *waypointsarray = [self getWaypointsArrayForRoutesegment: [routesevaluatedwithpasslist objectAtIndex: 0]];
                        
                        #ifdef TrainlineLogLevelFull
                        [self logLineidsForRoutesegment: [routesevaluatedwithpasslist objectAtIndex: 0]];
                        #endif
                        
                        RouteSegment *currentsegment = [routesevaluatedwithpasslist objectAtIndex: 0];
                        NSArray *waypointsarray = [currentsegment getWaypoints];
                        
                        #ifdef TrainlineLogLevelFull
                        [self logTimeDifferenceWithTextAndDate: @"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Evaluated with passlist. Only one route. Got waypoints" date:getRoutesDate];
                        #endif
                        
                        return waypointsarray;
                    } else if (routesevaluatedwithpasslist && routesevaluatedwithpasslist.count > 1) {
                        
                        #ifdef TrainlineLogLevelFull
                        NSDate *evaldistancedate = [NSDate date];
                        #endif
                        
                        if (self.isCancelled) {
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Trainline operation is cancelled");
                            #endif
                            return nil;
                        }
                        
                        #ifdef TrainlineLogLevelPoints
                        for (RouteSegment *currentsegment in routesevaluatedwithpasslist) {
                            NSLog(@"Current route segment: %@, distance: %d", currentsegment.routeid, currentsegment.routedistance);
                            [self logPointsForRoutesegment: currentsegment];
                        }
                        #endif
                        
                        NSArray *routesevaluatedwithdistance = [self evaluateRoutesWithMinDistance: routesevaluatedwithpasslist];
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Routes after evaluation with min distance: %d", routesevaluatedwithdistance.count);
                        [self logTimeDifferenceWithTextAndDate: @"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Evaluated with distance" date:evaldistancedate];
                        //[self logRouteIdsOfRoutesegment:routesevaluatedwithdistance];
                        [self logRouteIdsAndDistanceOfRoutesegment: routesevaluatedwithdistance];
                        #endif
                        
                        #ifdef TrainlineLogLevelPoints
                        for (RouteSegment *currentsegment in routesevaluatedwithdistance) {
                            [self logPointsForRoutesegment: currentsegment];
                        }
                        #endif
                        
                        if (routesevaluatedwithdistance && routesevaluatedwithdistance.count == 1) {
                            //NSArray *waypointsarray = [self getWaypointsArrayForRoutesegment: [routesevaluatedwithdistance objectAtIndex: 0]];
                            
                            #ifdef TrainlineLogLevelFull
                            [self logLineidsForRoutesegment: [routesevaluatedwithdistance objectAtIndex: 0]];
                            #endif
                            
                            RouteSegment *currentsegment = [routesevaluatedwithdistance objectAtIndex: 0];
                            NSArray *waypointsarray = [currentsegment getWaypoints];
                            
                            #ifdef TrainlineLogLevelFull
                            [self logTimeDifferenceWithTextAndDate: @"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Evaluated with distance. Only one route. Got waypoints" date:getRoutesDate];
                            #endif
                            
                            return waypointsarray;
                        } else if (routesevaluatedwithdistance && routesevaluatedwithdistance.count > 1) {
                            //NSArray *waypointsarray = [self getWaypointsArrayForRoutesegment: [routesevaluatedwithdistance objectAtIndex: 0]];
                            
                            #ifdef TrainlineLogLevelFull
                            [self logLineidsForRoutesegment: [routesevaluatedwithdistance objectAtIndex: 0]];
                            #endif
                            
                            RouteSegment *currentsegment = [routesevaluatedwithdistance objectAtIndex: 0];
                            NSArray *waypointsarray = [currentsegment getWaypoints];
                            
                            #ifdef TrainlineLogLevelFull
                            [self logTimeDifferenceWithTextAndDate: @"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. Evaluated. Choose first. Got waypoints" date:getRoutesDate];
                            #endif
                            
                            return waypointsarray;
                        }
                    }
                }
            }
        }
    }
        
    if (passlist) {
        return nil;
    }
    
    CLLocationCoordinate2D startcoordinate = CLLocationCoordinate2DMake([startstation.latitude doubleValue], [startstation.longitude doubleValue]);
    CLLocationCoordinate2D endcoordinate = CLLocationCoordinate2DMake([endstation.latitude doubleValue], [endstation.longitude doubleValue]);
    MTDWaypoint *startpoint = [[MTDWaypoint alloc] initWithCoordinate: startcoordinate];
    MTDWaypoint *endpoint = [[MTDWaypoint alloc] initWithCoordinate: endcoordinate];
    NSArray *routepoints = [[NSArray alloc] initWithObjects: startpoint, endpoint, nil];
    
    #ifdef TrainlineLogLevelFull
    [self logTimeDifferenceWithTextAndDate: @"GetRouteForStartEndstationEvaluateWithPasslistAndDistance. No common routes. Got waypoints" date:getRoutesDate];
    #endif
    
    return routepoints;
}

-  (CLLocationCoordinate2D) getCoordinatesForStation:(Station *)station {
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(0.0, 0.0);
    if (station) {
        if ([station isKindOfClass: [Station class]]) {
            coordinates.latitude = [[station latitude] floatValue];
            coordinates.longitude = [[station longitude] floatValue];
        }
    }
    return coordinates;
}

- (MTDRoute *)getMTDRouteForConsection:(ConSection *)consection {
    if (consection) {
        NSUInteger journeyTypeFlag = [consection conSectionType];
        
        if (self.isCancelled) {
            #ifdef TrainlineLogLevelFull
            NSLog(@"Trainline operation is cancelled");
            #endif
            return nil;
        }
        
        if (journeyTypeFlag == walkType) {
            NSArray *basicStopList = [self getBasicStopsForConsection:consection];
            
            if ([basicStopList count] >= 2) {
                BasicStop *startStop = [basicStopList objectAtIndex: 0];
                BasicStop *endStop = [basicStopList lastObject];
                Station *startStation = [self getStationForBasicStop: startStop];
                Station *endStation = [self getStationForBasicStop: endStop];
                
                CLLocationCoordinate2D from = [self getCoordinatesForStation: startStation];
                CLLocationCoordinate2D to = [self getCoordinatesForStation: endStation];
                if (from.latitude != 0 && from.longitude != 0 && to.latitude != 0 && to.longitude != 0) {
                    MTDWaypoint *frompoint = [[MTDWaypoint alloc] initWithCoordinate:from];
                    MTDWaypoint *topoint = [[MTDWaypoint alloc] initWithCoordinate:to];
                    NSArray *walkpoints = [[NSArray alloc] initWithObjects: frompoint, topoint, nil];
                    
                    UIColor *transportColor = [self getTransportColorWithConsection: consection];
                    NSString *transportName = [self getTransportNameWithConsection: consection];
                    
                    MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:walkpoints
                                                                maneuvers:nil
                                                                 distance:[MTDDistance distanceWithMeters:150866.3]
                                                            timeInSeconds:7915
                                                                     name:transportName
                                                                routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                              journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                               routeColor:transportColor
                                                           additionalInfo:nil];
                    
                    if (self.isCancelled) {
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Trainline operation is cancelled");
                        #endif
                        return nil;
                    }
                    
                    return route;
                }
            }
            
        } else if (journeyTypeFlag == journeyType) {
            NSArray *basicStopList = [self getBasicStopsForConsection:consection];
            
            if ([basicStopList count] >= 2) {
                NSMutableArray *waypointsArray = [NSMutableArray arrayWithCapacity: 2];
                
                for (int i = 0; i<[basicStopList count]; i++) {
                    Station *currentStation = [self getStationForBasicStop: [basicStopList objectAtIndex: i]];
                    CLLocationCoordinate2D coordinate = [self getCoordinatesForStation: currentStation];
                    MTDWaypoint *waypoint = [[MTDWaypoint alloc] initWithCoordinate:coordinate];
                    [waypointsArray addObject: waypoint];
                }
                
                if (!waypointsArray || waypointsArray.count < 2) {
                    return nil;
                }
                
                UIColor *transportColor = [self getTransportColorWithConsection: consection];
                NSString *transportName = [self getTransportNameWithConsection: consection];
                
                MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:waypointsArray
                                                            maneuvers:nil
                                                             distance:[MTDDistance distanceWithMeters:150866.3]
                                                        timeInSeconds:7915
                                                                 name:transportName
                                                            routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                          journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                           routeColor:transportColor
                                                       additionalInfo:nil];
                
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    return nil;
                }
                
                return route;
            }
        }
    }
    
    return nil;
}

- (MTDRoute *)getMTDDetailedRouteForJourneyAndDetaillevel:(Journey *)journey detaillevel:(NSUInteger)detaillevel {
    if (journey) {
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"GetMTDDetailedRouteForJourney");
        #endif
        
        if (![self isTrainportTypeEqualToTrainForStationboardJourney: journey]) {
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"GetMTDDetailedRouteForJourney. Journey is not train. return nil");
            #endif
            return nil;
        }
        
        #ifdef TrainlineLogLevelFull
        NSDate *savedate = [NSDate date];
        #endif
        
        NSArray *basicStopList = [self getBasicStopsForStationboardJourneyRequestResult: journey];
        
        UIColor *transportColor = [self getTransportColorWithStationboardJourney: journey];
        NSString *transportName = [self getTransportNameWithStationboardJourney: journey];
        NSString *transportNameSimple = [self getSimplifiedTransportNameWithStationboardJourney: journey];
        
        if ([basicStopList count] >= 2) {
            
            BasicStop *startStop = [basicStopList objectAtIndex: 0];
            BasicStop *endStop = [basicStopList lastObject];
            Station *startStation = [self getStationForBasicStop: startStop];
            Station *endStation = [self getStationForBasicStop: endStop];
            
            BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startStation endstation: endStation];
            if (stationsareoncommonroute) {
                
                NSArray *waypointsArray;
                
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    return nil;
                }
                
                waypointsArray = [self getRouteForStartEndstationEvaluateWithPasslistAndDistance: startStation endstation: endStation passlist:basicStopList transportname:transportNameSimple];
                
                if (!waypointsArray || waypointsArray.count < 2) {
                    return nil;
                }
                                
                MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:waypointsArray
                                                            maneuvers:nil
                                                             distance:[MTDDistance distanceWithMeters:150866.3]
                                                        timeInSeconds:7915
                                                                 name:transportName
                                                            routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                          journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                           routeColor:transportColor
                                                       additionalInfo:nil];
                
                #ifdef TrainlineLogLevelFull
                [self logTimeDifferenceWithTextAndDate:@"GetMTDDetailedRouteForConsection. Consection with common route. Finished" date:savedate];
                #endif
                
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    return nil;
                }
                                
                return route;
            } else {
                NSMutableArray *startstationsarray = [NSMutableArray array];
                NSMutableArray *endstationsarray = [NSMutableArray array];
                for (int i = 0; i < [basicStopList count] - 1; i++) {
                    [startstationsarray addObject: [basicStopList objectAtIndex: i]];
                    [endstationsarray addObject: [basicStopList objectAtIndex: i + 1]];
                }
                NSMutableArray *waypointsforallroutes = [NSMutableArray array];
                for (int i = 0; i < [startstationsarray count]; i++) {
                    Station *startstation = [[startstationsarray objectAtIndex: i] station];
                    Station *endstation = [[endstationsarray objectAtIndex: i] station];
                    
                    if (self.isCancelled) {
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Trainline operation is cancelled");
                        #endif
                        return nil;
                    }
                    
                    NSArray *routepoints = [self getRouteForStartEndstationEvaluateWithPasslistAndDistance: startstation endstation: endstation passlist: nil transportname:transportNameSimple];
                    [waypointsforallroutes addObjectsFromArray: routepoints];
                    
                    #ifdef TrainlineLogLevelFull
                    [self logTimeDifferenceWithTextAndDate:@"GetMTDDetailedRouteForConsection. Consection with partial routes. Partial route processed" date:savedate];
                    #endif
                }
                
                if (!waypointsforallroutes || waypointsforallroutes.count < 2) {
                    return nil;
                }
                
                MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:waypointsforallroutes
                                                            maneuvers:nil
                                                             distance:[MTDDistance distanceWithMeters:150866.3]
                                                        timeInSeconds:7915
                                                                 name:transportName
                                                            routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                          journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                           routeColor:transportColor
                                                       additionalInfo:nil];
                
                #ifdef TrainlineLogLevelFull
                [self logTimeDifferenceWithTextAndDate:@"GetMTDDetailedRouteForConsection. Consection with common partial routes. Finished" date:savedate];
                #endif
                
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    return nil;
                }
                
                return route;
            }
        }
    }
    return nil;
}

- (MTDRoute *)getMTDDetailedRouteForConsectionAndDetaillevel:(ConSection *)consection detaillevel:(NSUInteger)detaillevel {
    if (consection) {
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"GetMTDDetailedRouteForConsection");
        #endif
        
        if (self.isCancelled) {
            #ifdef TrainlineLogLevelFull
            NSLog(@"Trainline operation is cancelled");
            #endif
            return nil;
        }
        
        if (![self isTrainportTypeEqualToTrainForConsection: consection]) {
            
            MTDRoute *route = [self getMTDRouteForConsection: consection];
            return route;
        }
        
        #ifdef TrainlineLogLevelFull
        NSDate *savedate = [NSDate date];
        #endif
        
        NSArray *basicStopList = [self getBasicStopsForConsection:consection];
        
        UIColor *transportColor = [self getTransportColorWithConsection: consection];
        NSString *transportName = [self getTransportNameWithConsection: consection];
        NSString *transportNameSimple = [self getSimplifiedTransportNameWithConsection: consection];
        
        if ([basicStopList count] >= 2) {
            
            BasicStop *startStop = [basicStopList objectAtIndex: 0];
            BasicStop *endStop = [basicStopList lastObject];
            Station *startStation = [self getStationForBasicStop: startStop];
            Station *endStation = [self getStationForBasicStop: endStop];
            
            BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startStation endstation: endStation];
            if (stationsareoncommonroute) {
                
                NSArray *waypointsArray;
                
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    return nil;
                }
                
                waypointsArray = [self getRouteForStartEndstationEvaluateWithPasslistAndDistance: startStation endstation: endStation passlist:basicStopList transportname:transportNameSimple];
                
                if (!waypointsArray || waypointsArray.count < 2) {
                    return nil;
                }
                
                MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:waypointsArray
                                                            maneuvers:nil
                                                             distance:[MTDDistance distanceWithMeters:150866.3]
                                                        timeInSeconds:7915
                                                                 name:transportName
                                                            routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                          journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                           routeColor:transportColor
                                                       additionalInfo:nil];
                
                #ifdef TrainlineLogLevelFull
                [self logTimeDifferenceWithTextAndDate:@"GetMTDDetailedRouteForConsection. Consection with common route. Finished" date:savedate];
                #endif
                
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    return nil;
                }
                
                return route;
            } else {
                NSMutableArray *startstationsarray = [NSMutableArray array];
                NSMutableArray *endstationsarray = [NSMutableArray array];
                for (int i = 0; i < [basicStopList count] - 1; i++) {
                    [startstationsarray addObject: [basicStopList objectAtIndex: i]];
                    [endstationsarray addObject: [basicStopList objectAtIndex: i + 1]];
                }
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"Startstationsarray: %@", startstationsarray);
                NSLog(@"Endstationsarray: %@", endstationsarray);
                #endif
                
                NSMutableArray *waypointsforallroutes = [NSMutableArray array];
                for (int i = 0; i < [startstationsarray count]; i++) {
                    Station *startstation = [[startstationsarray objectAtIndex: i] station];
                    Station *endstation = [[endstationsarray objectAtIndex: i] station];
                    
                    if (self.isCancelled) {
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Trainline operation is cancelled");
                        #endif
                        return nil;
                    }
                    
                    NSArray *routepoints = [self getRouteForStartEndstationEvaluateWithPasslistAndDistance: startstation endstation: endstation passlist: nil transportname: transportNameSimple];
                    [waypointsforallroutes addObjectsFromArray: routepoints];
                    
                    #ifdef TrainlineLogLevelFull
                    [self logTimeDifferenceWithTextAndDate:@"GetMTDDetailedRouteForConsection. Consection with partial routes. Partial route processed" date:savedate];
                    #endif
                }
                
                if (!waypointsforallroutes || waypointsforallroutes.count < 2) {
                    return nil;
                }
                
                MTDRoute *route = [[MTDRoute alloc] initWithWaypoints:waypointsforallroutes
                                                            maneuvers:nil
                                                             distance:[MTDDistance distanceWithMeters:150866.3]
                                                        timeInSeconds:7915
                                                                 name:transportName
                                                            routeType:MTDDirectionsRouteTypePedestrianIncludingPublicTransport
                                                          journeyType:MTDDirectionsRouteJourneyTypeWalk
                                                           routeColor:transportColor
                                                       additionalInfo:nil];
                
                #ifdef TrainlineLogLevelFull
                [self logTimeDifferenceWithTextAndDate:@"GetMTDDetailedRouteForConsection. Consection with common partial routes. Finished" date:savedate];
                #endif
                
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    return nil;
                }
                
                return route;
                
            }
        }
    }
    return nil;
}

- (NSArray *)isDetailedTrainlinePotentiallyAvailableForConresult:(ConResult *)conresult {
    if (conresult) {
        if ([[conresult conSectionList] conSections]) {
            if ([[[conresult conSectionList] conSections] count] > 0) {
                
                BOOL atLeastOneDetailConsectionFound = NO;
                NSMutableArray *checkedconsectionflags = [NSMutableArray array];
                
                for (ConSection *currentConsection in [[conresult conSectionList]  conSections]) {
                    
                    if (self.isCancelled) {
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Trainline operation is cancelled");
                        #endif
                        return nil;
                    }
                    
                    if ([self isTrainportTypeEqualToTrainForConsection: currentConsection]) {
                        BOOL consectiondetailsavailable = [self isDetailedTrainlinePotentiallyAvailableForConsection: currentConsection];
                        if (consectiondetailsavailable) {
                            atLeastOneDetailConsectionFound = YES;
                            [checkedconsectionflags addObject: [NSNumber numberWithBool: YES]];
                        } else {
                            [checkedconsectionflags addObject: [NSNumber numberWithBool: NO]];
                        }
                    } else {
                        [checkedconsectionflags addObject: [NSNumber numberWithBool: NO]];
                    }
                }
                return checkedconsectionflags;
            }
        }
    }
    return nil;
}

- (BOOL)isDetailedTrainlinePotentiallyAvailableForConsection:(ConSection *)consection {
    
    if (![self isTrainportTypeEqualToTrainForConsection: consection]) {
        return NO;
    }
    
    NSArray *basicStopList = [self getBasicStopsForConsection:consection];
    BasicStop *startStop = [basicStopList objectAtIndex: 0];
    BasicStop *endStop = [basicStopList lastObject];
    Station *startStation = [self getStationForBasicStop: startStop];
    Station *endStation = [self getStationForBasicStop: endStop];
    
    BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startStation endstation: endStation];
    if (stationsareoncommonroute) {
        return YES;
    } else {
        NSMutableArray *startstationsarray = [NSMutableArray array];
        NSMutableArray *endstationsarray = [NSMutableArray array];
        for (int i = 0; i < [basicStopList count] - 1; i++) {
            [startstationsarray addObject: [basicStopList objectAtIndex: i]];
            [endstationsarray addObject: [basicStopList objectAtIndex: i + 1]];
        }
        
        BOOL atLeastOnePartialDetailedRouteFound = NO;
        
        for (int i = 0; i < [startstationsarray count]; i++) {
            Station *startstation = [[startstationsarray objectAtIndex: i] station];
            Station *endstation = [[endstationsarray objectAtIndex: i] station];
            
            BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startstation endstation: endstation];
            if (stationsareoncommonroute) {
                atLeastOnePartialDetailedRouteFound = YES;
            }
            
        }
        return atLeastOnePartialDetailedRouteFound;
    }
    return NO;
}

- (BOOL)isDetailedTrainlinePotentiallyAvailableForJourney:(Journey *)journey {
    
    if (![self isTrainportTypeEqualToTrainForStationboardJourney: journey]) {
        return NO;
    }
    
    NSArray *basicStopList = [self getBasicStopsForStationboardJourneyRequestResult:journey];
    BasicStop *startStop = [basicStopList objectAtIndex: 0];
    BasicStop *endStop = [basicStopList lastObject];
    Station *startStation = [self getStationForBasicStop: startStop];
    Station *endStation = [self getStationForBasicStop: endStop];
    
    BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startStation endstation: endStation];
    if (stationsareoncommonroute) {
        return YES;
    } else {
        NSMutableArray *startstationsarray = [NSMutableArray array];
        NSMutableArray *endstationsarray = [NSMutableArray array];
        for (int i = 0; i < [basicStopList count] - 1; i++) {
            [startstationsarray addObject: [basicStopList objectAtIndex: i]];
            [endstationsarray addObject: [basicStopList objectAtIndex: i + 1]];
        }
        
        BOOL atLeastOnePartialDetailedRouteFound = NO;
        
        for (int i = 0; i < [startstationsarray count]; i++) {
            Station *startstation = [[startstationsarray objectAtIndex: i] station];
            Station *endstation = [[endstationsarray objectAtIndex: i] station];
            
            BOOL stationsareoncommonroute = [self areStationsOnCommonRoute: startstation endstation: endstation];
            if (stationsareoncommonroute) {
                atLeastOnePartialDetailedRouteFound = YES;
            }
            
        }
        return atLeastOnePartialDetailedRouteFound;
    }
    return NO;
    
}

- (NSArray *) getMTDDetailedRoutesForConnectionResult:(ConResult *)conresult detaillevel:(NSUInteger)detaillevel {
    NSMutableArray *routesArray = [NSMutableArray arrayWithCapacity:2];
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"getMTDDetailedRoutesForConnectionResultWithIndex");
    #endif
    
    if (self.conresult) {
        if ([[self.conresult conSectionList] conSections]) {
            if ([[[self.conresult conSectionList] conSections] count] > 0) {
                
                BOOL atLeastOneDetailConsectionFound = NO;
                
                for (ConSection *currentConsection in [[self.conresult conSectionList]  conSections]) {
                    
                    if (self.isCancelled) {
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Trainline operation is cancelled");
                        #endif
                        return nil;
                    }
                    
                    if (![self isTrainportTypeEqualToTrainForConsection: currentConsection]) {
                        MTDRoute *currentRoute = [self getMTDRouteForConsection: currentConsection];
                        
                        if (currentRoute && currentRoute.waypoints.count >= 2) {
                            [routesArray addObject: currentRoute];
                        } else {
                            return nil;
                        }
                        
                    } else {
                        MTDRoute *currentRoute = [self getMTDDetailedRouteForConsectionAndDetaillevel: currentConsection detaillevel: detaillevel];
                        
                        if (currentRoute && currentRoute.waypoints.count >= 2) {
                            [routesArray addObject: currentRoute];
                        } else {
                            return nil;
                        }
                        
                        if (currentRoute && currentRoute.waypoints.count > 2) {
                            atLeastOneDetailConsectionFound = YES;
                        }
                    }
                }
                
                if (atLeastOneDetailConsectionFound) {
                    return routesArray;
                }
            }
        }
    }
    
    return nil;
}

- (NSArray *)getConresultWithEqualPasslistAndDetailedRouteIfAvailableForConresultAndCurrentConresIndex:(ConResult *)conresult connections:(Connections *)connections {
    
    NSMutableArray *passlistkeys = [NSMutableArray array];
    if (conresult && conresult.conSectionList && conresult.conSectionList.conSections && conresult.conSectionList.conSections.count > 0 && connections && connections.conResults && connections.conResults.count > 0) {
        for (ConSection *currentconsection in conresult.conSectionList.conSections) {
            
            if (currentconsection.journey && currentconsection.journey.passList && currentconsection.journey.passList.count > 0) {
                //NSMutableArray *consectionkeysarray = [NSMutableArray array];
                for (BasicStop *currentstop in currentconsection.journey.passList) {
                    Station *currentstation = [self getStationForBasicStop: currentstop];
                    if (currentstation.stationName) {
                        [passlistkeys  addObject: currentstation.stationName];
                    }
                }
                //if (consectionkeysarray && consectionkeysarray.count > 0) {
                //    [passlistkeys addObject: consectionkeysarray];
                //}
            } else if (currentconsection.walk) {
                BasicStop *dep = currentconsection.departure;
                BasicStop *arr = currentconsection.arrival;
                //NSMutableArray *consectionkeysarray = [NSMutableArray array];
                if (dep && arr) {
                    NSString *depstn = [[self getStationForBasicStop: dep] stationName];
                    NSString *arrstn = [[self getStationForBasicStop: arr] stationName];
                    [passlistkeys addObject: depstn];
                    [passlistkeys addObject: arrstn];
                }
                //if (consectionkeysarray && consectionkeysarray.count > 0) {
                //    [passlistkeys addObject: consectionkeysarray];
                //}
            }
        }
    }
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"passlistkeys: %@", passlistkeys);
    #endif
    
    if (passlistkeys && passlistkeys.count > 0) {
        for (int i = 0; i < connections.conResults.count; i++) {
            ConResult *currentresult = [connections.conResults objectAtIndex: i];
            NSMutableArray *passlistkeysother = [NSMutableArray array];
            
            if (currentresult.conSectionList && currentresult.conSectionList.conSections && currentresult.conSectionList.conSections.count > 0) {
                for (ConSection *currentconsection in currentresult.conSectionList.conSections) {
                    
                    if (currentconsection.journey && currentconsection.journey.passList && currentconsection.journey.passList.count > 0) {
                        //NSMutableArray *consectionkeysarray = [NSMutableArray array];
                        for (BasicStop *currentstop in currentconsection.journey.passList) {
                            Station *currentstation = [self getStationForBasicStop: currentstop];
                            if (currentstation.stationName) {
                                [passlistkeysother  addObject: currentstation.stationName];
                            }
                        }
                        //if (consectionkeysarray && consectionkeysarray.count > 0) {
                        //    [passlistkeysother addObject: consectionkeysarray];
                        //}
                    } else if (currentconsection.walk) {
                        BasicStop *dep = currentconsection.departure;
                        BasicStop *arr = currentconsection.arrival;
                        //NSMutableArray *consectionkeysarray = [NSMutableArray array];
                        if (dep && arr) {
                            NSString *depstn = [[self getStationForBasicStop: dep] stationName];
                            NSString *arrstn = [[self getStationForBasicStop: arr] stationName];
                            [passlistkeysother addObject: depstn];
                            [passlistkeysother addObject: arrstn];
                        }
                        //if (consectionkeysarray && consectionkeysarray.count > 0) {
                        //   [passlistkeysother addObject: consectionkeysarray];
                        //}
                    }
                }
            }
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"passlistkeysother: %@", passlistkeysother);
            #endif
            
            if (passlistkeysother && passlistkeysother.count > 0) {
                if (passlistkeysother.count == passlistkeys.count) {
                    BOOL allfound = YES;
                    for (int z = 0; z < passlistkeys.count; z++) {
                        NSString *passlistkeyotherkey = [passlistkeysother objectAtIndex: z];
                        NSString *passlistkey = [passlistkeys objectAtIndex: z];
                        if (![passlistkeyotherkey isEqualToString:passlistkey]) {
                            allfound = NO;
                        }
                    }
                    
                    if (allfound && currentresult.routes && currentresult.routes.count > 0) {
                        return currentresult.routes;
                    }
                }
            }
        }
    }
    return nil;
}

- (NSArray *)getConsectionWithEqualPasslistAndDetailedRouteIfAvailableForConsectionAndCurrentConresIndex:(ConSection *)consection connections:(Connections *)connections {
    NSMutableArray *passlistkeys = [NSMutableArray array];
    if (consection && consection.journey && consection.journey.passList && consection.journey.passList.count > 0 && connections && connections.conResults && connections.conResults.count > 0) {
        for (BasicStop *currentstop in consection.journey.passList) {
            Station *currentstation = [self getStationForBasicStop: currentstop];
            if (currentstation.stationName) {
                [passlistkeys addObject: currentstation.stationName];
            }
        }
    } else {
        return nil;
    }
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"passlistkeys: %@", passlistkeys);
    #endif
    
    if (passlistkeys && passlistkeys.count > 0) {
        for (int i = 0; i < [[connections conResults] count]; i++) {
            ConResult *currentresult = [[connections conResults] objectAtIndex: i];
            if (currentresult && [currentresult conSectionList] && [[currentresult conSectionList] conSections] && [[[currentresult conSectionList] conSections] count] > 0) {
                for (int z = 0; z < [[[currentresult conSectionList] conSections] count]; z++) {
                    ConSection *currentconsection = [[[currentresult conSectionList] conSections] objectAtIndex: z];
                    if (currentconsection.journey && currentconsection.journey.passList && currentconsection.journey.passList.count > 0) {
                        Journey *currentjourney = currentconsection.journey;
                        if (currentjourney.passList.count == passlistkeys.count) {
                            BOOL allfound = YES;
                            for (int y = 0; y < currentjourney.passList.count; y++) {
                                BasicStop *currrentstop = [currentjourney.passList objectAtIndex: y];
                                NSString *stationname = [[self getStationForBasicStop: currrentstop] stationName];
                                NSString *passlistkey = [passlistkeys objectAtIndex: y];
                                
                                #ifdef TrainlineLogLevelFull
                                NSLog(@"Current stationname: %@ vs. passlistkey: %@", stationname, passlistkeys);
                                #endif
                                
                                if (![stationname isEqualToString:passlistkey]) {
                                    allfound = NO;
                                }
                            }
                            if (allfound && currentconsection.routes && currentconsection.routes.count > 0) {
                                return currentconsection.routes;
                            }
                        }
                    }
                }
            }
        }

    }
    return nil;
}

- (NSArray *)getStationboardJourneyWithEqualPasslistAndDetailedRouteIfAvailableForStationboardJourneyAndStbresIndexAndStbtype:(Journey *)journey stationboardresults:(StationboardResults *)stationboardresults {
    NSMutableArray *passlistkeys = [NSMutableArray array];
    if (journey && journey.passList && journey.passList.count > 0 && stationboardresults && stationboardresults.stbJourneys && stationboardresults.stbJourneys.count > 0) {
        for (BasicStop *currentstop in journey.passList) {
            Station *currentstation = [self getStationForBasicStop: currentstop];
            if (currentstation.stationName) {
                [passlistkeys addObject: currentstation.stationName];
            }
        }
    } else {
        return nil;
    }
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"passlistkeys: %@", passlistkeys);
    #endif
    
    if (passlistkeys && passlistkeys.count > 0) {
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"passlistkeys passed, %d", stationboardresults.stbJourneys.count);
        #endif
        
        for (int i = 0; i < stationboardresults.stbJourneys.count; i++) {
            Journey *currentjourney = [stationboardresults.stbJourneys objectAtIndex: i];
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"Current journey: %@", currentjourney);
            #endif
            
            if (currentjourney && currentjourney.passList && currentjourney.passList.count > 0) {
                
                #ifdef TrainlineLogLevelFull
                NSLog(@"Current journey has passlist");
                #endif
                
                if (currentjourney.passList.count == passlistkeys.count) {
                    BOOL allfound = YES;
                    for (int y = 0; y < currentjourney.passList.count; y++) {
                        BasicStop *currrentstop = [currentjourney.passList objectAtIndex: y];
                        NSString *stationname = [[self getStationForBasicStop: currrentstop] stationName];
                        NSString *passlistkey = [passlistkeys objectAtIndex: y];
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Current stationname: %@ vs. passlistkey: %@", stationname, passlistkeys);
                        #endif
                        
                        if (![stationname isEqualToString:passlistkey]) {
                            allfound = NO;
                        }
                    }
                    if (allfound && currentjourney.routes && currentjourney.routes.count > 0) {
                        return currentjourney.routes;
                    }
                }
            }
        }
    }
    
    return nil;
}

- (void)main {
    // a lengthy operation
    
    
    @autoreleasepool {
        
        if (self.isCancelled) {
            #ifdef TrainlineLogLevelFull
            NSLog(@"Trainline operation is cancelled");
            #endif
            if (_trainlineOperationCompletionFailureBlock) {
                _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTCANCELLED);
                return;
            }
        }
        
        //NSDate *savedate = [NSDate date];
        
        MTDRoute *route = nil;
        NSArray *routes = nil;
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"Operation detail level: %d, routes tolerance level: %d", self.detaillevel, self.routeleadsawaysfromdestinationtolerance);
        #endif
        
        if (_conresult) {
            
            if (self.isCancelled) {
                #ifdef TrainlineLogLevelFull
                NSLog(@"Trainline operation is cancelled");
                #endif
                if (_trainlineOperationCompletionFailureBlock) {
                    _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTCANCELLED);
                    return;
                }
            }
            
            NSArray *checkedconsectionflags = [self isDetailedTrainlinePotentiallyAvailableForConresult: _conresult];
            
            if (_trainlineOperationConresultPrecheckedBlock && checkedconsectionflags && checkedconsectionflags.count > 0) {
                _trainlineOperationConresultPrecheckedBlock(checkedconsectionflags, _conresult);
            }
            
            BOOL atleastoneroutefound = NO;
            for (NSNumber *currentflag in checkedconsectionflags) {
                if ([currentflag boolValue]) {
                    atleastoneroutefound = YES;
                }
            }
            
            if (atleastoneroutefound) {
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    if (_trainlineOperationCompletionFailureBlock) {
                        _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTCANCELLED);
                        return;
                    }
                }
                
                if (_connections) {
                    routes = [self getConresultWithEqualPasslistAndDetailedRouteIfAvailableForConresultAndCurrentConresIndex:_conresult connections:_connections];
                }
                
                if (!routes || routes.count == 0) {
                    routes = [self getMTDDetailedRoutesForConnectionResult:_conresult detaillevel: _detaillevel];
                }
                #ifdef TrainlineLogLevelFull
                else {
                    NSLog(@"Conres routes found in other conresult");
                }
                #endif
                
                if (!routes ||  routes.count == 0) {
                    if (_trainlineOperationCompletionFailureBlock) {
                        _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTNORESULT);
                        return;
                    }
                } else {
                    if (_trainlineOperationCompletionSuccessBlock) {
                        _trainlineOperationCompletionSuccessBlock(routes);
                        return;
                    }
                }
                
            } else {
                if (_trainlineOperationCompletionFailureBlock) {
                    _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTNORESULT);
                    return;
                }
            }
        } else if (_consection) {
            
            BOOL checkedconsectionflag = [self isDetailedTrainlinePotentiallyAvailableForConsection: _consection];
            
            if (_trainlineOperationConsectionPrecheckedBlock) {
                _trainlineOperationConsectionPrecheckedBlock(checkedconsectionflag, _consection);
            }
            
            if (checkedconsectionflag) {
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    if (_trainlineOperationCompletionFailureBlock) {
                        _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTCANCELLED);
                        return;
                    }
                }
                
                if (_connections) {
                    routes = [self getConsectionWithEqualPasslistAndDetailedRouteIfAvailableForConsectionAndCurrentConresIndex:_consection connections:_connections];
                }
                
                if (!routes || routes.count == 0) {
                    route = [self getMTDDetailedRouteForConsectionAndDetaillevel:_consection detaillevel: _detaillevel];
                    if (!route) {
                        if (_trainlineOperationCompletionFailureBlock) {
                            _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTNORESULT);
                            return;
                        }
                    }
                    routes = [NSArray arrayWithObject: route];
                }
                #ifdef TrainlineLogLevelFull
                else {
                    NSLog(@"Consection routes found in other consection");
                }
                #endif
                
                if (!routes || routes.count == 0) {
                    if (_trainlineOperationCompletionFailureBlock) {
                        _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTNORESULT);
                        return;
                    }
                } else {
                    if (_trainlineOperationCompletionSuccessBlock) {
                        //NSArray *routes = [NSArray arrayWithObject: route];
                        _trainlineOperationCompletionSuccessBlock(routes);
                        return;
                    }
                }
                
            } else {
                if (_trainlineOperationCompletionFailureBlock) {
                    _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTNORESULT);
                    return;
                }
            }
            
            
        } else if (_journey) {
            
            BOOL checkedjourneyflag = [self isDetailedTrainlinePotentiallyAvailableForJourney: _journey];
            
            if (_trainlineOperationJourneyPrecheckedBlock) {
                _trainlineOperationJourneyPrecheckedBlock(checkedjourneyflag, _journey);
            }
            
            if (checkedjourneyflag) {
                if (self.isCancelled) {
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"Trainline operation is cancelled");
                    #endif
                    if (_trainlineOperationCompletionFailureBlock) {
                        _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTCANCELLED);
                        return;
                    }
                }
                
                if (_stationboardresults) {
                    routes = [self getStationboardJourneyWithEqualPasslistAndDetailedRouteIfAvailableForStationboardJourneyAndStbresIndexAndStbtype: _journey stationboardresults:_stationboardresults];
                }
                
                if (!routes || routes.count == 0) {
                    route = [self getMTDDetailedRouteForJourneyAndDetaillevel:_journey detaillevel:_detaillevel];
                    if (!route) {
                        if (_trainlineOperationCompletionFailureBlock) {
                            _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTNORESULT);
                            return;
                        }
                    }
                    routes = [NSArray arrayWithObject: route];
                }
                #ifdef TrainlineLogLevelFull
                else {
                    NSLog(@"Journey routes found in other journey");
                }
                #endif
                
                if (!routes || routes.count == 0) {
                    if (_trainlineOperationCompletionFailureBlock) {
                        _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTNORESULT);
                        return;
                    }
                } else {
                    if (_trainlineOperationCompletionSuccessBlock) {
                        //NSArray *routes = [NSArray arrayWithObject: route];
                        _trainlineOperationCompletionSuccessBlock(routes);
                        return;
                    }
                }
            } else {
                if (_trainlineOperationCompletionFailureBlock) {
                    _trainlineOperationCompletionFailureBlock(kTRAINLINEREQUESTNORESULT);
                    return;
                }
            }
        }
    }
}

@end

@implementation TrainlinesLine

- (id)initWithIdAndGeometrydata:(NSUInteger)lineid geometrydata:(NSData *)geometrydata {
    self = [super init];
    if (self) {
        self.lineId = lineid;
        self.geommetrydata = geometrydata;
        NSUInteger numberofpoints = [self getNumberOfPoints];
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"Init line: number of points: %d", numberofpoints);
        #endif
        
        if (numberofpoints >= 2) {
            //self.startpoint = [self getPointAtIndex: 0];
            //self.endpoint = [self getPointAtIndex: numberofpoints - 1];
            //self.readGeometryDataInReverseOrder = NO;
            for (int i = 0; i < numberofpoints - 1; i++) {
                CLLocationCoordinate2D startpoint = [self getPointAtIndexWithoutReverseorderflag: i];
                CLLocationCoordinate2D endpoint = [self getPointAtIndexWithoutReverseorderflag: i + 1];
                NSUInteger distance = [self calculateDistance: startpoint bPoint: endpoint];
                self.linedistance += distance;
            }
            //NSLog(@"Line init: start: %.6f, %.6f / end: %.6f, %.6f / distance: %d m", self.startpoint.latitude, self.startpoint.longitude, self.endpoint.latitude, self.endpoint.longitude, self.distance);
        }
    }
    return self;
}

- (void) reverseGeometryData {
    //NSMutableData *turnedGeometrydata = [NSMutableData dataWithData: [self.geommetrydata subdataWithRange: NSMakeRange(0, 4)]];
    NSMutableData *turnedGeometrydata = [NSMutableData dataWithData: [self.geommetrydata subdataWithRange: NSMakeRange(0, 2)]];
    NSUInteger numberofpoints = [self getNumberOfPoints];
    
    /*
     for (int i = 0;  i < numberofpoints; i++) {
     CLLocationCoordinate2D point = [self getPointAtIndex: i];
     NSLog(@"Point: %d / %.6f, %.6f / %d", i, point.latitude, point.longitude, numberofpoints);
     }
     */
    /*
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0;  i < numberofpoints; i++) {
        int index = 16 * i | 4;
        NSData *pointdata = [self.geommetrydata subdataWithRange:NSMakeRange(index, 16)];
        [dataArray addObject: pointdata];
    }
    
    for (NSData *currentdata in [dataArray reverseObjectEnumerator]) {
        [turnedGeometrydata appendData: currentdata];
    }
    
    self.geommetrydata = turnedGeometrydata;
    */
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0;  i < numberofpoints; i++) {
        int index = 8 * i | 2;
        NSData *pointdata = [self.geommetrydata subdataWithRange:NSMakeRange(index, 8)];
        [dataArray addObject: pointdata];
    }
    
    for (NSData *currentdata in [dataArray reverseObjectEnumerator]) {
        [turnedGeometrydata appendData: currentdata];
    }
    
    self.geommetrydata = turnedGeometrydata;
    
    
    //self.startpoint = [self getPointAtIndex: 0];
    //self.endpoint = [self getPointAtIndex: numberofpoints - 1];
    
    /*
     for (int i = 0;  i < numberofpoints; i++) {
     CLLocationCoordinate2D point = [self getPointAtIndex: i];
     NSLog(@"Point: %d / %.6f, %.6f / %d", i, point.latitude, point.longitude, numberofpoints);
     }
     */
}

- (float) calculateDistance: (CLLocationCoordinate2D) aPoint bPoint:(CLLocationCoordinate2D)bPoint {
	CLLocation *startpoint = [[CLLocation alloc] initWithLatitude:aPoint.latitude longitude:aPoint.longitude];
	CLLocation *endPoint = [[CLLocation alloc] initWithLatitude:bPoint.latitude longitude:bPoint.longitude];
	CLLocationDistance calculatedDistance;
	calculatedDistance = [startpoint distanceFromLocation:endPoint];
	return ((float)calculatedDistance);
}

- (CLLocationCoordinate2D)getStartpointWithoutReverseorderflag {
    CLLocationCoordinate2D startpoint = [self getPointAtIndexWithoutReverseorderflag: 0];
    //NSLog(@"Start point: %.6f, %.6f", startpoint.latitude, startpoint.longitude);
    return startpoint;
}

- (CLLocationCoordinate2D)getEndpointWithoutReverseorderflag {
    NSUInteger numberofpoints = [self getNumberOfPoints];
    CLLocationCoordinate2D endpoint = [self getPointAtIndexWithoutReverseorderflag: numberofpoints - 1];
    //NSLog(@"Start point: %.6f, %.6f", endpoint.latitude, endpoint.longitude);
    return endpoint;
}


- (CLLocationCoordinate2D)getStartpointWithReverseorderflag:(BOOL)reverseorder {
    return [self getPointAtIndexWithReverseorderflag: 0 reverseorder: reverseorder];
}

- (CLLocationCoordinate2D)getEndpointWithReverseorderflag:(BOOL)reverseorder {
    NSUInteger numberofpoints = [self getNumberOfPoints];
    return [self getPointAtIndexWithReverseorderflag: numberofpoints - 1 reverseorder: reverseorder];
}

void printBits(size_t const size, void const * const ptr)
{
    unsigned char *b = (unsigned char*) ptr;
    unsigned char byte;
    int i, j;
    
    for (i=(int)size-1;i>=0;i--)
    {
        for (j=7;j>=0;j--)
        {
            byte = b[i] & (1<<j);
            byte >>= j;
            printf("%u", byte);
        }
    }
    puts("");
}

unsigned int compressCoordinateValue(double coordinatevalue) {
    double intpart;
    double fractpart = modf(coordinatevalue , &intpart);
    unsigned int aftercomma = (int)(fractpart * 1000000);
    unsigned int beforecomma = (int)intpart;
    
    //NSLog(@"Number: %d, %d", beforecomma,aftercomma);
    //printBits(sizeof(beforecomma), &beforecomma);
    //printBits(sizeof(aftercomma), &aftercomma);
    
    char *bytesaftercomma = (char *)&aftercomma;
    char *bytesbeforecomma = (char *)&beforecomma;
    
    //printBits(1, &bytesaftercomma[3]);
    //printBits(1, &bytesbeforecomma[0]);
    
    bytesaftercomma[3] = bytesbeforecomma[0];
    
    //printBits(sizeof(aftercomma), &aftercomma);
    
    return aftercomma;
}

double decompressCoordinateValue(unsigned int compressedcoordinate) {
    double coordinatevalue = 0.0;
    unsigned int aftercomma = 0;
    unsigned int beforecomma = 0;
    
    char *bytescompressedcoordinate = (char *)&compressedcoordinate;
    char *bytesaftercomma = (char *)&aftercomma;
    char *bytesbeforecomma = (char *)&beforecomma;
    
    bytesbeforecomma[0] = bytescompressedcoordinate[3];
    bytesaftercomma[0] = bytescompressedcoordinate[0];
    bytesaftercomma[1] = bytescompressedcoordinate[1];
    bytesaftercomma[2] = bytescompressedcoordinate[2];
    
    coordinatevalue = (double)beforecomma + ((double)aftercomma / 1000000);
    
    //NSLog(@"Number: %d, %d", beforecomma,aftercomma);
    
    //printBits(sizeof(beforecomma), &beforecomma);
    //printBits(sizeof(aftercomma), &aftercomma);
    
    return coordinatevalue;
}


- (CLLocationCoordinate2D)getPointAtIndexWithoutReverseorderflag:(NSUInteger)pointindex {
    /*
    
    CLLocationCoordinate2D coordinate;
    
    int index = 16 * pointindex | 4;
    
    //NSLog(@"Line point index: %d", index);
    
    [self.geommetrydata getBytes: &coordinate.longitude range: NSMakeRange(index, 8)];
    [self.geommetrydata getBytes: &coordinate.latitude range: NSMakeRange(index + 8, 8)];
    
    //NSLog(@"Point values: %.6f, %.6f", coordinate.latitude, coordinate.longitude);
    */
    
    unsigned int compressedlat;
    unsigned int compressedlng;
    int index = 8 * pointindex | 2;
    [self.geommetrydata getBytes: &compressedlng range: NSMakeRange(index, 4)];
    [self.geommetrydata getBytes: &compressedlat range: NSMakeRange(index + 4, 4)];
    double latitude = decompressCoordinateValue(compressedlat);
    double longitude = decompressCoordinateValue(compressedlng);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    return coordinate;
}


- (CLLocationCoordinate2D)getPointAtIndexWithReverseorderflag:(NSUInteger)pointindex reverseorder:(BOOL)reverseorder {
    /*
    CLLocationCoordinate2D coordinate;
    
    NSUInteger numberofpoints = [self getNumberOfPoints];
    
    int index;
    
    if (!reverseorder) {
        index = 16 * pointindex | 4;
    } else {
        index = (16 * (numberofpoints - 1) - pointindex * 16) | 4;
    }
    
    //NSLog(@"getPointAtIndexWithReverseorderflag. Index: %d, reversed: %@, %d %d", index, reverseorder?@"Y":@"N", [self.geommetrydata length], [self.geommetrydata length] - 9);
    
    [self.geommetrydata getBytes: &coordinate.longitude range: NSMakeRange(index, 8)];
    [self.geommetrydata getBytes: &coordinate.latitude range: NSMakeRange(index + 8, 8)];
    */
    
    NSUInteger numberofpoints = [self getNumberOfPoints];
    int index;
    if (!reverseorder) {
        index = 8 * pointindex | 2;
    } else {
        index = (8 * (numberofpoints - 1) - pointindex * 8) | 2;
    }
    
    unsigned int compressedlat;
    unsigned int compressedlng;
    [self.geommetrydata getBytes: &compressedlng range: NSMakeRange(index, 4)];
    [self.geommetrydata getBytes: &compressedlat range: NSMakeRange(index + 4, 4)];
    double latitude = decompressCoordinateValue(compressedlat);
    double longitude = decompressCoordinateValue(compressedlng);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    return coordinate;
}

- (NSUInteger)getNumberOfPoints {
    
    int numberofpoints;
    unsigned short numberofpointsshort;
    
    //[self.geommetrydata getBytes: &numberofpoints range: NSMakeRange(0, 4)];
    [self.geommetrydata getBytes: &numberofpointsshort range: NSMakeRange(0, 2)];
    numberofpoints = (int)numberofpointsshort;
    
    return numberofpoints;
}

/*
 - (void) setReadGeometryInReverseOrderFlag:(BOOL)reverseorder {
 self.readGeometryDataInReverseOrder = reverseorder;
 }
 */

- (BOOL) isEqual:(id)trainlinesline {
    if ([trainlinesline isKindOfClass: [TrainlinesLine class]]) {
        return YES;
    }
    return NO;
}

- (BOOL) isEqualToLine:(TrainlinesLine *)line {
    NSUInteger starttostartdistance = [self calculateDistance: [self getStartpointWithoutReverseorderflag] bPoint: [line getStartpointWithoutReverseorderflag]];
    NSUInteger endtoenddistance = [self calculateDistance: [self getEndpointWithoutReverseorderflag] bPoint: [line getEndpointWithoutReverseorderflag]];
    NSUInteger starttoenddistance = [self calculateDistance: [self getStartpointWithoutReverseorderflag] bPoint: [line getEndpointWithoutReverseorderflag]];
    NSUInteger endtostartdistance = [self calculateDistance: [self getEndpointWithoutReverseorderflag] bPoint: [line getStartpointWithoutReverseorderflag]];
    
    NSUInteger sseedistance = starttostartdistance + endtoenddistance;
    NSUInteger seesdistance = starttoenddistance + endtostartdistance;
    if (sseedistance < LINETOLINEPOINTMAXRANGE || seesdistance < LINETOLINEPOINTMAXRANGE) {
        return YES;
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setGeommetrydata: [self geommetrydata]];          // Never changed if only with flag
        [copy setLineId: [self lineId]];
        [copy setMincoordinate: [self mincoordinate]];
        [copy setMaxcoordinate: [self maxcoordinate]];
        [copy setLinedistance: [self linedistance]];
        //[copy setReadGeometryDataInReverseOrder: [self readGeometryDataInReverseOrder]];
    }
    return copy;
}

@end

@implementation TrainlinesStation

- (id)initWithId:(NSUInteger)stationid name:(NSString *)stationname externalid:(NSString *)externalid latitude:(double)latitude longitude:(double)longitude {
    self = [super init];
    if (self) {
        self.stationId = stationid;
        self.stationname = stationname;
        CLLocation *location = [[CLLocation alloc] initWithLatitude: latitude longitude: longitude];
        self.location = location;
        self.externalid = externalid;
    }
    return self;
}

- (BOOL)hasLocation {
    if (self.location) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqual:(id)trainlinesstation {
    if ([trainlinesstation isKindOfClass: [trainlinesstation class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isEqualToStation:(TrainlinesStation *)trainlinesstation {
    if (!trainlinesstation) {
        return NO;
    }
    if ([self.stationname isEqualToString: trainlinesstation.stationname] &&
        self.stationId == trainlinesstation.stationId &&
        self.location.coordinate.latitude == trainlinesstation.location.coordinate.latitude &&
        self.location.coordinate.longitude == trainlinesstation.location.coordinate.longitude &&
        //self.rank == trainlinesstation.rank &&
        //self.isEndPoint == trainlinesstation.isEndPoint &&
        [self.externalid isEqualToString: trainlinesstation.externalid]) {
        return YES;
    }
    return NO;
}

- (NSArray *)getRouteNumbersWithout:(TrainlinesStation *)trainlinesstation {
    return nil;
}

- (NSArray *)getRouteNumbers {
    return nil;
}

@end

@implementation TrainlinesRoute

- (id)initWithId:(NSNumber *)routeid routename:(NSString *)routename {
    self = [super init];
    if (self) {
        self.routeid = routeid;
        self.name = routename;
    }
    return self;
}

- (MKMapRect)getRegion {
    MKMapRect maprect = MKMapRectMake(0, 0, 0, 0);
    return maprect;
}

- (NSString *)getCompaniesString {
    return nil;
}

- (NSArray *)getCompanyNames {
    return nil;
}

- (BOOL)isEqual:(id)route {
    if ([route isKindOfClass:[TrainlinesRoute class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqualToRoute:(TrainlinesRoute *)route {
    if (([self.routeid integerValue] == [route.routeid integerValue]) && ([self.name isEqualToString: route.name])) {
        return YES;
    }
    return NO;
}

@end

@implementation RouteSegment

- (id)init {
    self = [super init];
    if (self) {
        self.routelines = [NSMutableArray array];
        self.linesegments = [NSMutableArray array];
        self.routelinesreversegeomflags = [NSMutableArray array];
        self.ended = NO;
        self.endedwithrouteend = NO;
        self.endedwithstation = NO;
        //self.splitstartlinewithlinepoint = NO;
        //self.splitstartlinewithintermediatelinepoint = NO;
        //self.splitendlinewithlinepoint = NO;
        //self.splitendlinewithintermediatelinepoint = NO;
        self.leadsawaysfromdestinationpoints = 0;
    }
    return self;
}

- (NSUInteger)getNumbersOfRouteLines {
    if (self.routelines) {
        return [self.routelines count];
    }
    return 0;
}

- (NSUInteger)getNumbersOfLinepointsForRoutelineWithIndex:(NSUInteger)lineindex {
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    if (lineindex < numberoflines) {
        TrainlinesLine *trainline = [self.routelines objectAtIndex: lineindex];
        return [trainline getNumberOfPoints];
    }
    return 0;
}

- (CLLocationCoordinate2D)getLinepointWithIndexOfLineWithIndex:(NSUInteger)lineindex pointindex:(NSUInteger)pointindex {
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    NSUInteger numberofflags = [[self routelinesreversegeomflags] count];
    if (lineindex < numberoflines && numberofflags == numberoflines) {
        TrainlinesLine *trainline = [self.routelines objectAtIndex: lineindex];
        NSNumber *reverseflagnum = [self.routelinesreversegeomflags objectAtIndex: lineindex];
        BOOL reverseflag = ([reverseflagnum integerValue] == 1);
        NSUInteger numberofpoints = [trainline getNumberOfPoints];
        if (pointindex < numberofpoints) {
            return [trainline getPointAtIndexWithReverseorderflag:pointindex reverseorder: reverseflag];
        }
    }
    return CLLocationCoordinate2DMake(0, 0);
}

- (CLLocationCoordinate2D)getRoutestartpoint {
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    NSUInteger numberofflags = [[self routelinesreversegeomflags] count];
    if (numberoflines > 0 && numberofflags == numberoflines) {
        TrainlinesLine *trainline = [self.routelines objectAtIndex: 0];
        NSNumber *reverseflagnum = [self.routelinesreversegeomflags objectAtIndex: 0];
        BOOL reverseflag = ([reverseflagnum integerValue] == 1);
        return [trainline getStartpointWithReverseorderflag: reverseflag];
    }
    return CLLocationCoordinate2DMake(0, 0);
}

- (CLLocationCoordinate2D)getRouteendpoint {
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    NSUInteger numberofflags = [self getNumbersOfRouteLinesReverseorderflags];
    
    #ifdef TrainlineLogLevelFull
    NSLog(@"getRouteendpoint: %d, %d", numberoflines, numberofflags);
    #endif
    
    if (numberoflines > 0 && numberofflags == numberoflines) {
        TrainlinesLine *trainline = [self.routelines lastObject];
        NSNumber *reverseflagnum = [self.routelinesreversegeomflags lastObject];
        BOOL reverseflag = ([reverseflagnum integerValue] == 1);
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"getRouteendpoint. Read with reverseorder: %@", reverseflag?@"Y":@"N");
        #endif
        
        return [trainline getEndpointWithReverseorderflag: reverseflag];
    }
    return CLLocationCoordinate2DMake(0, 0);
}

- (TrainlinesLine *)getRoutelineWithIndex:(NSUInteger)lineindex {
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    if (lineindex < numberoflines) {
        return [self.routelines objectAtIndex: lineindex];
    }
    return nil;
}

- (TrainlinesLine *)getStartRouteline {
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    if (numberoflines > 0) {
        return [self.routelines objectAtIndex: 0];
    }
    return nil;
}

- (TrainlinesLine *)getEndRouteline {
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    if (numberoflines > 0) {
        return [self.routelines lastObject];
    }
    return nil;
}

- (NSUInteger)getNumbersOfRouteLinesReverseorderflags {
    if (self.routelinesreversegeomflags) {
        return [self.routelinesreversegeomflags count];
    }
    return 0;
}

- (BOOL)getReverseorderflagForRoutelineWithIndex:(NSUInteger)lineindex {
    NSUInteger numberofreverseorderflags = [self.routelinesreversegeomflags count];
    if (numberofreverseorderflags > 0) {
        NSNumber *flagnum = [self.routelinesreversegeomflags objectAtIndex: lineindex];
        return [flagnum integerValue] == 1;
    }
    return NO;
}

/*
- (NSArray *)getAllMTDWaypointsForRoutelines {
    
    if (self.waypoints && self.waypoints.count > 0) {
        return self.waypoints;
    }
    
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    NSUInteger numberofflags = [[self routelinesreversegeomflags] count];
    if (numberoflines > 0 && numberoflines == numberofflags) {
        NSMutableArray *waypointsarray = [NSMutableArray array];
        TrainlinesLine *startline = [self.routelines objectAtIndex: 0];
        NSNumber *reverseflagnum = [self.routelinesreversegeomflags objectAtIndex: 0];
        BOOL reverseflag = ([reverseflagnum integerValue] == 1);
        
        CLLocationCoordinate2D startlocation = [startline getStartpointWithReverseorderflag: reverseflag];
        MTDWaypoint *startpoint = [[MTDWaypoint alloc] initWithCoordinate: startlocation];
        [waypointsarray addObject: startpoint];
        for (int i = 0; i < numberoflines; i++) {
            TrainlinesLine *currentline = [self.routelines objectAtIndex: i];
            NSNumber *currentlineflag = [self.routelinesreversegeomflags objectAtIndex: i];
            BOOL reverselineflag = ([currentlineflag integerValue] == 1);
            NSUInteger numberofpoints = [currentline getNumberOfPoints];
            for (int y = 1; y < numberofpoints; y++) {
                CLLocationCoordinate2D linepoint = [currentline getPointAtIndexWithReverseorderflag: y reverseorder: reverselineflag];
                MTDWaypoint *endpoint = [[MTDWaypoint alloc] initWithCoordinate: linepoint];
                [waypointsarray addObject: endpoint];
            }
            
        }
        return waypointsarray;
    }
    return nil;
}
*/

- (float) calculateDistance: (CLLocationCoordinate2D) aPoint bPoint:(CLLocationCoordinate2D)bPoint {
	CLLocation *startpoint = [[CLLocation alloc] initWithLatitude:aPoint.latitude longitude:aPoint.longitude];
	CLLocation *endPoint = [[CLLocation alloc] initWithLatitude:bPoint.latitude longitude:bPoint.longitude];
	CLLocationDistance calculatedDistance;
	calculatedDistance = [startpoint distanceFromLocation:endPoint];
	return ((float)calculatedDistance);
}

/*
- (void)extractAllWaypoints {
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    NSUInteger numberofflags = [[self routelinesreversegeomflags] count];
    if (numberoflines > 0 && numberoflines == numberofflags) {
        NSMutableArray *waypointsarray = [NSMutableArray array];
        TrainlinesLine *startline = [self.routelines objectAtIndex: 0];
        NSNumber *reverseflagnum = [self.routelinesreversegeomflags objectAtIndex: 0];
        BOOL reverseflag = ([reverseflagnum integerValue] == 1);
        
        CLLocationCoordinate2D startlocation = [startline getStartpointWithReverseorderflag: reverseflag];
        MTDWaypoint *startpoint = [[MTDWaypoint alloc] initWithCoordinate: startlocation];
        [waypointsarray addObject: startpoint];
        for (int i = 0; i < numberoflines; i++) {
            TrainlinesLine *currentline = [self.routelines objectAtIndex: i];
            NSNumber *currentlineflag = [self.routelinesreversegeomflags objectAtIndex: i];
            BOOL reverselineflag = ([currentlineflag integerValue] == 1);
            NSUInteger numberofpoints = [currentline getNumberOfPoints];
            for (int y = 1; y < numberofpoints; y++) {
                CLLocationCoordinate2D linepoint = [currentline getPointAtIndexWithReverseorderflag: y reverseorder: reverselineflag];
                MTDWaypoint *endpoint = [[MTDWaypoint alloc] initWithCoordinate: linepoint];
                [waypointsarray addObject: endpoint];
            }
            
        }
        self.waypoints = [NSMutableArray arrayWithArray: waypointsarray];
    }
}
*/
/*
- (BOOL)extractWaypointsTerminatingWithCoordinateAndCheckForTermination:(CLLocationCoordinate2D)coordinate {
    
    NSLog(@"extractWaypointsTerminatingWithCoordinateAndCheckForTermination. Termination: %.6f, %.6f", coordinate.latitude, coordinate.longitude);
    
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    NSUInteger numberofflags = [[self routelinesreversegeomflags] count];
    if (numberoflines > 0 && numberoflines == numberofflags) {
        NSMutableArray *waypointsarray = [NSMutableArray array];
        TrainlinesLine *startline = [self.routelines objectAtIndex: 0];
        NSNumber *reverseflagnum = [self.routelinesreversegeomflags objectAtIndex: 0];
        BOOL reverseflag = ([reverseflagnum integerValue] == 1);
        
        CLLocationCoordinate2D startlocation = [startline getStartpointWithReverseorderflag: reverseflag];
        MTDWaypoint *startpoint = [[MTDWaypoint alloc] initWithCoordinate: startlocation];
        [waypointsarray addObject: startpoint];
        for (int i = 0; i < numberoflines; i++) {
            TrainlinesLine *currentline = [self.routelines objectAtIndex: i];
            NSNumber *currentlineflag = [self.routelinesreversegeomflags objectAtIndex: i];
            BOOL reverselineflag = ([currentlineflag integerValue] == 1);
            NSUInteger numberofpoints = [currentline getNumberOfPoints];
            for (int y = 1; y < numberofpoints; y++) {
                CLLocationCoordinate2D linepoint = [currentline getPointAtIndexWithReverseorderflag: y reverseorder: reverselineflag];
                MTDWaypoint *endpoint = [[MTDWaypoint alloc] initWithCoordinate: linepoint];
                [waypointsarray addObject: endpoint];
            }
            
        }
        
        NSMutableArray *waypointswithtermination = [NSMutableArray array];
        if (waypointsarray && waypointsarray.count > 0) {
            BOOL terminatedbycoordinate = NO;
            for (int z = 0; z < [waypointsarray count]; z++) {
                if (terminatedbycoordinate) {
                    continue;
                }
                MTDWaypoint *currentwaypoint = [waypointsarray objectAtIndex: z];
                CLLocationCoordinate2D waypointcoordinate = [currentwaypoint coordinate];
                NSUInteger distance = [self calculateDistance: coordinate bPoint: waypointcoordinate];
                [waypointswithtermination addObject: currentwaypoint];
                if (distance < TRAINSTATIONMAXRANGETOLINESTARTENDPOINT) {
                    NSLog(@"extractWaypointsTerminatingWithCoordinateAndCheckForTermination: %.6f, %.6f", waypointcoordinate.latitude, waypointcoordinate.longitude);
                    terminatedbycoordinate = YES;
                }
            }
            if (waypointswithtermination && waypointswithtermination.count > 0) {
                self.waypoints = [NSMutableArray arrayWithArray: waypointswithtermination];
            }
            if (terminatedbycoordinate) {
                return YES;
            }
        }
    }
    return NO;
}
*/

- (NSArray *)getWaypoints {
    return self.waypoints;
}

- (void)extractWaypointsByCuttingStartAndEndpoint {
    NSUInteger numberoflines = [self getNumbersOfRouteLines];
    NSUInteger numberofflags = [[self routelinesreversegeomflags] count];
    
    #ifdef TrainlineLogLevelFull
    if (self.startcutblock) {
        if (self.startcutblock.pointmatch) {
            NSLog(@"Route has start cut block point match: %d, %d, %d / %.6f, %.6f", self.startcutblock.lineid, self.startcutblock.lineindex ,self.startcutblock.pointmatchpointindex, self.startcutblock.pointmatchcoordinate.latitude, self.startcutblock.pointmatchcoordinate.longitude);
        } else {
            NSLog(@"Route has start cut block middle point: %d, %d, %d, %d / %.6f, %.6f", self.startcutblock.lineid, self.startcutblock.lineindex, self.startcutblock.nopointmatchstartpointindex, self.startcutblock.nopointmatchendpointindex, self.startcutblock.nopointmatchmiddlecoordinate.latitude, self.startcutblock.nopointmatchmiddlecoordinate.longitude);
        }
    }
    if (self.endcutblock) {
        if (self.endcutblock.pointmatch) {
            NSLog(@"Route has end cut block point match: %d, %d, %d / %.6f, %.6f", self.endcutblock.lineid, self.endcutblock.lineindex, self.endcutblock.pointmatchpointindex, self.endcutblock.pointmatchcoordinate.latitude, self.endcutblock.pointmatchcoordinate.longitude);
        } else {
            NSLog(@"Route has end cut block middle point: %d, %d, %d, %d/ %.6f, %.6f", self.endcutblock.lineid, self.endcutblock.lineindex, self.endcutblock.nopointmatchstartpointindex, self.endcutblock.nopointmatchendpointindex, self.endcutblock.nopointmatchmiddlecoordinate.latitude, self.endcutblock.nopointmatchmiddlecoordinate.longitude);
        }
    }
    #endif

    if (numberoflines > 0 && numberoflines == numberofflags) {
        
        #ifdef TrainlineLogLevelFull
        NSLog(@"extractWaypointsByCuttingStartAndEndpoint. Lines: %d", numberoflines);
        #endif
        
        NSMutableArray *waypointsarray = [NSMutableArray array];
        if (numberoflines == 1) {
            TrainlinesLine *startline = [self.routelines objectAtIndex: 0];
            NSNumber *reverseflagnum = [self.routelinesreversegeomflags objectAtIndex: 0];
            BOOL reverseflag = ([reverseflagnum integerValue] == 1);
            NSUInteger startpointindex = 0;
            NSUInteger numberofpoints = [startline getNumberOfPoints];
            NSUInteger endpointindex = numberofpoints;
            
            /*
             if (self.routestartlocation.latitude != 0 && self.routestartlocation.longitude != 0) {
             MTDWaypoint *startwaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.routestartlocation];
             [waypointsarray addObject: startwaypoint];
             }
             */
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"extractWaypointsByCuttingStartAndEndpoint. Only one line. Start. RevOrder: %d", reverseflag);
            #endif
            
            if (self.startcutblock) {
                if (self.startcutblock.pointmatch) {
                    startpointindex = self.startcutblock.pointmatchpointindex;
                } else {
                    startpointindex = self.startcutblock.nopointmatchendpointindex;
                    MTDWaypoint *middlewaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.startcutblock.nopointmatchmiddlecoordinate];
                    [waypointsarray addObject: middlewaypoint];
                }
            }
            if (startpointindex >= numberofpoints) {
                startpointindex = 0;
            }
            if (self.endcutblock) {
                if (self.endcutblock.pointmatch) {
                    endpointindex = self.endcutblock.pointmatchpointindex + 1;
                } else {
                    endpointindex = self.endcutblock.nopointmatchstartpointindex + 1;
                }
            }
            if (endpointindex > numberofpoints) {
                endpointindex = numberofpoints;
            }
            
            #ifdef TrainlineLogLevelFull
            NSLog(@"extractWaypointsByCuttingStartAndEndpoint. Only one line. Processing with: %d, %d of points: %d...", startpointindex, endpointindex, numberofpoints);
            #endif
            
            for (int i = startpointindex; i < endpointindex; i++) {
                CLLocationCoordinate2D linepoint = [startline getPointAtIndexWithReverseorderflag: i reverseorder: reverseflag];
                MTDWaypoint *endpoint = [[MTDWaypoint alloc] initWithCoordinate: linepoint];
                [waypointsarray addObject: endpoint];
            }
            
            if (self.endcutblock && !self.endcutblock.pointmatch) {
                MTDWaypoint *middlewaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.endcutblock.nopointmatchmiddlecoordinate];
                [waypointsarray addObject: middlewaypoint];
            }
            
            /*
             if (self.routeendlocation.latitude != 0 && self.routeendlocation.longitude != 0) {
             MTDWaypoint *endwaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.routeendlocation];
             [waypointsarray addObject: endwaypoint];
             }
             */
            
            if (waypointsarray && waypointsarray.count > 0) {
                MTDWaypoint *first = [waypointsarray objectAtIndex: 0];
                MTDWaypoint *last = [waypointsarray lastObject];
                NSUInteger starttofirst = [self calculateDistance: self.routestartlocation bPoint: first.coordinate];
                NSUInteger endtolast = [self calculateDistance: self.routeendlocation bPoint: last.coordinate];
                if (starttofirst < STARTENDCOORDINATETOWAYPOINTSSTARTENDDISTANCE) {
                    MTDWaypoint *startwaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.routestartlocation];
                    [waypointsarray insertObject: startwaypoint atIndex: 0];
                }
                if (endtolast < STARTENDCOORDINATETOWAYPOINTSSTARTENDDISTANCE) {
                    MTDWaypoint *endwaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.routeendlocation];
                    [waypointsarray addObject: endwaypoint];
                }
                
            }
            
            if (waypointsarray && waypointsarray.count > 0) {
                NSUInteger totalwaydistance = 0;
                for (int i = 0; i < waypointsarray.count - 1; i++) {
                    MTDWaypoint *firstpoint = [waypointsarray objectAtIndex: i];
                    MTDWaypoint *secondpoint = [waypointsarray objectAtIndex: i + 1];
                    NSUInteger currentpointdistance = [self calculateDistance: firstpoint.coordinate bPoint: secondpoint.coordinate];
                    totalwaydistance +=currentpointdistance;
                }
                self.routedistance = totalwaydistance;
            } else {
                self.routedistance = 0;
            }
                        
            self.waypoints = [NSMutableArray arrayWithArray: waypointsarray];
            return;
            //return self.waypoints;
        } else {
            
            /*
             if (self.routestartlocation.latitude != 0 && self.routestartlocation.longitude != 0) {
             MTDWaypoint *startwaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.routestartlocation];
             [waypointsarray addObject: startwaypoint];
             }
             */
            
            for (int i = 0; i < numberoflines; i++) {
                TrainlinesLine *currentline = [self.routelines objectAtIndex: i];
                NSNumber *reverseflagnum = [self.routelinesreversegeomflags objectAtIndex: i];
                BOOL reverseflag = ([reverseflagnum integerValue] == 1);
                NSUInteger numberofpoints = [currentline getNumberOfPoints];
                NSUInteger currentlineid = currentline.lineId;
                NSUInteger endcutblocklineid = 0;
                if (self.endcutblock) {
                    endcutblocklineid = self.endcutblock.lineid;
                }
                
                if (i == 0) {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"extractWaypointsByCuttingStartAndEndpoint. First Line.");
                    #endif
                    
                    NSUInteger startpointindex = 0;
                    
                    if (self.startcutblock) {
                        if (self.startcutblock.pointmatch) {
                            startpointindex = self.startcutblock.pointmatchpointindex;
                        } else {
                            startpointindex = self.startcutblock.nopointmatchendpointindex;
                            MTDWaypoint *middlewaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.startcutblock.nopointmatchmiddlecoordinate];
                            [waypointsarray addObject: middlewaypoint];
                        }
                    }
                    if (startpointindex >= numberofpoints) {
                        startpointindex = 0;
                    }
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"extractWaypointsByCuttingStartAndEndpoint. First Line: %d, %d. Processing with: %d, %d of points: %d...", i, currentlineid, startpointindex, numberofpoints, numberofpoints);
                    #endif
                    
                    for (int y = startpointindex; y < numberofpoints; y++) {
                        CLLocationCoordinate2D linepoint = [currentline getPointAtIndexWithReverseorderflag: y reverseorder: reverseflag];
                        MTDWaypoint *endpoint = [[MTDWaypoint alloc] initWithCoordinate: linepoint];
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Coordinate: %d / %.6f, %.6f / %d", y, endpoint.coordinate.latitude, endpoint.coordinate.longitude, numberofpoints);
                        #endif
                        
                        [waypointsarray addObject: endpoint];
                    }
                    
                } else if (i == numberoflines - 1) {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"extractWaypointsByCuttingStartAndEndpoint. Last Line.");
                    #endif
                    
                    NSUInteger endpointindex = numberofpoints;
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"End point index: %d", endpointindex);
                    #endif
                    
                    if (self.endcutblock) {
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Cut block there");
                        #endif
                        
                        if (self.endcutblock.pointmatch) {
                            endpointindex = self.endcutblock.pointmatchpointindex + 1;
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Cut block there. Matchpoint: %d", endpointindex);
                            #endif
                        } else {
                            endpointindex = self.endcutblock.nopointmatchstartpointindex + 1;
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Cut block there. Interim: %d", endpointindex);
                            #endif
                        }
                    }
                    if (endpointindex > numberofpoints) {
                        //NSLog(@"Adjust end pointindex");
                        endpointindex = numberofpoints;
                    }
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"extractWaypointsByCuttingStartAndEndpoint. Last Line: %d, %d. Processing with: %d, %d of points: %d...", i, currentlineid, 1, endpointindex, numberofpoints);
                    NSLog(@"Endpointindex: %d", endpointindex);
                    #endif
                    
                    //endpointindex += 1;
                    
                    for (int y = 1; y < endpointindex; y++) {
                        CLLocationCoordinate2D linepoint = [currentline getPointAtIndexWithReverseorderflag: y reverseorder: reverseflag];
                        MTDWaypoint *endpoint = [[MTDWaypoint alloc] initWithCoordinate: linepoint];
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"Coordinate: %d / %.6f, %.6f / %d", y, endpoint.coordinate.latitude, endpoint.coordinate.longitude, numberofpoints);
                        #endif
                        
                        [waypointsarray addObject: endpoint];
                    }
                    
                    if (self.endcutblock && !self.endcutblock.pointmatch) {
                        MTDWaypoint *middlewaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.endcutblock.nopointmatchmiddlecoordinate];
                        [waypointsarray addObject: middlewaypoint];
                    }
                    
                } else {
                    
                    #ifdef TrainlineLogLevelFull
                    NSLog(@"extractWaypointsByCuttingStartAndEndpoint. Middle Line.");
                    #endif
                    
                    if (endcutblocklineid == currentlineid) {
                        NSUInteger endpointindex = numberofpoints;
                        
                        if (self.endcutblock) {
                            
                            #ifdef TrainlineLogLevelFull
                            NSLog(@"Cut block there");
                            #endif
                            
                            if (self.endcutblock.pointmatch) {
                                endpointindex = self.endcutblock.pointmatchpointindex + 1;
                                
                                #ifdef TrainlineLogLevelFull
                                NSLog(@"Cut block there. Matchpoint: %d", endpointindex);
                                #endif
                            } else {
                                endpointindex = self.endcutblock.nopointmatchstartpointindex + 1;
                                
                                #ifdef TrainlineLogLevelFull
                                NSLog(@"Cut block there. Interim: %d", endpointindex);
                                #endif
                            }
                        }
                        if (endpointindex > numberofpoints) {
                            endpointindex = numberofpoints;
                        }
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"extractWaypointsByCuttingStartAndEndpoint. Cut Line: %d, %d. Processing with: %d, %d of points: %d...", i, currentlineid ,1, endpointindex, numberofpoints);
                        #endif
                        
                        for (int y = 1; y < endpointindex; y++) {
                            CLLocationCoordinate2D linepoint = [currentline getPointAtIndexWithReverseorderflag: y reverseorder: reverseflag];
                            MTDWaypoint *endpoint = [[MTDWaypoint alloc] initWithCoordinate: linepoint];
                            [waypointsarray addObject: endpoint];
                        }
                        
                        if (self.endcutblock && !self.endcutblock.pointmatch) {
                            MTDWaypoint *middlewaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.endcutblock.nopointmatchmiddlecoordinate];
                            [waypointsarray addObject: middlewaypoint];
                        }
                        
                    } else {
                        
                        #ifdef TrainlineLogLevelFull
                        NSLog(@"extractWaypointsByCuttingStartAndEndpoint. Line: %d, %d. Processing with: %d, %d of points: %d...", i, currentlineid,1, numberofpoints, numberofpoints);
                        #endif
                        
                        for (int y = 1; y < numberofpoints; y++) {
                            CLLocationCoordinate2D linepoint = [currentline getPointAtIndexWithReverseorderflag: y reverseorder: reverseflag];
                            MTDWaypoint *endpoint = [[MTDWaypoint alloc] initWithCoordinate: linepoint];
                            [waypointsarray addObject: endpoint];
                        }
                    }
                }
            }
            
            if (waypointsarray && waypointsarray.count > 0) {
                MTDWaypoint *first = [waypointsarray objectAtIndex: 0];
                MTDWaypoint *last = [waypointsarray lastObject];
                NSUInteger starttofirst = [self calculateDistance: self.routestartlocation bPoint: first.coordinate];
                NSUInteger endtolast = [self calculateDistance: self.routeendlocation bPoint: last.coordinate];
                if (starttofirst < STARTENDCOORDINATETOWAYPOINTSSTARTENDDISTANCE) {
                    MTDWaypoint *startwaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.routestartlocation];
                    [waypointsarray insertObject: startwaypoint atIndex: 0];
                }
                if (endtolast < STARTENDCOORDINATETOWAYPOINTSSTARTENDDISTANCE) {
                    MTDWaypoint *endwaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.routeendlocation];
                    [waypointsarray addObject: endwaypoint];
                }
                
            }
            
            /*
             if (self.routeendlocation.latitude != 0 && self.routeendlocation.longitude != 0) {
             MTDWaypoint *endwaypoint = [[MTDWaypoint alloc] initWithCoordinate: self.routeendlocation];
             [waypointsarray addObject: endwaypoint];
             }
             */
            
            if (waypointsarray && waypointsarray.count > 0) {
                NSUInteger totalwaydistance = 0;
                for (int i = 0; i < waypointsarray.count - 1; i++) {
                    MTDWaypoint *firstpoint = [waypointsarray objectAtIndex: i];
                    MTDWaypoint *secondpoint = [waypointsarray objectAtIndex: i + 1];
                    NSUInteger currentpointdistance = [self calculateDistance: firstpoint.coordinate bPoint: secondpoint.coordinate];
                    totalwaydistance +=currentpointdistance;
                }
                self.routedistance = totalwaydistance;
            } else {
                self.routedistance = 0;
            }
            
            self.waypoints = [NSMutableArray arrayWithArray: waypointsarray];
            return;
            //return self.waypoints;
        }
    }
    //return nil;
    self.routedistance = 0;
}

- (void) logTimeDifferenceWithTextAndDate:(NSString *)text date:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss:SS"];
    //NSString *dateString = [dateFormatter stringFromDate: [NSDate date]];
    NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:date];
    
    NSLog(@"%@, %.4f", text, diff);
}

- (void)removeLineByLineFromRoutesegmentlines:(TrainlinesLine *)line {
    if (self.linesegments && line) {
        
        #ifdef TrainlineLogLevelFull
        NSDate *saveDate = [NSDate date];
        NSLog(@"Lines count before filtering: %d",self.linesegments.count);
        #endif
        
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (int i = 0; i < [self.linesegments count]; i++) {
            TrainlinesLine *currentline = [self.linesegments objectAtIndex: i];
            if ([currentline isEqualToLine: line]) {
                [indexSet addIndex: i];
            }
            
        }
        
        [self.linesegments removeObjectsAtIndexes: indexSet];
        
        #ifdef TrainlineLogLevelFull
        NSString *countstring = [NSString stringWithFormat: @"Lines count after filtering: %d", self.linesegments.count];
        [self logTimeDifferenceWithTextAndDate: countstring date: saveDate];
        #endif
    }
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        //[copy setRoutelines: [self.routelines copyWithZone: zone]];
        [copy setRoutelines: [self.routelines mutableCopyWithZone: zone]];
        //[copy setRoutelines: [self routelines]];
        //[copy setLinesegments:[self linesegments]];
        [copy setLinesegments:[self.linesegments mutableCopyWithZone: zone]];
        [copy setEnded: [self ended]];
        [copy setEndedwithstation: [self endedwithstation]];
        [copy setEndedwithrouteend: [self endedwithrouteend]];
        [copy setRoutedistance: [self routedistance]];
        [copy setRoutelinesreversegeomflags: [self.routelinesreversegeomflags mutableCopyWithZone: zone]];
        //[copy setSplitstartlinewithlinepoint: [self splitstartlinewithlinepoint]];
        //[copy setSplitstartlinewithintermediatelinepoint: [self splitstartlinewithintermediatelinepoint]];
        //[copy setSplitendlinewithlinepoint: [self splitendlinewithlinepoint]];
        //[copy setSplitendlinewithintermediatelinepoint: [self splitendlinewithintermediatelinepoint]];
        [copy setStartcutblock: [self.startcutblock copy]];
        [copy setEndcutblock: [self.endcutblock copy]];
        [copy setRoutestartlocation: [self routestartlocation]];
        [copy setRouteendlocation: [self routeendlocation]];
        [copy setRouteid: [self.routeid copy]];
        [copy setLeadsawaysfromdestinationpoints: [self leadsawaysfromdestinationpoints]];
    }
    return copy;
}

@end

@implementation RouteLineCutBlock

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setLineid: [self lineid]];
        [copy setLineindex: [self lineindex]];
        [copy setPointmatch: [self pointmatch]];
        [copy setPointmatchpointindex: [self pointmatchpointindex]];
        [copy setPointmatchcoordinate: [self pointmatchcoordinate]];
        [copy setNopointmatchstartpointindex: [self nopointmatchstartpointindex]];
        [copy setNopointmatchendpointindex: [self nopointmatchendpointindex]];
        [copy setNopointmatchmiddlecoordinate: [self nopointmatchmiddlecoordinate]];
    }
    return copy;
}

@end