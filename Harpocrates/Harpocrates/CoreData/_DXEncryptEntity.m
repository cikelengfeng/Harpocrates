// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DXEncryptEntity.m instead.

#import "_DXEncryptEntity.h"

const struct DXEncryptEntityAttributes DXEncryptEntityAttributes = {
	.aKey = @"aKey",
	.aPassword = @"aPassword",
};

const struct DXEncryptEntityRelationships DXEncryptEntityRelationships = {
};

const struct DXEncryptEntityFetchedProperties DXEncryptEntityFetchedProperties = {
};

@implementation DXEncryptEntityID
@end

@implementation _DXEncryptEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DXEncryptEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DXEncryptEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DXEncryptEntity" inManagedObjectContext:moc_];
}

- (DXEncryptEntityID*)objectID {
	return (DXEncryptEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic aKey;






@dynamic aPassword;











@end
