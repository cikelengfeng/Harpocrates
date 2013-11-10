// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DXBaseEntity.m instead.

#import "_DXBaseEntity.h"

const struct DXBaseEntityAttributes DXBaseEntityAttributes = {
	.aTimeStamp = @"aTimeStamp",
};

const struct DXBaseEntityRelationships DXBaseEntityRelationships = {
};

const struct DXBaseEntityFetchedProperties DXBaseEntityFetchedProperties = {
};

@implementation DXBaseEntityID
@end

@implementation _DXBaseEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DXBaseEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DXBaseEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DXBaseEntity" inManagedObjectContext:moc_];
}

- (DXBaseEntityID*)objectID {
	return (DXBaseEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic aTimeStamp;











@end
