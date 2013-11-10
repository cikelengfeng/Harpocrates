// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DXEncryptEntity.h instead.

#import <CoreData/CoreData.h>
#import "DXBaseEntity.h"

extern const struct DXEncryptEntityAttributes {
	__unsafe_unretained NSString *aKey;
	__unsafe_unretained NSString *aPassword;
} DXEncryptEntityAttributes;

extern const struct DXEncryptEntityRelationships {
} DXEncryptEntityRelationships;

extern const struct DXEncryptEntityFetchedProperties {
} DXEncryptEntityFetchedProperties;





@interface DXEncryptEntityID : NSManagedObjectID {}
@end

@interface _DXEncryptEntity : DXBaseEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DXEncryptEntityID*)objectID;





@property (nonatomic, strong) NSString* aKey;



//- (BOOL)validateAKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* aPassword;



//- (BOOL)validateAPassword:(id*)value_ error:(NSError**)error_;






@end

@interface _DXEncryptEntity (CoreDataGeneratedAccessors)

@end

@interface _DXEncryptEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAKey;
- (void)setPrimitiveAKey:(NSString*)value;




- (NSString*)primitiveAPassword;
- (void)setPrimitiveAPassword:(NSString*)value;




@end
