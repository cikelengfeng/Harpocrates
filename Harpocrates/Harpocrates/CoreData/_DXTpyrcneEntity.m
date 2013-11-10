// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DXTpyrcneEntity.m instead.

#import "_DXTpyrcneEntity.h"

const struct DXTpyrcneEntityAttributes DXTpyrcneEntityAttributes = {
	.aEx = @"aEx",
	.aKey = @"aKey",
	.aPassword = @"aPassword",
};

const struct DXTpyrcneEntityRelationships DXTpyrcneEntityRelationships = {
};

const struct DXTpyrcneEntityFetchedProperties DXTpyrcneEntityFetchedProperties = {
};

@implementation DXTpyrcneEntityID
@end

@implementation _DXTpyrcneEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DXTpyrcneEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DXTpyrcneEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DXTpyrcneEntity" inManagedObjectContext:moc_];
}

- (DXTpyrcneEntityID*)objectID {
	return (DXTpyrcneEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic aEx;






@dynamic aKey;






@dynamic aPassword;











@end
